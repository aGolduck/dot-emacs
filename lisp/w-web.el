;;; -*- lexical-binding: t; -*-
(straight-use-package 'emmet-mode)
(straight-use-package 'json-mode)
(straight-use-package 'typescript-mode)
(straight-use-package 'tide)

;;; tide
(setq tide-completion-detailed t
      tide-always-show-documentation t
      ;; Fix #1792: by default, tide ignores payloads larger than 100kb. This
      ;; is too small for larger projects that produce long completion lists,
      ;; so we up it to 512kb.
      tide-server-max-response-length 524288)
(with-eval-after-load 'tide
  (diminish 'tide-mode "型"))

;;; js
(setq js-indent-level 2)
(add-hook 'js-mode-hook (lambda ()
                          (when (executable-find "tsserver")
                            (tide-setup)
                            (unless (tide-current-server) (tide-restart-server))
                            (tide-hl-identifier-mode 1))))
(dolist (hooked (list
                 #'company-mode
                 #'eldoc-mode
                 #'electric-pair-local-mode
                 ))
  (add-hook 'js-mode-hook hooked))

;;; typescript
(setq typescript-indent-level 2)
;; (add-hook 'typescript-mode-hook #'lsp)
;; (add-hook 'typescript-mode-hook #'lsp-deferred)
(dolist (hooked (list
                 #'company-mode
                 #'eldoc-mode
                 #'electric-pair-local-mode
                 ))
  (add-hook 'typescript-mode-hook hooked))
(when (executable-find "tsserver")
  (dolist (hooked (list #'tide-setup #'tide-hl-identifier-mode))
    (add-hook 'typescript-mode-hook hooked)))


(provide 'w-web)
