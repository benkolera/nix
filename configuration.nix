# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget 
    vimHugeX 
    sudo
    manpages
    gitAndTools.gitFull
    iptables nmap tcpdump
    rxvt_unicode
    zlib
    bc
    gcc
    binutils
    vim
    nix
    chromium
    firefoxWrapper
    trayer
    ghc
    haskellPackages.xmobar
    haskellPackages.xmonad
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    haskellPackages.yeganesh
    xfontsel
    xlsfonts
    dmenu
    stalonetray
    xscreensaver
    xclip
    maim
    vscode
  ];

  # Use the GRUB 2 boot loader.
  boot = {
    initrd = {
      checkJournalingFS = false;
      kernelModules = ["fbcon"];
    };
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "/dev/sda"; 
      };
    };
  };
  
  networking = {
    networkmanager.enable = true;
    hostName = "nyx"; 
    firewall = {
      allowPing = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      desktopManager.default = "none";
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
    };
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.bkolera = {
    isNormalUser = true;
    createHome = true;
    home = "/home/bkolera/";
    extraGroups = ["wheel" "networkmanager"];
    isSystemUser = false;
    useDefaultShell = true; 
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
