# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  cachix = import (fetchTarball { url = "https://github.com/cachix/cachix/tarball/master"; }) {};
  obelisk = import (fetchTarball { url = "https://github.com/obsidiansystems/obelisk/archive/master.tar.gz"; }) {};
in
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
        efibootmgr = {
          canTouchEfiVariables = true;
        };
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
    arandr
    arduino
    aspell
    aspellDicts.en
    awscli
    bc
    binutils
    bind
    blueman
    cabal2nix
    cachix
    chromium
    dmenu
    dunst
    dropbox
    emacs
    enlightenment.terminology
    expect
    feh
    file
    firefoxWrapper
    fswatch
    gimp
    gcc6
    ghc
    gitAndTools.gitFull
    gitAndTools.gitflow
    gnumake
    gparted
    ] ++
    ( with haskellPackages; [
      cabal-install
      ghcid
      stylish-haskell
      xmobar
      yeganesh
    ]) ++ [
    htop
    imagemagick
    iptables
    keepassx
    lastpass-cli
    libreoffice
    libpqxx
    maim
    manpages
    unstable.masterpdfeditor
    nixops
    ] ++
    ( with nodePackages; [
      bower
      npm
      tern
    ]) ++ [
    nmap
    ncdu
    nodejs
    obelisk.command
    openshot-qt
    openssl
    pavucontrol
    psmisc
    ] ++
    ( with pythonPackages ; [
      ansible
      docker_compose
    ]) ++ [
    p7zip
    rxvt_unicode
    ranger
    rfkill
    slack
    silver-searcher
    simplescreenrecorder
    slack
    slop
    sudo
    unstable.taffybar
    terminator
    traceroute
    tcpdump
    trayer
    tree
    vanilla-dmz
    vim
    vimHugeX
    vscode
    wireshark
    workrave
    wget
    xclip
    xfontsel
    xlockmore
    xlsfonts
    xscreensaver
    xorg.xbacklight
    unzip
    vagrant
    yarn
    zip
    zlib
  ];

  services = {
    upower.enable = true;
    openssh.enable = true;
    printing.enable = true;
    devmon.enable = true;
    redshift = {
      enable = true;
      brightness.day = "1.0";
      brightness.night = "0.7";
      longitude  = "153.0251";
      latitude = "-27.4698";
    };
    xserver = {
      enable = true;
      layout = "us";
      displayManager.lightdm.enable = true;
      libinput = {
        enable = true;
        naturalScrolling = true;
      };
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = (haskellPkgs: [
            haskellPkgs.taffybar
          ]);
        };
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
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh = {
      enable = true;
      shellAliases = {
      };
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "steeef";
      };
    };
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
