;;; how to find out where config code goes?
;; 1. major mode, like typescript-mode, org-mode
;; 2. big minor mode, like ivy-mode, lsp-mode
;; 3. minor mode

(use-package ansi-color
  :init
  (add-hook 'compilation-filter-hook
            (lambda ()
              (let ((buffer-read-only nil))
                (ansi-color-apply-on-region (point-min) (point-max))))))

(use-package auto-save
  :commands (auto-save-enable)
  :init
  (setq auto-save-silent t
	auto-save-delete-trailing-whitespace t)
  (add-hook 'after-init-hook #'auto-save-enable))

(use-package autorevert :init (add-hook 'after-init-hook #'global-auto-revert-mode))

(use-package avy)

(use-package bookmark)

(use-package cc-mode
  :init
  (add-hook 'c-mode-hook #'lsp))

(use-package ccls)

(use-package color-rg
  :commands
  (color-rg-search-input-in-project
   color-rg-search-symbol-in-project
   color-rg-search-input-in-current-file
   color-rg-search-symbol-in-current-file))

(use-package company
  :init
  (setq company-minimum-prefix-length 1
        company-tooltip-align-annotations t
        ;; default is 0.2
        company-idle-delay 0.0)
  :config (diminish 'company-mode "补"))

(use-package company-org-roam :after org-roam :config (push 'company-org-roam company-backends))

(use-package counsel)

(use-package dap-java
  :commands (dap-java-debug
             dap-java-run-test-method
             dap-java-debug-test-method
             dap-java-run-test-class
             dap-java-debug-test-class)
  :init
  (setq dap-java-test-runner
        "~/.emacs.d/.cache/lsp/eclipse.jdt.ls/test-runner/junit-platform-console-standalone.jar"))

(use-package dap-mode
  :after lsp-mode
  :init (add-hook 'dap-stopped-hook (lambda (arg) (call-interactively #'dap-hydra)))
  :config (dap-auto-configure-mode))

(use-package desktop
  :init
  (setq desktop-base-file-name (concat ".emacs-" emacs-version ".desktop")
        desktop-base-lock-name (concat ".emacs-" emacs-version ".desktop.lock")
        desktop-globals-to-save '()
        desktop-files-not-to-save ".*"
        desktop-buffers-not-to-save ".*"
        desktop-save t)
  (add-hook 'after-init-hook
            (lambda ()
              (when window-system
                (desktop-save-mode)
                (desktop-read)))))

(use-package diminish
  :init
  (add-hook 'after-init-hook
	    (lambda ()
              (dolist (mode (list
			     'flymake-posframe-mode
			     'gcmh-mode
			     'ivy-mode
			     'ivy-posframe-mode
                             'org-roam-mode
                             'winner-mode
                             'selectric-mode
                             'subword-mode
			     ))
		(diminish mode)))))

(use-package dired
  :init
  (setq dired-listing-switches "-Afhlv"
        dired-auto-revert-buffer t
        dired-dwim-target t
        dired-recursive-copies 'always
        dired-recursive-deletes 'top))

(use-package dired-rsync)

(use-package dotenv)

(use-package ediff-wind
  :init
  (setq ediff-merge-split-window-function 'split-window-vertically
        ediff-split-window-function 'split-window-horizontally
        ediff-window-setup-function 'ediff-setup-windows-plain)
  :config
  (add-hook 'ediff-after-quit-hook-internal #'winner-undo))

(use-package eldoc
  :commands (eldoc-add-command)
  :config (diminish 'eldoc-mode "册"))

(use-package elisp-mode :init
  (add-hook 'emacs-lisp-mode-hook #'company-mode)
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode))

(use-package epg-config :init (setq epg-pinentry-mode 'loopback))

(use-package esh-autosuggest :after esh-mode :commands (esh-autosuggest-mode))

(use-package esh-mode
  :init
  (add-hook 'eshell-mode-hook #'esh-autosuggest-mode)
  (add-hook 'eshell-mode-hook (lambda () (require 'eshell-z)))
  (add-hook 'eshell-mode-hook
            (lambda ()
              (define-key eshell-mode-map (kbd "C-u") #'eshell-kill-input))))

(use-package eshell-z :after esh-mode)

(use-package eww :init (add-hook 'eww-mode #'visual-line-mode))

(use-package expand-region :init (setq expand-region-contract-fast-key "V"))

(use-package file
  :init
  (setq auto-save-default nil
        make-backup-files nil))

(use-package find-func :init (setq find-function-C-source-directory "~/r/org.gnu/emacs/src"))

(use-package flycheck :config (diminish 'flycheck-mode "检"))

(use-package flycheck-posframe :after flycheck :init (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))

(use-package flymake-posframe
  :commands (flymake-posframe-mode)
  :init (add-hook 'flymake-mode-hook #'flymake-posframe-mode))

(use-package frame :init (add-hook 'after-init-hook #'blink-cursor-mode))

(use-package fuz :after (:any snails (:and ivy ivy-fuz)) :config (unless (require 'fuz-core nil t) (fuz-build-and-load-dymod)))

(use-package gcmh :init (add-hook 'after-init-hook #'gcmh-mode))

(use-package git-link)

(use-package goto-addr :init (add-hook 'after-init-hook #'goto-address-mode))

(use-package graphql-mode)

(use-package hi-lock
  :init
  ;; remove ugly hi-yellow from default
  (setq hi-lock-face-defaults '("hi-pink" "hi-green" "hi-blue" "hi-salmon" "hi-aquamarine" "hi-black-b" "hi-blue-b" "hi-red-b" "hi-green-b" "hi-black-hb"))
  :config (diminish 'hi-lock-mode "亮"))

(use-package hideshow
  :init (add-hook 'prog-mode-hook #'hs-minor-mode)
  :config
  (defconst wenpin/hideshow-folded-face '((t (:inherit 'font-lock-comment-face :box t))))
  (defun wenpin/hide-show-overlay-fn (wenpin/overlay)
    (when (eq 'code (overlay-get wenpin/overlay 'hs))
      (let* ((nlines (count-lines (overlay-start wenpin/overlay)
                                  (overlay-end wenpin/overlay)))
             (info (format " ... #%d " nlines)))
        (overlay-put wenpin/overlay 'display (propertize info 'face wenpin/hideshow-folded-face)))))
  (setq hs-set-up-overlay 'wenpin/hide-show-overlay-fn)
  (diminish 'hs-minor-mode "折"))

(use-package highlight-indent-guides
  :init
  (setq highlight-indent-guides-method 'character
        ;; highlight-indent-guides-character ?┃
        ;; highlight-indent-guides-character ?│
        ;; highlight-indent-guides-character ?║
        highlight-indent-guides-auto-odd-face-perc 15
        highlight-indent-guides-auto-even-face-perc 55
        highlight-indent-guides-auto-character-face-perc 61.8))

(use-package ivy
  :init
  (setq ivy-use-virtual-buffers t
	enable-recursive-minibuffers t)
  (add-hook 'after-init-hook #'ivy-mode))

(use-package ivy-hydra)

(use-package ivy-posframe
  :init
  (setq ivy-posframe-display-functions-alist
	'(
	  ;; (swiper . ivy-posframe-display-at-point)
	  (t . ivy-posframe-display-at-frame-center)))
  ;; (ivy-posframe-height-alist '((swiper . 20) (t . 40)))
  ;; (ivy-posframe-parameters '((left-fringe . 8) (right-fringe . 8)))
  (add-hook 'ivy-mode-hook #'ivy-posframe-mode))

(use-package ivy-xref
  :init
  ;; xref initialization is different in Emacs 27 - there are two different
  ;; variables which can be set rather than just one
  (when (>= emacs-major-version 27)
    (setq xref-show-definitions-function #'ivy-xref-show-defs))
  ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
  ;; commands other than xref-find-definitions (e.g. project-find-regexp)
  ;; as well
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

(use-package js-mode
  :init
  (setq js-indent-level 2)
  (add-hook 'js-mode-hook (lambda ()
                     (tide-setup)
                     (unless (tide-current-server) (tide-restart-server))
                     (tide-hl-identifier-mode 1)))
    (dolist (hooked (list
                   #'company-mode
                   #'eldoc-mode
                   #'electric-pair-local-mode
                   #'paredit-mode
                   ))
    (add-hook 'js-mode-hook hooked)))

(use-package json-mode)

(use-package lsp-ivy)

(use-package lsp-java
  :init
  (add-hook 'java-mode-hook #'display-line-numbers-mode)
  (add-hook 'java-mode-hook #'electric-pair-local-mode)
  (add-hook 'java-mode-hook #'lsp)
  (add-hook 'java-mode-hook #'lsp-ui-mode))

;; (use-package lsp-java-boot
;;   :init (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode))

(use-package lsp-mode
  :commands (lsp-headerline-breadcrumb-mode)
  :init
  (setq ;; lsp-diagnostic-package :none
        ;; lsp-enable-file-watchers nil
        ;; lsp-idle-delay 0.500
        lsp-enable-completion-at-point t
        lsp-enable-folding nil
        lsp-enable-indentation nil
        lsp-enable-on-type-formatting nil
        lsp-enable-text-document-color nil
        lsp-enable-xref t
        lsp-file-watch-ignored '("[/\\\\]\\.git$" "[/\\\\]\\.hg$" "[/\\\\]\\.bzr$" "[/\\\\]_darcs$" "[/\\\\]\\.svn$" "[/\\\\]_FOSSIL_$" "[/\\\\]\\.idea$" "[/\\\\]\\.ensime_cache$" "[/\\\\]\\.eunit$" "[/\\\\]node_modules$" "[/\\\\]\\.fslckout$" "[/\\\\]\\.tox$" "[/\\\\]\\.stack-work$" "[/\\\\]\\.bloop$" "[/\\\\]\\.metals$" "[/\\\\]target$" "[/\\\\]\\.ccls-cache$" "[/\\\\]\\.deps$" "[/\\\\]build-aux$" "[/\\\\]autom4te.cache$" "[/\\\\]\\.reference$" "/usr/include.*" "[/\\\\]\\.ccls-cache$")
        lsp-file-watch-threshold 10000
        lsp-log-io t
        lsp-print-performance t
        lsp-semantic-highlighting nil
        read-process-output-max (* 1024 1024))
  (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  ;; TODO should only start after lsp starts
  ;; (add-hook 'lsp-mode-hook
  ;;           (lambda () (run-at-time 10 nil #'lsp-headerline-breadcrumb-mode)))
  ;; (add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode)
  :config
  ;; (diminish 'lsp-mode "语")
  (diminish 'lsp-lens-mode "透"))

(use-package lsp-python-ms)

(use-package magit
  :init
  (setq-default magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)
  (setq magit-process-finish-apply-ansi-colors t)
  :config
  (define-key magit-status-mode-map (kbd "C-<tab>") nil))

(use-package magit-delta
  :if (not (equal (shell-command "delta") 127))
  :after magit
  :init (add-hook 'magit-mode-hook #'magit-delta-mode)
  :config (diminish 'magit-delta-mode ""))

(use-package magit-todos)

(use-package markdown-mode
  :init
  (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (setq markdown-command "multimarkdown"))

(use-package newcomment)

(use-package olivetti)

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
        org-log-done 'time
	org-outline-path-complete-in-steps nil
	org-refile-target-verify-function 'bh/verify-refile-target
	org-refile-targets (quote ((nil :maxlevel . 9) (org-agenda-files :maxlevel . 9)))
	org-refile-use-outline-path t
        org-return-follows-link t
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
			       (lambda ()
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
  (add-hook 'org-mode-hook #'visual-line-mode)
  :config
  (require 'ob-js)
  (org-babel-do-load-languages 'org-babel-load-languages
			       '((awk . t)
                                 (emacs-lisp . t)
                                 (js . t)
                                 (shell . t)
                                 (typescript . t)))
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
      (ad-set-arg 1 fixed-contents)))
  (define-key org-mode-map (kbd "C-<tab>") nil))

(use-package org-agenda
  :init (setq org-agenda-restore-windows-after-quit t)
  :config (define-key org-agenda-keymap (kbd "R") #'org-agenda-refile))

(use-package org-alert
  :commands (org-alert-enable)
  :init
  (setq alert-default-style 'libnotify))

(use-package org-cliplink)

(use-package org-download
  :after org
  :demand t
  ;; :init
  ;; FIXME org-link-unescape 不能 decode link
  ;; https://emacs-china.org/t/org-download/2422/3?u=wenpin
  ;; (defun custom-org-download-method (link)
  ;;   (org-download--fullname (org-link-unescape link)))
  ;; (setq org-download-method 'custom-org-download-method) ; 注意：这里不能用lambda表达式
  ;; 顺便改下annotate，就是自动插入的那行注释，里面写的是图片来源路径
  ;; (setq org-download-annotate-function
  ;;       '(lambda (link)
  ;;          (org-download-annotate-default (org-link-unescape link))))
  )

(use-package org-journal
  :after org
  :init
  (setq org-journal-dir "~/org/journal"
        org-journal-file-format "%Y%m%d.org"
        org-journal-find-file #'find-file
        org-journal-file-type 'daily
        org-extend-today-until 2
        ;; org-journal-carryover-items nil
        org-journal-date-prefix "* "
        org-journal-date-format "%A, %x"
        org-journal-time-prefix "** "
        org-journal-time-format "%R "))

(use-package org-roam
  :init
  (setq org-roam-directory "~/org/roam"
        org-roam-completion-system 'ivy)
  ;; (add-hook 'org-roam-capture-after-find-file-hook #'winner-undo)
  :config
  (define-key org-roam-mode-map (kbd "M-SPC n l") #'org-roam)
  (define-key org-roam-mode-map (kbd "M-SPC n h") #'org-roam-jump-to-index)
  (define-key org-mode-map (kbd "M-SPC n i") #'org-roam-insert)
  (diminish 'org-roam-mode "记"))

(use-package org-roam-server
  :if window-system
  :config
  (require 'org-roam-protocol)
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 4242
        org-roam-server-authenticate nil
        org-roam-server-label-truncate t
        org-roam-server-label-truncate-length 60
        org-roam-server-label-wrap-length 20)
  (diminish 'org-roam-server-mode "图"))

(use-package ox-hugo :after ox)

(use-package paredit
  :after eldoc
  :commands (enable-paredit-mode)
  :init
  (dolist (hook (list
                 'eval-expression-minibuffer-setup-hook
                 'ielm-mode-hook
                 'lisp-mode-hook
                 'lisp-interaction-mode-hook
                 'scheme-mode-hook
                 ))
    (add-hook hook #'paredit-mode))
  :config
  ;; https://emacs-china.org/t/paredit-smartparens/6727/11
  (defun paredit/space-for-delimiter-p (endp delm)
    (or (member 'font-lock-keyword-face (text-properties-at (1- (point))))
        (not (derived-mode-p 'basic-mode
                             'c++-mode
                             'c-mode
                             'coffee-mode
                             'csharp-mode
                             'd-mode
                             'dart-mode
                             'go-mode
                             'java-mode
                             'js-mode
                             'lua-mode
                             'objc-mode
                             'pascal-mode
                             'python-mode
                             'r-mode
                             'ruby-mode
                             'rust-mode
                             'typescript-mode))))
  (add-to-list 'paredit-space-for-delimiter-predicates #'paredit/space-for-delimiter-p)
  (eldoc-add-command
   'paredit-backward-delete
   'paredit-close-round)
  (diminish 'paredit-mode "括"))

(use-package pocket-reader)

(use-package posframe)

(use-package projectile
  :init
  (setq projectile-completion-system 'ivy
        projectile-mode-line-prefix "项")
  (add-hook 'after-init-hook #'projectile-mode))

(use-package python
  :init
  (setq lsp-python-ms-auto-install-server nil
        lsp-python-ms-executable "~/g/Microsoft/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")
  (add-hook 'python-mode-hook #'highlight-indent-guides-mode)
  (add-hook 'python-mode-hook (lambda () (require 'lsp-python-ms) (lsp))))

(use-package ranger)

(use-package re-builder :init (setq reb-re-syntax 'string))

(use-package recentf
  :init
  (setq recentf-auto-cleanup 'never
        recentf-max-saved-items nil)
  ;; https://www.emacswiki.org/emacs/RecentFiles#toc21
  (defun recentd-track-opened-file ()
    "Insert the name of the directory just opened into the recent list."
    (and (derived-mode-p 'dired-mode) default-directory
         (recentf-add-file (substring default-directory 0 -1)))
    ;; Must return nil because it is run from `write-file-functions'.
    nil)
  (defun recentd-track-closed-file ()
    "Update the recent list when a dired buffer is killed.
That is, remove a non kept dired from the recent list."
    (and (derived-mode-p 'dired-mode) default-directory
         (recentf-remove-if-non-kept (substring default-directory 0 -1))))
  (add-hook 'dired-after-readin-hook 'recentd-track-opened-file)
  (add-hook 'kill-buffer-hook 'recentd-track-closed-file)
  (add-hook 'after-init-hook #'recentf-mode))

(use-package rime
  ;; mostly copy from https://github.com/cnsunyour/.doom.d/blob/develop/modules/cnsunyour/chinese/config.el
  :init
  (setq default-input-method "rime"
	rime-translate-keybindings '("C-f" "C-b" "C-n" "C-p" "C-g")  ;; 发往 librime 的快捷键
	rime-librime-root (if (eq system-type 'darwin) (expand-file-name "~/.emacs.d/rime/librime-mac/dist"))
	rime-user-data-dir "~/.emacs.d/rime"
	rime-show-candidate 'posframe
	rime-posframe-style 'simple)
  :config
  (define-key rime-mode-map (kbd "C-`") #'rime-send-keybinding)
  (define-key rime-mode-map (kbd "C-S-`") #'rime-send-keybinding)
  (unless (fboundp 'rime--posframe-display-content)
    (error "Function `rime--posframe-display-content' is not available.")))

(use-package rust-mode
  :init
  (add-hook 'rust-mode-hook #'lsp))

(use-package saveplace :init (add-hook 'after-init-hook #'save-place-mode))

(use-package selectric-mode
  :if (not (equal (shell-command "aplay") 127))
  :init (add-hook 'after-init-hook #'selectric-mode))

(use-package simple)

(use-package smex) ;; smex is needed to order candidates for ivy

(use-package snails
  :if window-system
  ;; both wenpin/snails snails need to be in commands, otherwise emacs can not recognize type of wenpin/snails
  :commands (wenpin/snails snails)
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
  (setq snails-use-exec-path-from-shell nil))

(use-package startup :init (setq auto-save-list-file-prefix nil))

(use-package subword :init (add-hook 'after-init-hook #'global-subword-mode))

(use-package sudo-edit)

(use-package swiper)

(use-package tab-bar
  :if (> emacs-major-version 26)
  :init
  (setq tab-bar-tab-name-function
        (defun wenpin/tab-bar-show-file-name ()
          (let* ((buffer (window-buffer (minibuffer-selected-window)))
                 (file-name (buffer-file-name buffer)))
            (if file-name file-name (format "%s" buffer)))))
  (add-hook 'after-init-hook #'tab-bar-mode))

(use-package tab-line :if (> emacs-major-version 26) :init (add-hook 'after-init-hook #'global-tab-line-mode))

(use-package thing-edit)

(use-package tide
  :after (company flycheck)
  :init
  (setq tide-completion-detailed t
        tide-always-show-documentation t
        ;; Fix #1792: by default, tide ignores payloads larger than 100kb. This
        ;; is too small for larger projects that produce long completion lists,
        ;; so we up it to 512kb.
        tide-server-max-response-length 524288)
  :config (diminish 'tide-mode "型"))

(use-package typescript-mode
  :init
  (setq typescript-indent-level 2)
  ;; (add-hook 'typescript-mode-hook #'lsp)
  ;; (add-hook 'typescript-mode-hook #'lsp-deferred)
  (dolist (hooked (list
                   #'tide-setup
                   #'tide-hl-identifier-mode
                   #'company-mode
                   #'eldoc-mode
                   #'electric-pair-local-mode
                   #'paredit-mode
                   ))
    (add-hook 'typescript-mode-hook hooked))
  ;; :config
  ;; (require 'company-lsp)
  ;; (push 'company-lsp company-backends)
  )

(use-package valign :commands (valign-mode valign-table))

(use-package vc-hooks :init (setq vc-follow-symlinks t))

(use-package vterm
  :init
  (setq vterm-keymap-exceptions '("C-c" "C-x" "C-g" "C-h" "C-l" "M-x" "M-o" "C-v" "M-v" "C-y" "M-y")
        vterm-kill-buffer-on-exit t
        vterm-term-environment-variable "eterm-color")
  ;; (add-hook 'vterm-mode-hook
  ;;           (lambda ()
  ;;             (set (make-local-variable 'buffer-face-mode-face) 'fixed-pitch-serif)
  ;;             (buffer-face-mode t)))
  )

(use-package winner :init (add-hook 'after-init-hook #'winner-mode))

(use-package woman)

(use-package yaml-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\.'" . yaml-mode))
  (add-hook 'yaml-mode-hook #'highlight-indent-guides-mode))

(use-package yasnippet
  :init (add-hook 'java-mode-hook #'yas-minor-mode)
  :config (diminish 'yas-minor-mode "模"))

;; (use-package battery)

(use-package eaf
  :if (eq system-type 'gnu/linux)
  :config
  (define-key eaf-mode-map* (kbd "M-t") #'toggle-input-method)
  (eaf-bind-key toggle-input-method "M-t" eaf-browser-keybinding))

;; (use-package hl-todo :init (add-hook 'after-init-hook #'global-hl-todo-mode))

;; (use-package so-long :if (> emacs-major-version 26) :init (add-hook 'after-init-hook #'global-so-long-mode))

;; (use-package term-cursor
;;   :init
;;   (setq term-cursor-triggers '(blink-cursor-mode-hook
;;                                post-command-hook
;;                                lsp-ui-doc-frame-hook))
;;   (add-hook 'after-init-hook #'global-term-cursor-mode))

(use-package dired-x
  :init
  (setq dired-guess-shell-alist-user '(("\\.doc\\'" "libreoffice")
                                       ("\\.docx\\'" "libreoffice")
                                       ("\\.ppt\\'" "libreoffice")
                                       ("\\.pptx\\'" "libreoffice")
                                       ("\\.xls\\'" "libreoffice")
                                       ("\\.xlsx\\'" "libreoffice")))
  (add-hook 'dired-mode-hook (lambda () (require 'dired-x))))

(use-package pdf-tools)

(use-package calendar :init (setq calendar-chinese-all-holidays-flag t))

(use-package lsp-ui
  :init
  (setq lsp-ui-sideline-enable nil
        lsp-ui-doc-enable nil)
  :config
  (set-face-attribute 'lsp-ui-doc-background nil :background "white smoke"))

(use-package devdocs)

(use-package browse-url
  :init
  (when (eq system-type 'gnu/linux) (setq browse-url-browser-function 'eaf-open-browser)))

(use-package zeal-at-point)

(use-package view :config (diminish 'view-mode "览"))

(use-package abbrev :config (diminish 'abbrev-mode "缩"))

(use-package default-view :demand t)

(use-package pkgbuild-mode)

(use-package keyfreq
  :init
  (setq keyfreq-excluded-commands '(self-insert-command))
  (add-hook 'after-init-hook #'keyfreq-mode)
  (add-hook 'after-init-hook #'keyfreq-autosave-mode))

(provide 'init-config)
;;; init-config ends here
