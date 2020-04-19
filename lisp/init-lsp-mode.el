(straight-use-package 'lsp-mode)
(straight-use-package 'lsp-ui)
(straight-use-package 'company-lsp)
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0) ;; default is 0.2
;; TODO double by 2 every time to test
;; (setq gc-cons-threshold ) 
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-prefer-capf t)
;; (setq lsp-idle-delay 0.500)
(setq lsp-print-performance t)
(setq lsp-log-io t)
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))
(with-eval-after-load 'lsp-mode
  ;; :project/:workspace/:file
  (setq lsp-diagnostics-modeline-scope :project)
  (add-hook 'lsp-managed-mode-hook 'lsp-diagnostics-modeline-mode))

(provide 'init-lsp-mode.el)
