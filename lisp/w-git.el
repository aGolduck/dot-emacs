;;; -*- lexical-binding: t; -*-
(straight-use-package 'magit)
(straight-use-package 'magit-delta)
(straight-use-package 'magit-todos)
(straight-use-package 'diff-hl)

(setq vc-follow-symlinks t)

;;; magit
(setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1
      magit-process-finish-apply-ansi-colors t
      ;; emacsclient is not usable for gccemacs now
      with-editor-emacsclient-executable nil)
(global-set-key (kbd "M-SPC g s") #'magit-status)
(with-eval-after-load 'magit
  (define-key magit-status-mode-map (kbd "C-<tab>") nil))
(with-eval-after-load 'selectrum
  (setq magit-completing-read-function #'selectrum-completing-read))

;;; magit-delta 极大影响 magit 的速度
;; (when (executable-find "delta")
;;   (add-hook 'magit-mode-hook #'magit-delta-mode))

;; disable magit-todos to speed up magit
(setq magit-todos-exclude-globs '("*.css.map"))
;; (add-hook 'magit-mode-hook (lambda () (let ((inhibit-message t)) (magit-todos-mode 1))))
;; T conflicts with magit-note
;; (with-eval-after-load 'magit-todos-mode (transient-append-suffix 'magit-status-jump '(0 0 -1)
;;                                           '("T " "Todos" magit-todos-jump-to-todos)))


;; (add-hook 'after-init-hook #'global-hiff-hl-mode nil t nil) ;; do not know why global-diff-hl-mode can't be added, it's autoloaded
(global-diff-hl-mode)

(provide 'w-git)
