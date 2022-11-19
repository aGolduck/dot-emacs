;;; lsp
(require 'w-lsp-bridge)

;;; projectile
(require 'w-projectile)

;;; dumb-jump
(straight-use-package 'dumb-jump)
;; (setq dumb-jump-force-searcher 'rg) ;; rg is not working for at least elisp files
(with-eval-after-load 'xref
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;;; languages
(straight-use-package 'typescript-mode)
(setq typescript-indent-leven 2)
(straight-use-package 'go-mode)
(straight-use-package 'scala-mode)
(straight-use-package 'clojure-mode)
(straight-use-package 'cider)
(add-hook 'clojure-mode-hook #'lispy-mode)
;;; TODO company 的相关配置全部转移到 w-company
(add-hook 'clojure-mode-hook #'company-mode)
;; (with-eval-after-load 'clojure-mode
;;   (with-eval-after-load 'cider
;;     (with-eval-after-load 'flycheck
;;       (flycheck-clojure-setup))))
(add-to-list 'auto-mode-alist '("\\.sc\\'" . scala-mode))
(add-hook 'scala-mode-hook #'company-mode)
(straight-use-package 'haskell-mode)



(provide 'w-programming-essential)
