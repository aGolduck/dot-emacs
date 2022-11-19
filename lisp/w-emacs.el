;;; -*- lexical-binding: t; -*-
(straight-use-package 'gcmh)
(straight-use-package 'helpful)

;;; emacs regex builder
(setq reb-re-syntax 'string)

(add-hook 'after-init-hook #'gcmh-mode)
;; restore original gc-cons-percentage
(add-hook 'after-init-hook (lambda () (setq gc-cons-percentage 0.1)))
(with-eval-after-load 'gcmh
  (diminish 'gcmh-mode))

;;; helpful
;; (setq counsel-describe-function-function #'helpful-callable
;;       counsel-describe-variable-function #'helpful-variable)
;; (global-set-key (kbd "C-h f") #'helpful-callable)
;; (global-set-key (kbd "C-h v") #'helpful-variable)
;; (global-set-key (kbd "C-h F") #'helpful-function)
;; (global-set-key (kbd "C-h C") #'helpful-command)
(global-set-key (kbd "C-h k") #'helpful-key)
(global-set-key (kbd "C-h o") #'helpful-symbol)

(provide 'w-emacs)
