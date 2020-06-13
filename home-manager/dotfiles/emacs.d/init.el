;; Turn off some crufty defaults
(setq
 inhibit-startup-message t inhibit-startup-echo-area-message (user-login-name)
 initial-major-mode 'fundamental-mode initial-scratch-message nil
 fill-column 120
 locale-coding-system 'utf-8
 )

(setq-default
  tab-width 2
  indent-tabs-mode nil
  )

(defalias 'yes-or-no-p 'y-or-n-p)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(add-to-list 'default-frame-alist
  '(font . "Inconsolata-12"))
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(global-hl-line-mode t)

;; Setup use package that must use system packages
(require 'package)
(setq package-archives nil)
(package-initialize)
(require 'use-package)
(use-package use-package-ensure-system-package :ensure t)

;; Setup our custom file for local state
(setq custom-file "~/.emacs.d/custom.el")
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load-file custom-file)

(use-package all-the-icons)

(use-package doom-themes
  :after all-the-icons
  :config
  (setq
   doom-themes-enable-bold t
   doom-themes-enable-italic t
   )
  (load-theme 'doom-vibrant t)
  (doom-themes-visual-bell-config)

  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package evil
  :init ;; tweak evil's configuration before loading it
  (setq
   evil-search-module 'evil-search
   evil-vsplit-window-right t
   evil-split-window-below t
   evil-want-integration t
   evil-want-keybinding nil)
  :config ;; tweak evil after loading it
  (evil-mode)
  )

(use-package dashboard
  :init
  (setq
   initial-buffer-choice (lambda () (get-buffer "*dashboard*"))
   dashboard-center-content t
   dashboard-set-heading-icons t
   dashboard-set-file-icons t
   dashboard-items '((recents  . 10) (projects . 10))
   dashboard-startup-banner 'logo
   )

  :config
  (dashboard-setup-startup-hook)
  (defun dashboard-goto-recent-files ()
    "Go to recent files."
    (interactive)
    (funcall (local-key-binding "r"))
    )

  (defun dashboard-goto-projects ()
    "Go to projects."
    (interactive)
    (funcall (local-key-binding "p"))
    )

  (evil-define-key 'normal dashboard-mode-map
    "g" 'dashboard-refresh-buffer
    "}" 'dashboard-next-section
    "{" 'dashboard-previous-section
    "p" 'dashboard-goto-projects
    "r" 'dashboard-goto-recent-files
    )
  )

;; Stop creating annoying files
(setq
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil
 ) 


;; Improved handling of clipboard in GNU/Linux and otherwise.
(setq
 select-enable-clipboard t
 select-enable-primary t
 save-interprogram-paste-before-kill t
 mouse-yank-at-point t
 )

(use-package which-key
  :defer 0.1
  :init
  ;; Silence warning (:defer causes byte compile warnings)
  (declare-function which-key-prefix-then-key-order "which-key")
  (declare-function which-key-mode "which-key")

  (setq
   which-key-sort-order #'which-key-prefix-then-key-order
   which-key-sort-uppercase-first nil
   which-key-add-column-padding 1
   which-key-max-display-columns nil
   which-key-min-display-lines 6
   which-key-side-window-slot -10
   )
  :config
  (which-key-mode +1)
  )

(use-package evil-leader
  :config
  (evil-leader/set-leader "<SPC>")
  (global-evil-leader-mode)
  (evil-leader/set-key
    "<SPC>" 'counsel-M-x
    "bd" 'kill-buffer
    "br" 'revert-buffer
    "qq" 'kill-buffers-kill-terminal
    "qs" 'save-buffers-kill-emacs
    "sa" 'counsel-ag
    "w" evil-window-map
    )
  )
(use-package helm
  :config
  (helm-mode 1)
  (require 'helm-config)
  (evil-leader/set-key
    "<SPC>" 'helm-M-x
    "ff" 'helm-find-files
    "fr" 'helm-recentf
    "bb" 'helm-buffers-list
    "qq" 'kill-emacs
    )
  )

(use-package helm-projectile
  :after (helm projectile)
  :config
  (evil-leader/set-key
    "pp" 'helm-projectile
    "pr" 'helm-projectile-recentf
    "pd" 'helm-projectile-find-dir
    "pf" 'helm-projectile-find-file
    "po" 'helm-projectile-find-file-other
    "pb" 'helm-projectile-switch-to-buffer
    "pg" 'helm-projectile-rg
    ))

(use-package golden-ratio
  :after (evil)
  :defer 0.1
  :commands (golden-ratio golden-ratio-mode)
  :config
  ;; extra golden ratio commands
  (dolist
      (cs
       '(avy-pop-mark
        evil-avy-goto-word-or-subword-1
        evil-avy-goto-line
        evil-window-delete
        evil-window-split
        evil-window-vsplit
        evil-window-left
        evil-window-right
        evil-window-up
        evil-window-down
        evil-window-bottom-right
        evil-window-top-left
        evil-window-mru
        evil-window-next
        evil-window-prev
        evil-window-new
        evil-window-vnew
        evil-window-rotate-upwards
        evil-window-rotate-downwards
        evil-window-move-very-top
        evil-window-move-far-left
        evil-window-move-far-right
        evil-window-move-very-bottom
        next-multiframe-window
        previous-multiframe-window
        treemacs-add-and-display-current-project
        windmove-left
        windmove-right
        windmove-up
        windmove-down
        quit-window))

    (add-to-list 'golden-ratio-extra-commands cs))

  ;; modes for golden-ratio to exclude
  (dolist (ms
       '("bs-mode"
        "calc-mode"
        "ediff-mode"
        "eshell-mode"
        "gud-mode"
        "gdb-locals-mode"
        "gdb-registers-mode"
        "gdb-breakpoints-mode"
        "gdb-threads-mode"
        "gdb-frames-mode"
        "gdb-inferior-io-mode"
        "gdb-disassembly-mode"
        "gdb-memory-mode"
        "speedbar-mode"))

    (add-to-list 'golden-ratio-exclude-modes ms)))

(use-package adaptive-wrap
  :commands adaptive-wrap-prefix-mode)

(use-package visual-fill-column
  :defer 0.1
  :commands visual-fill-column-mode)

(use-package ranger
  :after (evil-leader)
  :defer 0.1
  :init
  (evil-leader/set-key "fd" 'ranger)
  )

(use-package projectile
  :after (helm)
  :init
  (setq projectile-completion-system 'helm)
  :config
  (evil-leader/set-key
    "ps" 'projectile-run-shell
    )
  (projectile-mode +1)
  )

(use-package magit
  :after evil-leader
  :defer 0.1
  :init
  (setq magit-revision-show-gravatars t)
  (evil-leader/set-key
    "gs" 'magit-status
    )
  )

(use-package evil-magit
  :after (evil magit)
  )

(use-package treemacs
  :defer 0.1
  :config
  (defun treemacs-ignore-flymake (file _)
    (string-match-p (regexp-quote "_flymake\..+") file))
  (push #'treemacs-ignore-flymake treemacs-ignored-file-predicates)
  (treemacs-follow-mode)
  )

(use-package treemacs-evil
  :after (treemacs evil)
  )
(use-package treemacs-projectile
  :after (treemacs projectile)
  :config
  (evil-leader/set-key
    "pt" 'treemacs-add-and-display-current-project
    )
  )

(use-package display-line-numbers
  :config
  (defun display-line-numbers--turn-on ()
    "turn on line numbers but excempting certain majore modes defined in `display-line-numbers-exempt-modes'"
    (if (and
         (not (member major-mode '(treemacs)))
         (not (minibufferp)))
        (display-line-numbers-mode)))
  (global-display-line-numbers-mode)
  )

(use-package eglot
  :after (company)
  :init
  (setq
   eglot-server-programs
   '( (haskell-mode . ("ghcide" "--lsp"))
      (scala-mode . "metals-emacs")
      )
   )
  )

(use-package direnv
  :config
  (direnv-mode))

(use-package haskell-mode
  :interpreter
  ("hs" . haskell-mode)
  )

(use-package scala-mode
  :interpreter
  ("scala" . scala-mode)
  )

(use-package evil-collection
  :after evil
  :custom (evil-collection-setup-minibuffer t)
  :init (evil-collection-init)
  )

(use-package company
  :bind
  (:map company-active-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.1)
  (global-company-mode t)
  )

(use-package whitespace
  :init
  (setq
   whitespace-line-column 120
   whitespace-global-modes
   '(haskell-mode scala-mode fundamental emacs-lisp-mode nix-mode)
   )
  (evil-leader/set-key
    "bw" 'whitespace-cleanup
    )
  :config
  (global-whitespace-mode))

(use-package rainbow-delimiters
  :init
  (add-hook 'haskell-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'scala-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'nix-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'elisp-mode-hook 'rainbow-delimiters-mode)
  )

(use-package org-pomodoro
  :commands (org-pomodoro)
  :config
  (setq alert-user-configuration (quote ((((:category . "org-pomodoro")) libnotify nil))))
  )
