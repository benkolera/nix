;;; packages.el --- hie layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author:  <ben.kolera@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Code:

(defconst lsp-haskell-packages
  '((lsp-haskell :requires haskell-mode :location (recipe :fetcher github :repo "emacs-lsp/lsp-haskell"))
    ))

(defun hie-nix/init-lsp-haskell ()
  (use-package lsp-haskell
    :init
    (progn
      (setq lsp-haskell-process-path-hie "hie-wrapper")
      (add-hook 'haskell-mode-hook #'lsp))))

