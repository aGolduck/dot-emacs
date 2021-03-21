;;; -*- lexical-binding: t; -*-

;;; new comment
(global-set-key [remap comment-dwim] #'comment-line)
;;; paren
(setq show-paren-when-point-in-periphery t
      show-paren-when-point-inside-paren t)
;;; yasnippet
(straight-use-package 'yasnippet)
(straight-use-package '(yasnippet-snippets :host github :repo "AndreaCrotti/yasnippet-snippets" :fork (:host nil :repo "git@github.com:wpchou/yasnippet-snippets.git")))
(with-eval-after-load 'yasnippet
  (diminish 'yas-minor-mode "模")
  (define-key yas-minor-mode-map (kbd "TAB") nil))
;;; flycheck
(straight-use-package 'flycheck)
(with-eval-after-load 'flycheck
  (diminish 'flycheck-mode "检"))
(straight-use-package 'flycheck-posframe)
(add-hook 'flycheck-mode-hook #'flycheck-posframe-mode)
(straight-use-package 'highlight-indent-guides)
;; It is reported that highlight-indent-guides takes too much cpu time
;; https://emacs-china.org/t/highlight-indent-guides/16532/4
(setq highlight-indent-guides-method 'character
      ;; highlight-indent-guides-character ?┃
      ;; highlight-indent-guides-character ?│
      ;; highlight-indent-guides-character ?║
      highlight-indent-guides-auto-odd-face-perc 15
      highlight-indent-guides-auto-even-face-perc 55
      highlight-indent-guides-auto-character-face-perc 61.8)

(straight-use-package 'quickrun)

(straight-use-package 'dumb-jump)
;; (setq dumb-jump-force-searcher 'rg) ;; rg is not working for at least elisp files
(global-set-key (kbd "M-SPC M-.") #'dumb-jump-go)
;; (global-set-key (kbd "M-SPC M-,") #'dumb-jump-back) ;; not neccesary, use M-,

(straight-use-package 'smartparens)
(with-eval-after-load 'smartparens (require 'smartparens-config))

(with-eval-after-load 'eldoc (diminish 'eldoc-mode "档"))
(straight-use-package 'devdocs)
(straight-use-package 'zeal-at-point)

(straight-use-package 'projectile)
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

;; (use-package paredit
;;   :commands (enable-paredit-mode)
;;   :init
;;   (dolist (hook (list
;;                  'eval-expression-minibuffer-setup-hook
;;                  'ielm-mode-hook
;;                  'lisp-mode-hook
;;                  'lisp-interaction-mode-hook
;;                  'scheme-mode-hook
;;                  ))
;;     (add-hook hook #'paredit-mode))
;;   :config
;;   ;; https://emacs-china.org/t/paredit-smartparens/6727/11
;;   (defun paredit/space-for-delimiter-p (endp delm)
;;     (or (member 'font-lock-keyword-face (text-properties-at (1- (point))))
;;         (not (derived-mode-p 'basic-mode
;;                              'c++-mode
;;                              'c-mode
;;                              'coffee-mode
;;                              'csharp-mode
;;                              'd-mode
;;                              'dart-mode
;;                              'go-mode
;;                              'java-mode
;;                              'js-mode
;;                              'lua-mode
;;                              'objc-mode
;;                              'pascal-mode
;;                              'python-mode
;;                              'r-mode
;;                              'ruby-mode
;;                              'rust-mode
;;                              'typescript-mode))))
;;   (add-to-list 'paredit-space-for-delimiter-predicates #'paredit/space-for-delimiter-p)
;;   (eldoc-add-command
;;    'paredit-backward-delete
;;    'paredit-close-round)
;;   (define-key paredit-mode-map (kbd ";") nil) ;; conflict with lispy-comment
;;   (define-key paredit-mode-map (kbd "M-r") nil)
;;   (diminish 'paredit-mode "括"))

(provide 'w-prog)
