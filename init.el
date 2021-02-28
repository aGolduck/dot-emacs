;;; -*- lexical-binding: t; -*-

(defun wenpin/locate-in-current-directory (path)
  (concat (file-name-directory (or load-file-name buffer-file-name)) path))

(add-to-list 'load-path (wenpin/locate-in-current-directory "lisp"))
(add-to-list 'load-path (wenpin/locate-in-current-directory "site-lisp"))

(require 'init-utils)
(require 'init-exec-path)
(require 'init-straight)
(require 'init-use-package)

(require 'init-grep)
;; (require 'init-lisp)

(load (wenpin/locate-in-current-directory "packages"))
(load (wenpin/locate-in-current-directory "config"))

;; other settings including extra variable, faces and keybindings
(load (wenpin/locate-in-current-directory "settings"))

;;; ignore custom file
(setq custom-file (locate-user-emacs-file "custom.el"))
;; (load custom-file 'no-error 'no-message)

(desktop-read)
(tab-bar-mode 1)
