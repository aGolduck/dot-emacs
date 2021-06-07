;; -*- lexical-binding: t; -*-
(straight-use-package 'clojure-mode)
(straight-use-package 'lsp-metals)
(straight-use-package 'cider)
(straight-use-package 'scala-mode)

;;; clojure
(add-hook 'clojure-mode-hook #'electric-pair-local-mode)
(add-hook 'clojure-mode-hook #'lispy-mode)
(add-hook 'clojure-mode-hook #'company-mode)

;;; scala
(add-to-list 'auto-mode-alist '("\\.sc\\'" . scala-mode))
(add-hook 'scala-mode-hook #'electric-pair-local-mode)
(add-hook 'clojure-mode-hook #'company-mode)

(provide 'w-jvm-languages)
