;;; -*- lexical-binding: t; -*-
;; org-clock-watch 需要用 dbus, 而且似乎会导致整个 emacs 卡住。
;; (straight-use-package '(org-clock-watch :host github :repo "wztdream/org-clock-watch" :files ("*")
;;                                         :fork (:host github :repo "aGolduck/org-clock-watch")))

(require 'bh-org)

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

(setq org-agenda-columns-add-appointments-to-effort-sum t
      ;; agenda-files 用于初始化，用过 org-agenda-file-to-front 会保存到 custom.el 覆盖该值
      org-agenda-files '("~/org/orgzly")
      org-agenda-log-mode-items '(closed)
      org-agenda-log-mode-items (quote (closed state))
      org-agenda-restore-windows-after-quit t
      org-agenda-show-future-repeats 'next
      org-agenda-span 'month
      org-agenda-tags-todo-honor-ignore-options t
      org-columns-default-format "%60ITEM(Task) %TODO %6Effort(Estim){:}  %6CLOCKSUM(Clock) %TAGS")
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
					      (org-agenda-show-future-repeats nil)))
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
	       nil))))
(global-set-key (kbd "C-c a") #'org-agenda)
(with-eval-after-load 'org-agenda
  (define-key org-agenda-keymap (kbd "R") #'org-agenda-refile))

(setq org-global-properties '(("Effort_ALL" . "0 0:05 0:10 0:20 0:30 1:00 2:00 3:00 4:00 5:00 6:00 7:00")))

(defun w/org-agenda-add-extra-files ()
  (interactive)
  (with-current-buffer
      (find-file-noselect "~/org/roam/agenda/reading.org")
    (org-agenda-file-to-front)))

(defun w/org-agenda-remove-extra-files ()
  (interactive)
  (org-remove-file "~/org/roam/agenda/reading.org"))

;; (add-hook 'after-init-hook (lambda () (org-clock-watch-toggle 'on)))

;;; org capture
(setq org-capture-templates
      '(
	("t" "TODO" entry (file+headline org-default-notes-file "INBOX")
	 "* TODO %?\n:PROPERTIES:\n:CREATED:  %U\n:END:\n%i\n%a")
	("N" "Today NEXT" entry (file+headline org-default-notes-file "INBOX")
	 "* NEXT %?\nSCHEDULED:  %T\n:PROPERTIES:\n:CREATED:  %U\n:END:\n%i\n%a")
	("n" "NOTE" entry (file+headline "~/org/roam/notes.org" "NOTES")
	 "* %?\n:PROPERTIES:\n:ID:  %(org-id-uuid)\n:CREATED:  %U\n:CONTEXT:  %a\n:END:\n%i\n")
	("j" "JOURNAL" entry (file+headline "~/org/roam/journal.org" "journal")
	 "* %U\n:PROPERTIES:\n:CREATED:  %U\n:CONTEXT:  %a\n:END:\n%i\n%?" :create-id t)
	;; ("j" "js source code" entry (file+headline org-default-notes-file "NOTES")
	;;  "* %?\n:PROPERTIES:\n:CREATED:  %U\n:CONTEXT:  %a\n:END:\n#+begin_src js\n%i  #+end_src\n")
	("s" "source code" entry (file+headline org-default-notes-file "NOTES")
	 "* %?\n:PROPERTIES:\n:CREATED:  %U\n:CONTEXT:  %a\n:END:\n#+begin_src %^{source language}\n%i%?  #+end_src\n")
	("g" "template group")
	("ga" "Template Group A holder" entry (file+headline org-default-notes-file "NOTES")
	 "* %?\n:PROPERTIES:\n:CREATED:  %U\n:CONTEXT:  %a\n:END:\n#+begin_src %^{source language}\n%i%?  #+end_src\n")))
(global-set-key (kbd "C-c c") #'org-capture)
(defun 可达鸭/org-capture-添加ID ()
  (when (org-capture-get :create-id)
    (message "captured")
    (org-id-get-create)))
(add-hook 'org-capture-prepare-finalize-hook #'可达鸭/org-capture-添加ID)

;;; org-pomodoro
;; (global-set-key (kbd "M-c") #'org-pomodoro)


(provide 'w-org-agenda)
