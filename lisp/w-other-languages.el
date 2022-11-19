;; (straight-use-package 'sqlformat)

;;; xml
(setq nxml-child-indent 4
      nxml-attribute-indent 4
      lsp-xml-jar-file (expand-file-name (locate-user-emacs-file "resources/org.eclipse.lemminx-uber.jar")))
(add-hook 'nxml-mode-hook #'smartparens-mode)

(provide 'w-other-languages)
