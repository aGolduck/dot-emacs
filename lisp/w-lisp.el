;; -*- lexical-binding: t; -*-
(use-package lispy
  :straight t
  :config
  (diminish 'lispy-mode)
  (define-key lispy-mode-map (kbd "[") nil)
  (define-key lispy-mode-map (kbd "]") nil)
  (define-key lispy-mode-map (kbd "M-a") #'lispy-backward)
  (define-key lispy-mode-map (kbd "M-e") #'lispy-forward)
  (define-key lispy-mode-map (kbd "i") nil)
  (define-key lispy-mode-map (kbd "M-i") nil)
  (define-key lispy-mode-map (kbd "M-o") nil))

(use-package elisp-mode
  :init
  (add-hook 'emacs-lisp-mode-hook #'company-mode)
  (add-hook 'emacs-lisp-mode-hook #'show-paren-mode)
  (add-hook 'emacs-lisp-mode-hook #'lispy-mode)
  ;; :config
  ;; (define-key emacs-lisp-mode-map (kbd "M-;") #'paredit-comment-dwim)
  )

(provide 'w-lisp)
