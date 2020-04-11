;; init.el --- description -*- lexical-binding: t; -*-                         
;;                                                                              
;; Copyright (C) 2020 Wenpin CHOU                                               
;;                                                                              
;; Author: Wenpin CHOU <http://github/wenpin>                                   
;; Maintainer: Wenpin CHOU <wpchou@outlook.com>                                 
;; Created: April 10, 2020                                                      
;; Modified: April 10, 2020                                                     
;; Version: 0.0.1                                                               
;; Keywords:                                                                    
;; Homepage: https://github.com/wenpin/init                                     
;; Package-Requires: ((emacs 26.3) (cl-lib "0.5"))                              
;;                                                                              
;; This file is not part of GNU Emacs.                                          
;;                                                                              
;;; Commentary:                                                                 
;;                                                                              
;;  description                                                                 
;;                                                                              
;;; Code:


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

;; rime, THE input method
(straight-use-package '(rime :host github :repo "DogLooksGood/emacs-rime" :files ("*.el" "Makefile" "lib.c")))
;; mostly copy from https://github.com/cnsunyour/.doom.d/blob/develop/modules/cnsunyour/chinese/config.el
(use-package rime
  :bind
  (("M-t" . 'toggle-input-method)
   :map rime-mode-map
    ;; ("C-S-s-j" . #'rime-force-enable)
    ("C-`" . #'rime-send-keybinding)
    ("C-S-`" . #'rime-send-keybinding))
  :custom
  (default-input-method "rime")
  (rime-translate-keybindings '("C-f" "C-b" "C-n" "C-p" "C-g"))  ;; 发往 librime 的快捷键
  (rime-user-data-dir "~/.doom.d/rime")
  (rime-show-candidate 'posframe)
  (rime-posframe-style 'simple)
  :config
  (unless (fboundp 'rime--posframe-display-content)
    (error "Function `rime--posframe-display-content' is not available.")))

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


;;; live in emacs
(straight-use-package '(emacs-application-framework :host github :repo "manateelazycat/emacs-application-framework" :files ("app" "core" "*.el" "*.py")))

;; query magit's dependences                                                    
(nth 1 (gethash "magit" straight--build-cache))
;; query dash's dependents                                                      
(cl-remove-if-not
 (lambda (package)
   (member "dash" (nth 1 (gethash package straight--build-cache))))
 (hash-table-keys straight--recipe-cache))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'no-error 'no-message)
