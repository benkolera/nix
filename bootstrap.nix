# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://cachix.cachix.org"
      "https://nixcache.reflex-frp.org"
      "https://hydra.iohk.io"
    ];
    binaryCachePublicKeys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    trustedUsers = [ "root" "bkolera" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/sdb6";
      preLVM = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "bkolera-desktop"; # Define your hostname.
  networking.networkmanager.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Australia/Brisbane";

  environment.systemPackages = with pkgs; [
    wget vim firefox git pciutils
  ];

  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  fonts = {
    enableFontDir = true;
     fonts = with pkgs; [
       noto-fonts-emoji
       nerdfonts
       emojione
       source-code-pro
       emacs-all-the-icons-fonts
       inconsolata
     ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;

  users.mutableUsers = false;
  users.users.bkolera = {
    hashedPassword = "$6$ime8RtSc$eTZd4V07pOJmBkOPAR0acR7NTaLjv1dzvsetq3dFJARXvNKrEcH1kSyILTplQ2mXRdHHbAu7I3OWUG.GWle8G0";
    isNormalUser = true;
    createHome = true;
    home = "/home/bkolera";
    extraGroups = ["wheel" "networkmanager" "docker" "audio" "dialout"];
    isSystemUser = false;
    shell = pkgs.zsh;
    uid = 1000;
  };

  system.stateVersion = "20.03"; # Did you read the comment?

}

