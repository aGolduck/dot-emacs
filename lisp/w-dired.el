;;;  -*- lexical-binding: t; -*-
;;; set up a template for complex configuration modules

;;; 1. load third-party packages
(straight-use-package 'dired-rsync)
(straight-use-package 'dired-quick-sort)
(straight-use-package 'dotenv-mode)
(straight-use-package 'direnv)
(straight-use-package 'ranger)

;;; 2. autoload
(autoload 'dired-jump "dired-x")
(autoload 'hydra-dired-quick-sort/body "dired-quick-sort")

;;; 3. customize variables
(setq dired-listing-switches "-Afhlv"
      dired-auto-revert-buffer t
      dired-dwim-target t
      dired-recursive-copies 'always
      dired-recursive-deletes 'top
      dired-guess-shell-alist-user '(("\\.doc\\'" "libreoffice")
                                     ("\\.docx\\'" "libreoffice")
                                     ("\\.ppt\\'" "libreoffice")
                                     ("\\.pptx\\'" "libreoffice")
                                     ("\\.xls\\'" "libreoffice")
                                     ("\\.xlsx\\'" "libreoffice"))
      image-dired-dir (w/locate-emacs-var-file "image-dired"))

;;; 4. lazy setup
(with-eval-after-load 'dired
  ;; TODO 4.5 set faces
  ;; 4.1 require packages
  (require 'dired-x)
  ;; 4.2 local mode map hook
  (add-hook 'dired-mode-hook #'dired-quick-sort)
  ;; 4.3 lazy set up
  ;; do not open extra dired buffer
  (put 'dired-find-alternate-file 'disabled nil)
  ;; 4.4 local mode map keybindings set up
  (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)
  (define-key dired-mode-map
    (kbd "^") (lambda () (interactive) (find-alternate-file "..")))
  (define-key dired-mode-map (kbd "s") #'hydra-dired-quick-sort/body))

;;; 5. global hooks
(when (executable-find "direnv")
  (add-hook 'after-init-hook #'direnv-mode))

;;; 6. global key bindings
(global-set-key (kbd "M-SPC ^") #'dired-jump)

;;; 7. extra third-party set up
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

;;; 8. provide feature
(provide 'w-dired)
