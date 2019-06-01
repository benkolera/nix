machineName:
{ config, pkgs, ... }:
let 
  thisPath = ./.;
  home-manager-src = import "${thisPath}/deps/home-manager";
in {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      "${thisPath}/machine.${machineName}.nix"
      "${home-manager-src}/nixos"
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
  };

  fonts = {
    enableFontDir = true;
     fonts = with pkgs; [
       noto-fonts-emoji
       nerdfonts
       emojione
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
    manpages
    nmap
    ncdu
    openssl
    parted
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
    smokeping = {
      enable = true;
      targetConfig = ''
          probe = FPing
          menu = Top
          title = Network Latency Grapher
          remark = Welcome to the SmokePing website of xxx Company. \
                   Here you will learn all about the latency of our network.
          + FPing
          menu = FPing
          title = FPing
          ++ Google
          menu = Google
          title = Google
          host = google.com
      '';
    };
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

  home-manager.users.bkolera = import ./home-manager;
  users.users.bkolera = {
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
