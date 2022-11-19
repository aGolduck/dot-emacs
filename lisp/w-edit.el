;;; -*- lexical-binding: t; -*-

(straight-use-package 'expand-region)
(straight-use-package 'undo-fu)

(add-hook 'after-init-hook #'delete-selection-mode)
(add-hook 'after-init-hook #'global-subword-mode)

(setq expand-region-contract-fast-key "V")
(global-set-key (kbd "M-SPC v") #'er/expand-region)

(global-set-key (kbd "C-z") #'undo-fu-only-undo)
(global-set-key (kbd "C-S-z") #'undo-fu-only-redo)

(add-hook 'hexl-mode-hook #'view-mode)

(provide 'w-edit)
