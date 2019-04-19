{ config, pkgs, ... }:
let
  restart-taffybar = ''
    echo "Restarting taffybar..."
    $DRY_RUN_CMD rm -fr $HOME/.cache/taffybar/
    $DRY_RUN_CMD systemctl --user restart taffybar.service
  '';
in {
  nixpkgs.overlays = [
    (import ./home-overlays/lorri)
    (import ./home-overlays/obelisk)
    (import ./home-overlays/spacemacs)
    (import ./home-overlays/direnv)
    (import ./home-overlays/taffybar)
  ];

  home.packages = with pkgs; [
    awscli
    cabal2nix
    cachix
    dmenu
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
    lorri
    obelisk.command
    openshot-qt
    p7zip
    pavucontrol
    python3
    ranger
    rfkill
    silver-searcher
    simplescreenrecorder
    slack
    xlockmore
    xorg.xbacklight
  ];

  home.file."bin" = { source = ./bin; recursive = true; };
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BROWSER = "firefox";
  };

  programs.home-manager = {
    enable = true;
  };

  programs.direnv.enable = true;
  programs.chromium.enable = true;
  programs.firefox.enable = true;

  home.file.".spacemacs".source = ./dotfiles/emacs/spacemacs;
  home.activation.linkEmacsCustom = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.spacemacs.d;
    ln -sf "${config.home.homeDirectory}/.config/nixpkgs/dotfiles/emacs/custom.el" $HOME/.spacemacs.d/custom.el;
  '';
  home.file.".emacs.d" = {
    source = pkgs.spacemacs;
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
    shading = 50;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "steeef";
    };
  };
  programs.vscode.enable = true;

  home.file.".gitmessage".source = ./dotfiles/git/gitmessage;
  programs.git = {
    enable = true;
    userName = "Ben Kolera";
    userEmail = "ben.kolera@gmail.com";
    ignores = [];
    extraConfig = {
      commit = {
        template = "${config.home.homeDirectory}/.gitmessage";
      };
    };
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
    inactiveInterval = 10;
  };

  services.xembed-sni-proxy.enable = true;

  services.pasystray.enable = true;
  home.file.".config/taffybar/taffybar.hs" = {
    source = ./dotfiles/taffybar/taffybar.hs;
    onChange = restart-taffybar;
  };
  home.file.".config/taffybar/taffybar.css" = {
    source = ./dotfiles/taffybar/taffybar.css;
    onChange = restart-taffybar;
  };
  services.taffybar.enable = true;
  services.status-notifier-watcher.enable = true;
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

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hpkgs: [
        hpkgs.xmonad-contrib
        hpkgs.taffybar
      ];
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

  home.language.base = "en_au";
  '';
}
