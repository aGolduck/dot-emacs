(straight-use-package 'treemacs)

;;; transient for magit,org-ql,rg...
(setq transient-history-file (w/locate-emacs-var-file "transient/history.el"))

;;; treemacs
(autoload 'treemacs-current-visibilit "treemacs" nil t nil)
(setq treemacs-no-png-images t
      treemacs-persist-file (w/locate-emacs-var-file ".cache/treemacs-persist"))
(add-hook 'treemacs-mode-hook (lambda () (setq-local line-spacing 0)))
(defun w/treemacs-goto-treemacs ()
  (interactive)
  (pcase (treemacs-current-visibility)
    ('visible (treemacs-select-window))
    ('exists (treemacs-select-window))
    ('none (treemacs-add-and-display-current-project))))
;; n for navigate?
(global-set-key (kbd "M-n") #'w/treemacs-goto-treemacs)
(with-eval-after-load 'treemacs
  (set-face-attribute 'treemacs-directory-face nil :inherit font-lock-function-name-face :height 0.9)
  ;; TODO :inherit variable-pitch
  (set-face-attribute 'treemacs-file-face nil :height 0.9)
  (set-face-attribute 'treemacs-git-ignored-face nil :inherit font-lock-comment-face :height 0.8 :weight 'light)
  ;; (define-key treemacs-mode-map (kbd "M-n") nil)
  )

;;; tab-bar
;;; tab-bar
(when (>= emacs-major-version 27)
  (setq tab-bar-show 1
        tab-bar-select-tab-modifiers '(meta)
        tab-bar-tab-hints t)

  ;; (setq tab-bar-tab-name-function
  ;;       (defun w/tab-bar-show-file-name ()
  ;;         (let* ((buffer (window-buffer (minibuffer-selected-window)))
  ;;                (file-name (buffer-file-name buffer)))
  ;;           (if file-name file-name (format "%s" buffer)))))

  (global-set-key (kbd "C-<tab>") #'tab-bar-switch-to-next-tab))



(provide 'w-ui)
