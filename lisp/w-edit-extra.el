;;; -*- lexical-binding: t; -*-

(straight-use-package 'expand-region)
(straight-use-package 'undo-fu)

(setq expand-region-contract-fast-key "V")
(global-set-key (kbd "M-SPC v") #'er/expand-region)

(global-set-key (kbd "C-z") #'undo-fu-only-undo)
(global-set-key (kbd "C-S-z") #'undo-fu-only-redo)

(provide 'w-edit-extra)
