;;; -*- lexical-binding: t; -*-
(straight-use-package 'emmet-mode)
;; (straight-use-package 'json-mode)
(straight-use-package 'typescript-mode)

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
                 ))
  (add-hook 'js-mode-hook hooked))

;;; typescript
(setq typescript-indent-level 2)
(dolist (hooked (list
                 #'company-mode
                 #'eldoc-mode
                 ))
  (add-hook 'typescript-mode-hook hooked))
(when (executable-find "tsserver")
  (dolist (hooked (list #'tide-setup #'tide-hl-identifier-mode))
    (add-hook 'typescript-mode-hook hooked)))


(provide 'w-web)
