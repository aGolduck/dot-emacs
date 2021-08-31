;; (straight-use-package 'sqlformat)

(add-hook 'sql-mode-hook #'company-mode)

(add-hook 'awk-mode-hook #'company-mode)

(provide 'w-other-languages)
