;;; -*- lexical-binding: t; -*-

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
(require 'w-company)
(require 'w-prog)
(require 'w-lsp)
(require 'w-flyspell)
;; (require 'w-rss)

(load (w/locate-in-current-directory "packages"))
(load (w/locate-in-current-directory "config"))

;; other settings including extra variable, faces and keybindings
(load (w/locate-in-current-directory "settings"))
;;; ignore custom file
(setq custom-file (locate-user-emacs-file "custom.el"))
;; (load custom-file 'no-error 'no-message)

(require 'w-org)
(require 'w-lisp)
(require 'read-only-by-default)

(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))
(desktop-read)
(tab-bar-mode 1)

(provide 'init)
