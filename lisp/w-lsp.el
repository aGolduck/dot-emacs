(use-package lsp-mode
  :commands (lsp-headerline-breadcrumb-mode)
  :init
  (setq lsp-file-watch-ignored '("[/\\\\]\\.git$" "[/\\\\]\\.hg$" "[/\\\\]\\.bzr$" "[/\\\\]_darcs$" "[/\\\\]\\.svn$" "[/\\\\]_FOSSIL_$" "[/\\\\]\\.idea$" "[/\\\\]\\.ensime_cache$" "[/\\\\]\\.eunit$" "[/\\\\]node_modules$" "[/\\\\]\\.fslckout$" "[/\\\\]\\.tox$" "[/\\\\]\\.stack-work$" "[/\\\\]\\.bloop$" "[/\\\\]\\.metals$" "[/\\\\]target$" "[/\\\\]\\.ccls-cache$" "[/\\\\]\\.deps$" "[/\\\\]build-aux$" "[/\\\\]autom4te.cache$" "[/\\\\]\\.reference$" "/usr/include.*" "[/\\\\]\\.ccls-cache$")
        ;; lsp-diagnostic-package :none
        ;; lsp-enable-file-watchers nil
        ;; lsp-idle-delay 0.500
        lsp-enable-completion-at-point t
        lsp-completion-enable-additional-text-edit t
        lsp-enable-folding nil
        lsp-enable-indentation nil
        lsp-enable-on-type-formatting nil
        lsp-enable-text-document-color nil
        lsp-enable-xref t
        lsp-file-watch-threshold 10000
        lsp-headerline-breadcrumb-enable t
        lsp-log-io t
        lsp-print-performance t
        lsp-semantic-highlighting nil
        read-process-output-max (* 1024 1024))
  (setq lsp-session-file (w/locate-emacs-var-file ".lsp-session-v1")
        lsp-server-install-dir (w/locate-emacs-var-file ".cache/lsp"))
  (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  ;; lsp-completion 使用 yas 补全，但没有补全完没有正确置空 yas--active-snippet，导致 auto-save 检测条件出错
  (add-hook 'lsp-mode-hook #'yas-minor-mode-on)
  ;; TODO should only start after lsp starts
  ;; (add-hook 'lsp-mode-hook
  ;;           (lambda () (run-at-time 10 nil #'lsp-headerline-breadcrumb-mode)))
  ;; (add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode)
  (global-unset-key (kbd "M--"))
  (use-package lsp-ui
    :init
    (setq lsp-ui-sideline-enable t
          lsp-ui-doc-enable t
          ;; lsp-ui-doc-delay .2
          lsp-ui-doc-position 'top)
    :config
    (set-face-attribute 'lsp-ui-sideline-code-action nil :foreground "dark green")
    (set-face-attribute 'lsp-ui-sideline-current-symbol nil :background "black")
    (set-face-attribute 'lsp-ui-doc-background nil :background "light grey"))
  (use-package dap-mode
    :init
    (setq dap-breakpoints-file (w/locate-emacs-var-file ".dap-breakpoints"))
    (add-hook 'dap-stopped-hook (lambda (arg) (call-interactively #'dap-hydra)))
    ;; (add-hook 'dap-terminated-hook (lambda (_args) (dap-hydra/nil)))
    :config
    (dap-auto-configure-mode))
  :config
  ;; (diminish 'lsp-mode "语")
  (define-key lsp-mode-map (kbd "M--") #'lsp-execute-code-action)
  (define-key lsp-mode-map (kbd "M-'") #'lsp-goto-implementation)
  (define-key lsp-mode-map (kbd "M-\"") #'lsp-find-references))

(with-eval-after-load 'lsp-lens
  (diminish 'lsp-lens-mode "透"))

(provide 'w-lsp)
