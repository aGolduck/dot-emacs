(straight-use-package '(org :type built-in)) ;; in case org-mode will be installed by other org third party packages
(straight-use-package 'ob-typescript)
(straight-use-package 'ob-http)

(setq org-directory "~/org"
      org-confirm-babel-evaluate nil
      org-export-with-sub-superscripts nil
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

(with-eval-after-load 'org
  ;;; org babel
  (setq org-plantuml-jar-path (expand-file-name (locate-user-emacs-file "resources/plantuml.jar")))
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
                                 (groovy . t)
                                 (haskell . t)
                                 (http . t)
                                 (js . t)
                                 (plantuml . t)
                                 (shell . t)
                                 (sql . t)
                                 (typescript . t)))
  ;; set faces
  (set-face-attribute 'org-headline-done nil :strike-through t)
  (set-face-attribute 'org-agenda-done nil :strike-through t))

(provide 'w-org-core)
