;; -*- lexical-binding: t; -*-

(use-package lispy
  :straight t
  :init
  (add-hook 'emacs-lisp-mode-hook #'lispy-mode)
  :config
  (diminish 'lispy-mode)
  (define-key lispy-mode-map (kbd "[") nil)
  (define-key lispy-mode-map (kbd "]") nil)
  (define-key lispy-mode-map (kbd "M-a") #'lispy-backward)
  (define-key lispy-mode-map (kbd "M-e") #'lispy-forward)
  (define-key lispy-mode-map (kbd "i") nil)
  (define-key lispy-mode-map (kbd "M-i") nil)
  (define-key lispy-mode-map (kbd "M-o") nil))

(provide 'init-lisp)
