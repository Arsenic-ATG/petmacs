;; init-vc.el --- Setup version control.  -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup)
         ("C-c M-g" . magit-file-popup))
  :config
  (setq magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)
  (add-to-list 'magit-log-arguments "--color")

  ;; When 'C-c C-c' is pressed in the magit commit message buffer,
  ;; delete the magit-diff buffer related to the current repo.
  (defun kill-magit-diff-buffer-in-current-repo (&rest _)
    "Delete the magit-diff buffer related to the current repo"
    (let ((magit-diff-buffer-in-current-repo
           (magit-mode-get-buffer 'magit-diff-mode)))
      (kill-buffer magit-diff-buffer-in-current-repo)))

  (add-hook 'git-commit-setup-hook
            (lambda ()
              (add-hook 'with-editor-post-finish-hook
			#'kill-magit-diff-buffer-in-current-repo
			nil t))) ; the t is important

  ;; kill magit status buffer when quitting magit status
  (define-key magit-mode-map (kbd "q") (lambda()
					 (interactive)
					 (magit-mode-bury-buffer t)))

  ;; Show tasks
  (use-package magit-todos
    :hook (ater-init . magit-todos-mode))

  ;; Walk through git revisions of a file
  (use-package git-timemachine
    :bind (:map vc-prefix-map
		("t" . git-timemachine)))
  ;; Pop up last commit information of current line
  (use-package git-messenger
    :bind (:map vc-prefix-map
		("p" . git-messenger:popup-message)
		:map git-messenger-map
		("m" . git-messenger:copy-message))
    :init
    ;; Use magit-show-commit for showing status/diff commands
    (setq git-messenger:use-magit-popup t))

  ;; Resolve diff3 conflicts
  (use-package smerge-mode
    :ensure nil
    :diminish
    :preface
    (with-eval-after-load 'hydra
      (defhydra smerge-hydra
	(:color pink :hint nil :post (smerge-auto-leave))
	"
^Move^       ^Keep^               ^Diff^                 ^Other^
^^-----------^^-------------------^^---------------------^^-------
_n_ext       _b_ase               _<_: upper/base        _C_ombine
_p_rev       _u_pper              _=_: upper/lower       _r_esolve
^^           _l_ower              _>_: base/lower        _k_ill current
^^           _a_ll                _R_efine
^^           _RET_: current       _E_diff
"
	("n" smerge-next)
	("p" smerge-prev)
	("b" smerge-keep-base)
	("u" smerge-keep-upper)
	("l" smerge-keep-lower)
	("a" smerge-keep-all)
	("RET" smerge-keep-current)
	("\C-m" smerge-keep-current)
	("<" smerge-diff-base-upper)
	("=" smerge-diff-upper-lower)
	(">" smerge-diff-base-lower)
	("R" smerge-refine)
	("E" smerge-ediff)
	("C" smerge-combine-with-next)
	("r" smerge-resolve)
	("k" smerge-kill-current)
	("ZZ" (lambda ()
		(interactive)
		(save-buffer)
		(bury-buffer))
	 "Save and bury buffer" :color blue)
	("q" nil "cancel" :color blue)))
    :hook ((find-file . (lambda ()
                          (save-excursion
                            (goto-char (point-min))
                            (when (re-search-forward "^<<<<<<< " nil t)
                              (smerge-mode 1)))))
           (magit-diff-visit-file . (lambda ()
                                      (when smerge-mode
					(smerge-hydra/body))))))

  ;; Open github/gitlab/bitbucket page
  (use-package browse-at-remote
    :bind (:map vc-prefix-map
		("B" . browse-at-remote))))

(use-package evil-magit
  :hook (magit-mode . evil-magit-init))

;; Git related modes
(use-package gitattributes-mode)
(use-package gitignore-mode)
(use-package gitconfig-mode)
(use-package git-commit)

(provide 'init-vc)

;;; init-vc.el ends here
