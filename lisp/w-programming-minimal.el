(add-hook 'prog-mode-hook #'electric-pair-local-mode)
(global-set-key [remap comment-dwim] #'comment-line)
(setq xref-show-definitions-function #'xref-show-definitions-completing-read)


(setq js-indent-level 2)


;;; xml
(setq nxml-child-indent 4
      nxml-attribute-indent 4
      lsp-xml-jar-file (expand-file-name (locate-user-emacs-file "resources/org.eclipse.lemminx-uber.jar")))

;;; java
(add-hook 'java-mode-hook #'display-line-numbers-mode)
(add-hook 'java-mode-hook #'yas-minor-mode)

(provide 'w-programming-minimal)
