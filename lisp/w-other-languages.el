;; (straight-use-package 'sqlformat)

(add-hook 'sql-mode-hook #'company-mode)

(add-hook 'awk-mode-hook #'company-mode)

;;; xml
(setq nxml-child-indent 4
      nxml-attribute-indent 4
      lsp-xml-jar-file (expand-file-name (locate-user-emacs-file "resources/org.eclipse.lemminx-uber.jar")))
(when (equal w/lsp-client "lsp")
  ;; xml lsp server is downloaded from http://mirrors.ustc.edu.cn/eclipse/lemminx/
  (add-hook 'nxml-mode-hook #'lsp))
(add-hook 'nxml-mode-hook #'smartparens-mode)

(provide 'w-other-languages)
