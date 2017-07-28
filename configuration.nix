{ config, pkgs, ... }:

let
  antigen = pkgs.fetchgit {
    url = "https://github.com/zsh-users/antigen";
    rev = "1d212d149d039cc8d7fdf90c016be6596b0d2f6b";
    sha256 = "1c7ipgs8gvxng3638bipcj8c1s1dn3bb97j8c73piv2xgk42aqb9";
  };
  meta = import /etc/nixos/meta.nix;
  isHome = meta.hostname == "nyx";
  isWork = meta.hostname == "bkolera";
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # Use the GRUB 2 boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        efibootmgr = {
          canTouchEfiVariables = true;
          efiDisk = if isHome then "/dev/nvme0" else "/dev/sda1";
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.variables.XCURSOR_PATH = "$HOME/.icons";
  environment.profileRelativeEnvVars.XCURSOR_PATH = [ "/share/icons" ];
  environment.systemPackages = with pkgs; [
    arandr
    aspell
    aspellDicts.en
    awscli
    bc
    binutils
    cabal2nix
    chromium
    docker
    dmenu
    emacs
    expect
    firefox-esr
    gcc
    ghc
    gitAndTools.gitFull
    gitAndTools.gitflow
    gnumake
    ] ++
    ( with haskellPackages; [
      cabal-install
      dante
      steeloverseer
      stylish-haskell
      taffybar
      xmobar
      xmonad
      xmonad-contrib
      xmonad-extras
      yeganesh
    ]) ++ [
    iptables
    lastpass-cli
    maim
    manpages
    nix
    npm2nix
    ] ++
    ( with nodePackages; [
      bower
      npm
    ]) ++ [
    nmap
    nodejs
    openvpn
    psmisc #killall
    purescript
    ] ++
    ( with pythonPackages ; [
      ansible
      docker_compose
    ]) ++ [
    rxvt_unicode
    ranger
    scala
    sbt
    silver-searcher
    slop
    stalonetray
    sudo
    taffybar
    tcpdump
    trayer
    vanilla-dmz
    vim
    vimHugeX
    vscode
    wireshark
    wget
    xclip
    xfontsel
    xlockmore
    xlsfonts
    xscreensaver
    unzip
    zip
    zlib
  ];

  networking = {
    networkmanager.enable = true;
    hostName = meta.hostname;
    firewall = {
      allowPing = true;
      allowedTCPPorts = [ 3000 ];
      allowedUDPPorts = [ ];
    };
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_AU.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  services = {
    upower.enable = true;
    openssh.enable = true;
    postgresql.enable = true;
    openvpn.servers = {};
    xserver = {
      enable = true;
      layout = "us";
      displayManager.lightdm.enable = true;
      desktopManager.default = "none";
      dpi = 216;
      videoDrivers = [ "nvidia" ];
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
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.bkolera = {
    isNormalUser = true;
    createHome = true;
    home = "/home/bkolera/";
    extraGroups = ["wheel" "networkmanager" "docker"];
    isSystemUser = false;
    shell = pkgs.zsh;
    uid = 1000;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  programs = {
    java.enable = true;
    zsh = {
      enable = true;
      shellAliases = {
      };
      enableCompletion = true;
      interactiveShellInit = ''
        source ${antigen}/antigen.zsh
        HISTFILE=~/.histfile
        HISTSIZE=5000
        SAVEHIST=10000
        setopt appendhistory share_history histignorealldups autocd extendedglob nomatch notify

        unsetopt beep
        bindkey -v

        zstyle ':completion:*' menu select

        autoload -U url-quote-magic
        zle -N self-insert url-quote-magic

        autoload -Uz compinit && compinit

        PATH="$HOME/bin:$HOME/.local/bin:$HOME/.npm-packages/bin:$PATH"

        antigen use oh-my-zsh

        antigen theme steeef
        antigen bundle ssh-agent
        antigen bundle zsh-users/zsh-syntax-highlighting

        antigen apply
      '';
    };
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
