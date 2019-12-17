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
      "http://nixcache.kadena.io"
      "https://nixcache.reflex-frp.org"
      "https://hydra.iohk.io"
      "http://hydra.qfpl.io"
      "https://hie-nix.cachix.org"
      "https://s3.eu-west-3.amazonaws.com/tezos-nix-cache"
    ];
    binaryCachePublicKeys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "qfpl.io:xME0cdnyFcOlMD1nwmn6VrkkGgDNLLpMXoMYl58bz5g="
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "obsidian-tezos-kiln:WlSLNxlnEAdYvrwzxmNMTMrheSniCg6O4EhqCHsMvvo="
      "kadena-cache.local-1:8wj8JW8V9tmc5bgNNyPM18DYNA1ws3X/MChXh1AQy/Q="
    ];
    trustedUsers = [ "root" "bkolera" ];
  };
  hardware.bluetooth = {
    enable = true;
    config = "
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
  };

  fonts = {
    enableFontDir = true;
     fonts = with pkgs; [
       noto-fonts-emoji
       nerdfonts
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
    postgresql = {
      enable = true;
      extraConfig = ''
        log_directory = '/tmp/pg_log'                    
        log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
        log_statement = 'all'
      '';
    };
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

    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c", MODE="0660", GROUP="users"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="2b7c", MODE="0660", GROUP="users"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="3b7c", MODE="0660", GROUP="users"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="4b7c", MODE="0660", GROUP="users"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1807", MODE="0660", GROUP="users"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1808", MODE="0660", GROUP="users"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000", MODE="0660", GROUP="users"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", GROUP="users"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0004", MODE="0660", GROUP="users"
    '';
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
    enableOnBoot = false;
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
