;;; init-grep.el --- Settings for grep and grep-like tools -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(straight-use-package 'rg)
(straight-use-package '(color-rg :host github :repo "manateelazycat/color-rg"))
(straight-use-package 'wgrep)

(when (executable-find "rg")
  ;; rg
  (global-set-key (kbd "M-SPC s") #'rg-menu)
  ;; color-rg
  (setq color-rg-search-ignore-rules "-g \"!node_modules\" -g \"!dist\" -g\"!straight\"")
  (dolist
      (color-rg-command
       (list
        'color-rg-search-input
        'color-rg-search-symbol
        'color-rg-search-input-in-project
        'color-rg-search-symbol-in-project
        'color-rg-search-symbol-in-current-file
        'color-rg-search-input-in-current-file
        'color-rg-search-project-rails
        'color-rg-search-symbol-with-type
        'color-rg-search-project-with-type
        'color-rg-search-project-rails-with-type))
    (autoload color-rg-command "color-rg" nil t nil))
  ;; (global-set-key (kbd "M-SPC S p") #'color-rg-search-input)
  ;; (global-set-key (kbd "M-SPC S P") #'color-rg-search-symbol-in-project)
  ;; (global-set-key (kbd "M-SPC s p") #'color-rg-search-input-in-project)
  )


(provide 'w-search-extra)
