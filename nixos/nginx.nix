{ pkgs, lib, config, inputs, ... }:

let
  appUser = "main";
  domain = "${appUser}.jarkom.local";
  dataDir = inputs.testing-website;
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.phpfpm.pools.${appUser} = {
    user = "rizqirazkafi";
    group = "nginx";
    settings = {
      "listen.owner" = "rizqirazkafi";
      "listen.group" = "nginx";
      "listen.mode" = "0660";
      "pm" = "dynamic";
      "pm.max_children" = 75;
      "pm.start_servers" = 10;
      "pm.min_spare_servers" = 5;
      "pm.max_spare_servers" = 20;
      "pm.max_requests" = 500;
      "catch_workers_output" = 1;
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      ${domain} = {
        root = "${dataDir}";

        extraConfig = "index index.php; ";

        locations."/" = {
          extraConfig = ''
            # First attempt to serve request as file, then
            # as directory, then fall back to displaying a 404.

            try_files $uri $uri/ =404;		
            autoindex on;
          '';
        };

        locations."~ .php" = {
          extraConfig = ''
            include ${config.services.nginx.package}/conf/fastcgi_params;

            # regex to split $uri to $fastcgi_script_name and $fastcgi_path
            fastcgi_split_path_info ^(.+?\.php)(/.*)$;

            # Check that the PHP script exists before passing it
            try_files $fastcgi_script_name =404;

            # Bypass the fact that try_files resets $fastcgi_path_info
            # see: http://trac.nginx.org/nginx/ticket/321
            set $path_info $fastcgi_path_info;
            fastcgi_param PATH_INFO $path_info;

            fastcgi_index index.php;
            fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
            include ${pkgs.nginx}/conf/fastcgi.conf;

            fastcgi_pass unix:${config.services.phpfpm.pools.${appUser}.socket};
          '';
        };
      };
    };
  };
}
