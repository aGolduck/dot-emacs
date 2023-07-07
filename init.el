;;; -*- lexical-binding: t; -*-

;;; prepare
(defun w/locate-in-current-directory (path)
  (concat (file-name-directory (or load-file-name buffer-file-name)) path))
(add-to-list 'load-path (w/locate-in-current-directory "lisp"))
(add-to-list 'load-path (w/locate-in-current-directory "site-lisp"))
(load (w/locate-in-current-directory "private"))
(defconst w/HOST (substring (shell-command-to-string "hostname") 0 -1))
(defconst w/EMACS-VAR (locate-user-emacs-file "var"))
(unless (file-exists-p w/EMACS-VAR) (mkdir w/EMACS-VAR))
(defun w/locate-emacs-var-file (file)
  (expand-file-name file w/EMACS-VAR))


(require 'w-minimal)

(setq explore-file (locate-user-emacs-file "w-explore.el"))
(load explore-file 'no-error 'no-message)


(require 'w-straight)


(require 'w-essential)
(require 'w-full)

;;; exploring zone after full initialization

;;; local settings
(require 'w-local)

;;; ignore custom file
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'no-error 'no-message)

;;; TODO 以下配置置前会出错, debug this
(require 'read-only-by-default)

(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))
(when window-system
  (desktop-save-mode 1)
  (desktop-read))
(when (>= emacs-major-version 27)
    (tab-bar-mode 1)
    ;; (setq tab-line-tab-name-function 'tab-line-tab-name-truncated-buffer)
    ;; (global-tab-line-mode 1)
    )

(provide 'init)
