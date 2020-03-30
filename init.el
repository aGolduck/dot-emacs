;;; init.el --- wenpin's emacs.d                     -*- lexical-binding: t; -*-

;; Copyright (C) 2020 wenpin

;; Author:  wenpin <w@shamingming.com>

;; bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; use-package
(setq straight-default-vc 'git)
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; oh, it's magit
(straight-use-package 'magit)

;; my org, my life
(straight-use-package 'org)

;; utilities
(straight-use-package 'which-key)
(which-key-mode)

;;; programming
;; lsp rules all
;; (require 'init-lsp-mode)
(straight-use-package '(nox :host github :repo "manateelazycat/nox"))
(dolist (hook (list 'js-mode-hook))
  (add-hook hook '(lamda () (nox-ensure))))

(straight-use-package 'typescript-mode)


;; live in emacs
(straight-use-package '(emacs-application-framework :host github :repo "manateelazycat/emacs-application-framework" :no-build t))
(add-to-list 'load-path (expand-file-name "straight/repos/emacs-application-framework" user-emacs-directory))
(require 'eaf)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(leuven))
 '(recentf-mode t)
 '(visible-bell t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "JetBrains Mono" :foundry "JB  " :slant normal :weight normal :height 98 :width normal)))))
