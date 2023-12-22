{pkgs}:
pkgs.writeShellScriptBin "nix-auto-installer" ''
  echo "hello world" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
''
