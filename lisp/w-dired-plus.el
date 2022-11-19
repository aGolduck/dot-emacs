(straight-use-package 'vlf)
(straight-use-package 'dotenv-mode)
(straight-use-package 'direnv)
(straight-use-package 'ranger)

;;; vlf
(add-hook 'after-init-hook (lambda () (require 'vlf-setup)))

;;; direnv
(when (executable-find "direnv")
  (add-hook 'after-init-hook #'direnv-mode))

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

(provide 'w-dired-plus)
