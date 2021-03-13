;;; -*- lexical-binding: t; -*-

(if (>= emacs-major-version 28)
    (setq w/lsp-client "lsp")
  (setq w/lsp-client "eglot"))

(defun w/locate-in-current-directory (path)
  (concat (file-name-directory (or load-file-name buffer-file-name)) path))

(add-to-list 'load-path (w/locate-in-current-directory "lisp"))
(add-to-list 'load-path (w/locate-in-current-directory "site-lisp"))

(load (w/locate-in-current-directory "private"))

(require 'w-utils)
(require 'w-exec-path)
(require 'w-straight)
(require 'w-use-package)

(straight-use-package 'diminish)
(require 'w-grep)
(require 'w-buffer)
(require 'w-file)
(require 'w-dired)
(require 'w-selectrum)
(require 'w-company)
(require 'w-org)
(require 'w-flyspell)
(require 'w-prog)
;; (require 'w-rss)

(when (equal w/lsp-client "lsp") (require 'w-lsp))
(when (equal w/lsp-client "eglot") (require 'w-eglot))
(require 'w-java)

(load (w/locate-in-current-directory "packages"))
(load (w/locate-in-current-directory "config"))

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
