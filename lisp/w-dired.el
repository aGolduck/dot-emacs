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

(with-eval-after-load 'dired
  ;; do not open extra dired buffer
  (put 'dired-find-alternate-file 'disabled nil)
  (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)
  (define-key dired-mode-map
    (kbd "^") (lambda () (interactive) (find-alternate-file "..")))

  (require 'dired-x)

  ;; image-dired
  (setq image-dired-dir (w/locate-emacs-var-file "image-dired"))

  (straight-use-package 'dired-rsync)
  (straight-use-package 'dired-quick-sort)
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

(provide 'w-dired)
