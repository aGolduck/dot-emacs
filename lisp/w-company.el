;; -*- lexical-binding: t; -*-

(straight-use-package 'company)
(straight-use-package 'prescient)
(straight-use-package 'company-prescient)

(setq company-minimum-prefix-length 1
      company-tooltip-align-annotations t
      ;; down downcase candidates, but correct inputs before point
      company-dabbrev-downcase nil
      company-dabbrev-ignore-case t
      ;; default is 0.2
      company-idle-delay 0.0)
(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))
(add-hook 'company-mode-hook #'company-prescient-mode)


(add-hook 'emacs-lisp-mode-hook #'company-mode)

(provide 'w-company)
