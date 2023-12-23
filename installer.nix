{pkgs}:
pkgs.writeShellScriptBin "nix-auto-installer" ''
  echo "Welcome to the NixOS installer script\n"
  echo "hello world" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
''
