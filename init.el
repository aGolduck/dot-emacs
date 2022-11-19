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


(require 'w-built-in)


(require 'w-straight)
(require 'w-essential)
(require 'w-org)
(require 'w-jvm-languages)

;;; csv-mode
(straight-use-package 'csv-mode)
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(setq csv-separators '("," ";" "|" " "))
;; TODO truncate after align mode is on, revert if getting off
(add-hook 'csv-align-mode-hook (lambda () (setq-local truncate-lines nil)))

;; (require 'w-lsp-bridge)


(straight-use-package 'typescript-mode)
(setq js-indent-level 2
      typescript-indent-leven 2)

;; quickrun
(straight-use-package 'quickrun)
(with-eval-after-load 'quickrun
  (quickrun-set-default "typescript" "typescript/deno"))


;; symbol-overlay
(straight-use-package 'symbol-overlay)
(global-set-key (kbd "M-s h .") 'symbol-overlay-put)
(global-set-key (kbd "M-s h c") 'symbol-overlay-remove-all)
(global-set-key (kbd "M-p") #'symbol-overlay-switch-backward)
(global-set-key (kbd "M-n") #'symbol-overlay-switch-forward)
(with-eval-after-load 'symbol-overlay
  (transient-define-prefix symbol-overlay-transient ()
    "Symbol Overlay transient"
    ["Symbol Overlay"
     ["Overlays"
      ("." "Add/Remove at point" symbol-overlay-put)
      ("k" "Remove All" symbol-overlay-remove-all)
      ]
     ["Move to Symbol"
      ("n" "Next" symbol-overlay-switch-forward)
      ("p" "Previous" symbol-overlay-switch-backward)
      ]
     ["Other"
      ("m" "Highlight symbol-at-point" symbol-overlay-mode)
      ]
     ])
  (define-key symbol-overlay-map (kbd "?") 'symbol-overlay-transient))


;; go-mode
(straight-use-package 'go-mode)

(straight-use-package 'interaction-log)
(require 'interaction-log)
(interaction-log-mode 1)

(require 'w-full)

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
  (desktop-save-mode 1)
  (desktop-read))
(when (>= emacs-major-version 27)
    (tab-bar-mode 1)
    ;; (setq tab-line-tab-name-function 'tab-line-tab-name-truncated-buffer)
    ;; (global-tab-line-mode 1)
    )

(provide 'init)
