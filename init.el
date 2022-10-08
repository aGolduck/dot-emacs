;;; -*- lexical-binding: t; -*-

;; M-SPC is key to my emacs world
(global-unset-key (kbd "M-SPC"))

(defvar w/lsp-client nil "language service protocol client")
;; (setq w/lsp-client "eglot")
;; (setq w/lsp-client "lsp")

(defun w/locate-in-current-directory (path)
  (concat (file-name-directory (or load-file-name buffer-file-name)) path))

(add-to-list 'load-path (w/locate-in-current-directory "lisp"))
(add-to-list 'load-path (w/locate-in-current-directory "site-lisp"))

(load (w/locate-in-current-directory "private"))

;;; prepare
(require 'w-prepare)
(require 'w-straight)
(require 'w-exec-path)

(require 'w-minimal)
(require 'w-core)
(require 'w-to-be-core)

(straight-use-package 'posframe)
(straight-use-package 'markdown-mode)
(straight-use-package 'yasnippet)
(straight-use-package '(lsp-bridge :host github :repo "manateelazycat/lsp-bridge" :files ("*")))
;; (yas-global-mode)
;; (setq lsp-bridge-enable-log t
;;       lsp-bridge-enable-debug t)
;; org-babel js/shell 等不支持，原因不明
(setq lsp-bridge-org-babel-lang-list '("css" "python"))
(with-eval-after-load 'lsp-bridge
  (define-key lsp-bridge-mode-map (kbd "M-.") #'lsp-bridge-find-def)
  (define-key lsp-bridge-mode-map (kbd "M-,") #'lsp-bridge-return-from-def))
(add-hook 'lsp-bridge-mode-hook #'yas-minor-mode)
;; (add-hook 'emacs-lisp-mode-hook #'lsp-bridge-mode)
(add-hook 'css-mode-hook #'lsp-bridge-mode)
(add-hook 'js-mode-hook #'lsp-bridge-mode)
(add-hook 'python-mode-hook #'lsp-bridge-mode)
;; (require 'w-full)

;;; local settings
(require 'w-local)

;; other settings including extra variable, faces and keybindings
(load (w/locate-in-current-directory "settings"))
;;; ignore custom file
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'no-error 'no-message)

(require 'w-lisp)
(require 'read-only-by-default)

(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))
(when window-system
  (desktop-read))
(when (>= emacs-major-version 27)
    (tab-bar-mode 1)
    ;; (setq tab-line-tab-name-function 'tab-line-tab-name-truncated-buffer)
    ;; (global-tab-line-mode 1)
    )

(provide 'init)
