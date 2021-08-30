;;; -*- lexical-binding: t; -*-
;;; org-mode common
(straight-use-package '(org :type built-in)) ;; in case org-mode will be installed by other org third party packages
(straight-use-package 'org-roam)
;; (straight-use-package 'org-roam-server)
(straight-use-package 'zotxt)
(straight-use-package 'org-journal)
(straight-use-package 'org-pomodoro)
(straight-use-package 'org-ql)
(straight-use-package 'org-cliplink)
(straight-use-package 'org-download)
(straight-use-package 'ox-gfm)
(straight-use-package 'ox-hugo)
(straight-use-package 'ob-typescript)
(straight-use-package 'ob-http)
(straight-use-package 'org-projectile)

(require 'bh-org)
(setq org-directory "~/org"
      org-archive-location "%s_archive::* Archived Tasks"
      org-archive-mark-done nil
      org-confirm-babel-evaluate nil
      org-default-notes-file (concat org-directory "/orgzly/Inbox.org")
      org-export-with-sub-superscripts nil
      org-html-inline-images t
      org-id-locations-file (w/locate-emacs-var-file ".org-id-locations")
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
;; (add-hook 'org-mode-hook #'valign-mode)  ;; valign-mode is buggy

;;; org agenda
(require 'w-org-agenda)

;;; org capture
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
(global-set-key (kbd "C-c c") #'org-capture)

;;; org-colview
(with-eval-after-load 'org-colview
  (define-key org-columns-map (kbd "SPC") #'org-columns-open-link))

;;; org link
(defun w/org-link-search-elisp (addressing-string)
  (when (eq major-mode 'emacs-lisp-mode)
    (goto-char (point-min))
    (and (search-forward addressing-string nil t)
         (goto-char (match-beginning 0)))))
(setq org-link-frame-setup '((file . find-file)))
(add-hook 'org-execute-file-search-functions #'w/org-link-search-elisp)
(global-set-key (kbd "M-SPC l s") #'org-store-link)

;;; org roam
(setq org-roam-v2-ack t
      org-roam-directory (file-truename "~/org/roam")
      org-roam-dailies-directory (file-truename "~/org/roam/daily")
      org-roam-db-location (w/locate-emacs-var-file "org-roam.db"))
(global-set-key (kbd "M-SPC n d") #'org-roam-dailies-capture-today)
(global-set-key (kbd "M-SPC n D") #'org-roam-dailies-today)
(global-set-key (kbd "M-SPC n c") #'org-roam-capture)
(global-set-key (kbd "M-SPC n i") #'org-roam-node-insert)
(global-set-key (kbd "M-SPC n n") #'org-roam-node-find)
(with-eval-after-load 'org-roam
  (org-roam-setup)
  (global-set-key (kbd "M-SPC n l") #'org-roam-buffer-toggle)
  (diminish 'org-roam-mode "记"))
;; (when window-system
;;   (with-eval-after-load 'org-roam-server
;;     (setq org-roam-server-host "127.0.0.1"
;;           org-roam-server-port 4242
;;           org-roam-server-authenticate nil
;;           org-roam-server-label-truncate t
;;           org-roam-server-label-truncate-length 60
;;           org-roam-server-label-wrap-length 20)
;;     (diminish 'org-roam-server-mode "图")))
;;; zotxt
;; (setq org-zotxt-link-description-style :citation)
(setq zotxt-default-bibliography-style "mkbehr-short")
(add-hook 'org-mode-hook #'org-zotxt-mode)
(with-eval-after-load 'org
  (org-link-set-parameters "zotero" :follow
                           (lambda (zpath)
                             (browse-url
                              ;; we get the "zotero:"-less url, so we put it back.
                              (format "zotero:%s" zpath)))))

;;; org third-party packages
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
      org-journal-time-format "%R ")
(global-set-key (kbd "M-c") #'org-pomodoro)

;;; lazy load
(with-eval-after-load 'org
  (require 'org-download)
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
  (define-key org-mode-map (kbd "C-<tab>") nil)

  ;; set faces
  (set-face-attribute 'org-headline-done nil :strike-through t)
  (set-face-attribute 'org-agenda-done nil :strike-through t))

(provide 'w-org)
