;; -*- lexical-binding: t; -*-

(straight-use-package 'company)
(setq company-minimum-prefix-length 1
      company-tooltip-align-annotations t
      ;; default is 0.2
      company-idle-delay 0.0)
(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (diminish 'company-mode "补"))

(straight-use-package 'company-prescient)
(add-hook 'company-mode-hook #'company-prescient-mode)

(straight-use-package 'company-box)
(add-hook 'company-mode-hook #'company-box-mode)

(provide 'init-company)
