;; -*- lexical-binding: t; -*-
(straight-use-package 'clojure-mode)
(straight-use-package 'cider)
;; (straight-use-package 'flycheck-clojure)
;; (straight-use-package 'lsp-metals)
(straight-use-package 'scala-mode)

;;; clojure
(add-hook 'clojure-mode-hook #'lispy-mode)
(add-hook 'clojure-mode-hook #'company-mode)
;; (with-eval-after-load 'clojure-mode
;;   (with-eval-after-load 'cider
;;     (with-eval-after-load 'flycheck
;;       (flycheck-clojure-setup))))

;;; scala
;; (defun toggle-on-lsp-scala ()
;;   (interactive)
;;   (add-hook 'scala-mode-hook #'lsp))
;; (defun toggle-off-lsp-scala ()
;;   (interactive)
;;   (remove-hook 'scala-mode-hook #'lsp))
;; (setq lsp-metals-server-args lsp-metals-server-args '("-J-Dmetals.allow-multiline-string-formatting=off"))
(add-to-list 'auto-mode-alist '("\\.sc\\'" . scala-mode))
(add-hook 'scala-mode-hook #'company-mode)


(provide 'w-jvm-languages)
