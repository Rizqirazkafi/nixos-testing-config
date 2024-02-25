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

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos-vm"; # Define your hostname.
  # networking.interfaces.ens18.ipv4.addresses = [{ address = "192.168.30.60"; prefixLength = 25; }];
  # networking.defaultGateway.address = "192.168.30.1";
  networking.nameservers = [ "1.1.1.1" ];
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;

    };
    displayManager.defaultSession = "xfce";
  };

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "xfce4-session";
  services.xrdp.openFirewall = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rizqirazkafi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ firefox tree ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8rh5OxRHsKPT/ic6qA7G3VxqV9SVFW89CdLnVPDJNY rizqirazkafi56@gmail.com"
    ];

  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8rh5OxRHsKPT/ic6qA7G3VxqV9SVFW89CdLnVPDJNY rizqirazkafi56@gmail.com"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    lazygit
    ansible
    tmux
    vim
    neovim
    wget
    git
    home-manager
    htop
    alacritty
    inputs.latex.legacyPackages.x86_64-linux.texliveFull
  ];
  services.qemuGuest.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [ 9005 ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 9005 ];
  system.stateVersion = "23.05";

}
