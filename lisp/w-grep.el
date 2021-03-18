;;; init-grep.el --- Settings for grep and grep-like tools -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(if (executable-find "rg")
    (progn
      ;; rg
      (straight-use-package 'rg)
      (global-set-key (kbd "M-SPC s p") #'rg-project)
      ;; color-rg
      (straight-use-package '(color-rg :host github :repo "manateelazycat/color-rg"))
      (dolist (color-rg-command (list
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
        (autoload color-rg-command "color-rg"))
      (global-set-key (kbd "M-SPC s P") #'color-rg-search-symbol-in-project)
  ;; (global-set-key (kbd "M-SPC s p") #'color-rg-search-input-in-project)
)
  (if (and (executable-find "ag")
           (straight-use-package 'ag))
      (progn
        (straight-use-package 'wgrep-ag)
        (global-set-key (kbd "M-SPC s p") #'ag-project))
    (straight-use-package 'wgrep)))

(provide 'w-grep)
