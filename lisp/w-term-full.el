;;;  -*- lexical-binding: t; -*-
(straight-use-package '(term-cursor :host github :repo "h0d/term-cursor.el"))
(straight-use-package 'eterm-256color)
(straight-use-package 'esh-autosuggest)
(straight-use-package 'eshell-z)

;;; common

(setq term-cursor-triggers '(blink-cursor-mode-hook
                               post-command-hook
                               lsp-ui-doc-frame-hook))
(when (not window-system)
  (add-hook 'after-init-hook #'global-term-cursor-mode))


;;; eshell
(autoload 'esh-autosuggest-mode "esh-autosuggest" nil t nil)
(setq eshell-directory-name (w/locate-emacs-var-file "eshell"))
(add-hook 'eshell-mode-hook #'esh-autosuggest-mode)
(add-hook 'eshell-mode-hook (lambda () (require 'eshell-z)))
(add-hook 'eshell-mode-hook
          (lambda ()
            (define-key eshell-mode-map (kbd "C-u") #'eshell-kill-input)))

(provide 'w-term-full)
