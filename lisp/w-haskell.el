(straight-use-package 'haskell-mode)
(straight-use-package 'lsp-haskell)

;;; lsp is good enough for haskell, no eglot
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-mode-hook #'lsp-ui-mode)
(add-hook 'haskell-literate-mode-hook #'lsp)
(add-hook 'haskell-mode-hook #'lsp)

(provide 'w-haskell)
