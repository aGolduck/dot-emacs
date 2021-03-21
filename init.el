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

(require 'w-prepare)
(require 'w-exec-path)
(require 'w-straight)

(straight-use-package 'diminish)
(require 'w-utils)
(require 'w-emacs)
(require 'w-ui)

(require 'w-window)
(require 'w-buffer)
(require 'w-file)
(require 'w-grep)
(require 'w-edit)

(require 'w-dired)
(require 'w-git)

(require 'w-rime)
(require 'w-flyspell)

(require 'w-selectrum)
(require 'w-company)

(require 'w-prog)
(require 'w-lsp)
(require 'w-eglot)
(require 'w-java)
(require 'w-haskell)
(require 'w-web)

(require 'w-org)

;; (require 'w-rss)
(require 'w-telega)
(require 'w-eaf)
(require 'w-term)
(require 'w-system)
(require 'w-z)

;; other settings including extra variable, faces and keybindings
(load (w/locate-in-current-directory "settings"))
;;; ignore custom file
(setq custom-file (locate-user-emacs-file "custom.el"))
;; (load custom-file 'no-error 'no-message)

(require 'w-lisp)
(require 'read-only-by-default)

(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))
(desktop-read)
;; (when (>= emacs-major-version 27)
;;     (tab-bar-mode 1)
;;     (setq tab-line-tab-name-function 'tab-line-tab-name-truncated-buffer)
;;     (global-tab-line-mode 1))

(provide 'init)
