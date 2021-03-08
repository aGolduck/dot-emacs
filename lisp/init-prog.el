;; -*- lexical-binding: t; -*-

(straight-use-package 'quickrun)

(use-package paredit
  :commands (enable-paredit-mode)
  :init
  (dolist (hook (list
                 'eval-expression-minibuffer-setup-hook
                 'ielm-mode-hook
                 'lisp-mode-hook
                 'lisp-interaction-mode-hook
                 'scheme-mode-hook
                 ))
    (add-hook hook #'paredit-mode))
  :config
  ;; https://emacs-china.org/t/paredit-smartparens/6727/11
  (defun paredit/space-for-delimiter-p (endp delm)
    (or (member 'font-lock-keyword-face (text-properties-at (1- (point))))
        (not (derived-mode-p 'basic-mode
                             'c++-mode
                             'c-mode
                             'coffee-mode
                             'csharp-mode
                             'd-mode
                             'dart-mode
                             'go-mode
                             'java-mode
                             'js-mode
                             'lua-mode
                             'objc-mode
                             'pascal-mode
                             'python-mode
                             'r-mode
                             'ruby-mode
                             'rust-mode
                             'typescript-mode))))
  (add-to-list 'paredit-space-for-delimiter-predicates #'paredit/space-for-delimiter-p)
  (eldoc-add-command
   'paredit-backward-delete
   'paredit-close-round)
  (define-key paredit-mode-map (kbd ";") nil) ;; conflict with lispy-comment
  (define-key paredit-mode-map (kbd "M-r") nil)
  (diminish 'paredit-mode "括"))

(provide 'w-prog)
