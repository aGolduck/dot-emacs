(add-hook 'prog-mode-hook #'electric-pair-local-mode)
(global-set-key [remap comment-dwim] #'comment-line)
(setq xref-show-definitions-function #'xref-show-definitions-completing-read)

;;; treesit
;; build treesit language definitions by https://github.com/casouri/tree-sitter-module
(setq treesit-extra-load-path '("~/g/casouri/tree-sitter-module/dist"))


;;; auto-insert
(setq auto-insert-directory "~/.emacs.d/auto-insert-templates"
      auto-insert-query t)
(define-auto-insert "\.ts" "with-logger.ts")
(define-auto-insert "\.java" "with-Logger.java")
(add-hook 'after-init-hook #'auto-insert-mode)


;;; auto-mode-alist
(add-to-list 'auto-mode-alist '("\\.cnf\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.gmk\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))

;;; java
;; java 文件经常巨长，打开行号方便定位
(add-hook 'java-mode-hook #'display-line-numbers-mode)
(add-hook 'java-mode-hook #'yas-minor-mode)

;;; js
(setq js-indent-level 2)

;;; xml
(setq nxml-child-indent 4
      nxml-attribute-indent 4
      lsp-xml-jar-file (expand-file-name (locate-user-emacs-file "resources/org.eclipse.lemminx-uber.jar")))

(provide 'w-programming-minimal)
