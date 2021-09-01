(require 'w-core)

(straight-use-package 'keyfreq)
(setq keyfreq-file (w/locate-emacs-var-file "keyfreq")
      keyfreq-excluded-commands 'nil)
;; (setq keyfreq-excluded-commands '(
;;                                   self-insert-command
;;                                   next-line
;;                                   previous-line
;;                                   org-self-insert-command
;;                                   dired-previous-line
;;                                   dired-next-line
;;                                   mwheel-scroll
;;                                   mouse-set-point
;;                                   mouse-drag-region
;;                                   org-agenda-next-line
;;                                   backward-word
;;                                   vterm--self-insert
;;                                   magit-section-forward
;;                                   paredit-backward
;;                                   paredit-forward
;;                                   magit-section-backward
;;                                   org-agenda-previous-line
;;                                   forward-word
;;                                   backward-char
;;                                   dired-find-file
;;                                   ace-window
;;                                   ivy-done
;;                                   eaf-send-key
;;                                   rime--backspace
;;                                   scroll-up-command
;;                                   ignore
;;                                   eaf-proxy-scroll_up_page
;;                                   ivy-backward-delete-char
;;                                   magit-next-line
;;                                   isearch-repeat-forward
;;                                   delete-backward-char
;;                                   org-delete-backward-char
;;                                   eaf-proxy-scroll_down_page
;;                                   beginning-of-buffer
;;                                   ivy-next-line
;;                                   move-end-of-line
;;                                   newline
;;                                   forward-sexp
;;                                   dap-tooltip-mouse-motion
;;                                   scroll-down-command
;;                                   isearch-printing-char
;;                                   magit-section-toggle
;;                                   paredit-backward-delete
;;                                   end-of-buffer
;;                                   company-complete-selection
;;                                   forward-char
;;                                   dired-up-directory
;;                                   counsel-recentf
;;                                   minibuffer-keyboard-quit
;;                                   set-mark-command
;;                                   dired-jump
;;                                   magit-previous-line))
(add-hook 'after-init-hook #'keyfreq-mode)
(add-hook 'after-init-hook #'keyfreq-autosave-mode)

(require 'w-gui)

(straight-use-package 'vlf)

;;; vlf
(add-hook 'after-init-hook (lambda () (require 'vlf-setup)))

(straight-use-package 'dotenv-mode)
(straight-use-package 'direnv)
(straight-use-package 'ranger)


;;; global hooks
(when (executable-find "direnv")
  (add-hook 'after-init-hook #'direnv-mode))


;;; extra third-party set up
;;; ranger
(setq ranger-map-style 'emacs)
(setq ranger-key (kbd "M-R"))
(global-set-key (kbd "M-r") #'ranger)
(with-eval-after-load 'ranger
  (define-key ranger-emacs-mode-map (kbd "n") #'ranger-next-file)
  (define-key ranger-emacs-mode-map (kbd "p") #'ranger-prev-file)
  (define-key ranger-emacs-mode-map (kbd "b") #'ranger-up-directory)
  (define-key ranger-emacs-mode-map (kbd "f") #'ranger-find-file)
  (define-key ranger-emacs-mode-map (kbd "C-n") #'ranger-next-file)
  (define-key ranger-emacs-mode-map (kbd "C-p") #'ranger-prev-file))

(straight-use-package 'git-link)
;;; git link
(global-set-key (kbd "M-SPC g L") #'git-link)

(require 'w-term-full)
(require 'w-system)
(straight-use-package '(thing-edit :host github :repo "manateelazycat/thing-edit"))
(require 'w-flyspell)
;; (require 'w-rime)

;;; programming
(require 'w-prog)
(require 'w-jump)
(require 'w-lsp)
(require 'w-eglot)

(require 'w-c)
(require 'w-java)
(require 'w-jvm-languages)
(require 'w-haskell)
(require 'w-web)
(require 'w-other-languages)
(require 'w-mmm)



;;; org-mode
(require 'w-org)

;;; anything else
(require 'w-z)

(provide 'w-full)
