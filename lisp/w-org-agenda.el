;;; -*- lexical-binding: t; -*-
;; org-clock-watch 需要用 dbus, 而且似乎会导致整个 emacs 卡住。
;; (straight-use-package '(org-clock-watch :host github :repo "wztdream/org-clock-watch" :files ("*")
;;                                         :fork (:host github :repo "aGolduck/org-clock-watch")))

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

;; (add-hook 'after-init-hook (lambda () (org-clock-watch-toggle 'on)))

(provide 'w-org-agenda)
