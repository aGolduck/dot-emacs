;;; keybindgs conflictd with view-mode
(use-package lispy
  :straight t
  :init
  (add-hook 'emacs-lisp-mode-hook #'lispy-mode)
  :config
  (define-key lispy-mode-map (kbd "[") nil)
  (define-key lispy-mode-map (kbd "]") nil)
  (define-key lispy-mode-map (kbd "M-a") #'lispy-backward)
  (define-key lispy-mode-map (kbd "M-e") #'lispy-forward)
;  (define-key lispy-mode-map (kbd "e") (lambda () (if view-mode #'view-exit #'lispy-eval)))
  )

(provide 'init-lisp)
