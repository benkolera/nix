machineName:
{ config, pkgs, ... }:
let
  thisPath = ./.;
  niv-sources = import "${thisPath}/nix/sources.nix";
in {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      "${thisPath}/machine.${machineName}.nix"
      "${niv-sources.home-manager}/nixos"
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
  hardware.bluetooth = {
    enable = true;
    config = {
      General = {
        Enable="Source,Sink,Media,Socket";
      };
    };
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [ ./pulse-audio-gsx-1000.patch ];
    });
    daemon.config = {
      # Allow app volumes to be set independently of master
      flat-volumes = "no";
    };
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
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
       emacs-all-the-icons-fonts
       inconsolata
     ];
  };


  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  i18n.defaultLocale = "en_US.UTF-8";
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
    git
    gnumake
    gparted
    htop
    iptables
    manpages
    nmap
    ncdu
    openssl
    parted
    pciutils
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
    memcached.enable = true;
    devmon.enable = true;
    gnome3.gnome-keyring.enable = true;
    postgresql = {
      enable = true;
      extraConfig = ''
        log_directory = '/tmp/pg_log'
        log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
        log_statement = 'all'
      '';
    };
    dbus.packages = [ pkgs.blueman ];
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
      displayManager = {
        lightdm = {
          enable = true;
        };
      };
      libinput = {
        enable = true;
        naturalScrolling = false;
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
    ssh.startAgent = true;
  };

  virtualisation.virtualbox.host = {
    enable = true;
    headless = false;
  };

  home-manager.users.bkolera = import ./home-manager;
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

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";

}
