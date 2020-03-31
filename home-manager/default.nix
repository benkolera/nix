{ config, pkgs, lib, ... }:
let
  restart-taffybar = ''
    echo "Restarting taffybar..."
    $DRY_RUN_CMD rm -fr $HOME/.cache/taffybar/
    $DRY_RUN_CMD systemctl --user restart taffybar.service && true
    echo "Taffybar restart done"
  '';
  isKakFile = name: type: type == "regular" && lib.hasSuffix ".kak" name;
  isDir     = name: type: type == "directory";
  allKakFiles = (dir: 
    let fullPath = p: "${dir}/${p}";
        files = builtins.readDir dir;
        subdirs  = lib.concatMap (p: allKakFiles (fullPath p)) (lib.attrNames (lib.filterAttrs isDir files));
        subfiles = builtins.map fullPath (lib.attrNames (lib.filterAttrs isKakFile files));
    # This makes sure the most shallow files are loaded first
    in (subfiles ++ subdirs)
  );
  kakImport = name: ''source "${name}"'';
  allKakImports = dir: builtins.concatStringsSep "\n" (map kakImport (allKakFiles dir));
in {
  nixpkgs.overlays = [
    (import ./home-overlays/haskell-gtk.nix)
    (import ./home-overlays/direnv)
    (import ./home-overlays/obelisk)
    (import ./home-overlays/spacemacs)
    (import ./home-overlays/tmux-themepack)
    (import ./home-overlays/kak-fzf)
    (import ./home-overlays/kak-powerline)
    (import ./home-overlays/kaktree)
    (import ./home-overlays/kakoune)
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  home.packages = with pkgs; [
    awscli
    brave
    cabal2nix
    #cachix Cachix is busted for now
    dmenu
    gitAndTools.gitflow
    gimp
    ghostscript
    gocode
    goimports
    gogetdoc
    epiphany
    #elmPackages.elm
    #elmPackages.elm-format
  ]++
  ( with haskellPackages; [
    ghcid
    xmobar
    yeganesh
  ]) ++ [
    inkscape
    jq
    keepassx
    libreoffice
    # ledger-live-desktop
    libpqxx
    nixops
    nodejs
    nodePackages.npm
    obelisk.command
    # Busted as of 2020-02-25
    #openshot-qt
    p7zip
    pandoc
    pavucontrol
    python3
    python3Packages.grip
    ranger
    rfkill
    sbt
    signal-desktop
    silver-searcher
    simplescreenrecorder
    slack
    thunderbird
    xlockmore
    tig
    tmate
    xsel
    xorg.xbacklight
    zoom-us
  ];

  home.file."bin" = { source = ./bin; recursive = true; };
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BROWSER = "brave";
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
          family = "Source Code Pro";
          size = 11.0;
        };
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

  home.file.".spacemacs".source = ./dotfiles/emacs/spacemacs;
  home.activation.checkoutOrg = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    FOLDER="$HOME/org";
    if [ ! -d "$FOLDER" ] ; then
      git clone "git@github.com:benkolera/org" "$FOLDER"
    fi
  '';
  home.file.".emacs.d" = {
    source = pkgs.spacemacs;
    recursive = true;
  };
  programs.emacs = {
    enable  = true;
    package = pkgs.emacs.override { inherit (pkgs) imagemagick; };
    extraPackages = epkgs: with epkgs; [pdf-tools];
  };
  programs.fzf = {
    enable = true;
  };

  programs.htop.enable = true;
  programs.urxvt = {
    enable = true;
    fonts = ["xft:Source Code Pro:size=11"];
    keybindings = {
    };
    transparent = false;
    shading = 90;
  };

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
  programs.kakoune = {
    enable = true; 
    config = {
      colorScheme = "zenburn";
      tabStop = 4;
      indentWidth = 2;
      ui = {
        enableMouse = true;
        setTitle = false;
      };
      numberLines.enable = true;
      showWhitespace.enable = true;
      keyMappings = [
        { mode = "normal"; key = "'#'"; effect = ":comment-line<ret>"; }
        { mode = "normal"; key = "'<c-p>'"; effect = ":fzf-mode<ret>"; }
        { mode = "normal"; key = "'<space>'"; effect = ","; docstring = "leader"; }
        { mode = "normal"; key = "'<backspace>'"; effect = "<space>"; docstring = "remove all sels except main"; }
        { mode = "normal"; key = "'<a-backspace>'"; effect = "<a-space>"; docstring = "remove main sel"; }
        { mode = "user"; key = "'p'"; effect = "!xclip -o -selection clipboard<ret>"; docstring = "paste (after) from clipboard"; }
        { mode = "user"; key = "'P'"; effect = "<a-!>xclip -o -selection clipboard<ret>"; docstring = "paste (before) from clipboard"; }
        { mode = "user"; key = "'y'"; effect = "<a-|>xclip -i -selection clipboard<ret>:echo copied selection to x11 clipboard<ret>"; docstring = "Yank to clipboard"; }
        { mode = "user"; key = "'R'"; effect = "|xclip -o -selection<ret>"; docstring = "Replace from clipboard"; }
        { mode = "normal"; key = "'x'"; effect = ":extend-line-down %val{count}<ret>"; }
        { mode = "normal"; key = "'X'"; effect = ":extend-line-up %val{count}<ret>"; }
      ];
      hooks = [
        { name = "WinSetOption"; option = "filetype=elm"; 
          commands = ''
            set window formatcmd 'elm-format --stdin'
            hook buffer BufWritePre .* %{format}
          '';
        }
        { name = "WinSetOption"; option = "filetype=haskell"; 
          commands = ''
            set window formatcmd 'stylish-haskell'
            hook buffer BufWritePre .* %{format}
          '';
        }
        { name = "WinSetOption"; option = "filetype=kaktree";
          commands = ''
            remove-highlighter buffer/numbers
            remove-highlighter buffer/matching
            remove-highlighter buffer/wrap
            remove-highlighter buffer/show-whitespaces
          '';
        }
      ];
    };
    extraConfig = ''
     
      ${allKakImports pkgs.kak-fzf}
      ${allKakImports pkgs.kak-powerline}
      ${allKakImports pkgs.kaktree}
      kaktree-enable
      hook global ModuleLoaded kaktree %{
        set-option global kaktree_double_click_duration '0.5'
        set-option global kaktree_indentation 1
        set-option global kaktree_dir_icon_open  '▾ 🗁 '
        set-option global kaktree_dir_icon_close '▸ 🗀 '
        set-option global kaktree_file_icon      '⠀⠀🖺'
      }
      define-command mkdir %{ nop %sh{ mkdir -p $(dirname $kak_buffile) } }
      set-option global grepcmd 'ag --column'
      add-highlighter global/ show-matching
      add-highlighter global/ show-whitespaces
 
      declare-option -hidden regex curword
      set-face global CurWord default,rgb:4a4a4a
 
      add-highlighter global/ dynregex '%opt{curword}' 0:CurWord
      def -params 1 extend-line-down %{
        exec "<a-:>%arg{1}X"
      }
      def -params 1 extend-line-up %{
        exec "<a-:><a-;>%arg{1}K<a-;>"
        try %{
          exec -draft ';<a-K>\n<ret>'
          exec X
        }
        exec '<a-;><a-X>'
      }
      declare-user-mode tig
      map global tig m ': repl "${pkgs.tig}/bin/tig"<ret>' -docstring 'show main view (with tig)'

      declare-user-mode kaktree
      map global kaktree t ': kaktree-toggle<ret>' -docstring 'Toggle kaktree'
      map global kaktree f ': kaktree-focus<ret>' -docstring 'Focus kaktree'

      map global user g ': enter-user-mode tig<ret>' -docstring 'tig commands'

      map global user r ': repl ranger<ret>' -docstring 'select files in ranger'
      
      map global user t ': enter-user-mode kaktree<ret>' -docstring 'kaktree commands'

    '';
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

  services.blueman-applet.enable = false;
  services.flameshot.enable = true;
  services.unclutter.enable = true;
  services.network-manager-applet.enable = true;

  services.redshift = {
    enable = false;
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
