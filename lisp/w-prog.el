;;; -*- lexical-binding: t; -*-
(straight-use-package 'devdocs)
(straight-use-package 'devdocs-browser)
(straight-use-package 'flycheck)
(straight-use-package 'flycheck-posframe)
(straight-use-package 'highlight-indent-guides)
(straight-use-package 'projectile)
(straight-use-package 'quickrun)
(straight-use-package 'smartparens)
(straight-use-package 'xref)
(straight-use-package 'yasnippet)
(straight-use-package 'yasnippet-snippets)
(straight-use-package 'zeal-at-point)
;; git ssh address example, don't remove this comment
;; (straight-use-package '(yasnippet-snippets :host github :repo "AndreaCrotti/yasnippet-snippets" :fork (:host nil :repo "git@github.com:wpchou/yasnippet-snippets.git")))

;;; new comment
(global-set-key [remap comment-dwim] #'comment-line)
;;; xref
(setq xref-show-definitions-function #'xref-show-definitions-completing-read)
;;; paren
(setq show-paren-when-point-in-periphery t
      show-paren-when-point-inside-paren t)
;;; yasnippet
(with-eval-after-load 'yasnippet
  (diminish 'yas-minor-mode "模")
  (define-key yas-minor-mode-map (kbd "TAB") nil))
;;; flycheck
(with-eval-after-load 'flycheck
  (diminish 'flycheck-mode "检"))
(add-hook 'flycheck-mode-hook #'flycheck-posframe-mode)
;; It is reported that highlight-indent-guides takes too much cpu time
;; https://emacs-china.org/t/highlight-indent-guides/16532/4
(setq highlight-indent-guides-method 'character
      ;; highlight-indent-guides-character ?┃
      ;; highlight-indent-guides-character ?│
      ;; highlight-indent-guides-character ?║
      highlight-indent-guides-auto-odd-face-perc 15
      highlight-indent-guides-auto-even-face-perc 55
      highlight-indent-guides-auto-character-face-perc 61.8)

(with-eval-after-load 'smartparens
  (require 'smartparens-config)
  (define-key smartparens-mode-map (kbd "C-(") #'sp-wrap-round))

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

;;; documentations
(setq devdocs-browser-cache-directory (w/locate-emacs-var-file "devdocs-browser"))

(provide 'w-prog)
