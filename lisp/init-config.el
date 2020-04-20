;;; Lazycat is lazy
(use-package auto-save
  :defer t
  :init
  (setq auto-save-silent t
	auto-save-delete-trailing-whitespace t)
  (add-hook 'after-init-hook #'auto-save-enable))
;;; waiting to explore
(use-package company
  :defer t
  :init
  (add-hook 'emacs-lisp-mode-hook #'company-mode)
  (add-hook 'js-mode-hook #'company-mode)
  (add-hook 'typescript-mode-hook #'company-mode))
;;; ivy, counsel and swiper
(use-package counsel
  :init
  (setq ivy-use-virtual-buffers t
	enable-recursive-minibuffers t)
  (add-hook 'after-init-hook #'ivy-mode)
  (add-hook 'ivy-mode-hook #'counsel-mode)
  (global-set-key (kbd "C-s") 'swiper)
  ;; (global-set-key (kbd "C-c C-r") 'ivy-resume)
  ;; (global-set-key (kbd "M-x") 'counsel-M-x)
  ;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  ;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  ;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  ;; (global-set-key (kbd "<f1> l") 'counsel-find-library)
  ;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  ;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  ;; (global-set-key (kbd "C-c g") 'counsel-git)
  ;; (global-set-key (kbd "C-c j") 'counsel-git-grep)
  ;; (global-set-key (kbd "C-c k") 'counsel-ag)
  ;; (global-set-key (kbd "C-x l") 'counsel-locate)
  ;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  ;; (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  )
;;; live in emacs
(use-package eaf :if (eq system-type 'gnu/linux) :defer t)
;;; simple and intuitive
(use-package expand-region :defer t :init (global-set-key (kbd "M-SPC v") 'er/expand-region))
;;; currently for snails only
(use-package fuz :after (:any snails (:and ivy ivy-fuz)) :config (unless (require 'fuz-core nil t) (fuz-build-and-load-dymod)))
;;; reset gc after init
(use-package gcmh :defer t :init (add-hook 'after-init-hook #'gcmh-mode))
;;; use posframe stop eaf blinking
(use-package ivy-posframe
  :after ivy
  :init
  (setq ivy-posframe-display-functions-alist
	'(
					;(swiper . ivy-posframe-display-at-point)
	  (t . ivy-posframe-display-at-frame-center)))
					;(ivy-posframe-height-alist '((swiper . 20) (t . 40)))
					;(ivy-posframe-parameters '((left-fringe . 8) (right-fringe . 8)))
  :config (ivy-posframe-mode 1))
;;; oh, it's magit
(use-package magit :defer t :init (global-set-key (kbd "M-SPC g s") 'magit-status))
(use-package markdown-mode
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (setq markdown-command "multimarkdown"))
;;; lsp rules all
(use-package nox
  :defer t
  :config
  (dolist (hook (list
		 'js-mode-hook
		 'typescript-mode-hook
		 ))
    (add-hook hook '(lamda () (nox-ensure)))))
;;; it's spc, spc
(use-package snails
  :defer t
  :if window-system
  :commands (snails)
  :init
  (when (eq system-type 'darwin)
    (setq snails-default-backends '(
			    snails-backend-buffer
			    snails-backend-recentf
			    snails-backend-imenu
			    snails-backend-current-buffer
			    snails-backend-rg
			    snails-backend-projectile
			    snails-backend-mdfind
			    snails-backend-fasd
			    snails-backend-command
			    )))
  (setq snails-use-exec-path-from-shell nil)
  (global-set-key (kbd "M-SPC SPC") 'snails))
;;; my org, my life
(use-package org
  :defer t
  :init
  (require 'bh-org)
  (defun bh/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))
  (setq org-directory "~/org"
	org-agenda-span 'month
	org-agenda-show-future-repeats 'next
	org-agenda-files '("~/org/orgzly")
	org-agenda-log-mode-items '(closed)
	org-default-notes-file (concat org-directory "/orgzly/Inbox.org")
	org-refile-targets (quote ((nil :maxlevel . 9)
                                   (org-agenda-files :maxlevel . 9)))
	org-refile-use-outline-path t
	org-outline-path-complete-in-steps nil
	org-agenda-log-mode-items (quote (closed state))
	org-refile-target-verify-function 'bh/verify-refile-target
	org-stuck-projects (quote ("" nil nil ""))
	org-archive-mark-done nil
	org-archive-location "%s_archive::* Archived Tasks"
	org-confirm-babel-evaluate nil
	org-html-inline-images t
	org-export-with-sub-superscripts nil
	org-use-sub-superscripts nil)
  (setq org-todo-keywords
	(quote ((sequence "TODO(T)" "NEXT(n)" "|" "DONE(t)")
		(sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c!)" "PHONE" "MEETING")
		;; 下面这行会导致 spacemacs 的 org headings 效果消失，因为关键词重复
		;; (type "EXPERIENCE(e) DEBUG(d) | "DONE")
		(type "EXPERIENCE(e)" "DEBUG(d)" "BOOKMARK(b)" "MARKBOOK(m)")
		)))
  (setq org-capture-templates
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
		("G" "Context  block agenda"
		 ((tags-todo "@office")
		  (tags-todo "@night")
		  (tags-todo "@noon")
		  (tags-todo "@bus")
		  (tags-todo "LATER")
		  )
		 nil)
		)))
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
(use-package org-journal
  :defer t
  :init (setq org-journal-dir "~/org/diary" org-journal-file-format "%Y%m%d.org"))
;;; difference between heaven and hell
(use-package paredit
  :defer t
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
(use-package posframe :defer t)
;;; rime, THE INPUT METHOD
;; mostly copy from https://github.com/cnsunyour/.doom.d/blob/develop/modules/cnsunyour/chinese/config.el
(use-package rime
  :defer t
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
(use-package typescript-mode
  :defer t
  :init (setq typescript-indent-level 2))

(provide 'init-config)
;;; init-config ends here
