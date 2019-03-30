{ config, pkgs, ... }:
let
  obelisk = import ./obelisk {};
  spacemacs = import ./spacemacs {};
in
{

  home.packages = with pkgs; [
    awscli
    cabal2nix
    cachix
    dmenu
    ranger
    xlockmore
    gitAndTools.gitflow
  ]++
  ( with haskellPackages; [
    ghcid
    stylish-haskell
    xmobar
    yeganesh
  ]) ++ [
    keepassx
    libreoffice
    obelisk.command
    openshot-qt
    pavucontrol
    python3
    p7zip
    ranger
    rfkill
    silver-searcher
    simplescreenrecorder
    slack
    xlockmore
    xorg.xbacklight
  ];

  home.file."bin/git-clone-gh".source = ./bin/git-clone-gh;
  home.file."bin/git-clone-gl".source = ./bin/git-clone-gl;
  home.file."bin/git-clone-csiro".source = ./bin/git-clone-csiro;

  programs.home-manager = {
    enable = true;
  };

  programs.direnv.enable = true;
  programs.chromium.enable = true;
  programs.firefox.enable = true;

  home.file.".spacemacs".source = ./dotfiles/emacs/spacemacs;
  home.activation.linkEmacsCustom = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf "${config.home.homeDirectory}/.config/nixpkgs/dotfiles/emacs/custom.el" $HOME/.spacemacs.d/custom.el;
  '';
  home.file.".emacs.d" = {
    source = spacemacs;
    recursive = true;
  };
  programs.emacs.enable = true;

  programs.htop.enable = true;
  programs.urxvt = {
    enable = true;
    fonts = ["xft:Source Code Pro:size=11"];
    keybindings = {
      "Shift-Control-C" = "eval:selection_to_clipboard";
      "Shift-Control-V" = "eval:paste_clipboard";
    };
    transparent = true;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "steeef";
    };
  };
  programs.vscode.enable = true;

  programs.git = {
    enable = true;
    userName = "Ben Kolera";
    userEmail = "ben.kolera@gmail.com";
    ignores = [];
  };

  programs.zathura.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 36000;
    maxCacheTtl = 36000;
    defaultCacheTtlSsh = 36000;
    maxCacheTtlSsh = 36000;
    enableSshSupport = true;
  };
  
  home.file."backgrounds" = {
    source = ./backgrounds;
    recursive = true;
  };
  services.random-background = {
    enable = true;
    imageDirectory = "%h/backgrounds";
  };
  services.screen-locker = {
    enable = true;
    lockCmd = "xlock -mode blank";
    inactiveInterval = 3;
  };

  services.compton.enable = true;

  services.stalonetray = {
    enable = true;
    config = {
      icon_size = 22;
      kludges = "fix_window_pos,force_icons_size";
      sticky = 1;
      window_type = "dock";
      window_strut = "auto";
      skip_taskbar = 1;
      icon_gravity = "NE";
      background = "black";
      geometry = "5x1-0+0";
      window_layer = "top";
    };
  };
  services.pasystray.enable = true;
  services.taffybar.enable = false;
  services.blueman-applet.enable = true;
  services.flameshot.enable = true;
  services.unclutter.enable = true;
  services.network-manager-applet.enable = true;

  services.redshift = {
    enable = true;
    brightness.day = "1.0";
    brightness.night = "0.7";
    longitude  = "153.0251";
    latitude = "-27.4698";
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Source Code Pro";
        markup = "full";
        format = "<b>%s</b>\\n%b";
        icon_position = "left";
        sort = true;
        alignment = "center";
        geometry = "500x60-15+49";
        browser = "/usr/bin/firefox -new-tab";
        transparency = 10;
        word_wrap = true;
        show_indicators = false;
        separator_height = 2;
        padding = 6;
        horizontal_padding = 6;
        separator_color = "frame";
        frame_width = 2;
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
      urgency_low = {
        frame_color = "#3B7C87";
        foreground = "#3B7C87";
        background = "#191311";
        timeout = 4;
      };
      urgency_normal = {
        frame_color = "#5B8234";
        foreground = "#5B8234";
        background = "#191311";
        timeout = 6;
      };
      urgency_critical = {
        frame_color = "#B7472A";
        foreground = "#B7472A";
        background = "#191311";
        timeout = 8;
      };
    };
  };

  home.file."bin/tray-pad-icon".source = ./bin/tray-pad-icon;
  home.file.".xmonad/xmobar.hs".source = ./dotfiles/xmonad/xmobar.hs;
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./dotfiles/xmonad/xmonad.hs;
    };
  };

  xresources.extraConfig = ''
	! special
	*.foreground:   #c5c8c6
	*.background:   #1d1f21
	*.cursorColor:  #c5c8c6

	! black
	*.color0:       #282a2e
	*.color8:       #373b41

	! red
	*.color1:       #a54242
	*.color9:       #cc6666

	! green
	*.color2:       #8c9440
	*.color10:      #b5bd68

	! yellow
	*.color3:       #de935f
	*.color11:      #f0c674

	! blue
	*.color4:       #5f819d
	*.color12:      #81a2be

	! magenta
	*.color5:       #85678f
	*.color13:      #b294bb

	! cyan
	*.color6:       #5e8d87
	*.color14:      #8abeb7

	! white
	*.color7:       #707880
	*.color15:      #c5c8c6
  '';
}