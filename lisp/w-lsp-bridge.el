(straight-use-package 'posframe)
(straight-use-package 'markdown-mode)
(straight-use-package 'yasnippet)
(straight-use-package '(lsp-bridge :host github :repo "manateelazycat/lsp-bridge" :files ("*")))
;; (yas-global-mode)
;; (setq lsp-bridge-enable-log t
;;       lsp-bridge-enable-debug t)
;; org-babel js/shell 等不支持，原因不明
(setq acm-enable-search-file-words nil
      lsp-bridge-enable-diagnostics nil
      lsp-bridge-org-babel-lang-list '("css" "python"))
(with-eval-after-load 'lsp-bridge
  (define-key lsp-bridge-mode-map (kbd "M-'") #'lsp-bridge-popup-documentation)
  (define-key lsp-bridge-mode-map (kbd "M-.") #'lsp-bridge-find-def)
  (define-key lsp-bridge-mode-map (kbd "M-,") #'lsp-bridge-find-def-return)
  (define-key lsp-bridge-mode-map (kbd "M-<RET>") #'lsp-bridge-code-action)
  (define-key lsp-bridge-mode-map (kbd "M-r") #'lsp-bridge-rename)
  (define-key lsp-bridge-mode-map (kbd "M-\"") #'lsp-bridge-find-references)

  (add-to-list 'lsp-bridge-single-lang-server-extension-list '(("ts") . "deno")))
(add-hook 'lsp-bridge-mode-hook #'yas-minor-mode)
;; (add-hook 'emacs-lisp-mode-hook #'lsp-bridge-mode)
(add-hook 'css-mode-hook #'lsp-bridge-mode)
(add-hook 'js-mode-hook #'lsp-bridge-mode)
(add-hook 'typescript-mode-hook #'lsp-bridge-mode)
(add-hook 'python-mode-hook #'lsp-bridge-mode)
(add-hook 'go-mode-hook #'lsp-bridge-mode)

(setq lsp-bridge-get-single-lang-server-by-project
      (lambda (project-path filepath)
        (when (string-equal (file-name-base project-path) "deno-bridge")
        "deno")))

(provide 'w-lsp-bridge)
