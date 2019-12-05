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
    (import ./home-overlays/taffybar)
    (import ./home-overlays/direnv)
    (import ./home-overlays/lorri)
    (import ./home-overlays/obelisk)
    (import ./home-overlays/spacemacs)
    (import ./home-overlays/stylish-haskell)
    (import ./home-overlays/tmux-themepack)
    (import ./home-overlays/kak-fzf)
    (import ./home-overlays/kak-powerline)
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
    elmPackages.elm
    elmPackages.elm-format
  ]++
  ( with haskellPackages; [
    Agda
    ghcid
    xmobar
    yeganesh
  ]) ++ [
    inkscape
    jq
    keepassx
    libreoffice
    #ledger-live-desktop
    lorri
    libpqxx
    nixops
    nodejs
    nodePackages.npm
    obelisk.command
    openshot-qt
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
    stylish-haskell
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
    EDITOR = "kak";
    VISUAL = "kak";
    BROWSER = "brave";
  };

  programs.home-manager = {
    enable = true;
  };

  programs.direnv.enable = true;
  programs.chromium.enable = true;
  programs.firefox.enable = true;

  home.file.".config/stylish-haskell/config.yaml".source = ./dotfiles/stylish-haskell/config.yaml;

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
  home.file.".emacs.d/private/bkolera-org" = {
    source = ./dotfiles/emacs/layers/bkolera-org;
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
      ];
    };
    extraConfig = ''
     
      ${allKakImports pkgs.kak-fzf}
      ${allKakImports pkgs.kak-powerline}
 
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
      def suspend-and-resume \
          -params 1..2 \
          -docstring 'suspend-and-resume <cli command> [<kak command after resume>]: backgrounds current kakoune client and runs specified cli command.  Upon exit of command the optional kak command is executed.' \
          %{ evaluate-commands %sh{

          # Note we are adding '&& fg' which resumes the kakoune client process after the cli command exits
          cli_cmd="$1 && fg"
          post_resume_cmd="$2"

          # automation is different platform to platform
          platform=$(uname -s)
          case $platform in
              Darwin)
                  automate_cmd="sleep 0.01; osascript -e 'tell application \"System Events\" to keystroke \"$cli_cmd\\n\" '"
                  kill_cmd="/usr/bin/kill"
                  break
                  ;;
              Linux)
                  automate_cmd="sleep 0.2; ${pkgs.xdotool}/bin/xdotool type '$cli_cmd'; ${pkgs.xdotool}/bin/xdotool key Return"
                  kill_cmd="${pkgs.coreutils}/bin/kill"
                  break
                  ;;
          esac

          # Uses platforms automation to schedule the typing of our cli command
          ${pkgs.coreutils}/bin/nohup sh -c "$automate_cmd"  > /dev/null 2>&1 &
          # Send kakoune client to the background
          $kill_cmd -SIGTSTP $kak_client_pid

          # ...At this point the kakoune client is paused until the " && fg " gets run in the $automate_cmd

          # Upon resume, run the kak command is specified
          if [ ! -z "$post_resume_cmd" ]; then
              echo "$post_resume_cmd"
          fi
      }}
      def tig-blame -override -docstring 'Open blame in tig for current file and line' %{
          # Note here we aren't passing any command on resume of kakoune
          suspend-and-resume "${pkgs.tig}/bin/tig blame +%val{cursor_line} %val{buffile}" 
      }

      declare-user-mode tig
      map global tig b ': tig-blame<ret>' -docstring 'show blame (with tig)'
      map global tig s ': suspend-and-resume "${pkgs.tig}/bin/tig status"<ret>' -docstring 'show git status (with tig)'
      map global tig m ': suspend-and-resume "${pkgs.tig}/bin/tig"<ret>' -docstring 'show main view (with tig)'

      map global user t ': enter-user-mode tig<ret>' -docstring 'tig commands'

      def for-each-line \
          -docstring "for-each-line <command> <path to file>: run command with the value of each line in the file" \
          -params 2 \
          %{ evaluate-commands %sh{

          while read f; do
              printf "$1 $f\n"
          done < "$2"
      }}

      def toggle-ranger %{
          suspend-and-resume \
              "${pkgs.ranger}/bin/ranger --choosefiles=/tmp/ranger-files-%val{client_pid}" \
              "for-each-line edit /tmp/ranger-files-%val{client_pid}"
      }

      map global user r ': toggle-ranger<ret>' -docstring 'select files in ranger'

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
