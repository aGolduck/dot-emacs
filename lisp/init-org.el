(use-package org
  :init
  (require 'bh-org)
  (setq org-directory "~/org"
	org-archive-location "%s_archive::* Archived Tasks"
	org-archive-mark-done nil
	org-confirm-babel-evaluate nil
	org-default-notes-file (concat org-directory "/orgzly/Inbox.org")
	org-export-with-sub-superscripts nil
	org-html-inline-images t
        org-log-done 'time
	org-outline-path-complete-in-steps nil
        org-preview-latex-default-process 'dvisvgm
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
  (add-hook 'org-mode-hook #'visual-line-mode)
  ;; (add-hook 'org-mode-hook #'valign-mode)
  (use-package ol
    :init
    (defun w/org-link-search-elisp (addressing-string)
      (when (eq major-mode 'emacs-lisp-mode)
        (goto-char (point-min))
        (and (search-forward addressing-string nil t)
             (goto-char (match-beginning 0)))))
    (setq org-link-frame-setup '((file . find-file)))
    (add-hook 'org-execute-file-search-functions #'w/org-link-search-elisp)
    (global-set-key (kbd "M-SPC l s") #'org-store-link))
  (use-package org-agenda
    :init
    (setq org-agenda-restore-windows-after-quit t
  	  org-agenda-files '("~/org/orgzly")
	  org-agenda-log-mode-items '(closed)
	  org-agenda-log-mode-items (quote (closed state))
	  org-agenda-show-future-repeats 'next
	  org-agenda-span 'month
	  org-agenda-tags-todo-honor-ignore-options t)
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
    (global-set-key (kbd "C-c a") #'org-agenda)
    :config
    (define-key org-agenda-keymap (kbd "R") #'org-agenda-refile))
  (use-package org-capture
    :init
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
    (global-set-key (kbd "C-c c") #'org-capture))
  (use-package org-id :init (setq org-id-locations-file (w/locate-emacs-var-file ".org-id-locations")))
  (use-package org-colview :config (define-key org-columns-map (kbd "SPC") #'org-columns-open-link))
  (use-package ob-clojure)
  (use-package ob-groovy)
  (use-package org-cliplink)
  (use-package org-journal
    :init
    (setq org-journal-dir "~/org/journal"
          org-journal-cache-file (w/locate-emacs-var-file "org-journal.cache")
          org-journal-file-format "%Y%m%d.org"
          org-journal-find-file #'find-file
          org-journal-file-type 'daily
          org-extend-today-until 2
          ;; org-journal-carryover-items nil
          org-journal-date-prefix "* "
          org-journal-date-format "%A, %x"
          org-journal-time-prefix "** "
          org-journal-time-format "%R "))
  (use-package org-pomodoro :init (global-set-key (kbd "M-c") #'org-pomodoro))
  (use-package org-ql)
  (use-package org-roam
    :commands (org-roam-dailies-today org-roam-dailies-capture-today)
    :init
    (setq org-roam-directory (file-truename "~/org/roam")
          org-roam-db-location (w/locate-emacs-var-file "org-roam.db")
          ;; org-roam-completion-system 'ivy
          )
    ;; (add-hook 'org-roam-capture-after-find-file-hook #'winner-undo)
    (global-set-key (kbd "M-SPC n d") #'org-roam-dailies-capture-today)
    (global-set-key (kbd "M-SPC n D") #'org-roam-dailies-today)
    (global-set-key (kbd "M-SPC n n") #'org-roam-find-file)
    (global-set-key (kbd "M-SPC n N") #'org-roam-find-file-immediate)
    :config
    (define-key org-roam-mode-map (kbd "M-SPC n l") #'org-roam)
    (define-key org-roam-mode-map (kbd "M-SPC n h") #'org-roam-jump-to-index)
    (global-set-key (kbd "M-SPC n i") #'org-roam-insert)
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
  (use-package ox-hugo))

(straight-use-package 'org-download)
 (straight-use-package 'ob-http)

(with-eval-after-load 'org
  (require 'org-download)
  ;; fix error of org-babel-js evaluation
  (setq org-babel-js-function-wrapper
        "console.log(require('util').inspect(function(){\n%s\n}(), { depth: 100 }))")
  ;; TODO ob-jshell
  ;; reference: https://stackoverflow.com/questions/10405461/org-babel-new-language
  (defun org-babel-execute:jsh (body params)
    "Execute a block of jshell code snippets or commands with org-babel"
    (message "Executing jshell snippets")
    (org-babel-eval "jshell --feedback concise" (concat body "\n/exit")))
  (add-to-list 'org-src-lang-modes '("jsh" . "java"))
  (org-babel-do-load-languages 'org-babel-load-languages
			       '((awk . t)
                                 (clojure . t)
                                 (emacs-lisp . t)
                                 (http . t)
                                 (groovy . t)
                                 (haskell . t)
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

;; (use-package org-alert
;;   :commands (org-alert-enable)
;;   :init
;;   (setq alert-default-style 'libnotify))

(provide 'init-org)
