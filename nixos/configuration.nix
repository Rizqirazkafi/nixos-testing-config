# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ inputs, config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./vim.nix
    # ./disk-config.nix
    inputs.home-manager.nixosModules.home-manager
  ];
  # Added flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "rizqirazkafi" ];
  nix.package = pkgs.nixFlakes;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.rizqirazkafi = import ../home.nix;
  };
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -sa terminal-overrides ",alacritty:RGB"
      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix
      set -g mouse
    '';
    plugins = with pkgs.tmuxPlugins; [ vim-tmux-navigator sensible ];
  };

  # Use the systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-vm"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rizqirazkafi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ tree ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8rh5OxRHsKPT/ic6qA7G3VxqV9SVFW89CdLnVPDJNY rizqirazkafi56@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4BKp6wALZpa0l93oz7GOma8yJ4jY6r/G8H3usLiJ+n rizqirazkafi56@gmail.com"
    ];

  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8rh5OxRHsKPT/ic6qA7G3VxqV9SVFW89CdLnVPDJNY rizqirazkafi56@gmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4BKp6wALZpa0l93oz7GOma8yJ4jY6r/G8H3usLiJ+n rizqirazkafi56@gmail.com"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ncdu
    lazygit
    tmux
    vim
    neovim
    wget
    git
    home-manager
    htop
    # inputs.latex.legacyPackages.x86_64-linux.texliveFull
  ];
  services.qemuGuest.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [ 22 ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  system.stateVersion = "23.05";

}
