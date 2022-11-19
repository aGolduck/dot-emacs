;;; -*- lexical-binding: t; -*-
;;; IMPORTANT: java 11 is needed or jdtls, the java lsp-server
(straight-use-package 'autodisass-java-bytecode)

(add-hook 'java-mode-hook #'display-line-numbers-mode)
(add-hook 'java-mode-hook #'yas-minor-mode)
;; (add-hook 'java-mode-hook
;;           (lambda ()
;;             (face-remap-add-relative 'font-lock-function-name-face :height 1.5)))

;;; java bytecode
(require 'autodisass-java-bytecode)


(provide 'w-java)
