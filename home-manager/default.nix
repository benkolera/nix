{ config, pkgs, lib, ... }:
let
  scripts = import ./scripts pkgs;
in {
  nixpkgs.overlays = [
    (import ./home-overlays/haskell-gtk.nix)
    (import ./home-overlays/direnv)
    (import ./home-overlays/obelisk)
    (import ./home-overlays/tmux-themepack)
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  home.packages = with pkgs; [
    aws-okta
    aws-vault
    awscli
    brave
    cabal2nix
    dmenu
    glances
    gitAndTools.gitflow
    gimp
    ghostscript
    gocode
    goimports
    gogetdoc
    epiphany
    feh
  ]++
  ( with haskellPackages; [
    ghcid
    xmobar
    yeganesh
  ]) ++ [
    inkscape
    jq
    libreoffice
    metals
    nixops
    niv
    nodejs
    nodePackages.npm
    obelisk.command
    p7zip
    pavucontrol
    python3
    ranger
    rescuetime
    rfkill
    ripgrep
  ] ++ scripts.all ++ [
    sbt
    signal-desktop
    silver-searcher
    simplescreenrecorder
    slack
    thunderbird
    xlockmore
    tmate
    xsel
    xorg.xbacklight
    xorg.xkill
    zoom-us
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BROWSER = "firefox";
  };

  programs.home-manager = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 2;
          y = 2;
        };
        startup_mode = "Fullscreen";
      };
      font = {
        normal = {
          family = "Inconsolata";
        };
        size = 14;
      };
      colors = {
        primary = {
          background = "0x282a36";
          foreground = "0xf8f8f2";
        };
        normal = {
          black = "0x000000";
          red = "0xff5555";
          green = "0x50fa7b";
          yellow = "0xf1fa8c";
          blue = "0xcaa9fa";
          magenta = "0xff79c6";
          cyan = "0x8be9fd";
          white = "0xbfbfbf";
        };

        bright = {
          black = "0x282a35";
          red = "0xff6e67";
          green = "0x5af78e";
          yellow = "0xf4f99d";
          blue = "0xcaa9fa";
          magenta = "0xff92d0";
          cyan = "0x9aedfe";
          white = "0xe6e6e6";
        };
      };
    };
  };
  programs.direnv.enable = true;
  programs.chromium.enable = true;
  programs.firefox.enable = true;

  programs.emacs = {
    enable  = true;
    package = pkgs.emacs.override { inherit (pkgs) imagemagick; };
    extraPackages = epkgs: with epkgs; [ 
      adaptive-wrap
      all-the-icons-ivy
      avy
      company
      counsel
      counsel-projectile
      dashboard
      deadgrep
      direnv
      doom-modeline
      doom-themes
      eglot
      evil
      evil-collection
      evil-leader
      evil-exchange
      evil-magit
      evil-matchit
      evil-numbers
      evil-surround
      evil-visualstar
      fill-column-indicator
      git-gutter
      git-gutter-fringe
      golden-ratio
      haskell-mode
      ivy
      ivy-rich
      magit
      nix-mode
      pdf-tools 
      projectile
      rainbow-delimiters
      ranger
      swiper
      scala-mode
      treemacs
      treemacs-projectile
      treemacs-evil
      undo-tree
      use-package
      use-package-ensure-system-package
      visual-fill-column
      which-key
      ];
  };
  services.emacs.enable = true;
  home.file.".emacs.d" = { source = ./dotfiles/emacs.d; recursive = true;};

  programs.fzf = {
    enable = true;
  };

  programs.htop.enable = true;
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "steeef";
    };
  };
  programs.vscode = {
    enable = true;
    userSettings = {
      editor = {
        formatOnSave = true;
        rulers = [120];
        minimap.enabled = false;
        tabSize = 2;
        insertSpaces = true;
      };
      window = {
        menuBarVisibility = "toggle";
        zoomLevel = -1;
      };
    };
  };
  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 10000;
    terminal = "screen-256color";
    aggressiveResize = true;
    shortcut = "a";
    extraConfig = ''
      unbind '"'
      unbind %
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      set -gq status-utf8 on
      setw -g mouse on
      set-option -s set-clipboard off
      bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection -i"
      bind-key -T copy-mode Enter send-keys -X copy-pipe-and-cancel "xclip -i"
      set -sg escape-time 0
      source-file "${pkgs.tmux-themepack}/powerline/default/orange.tmuxtheme"
    '';
  };
  home.file.".gitmessage".source = ./dotfiles/git/gitmessage;
  programs.git = {
    enable = true;
    userName = "Ben Kolera";
    userEmail = "ben.kolera@gmail.com";
    ignores = [];
    signing = {
      key = "B1E028581508635A";
      signByDefault = true;
    };
    extraConfig = {
      commit = {
        template = "${config.home.homeDirectory}/.gitmessage";
      };
    };
  };

  programs.zathura.enable = true;
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 36000;
    maxCacheTtl = 36000;
    defaultCacheTtlSsh = 36000;
    maxCacheTtlSsh = 36000;
    enableSshSupport = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-qt}/bin/pinentry
    '';
  };
  home.file."backgrounds" = {
    source = ./backgrounds;
    recursive = true;
  };
  services.lorri.enable = true;
  services.random-background = {
    enable = true;
    imageDirectory = "%h/backgrounds";
  };
  services.screen-locker = {
    enable = true;
    lockCmd = "xlock -mode blank";
    inactiveInterval = 10;
  };
  services.blueman-applet.enable = true;
  services.flameshot.enable = true;
  services.unclutter.enable = true;
  services.network-manager-applet.enable = true;
  services.rsibreak.enable = true;
  services.stalonetray.enable = true;
  services.pasystray.enable = true;

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
        font = "Inconsolata";
        markup = "full";
        format = "<b>%s</b>\\n%b";
        icon_position = "left";
        sort = true;
        alignment = "center";
        geometry = "500x60-15+49";
        browser = "firefox -new-tab";
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

  systemd.user.services.rescuetime = {
    Unit = {
        Description = "Rescuetime daemon";
        Requires = "graphical-session.target";
        After = "stalonetray.service";
    };

    Service = {
        Environment =
          let toolPaths = lib.makeBinPath [ pkgs.firefox pkgs.gnugrep ];
          in [ "PATH=${toolPaths}" "BROWSER=firefox" ];
        ExecStart = "${pkgs.rescuetime}/bin/rescuetime";
    };
  };

  home.file.".xmonad/xmobar.hs".source = ./dotfiles/xmonad/xmobar.hs;
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hpkgs: [
        hpkgs.xmonad-contrib
      ];
      config = ./dotfiles/xmonad/xmonad.hs;
    };
  };

  xresources.extraConfig = ''
  ! special
  *.foreground:   #c5c8c6
  *.background:   #000000
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
