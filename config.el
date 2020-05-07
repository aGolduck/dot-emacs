;;; how to find out where config code goes?
;; 1. major mode, like typescript-mode, org-mode
;; 2. big minor mode, like ivy-mode, lsp-mode
;; 3. minor mode


;;; avoid conflict
(use-package autorevert :init (add-hook 'after-init-hook #'global-auto-revert-mode))
;;; Lazycat is lazy
(use-package auto-save
  :commands (auto-save-enable)
  :init
  (defun buffer-is-org-capture-p (buffer)
    "buffer is org capture"
    (save-excursion
      (set-buffer buffer)
      (if (boundp 'org-capture-mode) org-capture-mode nil)))
  (defun any-buffer-is-org-capture-p ()
    "auto-save would keep deleting trailing whitespace of org-capture"
    (if (member t (mapcar 'buffer-is-org-capture-p (buffer-list))) t nil))
  (setq auto-save-silent t
	auto-save-delete-trailing-whitespace t
	;; TODO: auto-save-disable-predicates not working
	;; auto-save-disable-predicates '('any-buffer-is-org-capture-p)
	)
  (add-hook 'after-init-hook #'auto-save-enable))
;;; jump to anywhere
(use-package avy
  :init
  (global-set-key (kbd "M-SPC g g") 'avy-goto-char-timer)
  (global-set-key (kbd "M-SPC g l") 'avy-goto-line)
  (global-set-key (kbd "M-SPC g w") 'avy-goto-word-0))
(use-package bookmark
  :init
  (global-set-key (kbd "M-SPC b s") 'bookmark-set))
;;; search and refactor in project
(use-package color-rg
  :commands
  (color-rg-search-input-in-project
   color-rg-search-symbol-in-project
   color-rg-search-input-in-current-file
   color-rg-search-symbol-in-current-file
   )
  :init
  (global-set-key (kbd "M-SPC s p") 'color-rg-search-input-in-project)
  (global-set-key (kbd "M-SPC s P") 'color-rg-search-symbol-in-project))
;;; TODO: waiting to explore
(use-package company)
;;; completion for script languages like js
(use-package company-tabnine)
;;; counsel invoked by ivy
(use-package counsel
  :init
  (global-set-key (kbd "M-SPC b j") 'counsel-bookmark)
  (global-set-key (kbd "M-SPC f r") 'counsel-recentf)
  (global-set-key (kbd "M-x") 'counsel-M-x))
(use-package diminish
  :init
  (add-hook 'after-init-hook
	    '(lambda () (dolist (mode (list
				       'flymake-posframe-mode
				       'gcmh-mode
				       'ivy-mode
				       'ivy-posframe-mode
				       ))
			  (diminish mode)))))
;;; to set up env variables
(use-package dotenv)
;;; live in emacs
(use-package eaf :if (eq system-type 'gnu/linux))
;;; eldoc configured for paredit
;; TODO: is avoiding all require really necceassary
;; (use-package eldoc :commands (eldoc-add-command))
;;; selection simple and intuitive
(use-package eglot)
(use-package elisp-mode :init
  (add-hook 'emacs-lisp-mode-hook #'company-mode)
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode))
(use-package expand-region :init (global-set-key (kbd "M-SPC v") 'er/expand-region))
;;; workspace
(use-package eyebrowse
  :if (< emacs-major-version 27)
  :init
  (add-hook 'after-init-hook #'eyebrowse-mode)
  ;; TODO: oddly, keydings below didn't work
  (global-key-binding (kbd "M-SPC w c") 'eyebrowse-create-window-config)
  (global-key-binding (kbd "M-SPC w n") 'eyebrowse-next-window-config))
(use-package file
  :init
  (global-set-key (kbd "M-SPC f f") 'find-file)
  (global-set-key (kbd "M-SPC f F") 'find-file-other-window))
(use-package flymake-posframe
  :commands (flymake-posframe-mode)
  :init (add-hook 'flymake-mode-hook #'flymake-posframe-mode))
;;; currently for snails only
(use-package fuz :after (:any snails (:and ivy ivy-fuz)) :config (unless (require 'fuz-core nil t) (fuz-build-and-load-dymod)))
;;; reset gc after init
(use-package gcmh :init (add-hook 'after-init-hook #'gcmh-mode))
(use-package git-link)
(use-package goto-addr :init (add-hook 'after-init-hook #'goto-address-mode))
;;; new api mode
(use-package graphql-mode)
;;; ivy, counsel and swiper
;; (use-package hl-todo :init (add-hook 'after-init-hook #'global-hl-todo-mode))
(use-package ivy
  :init
  (setq ivy-use-virtual-buffers t
	enable-recursive-minibuffers t)
  (add-hook 'after-init-hook #'ivy-mode)
  (global-set-key (kbd "M-SPC b b") 'ivy-switch-buffer)
  (global-set-key (kbd "M-SPC b B") 'ivy-switch-buffer-other-window))
;;; use posframe to avoid eaf blinking
(use-package ivy-posframe
  :init
  (setq ivy-posframe-display-functions-alist
	'(
	  ;; (swiper . ivy-posframe-display-at-point)
	  (t . ivy-posframe-display-at-frame-center)))
  ;; (ivy-posframe-height-alist '((swiper . 20) (t . 40)))
  ;; (ivy-posframe-parameters '((left-fringe . 8) (right-fringe . 8)))
  (add-hook 'ivy-mode-hook #'ivy-posframe-mode))
;;; livehood
(use-package js-mode
  :init
  (add-hook 'js-mode-hook #'company-mode)
  (add-hook 'js-mode-hook
	    '(lambda ()
	       (set (make-local-variable 'company-backends)
		    '((company-tabnine))))))
(use-package lsp-mode
  :init
  (setq lsp-log-io t
        lsp-print-performance t
        lsp-enable-completion-at-point t
        lsp-enable-xref t
        ;; lsp-diagnostic-package :none
        lsp-semantic-highlighting nil
        )
  (add-hook 'lsp-mode-hook #'yas-minor-mode))
;;; oh, it's magit
(use-package magit
  :init
  (setq-default magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)
  (global-set-key (kbd "M-SPC g s") 'magit-status))
;;; agenda for projects
(use-package magit-todos :init (global-set-key (kbd "M-SPC p t") 'magit-todos-list))
;;; if everyone use emacs......
(use-package markdown-mode
  :init
  (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (setq markdown-command "multimarkdown"))
;;; lsp rules all
(use-package nox
  ;; TODO: nox is not friendly to use-package, reference: snails
  :demand t
  :config
  (dolist (hook (list
		 ;; 'typescript-mode-hook
		 ))
    (add-hook hook '(lambda () (nox-ensure)))))
;;; project definition
(use-package projectile :init (global-set-key (kbd "M-SPC p f") 'projectile-find-file))
;;; it's spc, spc
(use-package snails
  :if window-system
  ;; both wenpin-snails snails need to be in commands, otherwise emacs can not recognize type of wenpin-snails
  :commands (wenpin-snails snails)
  :init
  ;; (when (eq system-type 'darwin)
  ;;   (setq snails-default-backends '(
  ;;       			    snails-backend-buffer
  ;;       			    snails-backend-recentf
  ;;       			    snails-backend-imenu
  ;;       			    snails-backend-current-buffer
  ;;       			    snails-backend-rg
  ;;       			    snails-backend-projectile
  ;;       			    snails-backend-mdfind
  ;;       			    snails-backend-fasd
  ;;       			    snails-backend-command
  ;;       			    )))
  ;; (when (eq system-type 'gnu/linux)
  ;;   (setq snails-default-backends '(
  ;; 			    snails-backend-buffer
  ;; 			    snails-backend-recentf
  ;; 			    snails-backend-imenu
  ;; 			    snails-backend-current-buffer
  ;; 			    snails-backend-rg
  ;; 			    snails-backend-projectile
  ;; 			    snails-backend-fd
  ;; 			    snails-backend-fasd
  ;; 			    snails-backend-command
  ;; 			    snails-backend-eaf-pdf-table
  ;; 			    snails-backend-eaf-browser-history
  ;; 			    snails-backend-eaf-browser-open
  ;; 			    snails-backend-eaf-browser-search
  ;; 			    snails-backend-eaf-github-search
  ;; 			    )))
  (setq snails-use-exec-path-from-shell nil)
  (global-set-key (kbd "M-SPC SPC") 'wenpin-snails))
(use-package olivetti)
;;; my org, my life
(use-package org
  :init
  (require 'bh-org)
  (setq org-directory "~/org"
	org-agenda-files '("~/org/orgzly")
	org-agenda-log-mode-items '(closed)
	org-agenda-log-mode-items (quote (closed state))
	org-agenda-show-future-repeats 'next
	org-agenda-span 'month
	org-agenda-tags-todo-honor-ignore-options t
	org-archive-location "%s_archive::* Archived Tasks"
	org-archive-mark-done nil
	org-confirm-babel-evaluate nil
	org-default-notes-file (concat org-directory "/orgzly/Inbox.org")
	org-export-with-sub-superscripts nil
	org-html-inline-images t
	org-outline-path-complete-in-steps nil
	org-refile-target-verify-function 'bh/verify-refile-target
	org-refile-targets (quote ((nil :maxlevel . 9) (org-agenda-files :maxlevel . 9)))
	org-refile-use-outline-path t
	org-stuck-projects (quote ("" nil nil ""))
	org-use-sub-superscripts nil)
  (setq org-todo-keywords
	(quote ((sequence "TODO(T)" "NEXT(n)" "|" "DONE(t)")
		(sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c!)" "PHONE" "MEETING")
		;; 下面这行会导致 spacemacs 的 org headings 效果消失，因为关键词重复
		;; (type "EXPERIENCE(e) DEBUG(d) | "DONE")
		(type "EXPERIENCE(e)" "DEBUG(d)" "BOOKMARK(b)" "MARKBOOK(m)")
		)))
  (setq org-todo-state-tags-triggers
	(quote (("CANCELLED" ("CANCELLED" . t))
		("WAITING" ("WAITING" . t))
		("HOLD" ("WAITING") ("HOLD" . t))
		(done ("WAITING") ("HOLD"))
		("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
		("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
		("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))
  (setq org-capture-templates
	'(
	  ("t" "TODO" entry (file+headline org-default-notes-file "INBOX")
	   "* TODO %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :END:\n%i\n  %a")
	  ("n" "Today NEXT" entry (file+headline org-default-notes-file "INBOX")
	   "* NEXT %?\n  SCHEDULED:  %T\n  :PROPERTIES:\n  :CREATED:  %U\n  :END:\n%i\n  %a")
	  ("N" "NOTE" entry (file+headline org-default-notes-file "NOTES")
	   "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n%i\n")
	  ("j" "js source code" entry (file+headline org-default-notes-file "NOTES")
	   "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n  #+begin_src js\n%i  #+end_src\n")
	  ("s" "source code" entry (file+headline org-default-notes-file "NOTES")
	   "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n  #+begin_src %^{source language}\n%i%?  #+end_src\n")
	  ("g" "template group")
	  ("ga" "Template Group A holder" entry (file+headline org-default-notes-file "NOTES")
	   "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n  #+begin_src %^{source language}\n%i%?  #+end_src\n")
	  ))
  (setq org-agenda-custom-commands
	(quote (("A" "My Agenda"
		 (
		  (tags-todo "-@office/!"
			     ((org-agenda-overriding-header "Next Actions")
			      (org-agenda-tags-todo-honor-ignore-options t)
			      (org-agenda-todo-ignore-scheduled 'future)
			      (org-agenda-skip-function
			       '(lambda ()
				  (or (org-agenda-skip-subtree-if 'todo '("HOLD" "WAITING"))
				      (org-agenda-skip-entry-if 'nottodo '("NEXT")))))
			      (org-tags-match-list-sublevels t)
			      (org-agenda-sorting-strategy
			       '(todo-state-down priority-down effort-up category-keep))))
		  (tags-todo "-CANCELLED/!NEXT"
		             ((org-agenda-overriding-header (concat "Project Next Tasks"
		                                                    (if bh/hide-scheduled-and-waiting-next-tasks
		                                                        ""
		                                                      " (including WAITING and SCHEDULED tasks)")))
		              (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
		              (org-tags-match-list-sublevels t)
		              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
		              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
		              (org-agenda-sorting-strategy
		               '(todo-state-down effort-up category-keep))))
		  (tags "REFILE/!TODO"
			((org-agenda-overriding-header "Tasks to Refile")
			 (org-agenda-todo-ignore-scheduled 'future)
			 (org-agenda-todo-ignore-deadlines 'future)
			 (org-tags-match-list-sublevels nil)))
		  (tags-todo "-CANCELLED/!"
		             ((org-agenda-overriding-header "Stuck Projects")
		              (org-agenda-skip-function 'bh/skip-non-stuck-projects)
		              (org-agenda-sorting-strategy
		               '(category-keep))))
		  (tags-todo "-HOLD-CANCELLED/!"
		             ((org-agenda-overriding-header "Projects")
		              (org-agenda-skip-function 'bh/skip-non-projects)
		              (org-tags-match-list-sublevels 'indented)
		              (org-agenda-sorting-strategy
		               '(category-keep))))
		  (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
		             ((org-agenda-overriding-header (concat "Project Subtasks"
		                                                    (if bh/hide-scheduled-and-waiting-next-tasks
		                                                        ""
		                                                      " (including WAITING and SCHEDULED tasks)")))
		              (org-agenda-skip-function 'bh/skip-non-project-tasks)
		              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
		              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
		              (org-agenda-sorting-strategy
		               '(category-keep))))
		  (tags-todo "-REFILE-CANCELLED-WAITING-HOLD-CONTEXT/!"
		             ((org-agenda-overriding-header (concat "Standalone Tasks"
		                                                    (if bh/hide-scheduled-and-waiting-next-tasks
		                                                        ""
		                                                      " (including WAITING and SCHEDULED tasks)")))
		              (org-agenda-skip-function 'bh/skip-project-tasks)
		              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
		              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
		              (org-agenda-sorting-strategy
		               '(category-keep))))
		  )
		 nil)
		("g" . "goto context")
		("ga" "year agenda" agenda ""  ((org-agenda-span 'year)
						(org-agenda-start-on-weekday nil)
						(org-agenda-show-future-repeats nil)
						))
		("go" "Office" tags-todo "@office" ((org-agenda-sorting-strategy
						     '(todo-state-down priority-down effort-up category-keep tsia-down))))
		("gN" "Night" tags-todo "@night")
		("gn" "noon" tags-todo "@noon")
		("gb" "bus" tags-todo "@bus")
		("gl" "later" tags-todo "LATER")
		("G" "Context block agenda"
		 ((tags-todo "@office")
		  (tags-todo "@night")
		  (tags-todo "@noon")
		  (tags-todo "@bus")
		  (tags-todo "LATER")
		  )
		 nil)
		)))
  (org-babel-do-load-languages 'org-babel-load-languages
			       '((awk . t)))
  ;; key binding
  (global-set-key (kbd "C-c c") 'org-capture)
  (global-set-key (kbd "C-c a") 'org-agenda)
  :config
  (defadvice org-html-paragraph (before org-html-paragraph-advice
					(paragraph contents info) activate)
    "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to html."
    (let* ((origin-contents (ad-get-arg 1))
           (fix-regexp "[[:multibyte:]]")
           (fixed-contents
            (replace-regexp-in-string
             (concat
              "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)") "\\1\\2" origin-contents)))
      (ad-set-arg 1 fixed-contents))))
(use-package org-agenda
  :config (define-key org-agenda-keymap (kbd "R") 'org-agenda-refile))
;;; for diary
(use-package org-journal
  :init (setq org-journal-dir "~/org/journal" org-journal-file-format "%Y%m%d.org"))
;;; difference between heaven and hell
(use-package paredit
  :commands (enable-paredit-mode)
  :init
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
;;; rime, THE INPUT METHOD
(use-package rime
  ;; mostly copy from https://github.com/cnsunyour/.doom.d/blob/develop/modules/cnsunyour/chinese/config.el
  :init
  (setq default-input-method "rime"
	rime-translate-keybindings '("C-f" "C-b" "C-n" "C-p" "C-g")  ;; 发往 librime 的快捷键
	rime-librime-root (if (eq system-type 'darwin) (expand-file-name "~/.emacs.d/rime/librime-mac/dist"))
	rime-user-data-dir "~/.emacs.d/rime"
	rime-show-candidate 'posframe
	rime-posframe-style 'simple)
  (global-set-key (kbd "M-t") 'toggle-input-method)
  :config
  (define-key rime-mode-map (kbd "C-`") 'rime-send-keybinding)
  (define-key rime-mode-map (kbd "C-S-`") 'rime-send-keybinding)
  (unless (fboundp 'rime--posframe-display-content)
    (error "Function `rime--posframe-display-content' is not available.")))
(use-package rust-mode
  :init
  (add-hook 'rust-mode-hook #'lsp))
;;; save cursor place
(use-package saveplace :init (add-hook 'after-init-hook #'save-place-mode))
;;; only for emacs 27+, 导致 .emacs.d/init.el 无法编辑，暂时看不到启动的必要
;; (use-package so-long :if (> emacs-major-version 26) :init (add-hook 'after-init-hook #'global-so-long-mode))
;;; for snake-shape words
(use-package subword :init (add-hook 'after-init-hook #'global-subword-mode))
;;; swiper, invoked by ivy
(use-package swiper
  :init
  (global-set-key (kbd "C-s") 'swiper)
  (global-set-key (kbd "C-M-s") 'swiper-thing-at-point))
(use-package tab-bar :if (> emacs-major-version 26) :init (add-hook 'after-init-hook #'tab-bar-mode))
(use-package tab-line :if (> emacs-major-version 26) :init (add-hook 'after-init-hook #'global-tab-line-mode))
;;; better livehood
(use-package typescript-mode
  :init
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode-hook #'paredit-mode)
  (add-hook 'typescript-mode-hook #'lsp)
  (add-hook 'typescript-mode-hook #'electric-pair-local-mode)
  ;; (add-hook 'typescript-mode-hook #'company-mode)
  ;; (add-hook 'typescript-mode-hook #'lsp-deferred)
  )
(use-package view-mode
  :init
  (add-hook 'find-file-hook
	    '(lambda ()
	       (unless (or
			(string-match-p "org/orgzly" (buffer-file-name))
			(string-match-p ".git/COMMIT_EDITMSG" (buffer-file-name))
			)
		 (view-mode)))))
(use-package vterm)
;;; yaml mode for yaml, ansible
(use-package yaml-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\.'" . yaml-mode)))



(provide 'init-config)
;;; init-config ends here
