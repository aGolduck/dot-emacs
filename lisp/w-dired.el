;;;  -*- lexical-binding: t; -*-
(setq dired-listing-switches "-Afhlv"
      dired-auto-revert-buffer t
      dired-dwim-target t
      dired-recursive-copies 'always
      dired-recursive-deletes 'top)

;; dired-x
(setq dired-guess-shell-alist-user '(("\\.doc\\'" "libreoffice")
                                     ("\\.docx\\'" "libreoffice")
                                     ("\\.ppt\\'" "libreoffice")
                                     ("\\.pptx\\'" "libreoffice")
                                     ("\\.xls\\'" "libreoffice")
                                     ("\\.xlsx\\'" "libreoffice")))
(autoload 'dired-jump "dired-x")
(global-set-key (kbd "M-SPC ^") #'dired-jump)

(straight-use-package 'dired-rsync)
(straight-use-package 'dired-quick-sort)
(with-eval-after-load 'dired
  ;; do not open extra dired buffer
  (put 'dired-find-alternate-file 'disabled nil)
  (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)
  (define-key dired-mode-map
    (kbd "^") (lambda () (interactive) (find-alternate-file "..")))

  (require 'dired-x)

  ;; image-dired
  (setq image-dired-dir (w/locate-emacs-var-file "image-dired"))

  (autoload 'hydra-dired-quick-sort/body "dired-quick-sort")
  (define-key dired-mode-map (kbd "s") #'hydra-dired-quick-sort/body)
  (add-hook 'dired-mode-hook #'dired-quick-sort)
  ;; (use-package dired-quick-sort
  ;;   :straight t
  ;;   :commands (hydra-dired-quick-sort/body)
  ;;   :init
  ;;   (define-key dired-mode-map (kbd "s") #'hydra-dired-quick-sort/body)
  ;;   (add-hook 'dired-mode-hook #'dired-quick-sort))
  )

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


(provide 'w-dired)
