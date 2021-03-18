;;; -*- lexical-binding: t; -*-
;;; magit
(straight-use-package 'magit)
(setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1
      magit-post-commit-hook #'winner-undo
      magit-process-finish-apply-ansi-colors t
      ;; emacsclient is not usable for gccemacs now
      with-editor-emacsclient-executable nil)
(global-set-key (kbd "M-SPC g s") #'magit-status)
(with-eval-after-load 'magit
  (define-key magit-status-mode-map (kbd "C-<tab>") nil))

(when (executable-find "delta")
  (straight-use-package 'magit-delta)
  (add-hook 'magit-mode-hook #'magit-delta-mode)
  (with-eval-after-load 'magit-delta
    (diminish 'magit-delta-mode)))

(straight-use-package 'magit-todos)
(add-hook 'magit-mode-hook #'magit-todos-mode)


;;; git link
(straight-use-package 'git-link)
(global-set-key (kbd "M-SPC g L") #'git-link)

(setq vc-follow-symlinks t)

(provide 'w-git)
