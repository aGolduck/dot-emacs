(require 'w-core)

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
