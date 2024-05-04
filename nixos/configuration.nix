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
    ./nginx.nix
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
    extraGroups = [ "wheel" ]; # enable ‘sudo’ for the user.
    packages = with pkgs; [ tree ];
    openssh.authorizedKeys.keys = [
      # Nitro
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMWLbWrVUvtf2+i4DVKVBCYalLNPuY1xRG2JIt64HHV rizqirazkafi56@gmail.com"
      # nixosvm-efi
      ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtzb3oMobBQVSza6gjWUMteRTNk+LRNBQqRSx3UrN1V rizqirazkafi56@gmail.com
      ''
    ];

  };
  users.users.root.openssh.authorizedKeys.keys = [
    # Nitro
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMWLbWrVUvtf2+i4DVKVBCYalLNPuY1xRG2JIt64HHV rizqirazkafi56@gmail.com"
    # nixosvm-efi
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtzb3oMobBQVSza6gjWUMteRTNk+LRNBQqRSx3UrN1V rizqirazkafi56@gmail.com
    ''
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    lazygit
    tmux
    vim
    neovim
    wget
    git
    home-manager
    htop
    ranger
  ];
  services.qemuGuest.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  security.pam.enableSSHAgentAuth = true;
  services.openssh = {
    enable = true;
    banner = ''
         _____ ________    ___    __  ______  ______
        / ___// ____/ /   /   |  /  |/  /   |/_  __/
        \__ \/ __/ / /   / /| | / /|_/ / /| | / /
       ___/ / /___/ /___/ ___ |/ /  / / ___ |/ /
      /____/_____/_____/_/  |_/_/  /_/_/  |_/_/

          ____  ___  _________    _   ________
         / __ \/   |/_  __/   |  / | / / ____/
        / / / / /| | / / / /| | /  |/ / / __
       / /_/ / ___ |/ / / ___ |/ /|  / /_/ /
      /_____/_/  |_/_/ /_/  |_/_/ |_/\____/

    '';
    ports = [ 9005 ];
    settings.PasswordAuthentication = false;
  };
  # services.openssh.settings.PermitRootLogin = "prohibit-password";
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 9005 80 443 ];
  system.stateVersion = "23.05";

}
