;;; -*- lexical-binding: t; -*-
;;; mode-line, header-line, frame-title
(setq-default
 header-line-format '(
                      "%e"
                      mode-line-front-space
                      mode-line-mule-info
                      mode-line-position
                      (vc-mode vc-mode)
                      " "
                      ;; mode-line-modes
                      mode-line-buffer-identification
                      ;; mode-line-misc-info
                      mode-line-end-spaces)
 mode-line-format '(
                    "%e"
                    mode-line-front-space
                    ;; mode-line-mule-info
                    ;; mode-line-position
                    ;; (vc-mode vc-mode)
                    mode-line-modes
                    ;; mode-line-buffer-identification
                    mode-line-misc-info
                    mode-line-end-spaces)
 frame-title-format ;; '(buffer-file-name "%f" "%b")
 '((:eval (concat
           (if (and (boundp 'org-pomodoro-mode-line) org-pomodoro-mode-line)
               (if (listp org-pomodoro-mode-line)
                   (apply #'concat org-pomodoro-mode-line)
                 org-pomodoro-mode-line)
             "")
           (if (and (boundp 'org-mode-line-string) org-mode-line-string)
               org-mode-line-string
             "")
           (if (buffer-file-name)
               (abbreviate-file-name (buffer-file-name))
             "%b")))))

;;; font-lock
(with-eval-after-load 'font-lock
  (set-face-attribute 'font-lock-comment-face nil :height 0.9))

;;; hi-lock
(setq hi-lock-face-defaults '("hi-pink" "hi-green" "hi-blue" "hi-salmon" "hi-aquamarine" "hi-black-b" "hi-blue-b" "hi-red-b" "hi-green-b" "hi-black-hb"))
(global-set-key (kbd "M-SPC h f") #'hi-lock-find-patterns)
(global-set-key (kbd "M-SPC h l") #'highlight-lines-matching-regexp)
(global-set-key (kbd "M-SPC h p") #'highlight-phrase)
(global-set-key (kbd "M-SPC h r") #'highlight-regexp)
(global-set-key (kbd "M-SPC h s") #'highlight-symbol-at-point)
(global-set-key (kbd "M-SPC h u") #'unhighlight-regexp)
(global-set-key (kbd "M-SPC h w") #'hi-lock-write-interactive-patterns)
(with-eval-after-load 'hi-lock
  (diminish 'hi-lock-mode "亮"))

;;; frame
(add-hook 'after-init-hook #'blink-cursor-mode)

;;; olivetti
(straight-use-package 'olivetti)

;;; posframe
(straight-use-package 'posframe)

;;; transient for magit,org-ql,rg...
(straight-use-package 'transient)
(setq transient-history-file (w/locate-emacs-var-file "transient/history.el"))

;;; tab-bar
(when (>= emacs-major-version 27)
  (setq tab-bar-show t
        tab-bar-select-tab-modifiers '(meta)
        tab-bar-tab-hints t))
;; (setq tab-bar-tab-name-function
;;       (defun w/tab-bar-show-file-name ()
;;         (let* ((buffer (window-buffer (minibuffer-selected-window)))
;;                (file-name (buffer-file-name buffer)))
;;           (if file-name file-name (format "%s" buffer)))))

;;; valign
(straight-use-package '(valign :host github :repo "casouri/valign"))
(with-eval-after-load 'valign (diminish 'valign-mode))

;;; treemacs
(straight-use-package 'treemacs)
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

;;; selectric-mode
(straight-use-package 'selectric-mode)
(when (executable-find "aplay")
  (setq selectric-affected-bindings-list nil)
  (add-hook 'after-init-hook #'selectric-mode)
  (with-eval-after-load 'selectric-mode (diminish 'selectric-mode)))

(provide 'w-ui)
