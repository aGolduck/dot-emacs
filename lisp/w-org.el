;;; -*- lexical-binding: t; -*-
(straight-use-package 'ob-typescript)
(straight-use-package 'ob-http)

(setq org-directory "~/org"
      org-confirm-babel-evaluate nil
      org-export-with-sub-superscripts nil
      org-export-with-toc nil
      org-use-sub-superscripts nil)

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
                                 (C . t)
                                 (clojure . t)
                                 (emacs-lisp . t)
                                 (groovy . t)
                                 (haskell . t)
                                 (http . t)
                                 (js . t)
                                 (plantuml . t)
                                 (shell . t)
                                 (sql . t)
                                 (typescript . t)
                                 (python . t)
                                 ))
  ;; set faces
  (set-face-attribute 'org-headline-done nil :strike-through t)
  (set-face-attribute 'org-agenda-done nil :strike-through t))

(straight-use-package 'ox-gfm)


(setq org-adapt-indentation nil
      org-archive-location "%s_archive::* Archived Tasks"
      org-archive-mark-done nil
      org-default-notes-file (concat org-directory "/orgzly/Inbox.org")
      org-html-inline-images t
      org-id-locations-file (w/locate-emacs-var-file ".org-id-locations")
      org-log-done 'time
      org-outline-path-complete-in-steps nil
      org-preview-latex-default-process 'dvisvgm
      ;; org-refile-target-verify-function 'bh/verify-refile-target
      org-refile-targets '((nil :maxlevel . 9) (org-agenda-files :maxlevel . 9)
                           (("~/org/roam/notes.org"
                             "~/org/roam/work.org"
                             "~/org/roam/emacs.org"
                             "~/org/roam/unix.org")
                            :maxlevel . 3))
      org-refile-use-outline-path t
      org-return-follows-link t
      org-stuck-projects (quote ("" nil nil "")))

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


;;; zotxt
;; (setq org-zotxt-link-description-style :citation)
;; (setq zotxt-default-bibliography-style "mkbehr-short")
;; (add-hook 'org-mode-hook #'org-zotxt-mode)
;; (with-eval-after-load 'org
;;   (org-link-set-parameters "zotero" :follow
;;                            (lambda (zpath)
;;                              (browse-url
;;                               ;; we get the "zotero:"-less url, so we put it back.
;;                               (format "zotero:%s" zpath)))))

;;; lazy load
;; (with-eval-after-load 'org
;;   (require 'org-download)

;;   (defadvice org-html-paragraph (before org-html-paragraph-advice
;; 					(paragraph contents info) activate)
;;     "Join consecutive Chinese lines into a single long line without
;; unwanted space when exporting org-mode to html."
;;     (let* ((origin-contents (ad-get-arg 1))
;;            (fix-regexp "[[:multibyte:]]")
;;            (fixed-contents
;;             (replace-regexp-in-string
;;              (concat
;;               "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)") "\\1\\2" origin-contents)))
;;       (ad-set-arg 1 fixed-contents)))
;;   (define-key org-mode-map (kbd "C-<tab>") nil))

(provide 'w-org)
