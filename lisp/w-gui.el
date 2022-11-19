;;; -*- lexical-binding: t; -*-
(require 'w-gui-core)

(straight-use-package 'selectric-mode)
(straight-use-package 'page-break-lines)

;;; selectric-mode
(when (executable-find "aplay")
  (setq selectric-affected-bindings-list nil)
  (add-hook 'after-init-hook #'selectric-mode)
)



;;; page break line
(add-hook 'emacs-lisp-mode-hook #'page-break-lines-mode)

(provide 'w-gui)
