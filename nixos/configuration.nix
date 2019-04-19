# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./machine.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://cachix.cachix.org"
      "https://nixcache.reflex-frp.org"
      "http://hydra.qfpl.io"
      "https://hie-nix.cachix.org"
    ];
    binaryCachePublicKeys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "qfpl.io:xME0cdnyFcOlMD1nwmn6VrkkGgDNLLpMXoMYl58bz5g="
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
    ];
    trustedUsers = [ "root" "bkolera" ];
  };
  hardware.bluetooth = {
    enable = true;
    extraConfig = "
      [General]
      Enable=Source,Sink,Media,Socket
    ";
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    daemon.config = {
      # Allow app volumes to be set independently of master
      flat-volumes = "no";
    };
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
    };
  };
  nixpkgs.config = {
    allowUnfree = true;
    chromium = {
     #enablePepperFlash = true;
     enablePepperPDF = true;
    };
    packageOverrides = pkgs: {
      unstable = import <unstable> {
        config = config // { allowUnfree = true; };
      };
    };
  };

  fonts = {
    enableFontDir = true;
     fonts = with pkgs; [
       emojione
       source-code-pro
     ];
  };


  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Australia/Brisbane";


  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    arandr
    binutils
    bind
    blueman
    file
    gcc6
    gnumake
    gparted
    htop
    iptables
    libpqxx
    manpages
    nixops
    ] ++
    ( with nodePackages; [
      bower
      npm
      tern
    ]) ++ [
    nmap
    ncdu
    openssl
    psmisc
    sudo
    traceroute
    tcpdump
    tree
    vim
    wireshark
    wget
    xclip
    xfontsel
    xlsfonts
    xorg.xbacklight
    unzip
    zip
    zlib
  ];

  services = {
    upower.enable = true;
    openssh.enable = true;
    printing.enable = true;
    devmon.enable = true;
    postgresql.enable = true;
    dbus.packages = [ pkgs.blueman ];
    xserver = {
      enable = true;
      layout = "us";
      displayManager.lightdm.enable = true;
      libinput = {
        enable = true;
        naturalScrolling = true;
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  programs = {
    java.enable = true;
    mtr.enable = true;
  };

  virtualisation.virtualbox.host = {
    enable = true;
    headless = false;
  };

  users.extraUsers.bkolera = {
    isNormalUser = true;
    createHome = true;
    home = "/home/bkolera";
    extraGroups = ["wheel" "networkmanager" "docker" "audio" "dialout"];
    isSystemUser = false;
    shell = pkgs.zsh;
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";

}
