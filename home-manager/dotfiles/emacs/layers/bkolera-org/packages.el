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
    ;; This comes from nix
    (pdf-tools :location built-in)
    ))

(defun bkolera-org/init-org-cliplink () (use-package org-cliplink :defer t))
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
      (setq org-default-notes-file (concat org-directory "/inbox.org"))
      (spacemacs/set-leader-keys-for-major-mode 'org-mode "iL" 'org-cliplink)
      (setq org-todo-keywords '((sequence "MAYBE(m) SOON(s)" "NEXT(n)" "TODAY(t)" "INPROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
      (setq org-agenda-custom-commands
            '(("m" todo "MAYBE")
              ("d" "Today" ((agenda "" ((org-agenda-span 'day)))
                            (alltodo "" ((org-agenda-overriding-header "")
                                         (org-super-agenda-groups
                                          '((:name "Today" :todo "TODAY")
                                            (:name "In Progress" :todo "DOING")
                                            (:todo "WAITING")
                                           ))))))
              ("w" "Week's agenda and all TODOs"
               ((agenda "" ((org-agenda-span 'week)))
                (alltodo "" ((org-agenda-overriding-header "")
                             (org-super-agenda-groups
                              '(
                                (:name "Soon" :todo "SOON")
                                (:name "Next" :todo "NEXT")
                                (:name "Today" :todo "TODAY")
                                (:name "In Progress" :todo "DOING")
                                (:todo "WAITING")
                                ))))))))
      (setq org-capture-templates
            '(("t" "Todo [inbox]" entry (file "")
               "* TODO %i%? \n  SCHEDULED:  %t\n" :empty-lines 1)
              ("K" "Cliplink capture task" entry (file "")
               "* TODO %(org-cliplink-capture) \n  SCHEDULED: %t\n" :empty-lines 1)))
      (setq org-download-method 'attach)
      )))

;;; packages.el ends here
