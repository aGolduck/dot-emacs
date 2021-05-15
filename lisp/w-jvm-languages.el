;; -*- lexical-binding: t; -*-
(straight-use-package 'clojure-mode)
(straight-use-package 'cider)
(straight-use-package 'scala-mode)

;;; clojure
(add-hook 'clojure-mode-hook #'electric-pair-local-mode)

;;; scala
(add-to-list 'auto-mode-alist '("\\.sc\\'" . scala-mode))
(add-hook 'scala-mode-hook #'electric-pair-local-mode)

(provide 'w-jvm-languages)
