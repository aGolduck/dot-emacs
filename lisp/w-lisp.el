;;; -*- lexical-binding: t; -*-
(straight-use-package 'lispy)

(with-eval-after-load 'lispy
  (diminish 'lispy-mode)
  ;; (define-key lispy-mode-map (kbd "[") nil)
  ;; (define-key lispy-mode-map (kbd "]") nil)
  (define-key lispy-mode-map (kbd "M-a") #'lispy-backward)
  (define-key lispy-mode-map (kbd "M-e") #'lispy-forward)
  (define-key lispy-mode-map (kbd "i") nil)
  (define-key lispy-mode-map (kbd "M-i") nil)
  (define-key lispy-mode-map (kbd "M-o") nil))

(add-hook 'emacs-lisp-mode-hook #'company-mode)
  (add-hook 'emacs-lisp-mode-hook #'show-paren-mode)
  (add-hook 'emacs-lisp-mode-hook #'lispy-mode)


(provide 'w-lisp)
