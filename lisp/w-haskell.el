(require 'w-lsp)

(straight-use-package 'haskell-mode)
(straight-use-package 'lsp-haskell)

;;; use lsp-haskell instead of eglot
(when (not w/lsp-client)
  (add-hook 'haskell-mode-hook #'lsp)
  (add-hook 'haskell-mode-hook #'lsp-ui-mode)
  (add-hook 'haskell-literate-mode-hook #'lsp)
  (add-hook 'haskell-mode-hook #'lsp))

(provide 'w-haskell)
