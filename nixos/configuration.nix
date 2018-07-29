# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import <unstable> {};
  sni = import ./lib/sni.nix;
  status-notifier-item = unstable.haskellPackages.callPackage sni {};
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

  nix.binaryCaches = [
    "https://cache.nixos.org/"
    "https://nixcache.reflex-frp.org"
    "http://hydra.qfpl.io"
  ];
  nix.binaryCachePublicKeys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    "qfpl.io:xME0cdnyFcOlMD1nwmn6VrkkGgDNLLpMXoMYl58bz5g="
  ];


  hardware.pulseaudio.enable = true;

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
    cabal2nix
    chromium
    dmenu
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
      xmobar
      yeganesh
    ]) ++ [
    htop
    imagemagick
    iptables
    lastpass-cli
    libreoffice
    libpqxx
    maim
    manpages
    ] ++
    ( with nodePackages; [
      bower
      npm
      tern
    ]) ++ [
    nmap
    ncdu
    nodejs
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
    scala
    sbt
    silver-searcher
    simplescreenrecorder
    status-notifier-item
    slack
    slop
    sudo
    unstable.taffybar
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
      libinput.enable = true;
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
