;; init-ui.el --- Setup UI.  -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(eval-when-compile
  (require 'init-const)
  (require 'init-custom))

;; Icons
;; NOTE: Must run `M-x all-the-icons-install-fonts' manually on Windows
(use-package all-the-icons
  :if (display-graphic-p)
  :init (unless (or sys/win32p (member "all-the-icons" (font-family-list)))
          (all-the-icons-install-fonts t))
  :config
  (add-to-list 'all-the-icons-icon-alist
               '("\\.xpm$" all-the-icons-octicon "file-media" :v-adjust 0.0 :face all-the-icons-dgreen))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.lua$" all-the-icons-fileicon "lua" :face all-the-icons-dblue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(lua-mode all-the-icons-fileicon "lua" :face all-the-icons-dblue))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.go$" all-the-icons-fileicon "go" :face all-the-icons-blue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(go-mode all-the-icons-fileicon "go" :face all-the-icons-blue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(help-mode all-the-icons-faicon "info-circle" :height 1.1 :v-adjust -0.1 :face all-the-icons-purple))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(Info-mode all-the-icons-faicon "info-circle" :height 1.1 :v-adjust -0.1))
  (add-to-list 'all-the-icons-icon-alist
               '("NEWS$" all-the-icons-faicon "newspaper-o" :height 0.9 :v-adjust -0.2))
  (add-to-list 'all-the-icons-icon-alist
               '("Cask\\'" all-the-icons-fileicon "elisp" :height 1.0 :v-adjust -0.2 :face all-the-icons-blue))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(cask-mode all-the-icons-fileicon "elisp" :height 1.0 :v-adjust -0.2 :face all-the-icons-blue))
  (add-to-list 'all-the-icons-icon-alist
               '(".*\\.ipynb\\'" all-the-icons-fileicon "jupyter" :height 1.2 :face all-the-icons-orange))
  (add-to-list 'all-the-icons-icon-alist
               '("\\.epub\\'" all-the-icons-faicon "book" :height 1.0 :v-adjust -0.1 :face all-the-icons-green))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(nov-mode all-the-icons-faicon "book" :height 1.0 :v-adjust -0.1 :face all-the-icons-green))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(gfm-mode  all-the-icons-octicon "markdown" :face all-the-icons-blue)))

(use-package font-lock+
  :quelpa
  (font-lock+ :repo "emacsmirror/font-lock-plus" :fetcher github))

(use-package all-the-icons-ivy
  :hook (after-init . all-the-icons-ivy-setup))

(use-package doom-modeline
  :hook ((after-init . doom-modeline-mode)
         (doom-modeline-mode . setup-custom-doom-modeline))
  :custom-face
  (doom-modeline-buffer-file ((t (:inherit font-lock-string-face :weight bold))))
  :init
  (unless after-init-time
    ;; prevent flash of unstyled modeline at startup
    (setq-default mode-line-format nil))
  :config
  (progn
    (setq
     find-file-visit-truename t  ; display the real names for symlink files
     ;; doom-modeline-height 21
     doom-modeline-lsp nil
     doom-modeline-persp-name nil
     doom-modeline-github nil
     ;; doom-modeline-buffer-file-name-style 'truncate-with-project
     doom-modeline-buffer-file-name-style 'file-name
     doom-modeline-major-mode-color-icon t)

    (doom-modeline-def-segment my-python-venv
      "The current python virtual environment state."
      (when (eq major-mode 'python-mode)
        (if (eq python-shell-virtualenv-root nil)
            ""
          (propertize
           (let ((base-dir-name (file-name-nondirectory (substring python-shell-virtualenv-root 0 -1))))
             (if (< 10 (length base-dir-name))
                 (format " (%s..)" (substring base-dir-name 0 8))
               (format " (%s)" base-dir-name)))
           'face (if (doom-modeline--active) 'doom-modeline-buffer-major-mode)))))

    (doom-modeline-def-modeline 'my-modeline-layout
      '(bar workspace-name window-number modals matches buffer-info remote-host buffer-position parrot selection-info)
      '(objed-state misc-info persp-name lsp irc mu4e github debug fancy-battery minor-modes input-method buffer-encoding my-python-venv process vcs checker))


    (defun setup-custom-doom-modeline ()
      (doom-modeline-set-modeline 'my-modeline-layout 'default))))

(use-package doom-themes
  :defer nil
  :custom
  (doom-themes-enable-italic t)
  (doom-themes-enable-bold t)
  :config
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  ;; enable custom treemacs themes
  (doom-themes-treemacs-config))

(load-theme petmacs--default-theme t)
;;; Disable theme before load a new theme
(defadvice load-theme
    (before theme-dont-propagate activate)
  "Disable theme before load theme."
  (mapc #'disable-theme custom-enabled-themes))

(use-package display-line-numbers-mode
  :ensure nil
  :init
  (setq-default display-line-numbers-type 'relative)
  (global-display-line-numbers-mode 1))

;; Highlight current line number
(use-package hlinum
  :defines linum-highlight-in-all-buffersp
  :hook (global-linum-mode . hlinum-activate)
  :init
  (setq linum-highlight-in-all-buffersp t)
  (custom-set-faces
   `(linum-highlight-face
     ((t (:inherit 'default :background ,(face-background 'default) :foreground ,(face-foreground 'default)))))))

;; Display Time
(use-package time
  :ensure nil
  :unless (display-graphic-p)
  :hook (after-init . display-time-mode)
  :init
  (setq display-time-24hr-format t
        display-time-day-and-date t))

(use-package hide-mode-line
  :hook (((completion-list-mode completion-in-region-mode) . hide-mode-line-mode)))

;; Suppress GUI features
(setq use-file-dialog nil)
(setq use-dialog-box nil)
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)

;; Display dividers between windows
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(add-hook 'window-setup-hook #'window-divider-mode)

(fset 'yes-or-no-p 'y-or-n-p)
(setq visible-bell t)
(setq inhibit-compacting-font-caches t) ; Don’t compact font caches during GC.

(add-hook 'window-setup-hook #'size-indication-mode)

(provide 'init-ui)

;;; init-ui.el ends here
