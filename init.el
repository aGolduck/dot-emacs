;;; pre-init
;; M-SPC is key to my emacs world
(global-unset-key (kbd "M-SPC"))
;; accelerate loading init files, will be reset by gcmh
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

;;; bootstrap straight.el and use-package
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
(setq straight-default-vc 'git)
;; use-package powers all
(straight-use-package 'use-package)
;; decouple code related to straight.el and use-package
(setq straight-use-package-by-default nil)
;; install and load packages by straight.el
;; straight.el loads auto-load functions only
(load (concat (file-name-directory (or load-file-name buffer-file-name)) "package"))
;; personal lisp
(add-to-list 'load-path (concat (file-name-directory (or load-file-name buffer-file-name)) "lisp"))
(add-to-list 'load-path (concat (file-name-directory (or load-file-name buffer-file-name)) "site-lisp"))

;;; lazycat is lazy
(use-package auto-save
  :config
  (setq auto-save-silent t
	auto-save-delete-trailing-whitespace t)
  (auto-save-enable))
;;; waiting to explore
(use-package company
  :init
  (add-hook 'emacs-lisp-mode-hook #'company-mode)
  (add-hook 'js-mode-hook #'company-mode)
  (add-hook 'typescript-mode-hook #'company-mode))
;;; live in emacs
(use-package eaf)
;;; simple and intuitive
(use-package expand-region :bind ("M-SPC v" . er/expand-region))
;;; currently for snails only
(use-package fuz :config (unless (require 'fuz-core nil t) (fuz-build-and-load-dymod)))
;;; oh, it's magit
(use-package magit :bind ("M-SPC g s" . magit-status))
;;; it's spc, spc
(use-package snails
  :after fuz
  :bind ("M-SPC SPC" . snails)
;  :config (snails '(snails-backend-buffer snails-backend-recentf))
  )
;;; lsp rules all
(use-package nox
  :after (company posframe)
  :config
  (dolist (hook (list
		 'js-mode-hook
		 'typescript-mode-hook
		 ))
    (add-hook hook '(lamda () (nox-ensure))))
)
;;; my org, my life
(use-package org
  :custom
  (org-directory "~/org")
  (org-agenda-span 'month)
  (org-agenda-show-future-repeats 'next)
  (org-agenda-files '("~/org/orgzly"))
  (org-agenda-log-mode-items '(closed))
  (org-todo-keywords
      (quote ((sequence "TODO(T)" "NEXT(n)" "|" "DONE(t)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c!)" "PHONE" "MEETING")
              ;; 下面这行会导致 spacemacs 的 org headings 效果消失，因为关键词重复
              ;; (type "EXPERIENCE(e) DEBUG(d) | "DONE")
              (type "EXPERIENCE(e)" "DEBUG(d)" "BOOKMARK(b)" "MARKBOOK(m)")
              )))
  (org-default-notes-file (concat org-directory "/orgzly/Inbox.org"))
  (org-capture-templates
      '(
        ("t" "TODO" entry (file org-default-notes-file)
         "* TODO %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :END:\n%i\n  %a")
        ("n" "NOTE" entry (file+headline org-default-notes-file "NOTES")
         "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n%i\n")
        ("j" "js source code" entry (file+headline org-default-notes-file "NOTES")
         "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n  #+begin_src js\n%i  #+end_src\n")
        ("s" "source code" entry (file+headline org-default-notes-file "NOTES")
         "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n  #+begin_src %^{source language}\n%i%?  #+end_src\n")
        ("g" "template group")
        ("ga" "Template Group A holder" entry (file+headline org-default-notes-file "NOTES")
         "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n  #+begin_src %^{source language}\n%i%?  #+end_src\n")
        ))
  )
;;; difference between heaven and hell
(use-package paredit
  :commands (enable-paredit-mode)
  :init
    (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
    (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
    (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
    (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
    (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
    (add-hook 'scheme-mode-hook           #'enable-paredit-mode)
    :config
    (require 'eldoc)
    (eldoc-add-command
     'paredit-backward-delete
     'paredit-close-round)
    )
;;; modern emacs
(use-package posframe)

;;; rime, THE input method
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

(use-package typescript-mode
  :custom (typescript-indent-level 2))
(use-package which-key :config (which-key-mode 1))

;;; reset gc
(use-package gcmh :config (gcmh-mode 1))

(global-set-key (kbd "M-SPC f f") 'find-file)
(global-set-key (kbd "M-SPC q q") 'save-buffers-kill-terminal)
(tool-bar-mode -1)
(toggle-frame-maximized)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'no-error 'no-message)
