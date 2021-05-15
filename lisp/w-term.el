;;;  -*- lexical-binding: t; -*-
(straight-use-package '(term-cursor :host github :repo "h0d/term-cursor.el"))
(straight-use-package 'eterm-256color)
(w/straight-use-package-unless-featurep 'vterm #'vterm)
(straight-use-package 'esh-autosuggest)
(straight-use-package 'eshell-z)

;;; common
(add-hook 'compilation-filter-hook
          (lambda ()
            (let ((buffer-read-only nil))
              (ansi-color-apply-on-region (point-min) (point-max)))))
;; (setq term-cursor-triggers '(blink-cursor-mode-hook
;;                                post-command-hook
;;                                lsp-ui-doc-frame-hook))
;; (add-hook 'after-init-hook #'global-term-cursor-mode)

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

;;; eshell
(autoload 'esh-autosuggest-mode "esh-autosuggest")
(setq eshell-directory-name (w/locate-emacs-var-file "eshell"))
(add-hook 'eshell-mode-hook #'esh-autosuggest-mode)
(add-hook 'eshell-mode-hook (lambda () (require 'eshell-z)))
(add-hook 'eshell-mode-hook
          (lambda ()
            (define-key eshell-mode-map (kbd "C-u") #'eshell-kill-input)))

(provide 'w-term)
