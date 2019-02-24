;; init-tools.el --- Setup useful tools.  -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(use-package which-key
  :diminish which-key-mode
  :bind (:map help-map ("C-h" . which-key-C-h-dispatch))
  :hook (after-init . which-key-mode)
  :init
  (setq which-key-idle-delay 0.2)
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix " "))

(use-package hungry-delete
  :hook (after-init . global-hungry-delete-mode))

(use-package editorconfig
  :diminish editorconfig-mode
  :hook (after-init . editorconfig-mode))

(use-package rg
  :hook (after-init . rg-enable-default-bindings)
  :config
  (setq rg-group-result t)
  (setq rg-show-columns t)

  (cl-pushnew '("tmpl" . "*.tmpl") rg-custom-type-aliases)

  (with-eval-after-load 'projectile
    (defalias 'projectile-ripgrep 'rg-project)
    (bind-key "s R" #'rg-project projectile-command-map)))

(use-package avy
  :defer nil
  :init
  (setq avy-timeout-seconds 0.0))

;; center window
(use-package olivetti
  :diminish
  :init
  (setq olivetti-body-width 0.6))

(use-package restart-emacs)

(use-package carbon-now-sh)
(use-package daemons)                   ; system services/daemons
(use-package diffview)                  ; side-by-side diff view
(use-package esup)                      ; Emacs startup profiler


(provide 'init-tools)

;;; init-tools.el ends here
