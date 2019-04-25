;; init-ibuffer.el --- Setup ibuffer.  -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(use-package ibuffer
  :ensure nil
  :functions (all-the-icons-icon-for-file
               all-the-icons-icon-for-mode
               all-the-icons-auto-mode-match?
               all-the-icons-faicon)
  :preface
  (defun petmacs/ibuffer-previous-line ()
    (interactive)
    (previous-line)
    (if (<= (line-number-at-pos) 2)
	(goto-line (- (count-lines (point-min) (point-max)) 2))))

  (defun petmacs/ibuffer-next-line ()
    (interactive)
    (next-line)
    (if (>= (line-number-at-pos) (- (count-lines (point-min) (point-max)) 1))
	(goto-line 3)))

  :commands ibuffer-find-file
  :bind ("C-x C-b" . ibuffer)
  :config
  (define-key ibuffer-mode-map (kbd "j") 'petmacs/ibuffer-next-line)
  (define-key ibuffer-mode-map (kbd "k") 'petmacs/ibuffer-previous-line)

  (setq ibuffer-filter-group-name-face '(:inherit (font-lock-string-face bold)))

  ;; Display buffer icons on GUI
  (when (display-graphic-p)
    ;; To be correctly aligned, the size of the name field must be equal to that
    ;; of the icon column below, plus 1 (for the tab I inserted)
    (define-ibuffer-column icon (:name "   ")
      (let ((icon (if (and (buffer-file-name)
                           (all-the-icons-auto-mode-match?))
                      (all-the-icons-icon-for-file (file-name-nondirectory (buffer-file-name)) :v-adjust -0.05)
                    (all-the-icons-icon-for-mode major-mode :v-adjust -0.05))))
        (if (symbolp icon)
            (setq icon (all-the-icons-faicon "file-o" :face 'all-the-icons-dsilver :height 0.8 :v-adjust 0.0))
          icon)))

    (let ((tab-width 1))
      (setq ibuffer-formats '((mark modified read-only locked
                                    ;; Here you may adjust by replacing :right with :center or :left
                                    ;; According to taste, if you want the icon further from the name
                                    " " (icon 1 -1 :left :elide) "\t" (name 18 18 :left :elide)
                                    " " (size 9 -1 :right)
                                    " " (mode 16 16 :left :elide) " " filename-and-process)
                              (mark " " (name 16 -1) " " filename)))))

  (with-eval-after-load 'counsel
    (defun my-ibuffer-find-file ()
      (interactive)
      (let ((default-directory (let ((buf (ibuffer-current-buffer)))
                                 (if (buffer-live-p buf)
                                     (with-current-buffer buf
                                       default-directory)
                                   default-directory))))
        (counsel-find-file default-directory)))
    (advice-add #'ibuffer-find-file :override #'my-ibuffer-find-file))

  ;; Group ibuffer's list by project root
  (use-package ibuffer-projectile
    :functions all-the-icons-octicon ibuffer-do-sort-by-alphabetic
    :hook ((ibuffer . (lambda ()
                         (ibuffer-projectile-set-filter-groups)
                         (unless (eq ibuffer-sorting-mode 'alphabetic)
                           (ibuffer-do-sort-by-alphabetic)))))
    :config
    (setq ibuffer-projectile-prefix
          (if (display-graphic-p)
              (concat
               (all-the-icons-octicon "file-directory"
                                      :face ibuffer-filter-group-name-face
                                      :v-adjust -0.05
                                      :height 1.25)
               " ")
            "Project: "))))

(provide 'init-ibuffer)

;;; init-ibuffer.el ends here
