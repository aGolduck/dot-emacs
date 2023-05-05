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


(require 'w-straight)

;;; exploring zone before loading third-party packages

(defun w/打开gdb调试时自动显示行号 ()
  (if gdb-many-windows
      (global-display-line-numbers-mode 1)
    (global-display-line-numbers-mode -1)))
(add-hook 'gdb-many-windows-hook #'w/打开gdb调试时自动显示行号)

;; copied from https://emacs.stackexchange.com/questions/58590/why-set-window-dedicated-p-doesnt-work-with-certain-buffers
(defun toggle-current-window-dedication-and-fix ()
  (interactive)
  (let* ((window    (selected-window))
         (dedicated-and-fixed-p (window-dedicated-p window)))
    (set-window-dedicated-p window (not dedicated-and-fixed-p))
    (set-window-parameter window 'no-delete-other-windows (not dedicated-and-fixed-p))
    (message "Window fixed and %sdedicated to %s"
             (if dedicated-and-fixed-p "no longer " "")
             (buffer-name))))

(defun idea ()
  (interactive)
  ;; Using shell-command runs the program as a child, even when done asynchronously
  ;; start-process also runs as a child process

  ;; (shell-command "idea" (project-root (project-current)))
  ;; sleep for 1 second, or emacs will be stuck
  ;; (sleep-for 1)
  ;; (ns-do-applescript "tell application \"IntelliJ IDEA\" to activate")

  ;; call-process start the program as its own distinct process
  (call-process "idea" nil nil nil (expand-file-name (project-root (project-current))))
  )

;; 用 tramp 时读入 zshenv 配置的 PATH
(with-eval-after-load 'tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

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
