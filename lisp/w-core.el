(straight-use-package 'diminish)

;;; utils
(require 'w-utils)
(require 'w-emacs)

(straight-use-package 'transient)
;;; transient for magit,org-ql,rg...
(setq transient-history-file (w/locate-emacs-var-file "transient/history.el"))

(straight-use-package 'treemacs)
;;; treemacs
(autoload 'treemacs-current-visibilit "treemacs")
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

;;; emacs/system tools
(require 'w-window)
(require 'w-buffer)
(require 'w-file)

(w/straight-use-package-unless-featurep 'vterm #'vterm)
;;; vterm
(setq vterm-buffer-name-string "vterm %s"
      vterm-keymap-exceptions '("C-c" "C-x" "C-g" "C-h" "C-l" "M-x" "M-o" "C-v" "M-v" "C-y" "M-y" "M-i" "M-c")
      vterm-kill-buffer-on-exit t
      vterm-shell "zsh"
      vterm-term-environment-variable "eterm-color")
;; (add-hook 'vterm-mode-hook
;;           (lambda ()
;;             (set (make-local-variable 'buffer-face-mode-face) 'fixed-pitch-serif)
;;             (buffer-face-mode t)))
(with-eval-after-load 'vterm
  (set-face-attribute 'vterm-color-green nil :foreground "dark green"))

(require 'w-dired)
(require 'w-git)
;;; text edit
(require 'w-search)
(require 'w-edit)
(require 'w-pyim)

;;; complete anything
(require 'w-minibuffer)
(require 'w-company)


(provide 'w-core)
