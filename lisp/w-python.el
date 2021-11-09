;;; -*- lexical-binding: t; -*-

;; (straight-use-package 'jupyter)
(straight-use-package 'ein)

;; (setq lsp-python-ms-auto-install-server nil
;;       lsp-python-ms-executable "~/g/Microsoft/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")
;; (add-hook 'python-mode-hook (lambda () (require 'lsp-python-ms) (lsp)))
(add-hook 'python-mode-hook #'highlight-indent-guides-mode)

(provide 'w-python)
