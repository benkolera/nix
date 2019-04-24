;;; packages.el --- bkolera-org layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Ben Kolera <ben.kolera@gmail.com>
;; URL: https://github.com/benkolera/nix
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

(defconst bkolera-org-packages
  '(org
    org-noter
    org-cliplink
    org-super-agenda
    ;; This comes from nix
    (pdf-tools :location built-in)
    ))

(defun bkolera-org/init-org-cliplink () (use-package org-cliplink :defer t))
(defun bkolera-org/init-org-super-agenda ()
  (use-package org-super-agenda :defer t :hook (org-agenda-mode . org-super-agenda-mode)))
(defun bkolera-org/init-org-noter () (use-package org-noter :defer t))

(defun bkolera-org/init-pdf-tools ()
  (use-package pdf-tools
    :defer t
    :mode (("\\.pdf\\'" . pdf-view-mode))
    :config
    (progn
      (pdf-tools-install)
      )))

(defun bkolera-org/post-init-org ()
  (use-package org
    :defer t
    :config
    (progn
      (add-hook 'org-mode-hook 'turn-on-auto-fill)
      (spacemacs/set-leader-keys-for-major-mode 'org-mode "iL" 'org-cliplink)
      (setq spacemacs-theme-org-agenda-height nil
            org-agenda-skip-scheduled-if-done t
            org-agenda-skip-deadline-if-done t
            org-agenda-include-deadlines t
            org-agenda-include-diary t
            org-agenda-block-separator nil
            org-agenda-compact-blocks t
            org-agenda-start-with-log-mode t
            org-todo-keywords '((sequence "MAYBE(m)" "SOON(s)" "NEXT(n)" "TODAY(t)" "INPROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)"))
            org-default-notes-file (concat org-directory "/inbox.org")
            )

      (setq org-agenda-custom-commands
            '(("m" todo "MAYBE")
              ("t" "Today"
               ((agenda "" ((org-agenda-span 'day)
                            (org-super-agenda-groups
                             '((:name "Today"
                                      :time-grid t
                                      :date today
                                      :todo "TODAY"
                                      :scheduled today
                                      :order 1)))))
                (alltodo "" ((org-agenda-overriding-header "")
                             (org-super-agenda-groups
                              '((:name "Today"
                                       :todo "TODAY"
                                       :order 1)
                                (:discard (:anything t))))))))
              ("w" "This Week"
               ((agenda "" ((org-agenda-span 'week)))
                (alltodo "" ((org-agenda-overriding-header "")
                             (org-super-agenda-groups
                              '((:name "Today"
                                       :todo "TODAY"
                                       :order 1)
                                (:name "Next"
                                       :todo "NEXT"
                                       :order 2)
                                (:name "Soon"
                                       :todo "SOON"
                                       :order 3)
                                (:discard (:anything t))))))))))
      (setq org-capture-templates
            '(("t" "Todo [inbox]" entry (file "")
               "* TODO %i%? \n  SCHEDULED:  %t\n" :empty-lines 1)
              ("K" "Cliplink capture task" entry (file "")
               "* TODO %(org-cliplink-capture) \n  SCHEDULED: %t\n" :empty-lines 1)))
      (setq org-download-method 'attach)
      )))

;;; packages.el ends here
