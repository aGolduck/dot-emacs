(straight-use-package 'projectile)
(straight-use-package 'xref)

;;; new comment
(global-set-key [remap comment-dwim] #'comment-line)
;;; xref
(setq xref-show-definitions-function #'xref-show-definitions-completing-read)

(with-eval-after-load 'eldoc (diminish 'eldoc-mode "档"))

;;; projectile
(defun w/projectile-shortened-mode-line ()
  "Report project name shortened and type in the modeline."
  (let* ((project-name (projectile-project-name))
         (project-type (projectile-project-type))
         (shortened-project-name (if (< (length project-name) 10)
                                     project-name
                                   (concat (substring project-name 0 7) "..." (substring project-name -3 nil)))))
    (format "%s[%s]"
            projectile-mode-line-prefix
            (or shortened-project-name "-")
            ;; (if project-type
            ;;     (format ":%s" project-type)
            ;;   "")
            )))
(setq ;; projectile-completion-system 'ivy
 projectile-cache-file (w/locate-emacs-var-file "projectile.cache")
 projectile-known-projects-file (w/locate-emacs-var-file "projectile-bookmarks.eld")
 projectile-mode-line-function 'w/projectile-shortened-mode-line
 projectile-mode-line-prefix "项"
 projectile-project-search-path '("~/g" "~/r" "~/b"))
(when (executable-find "rg")
  (setq-default projectile-generic-command "rg --files --hidden"))
(add-hook 'after-init-hook #'projectile-mode)
(global-set-key (kbd "M-SPC p f") #'projectile-find-file)
(global-set-key (kbd "M-SPC p t") #'projectile-run-vterm)

(provide 'w-prog-core)