;;; -*- lexical-binding: t; -*-

(add-hook 'after-init-hook #'delete-selection-mode)
(add-hook 'after-init-hook #'global-subword-mode)
(with-eval-after-load 'subword
  (diminish 'subword-mode))

(straight-use-package 'expand-region)
(setq expand-region-contract-fast-key "V")
(global-set-key (kbd "M-SPC v") #'er/expand-region)

(straight-use-package '(thing-edit :host github :repo "manateelazycat/thing-edit"))

(add-hook 'hexl-mode-hook #'view-mode)

(provide 'w-edit)
