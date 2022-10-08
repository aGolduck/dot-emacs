;;;  -*- lexical-binding: t; -*-
;;; set up a template for complex configuration modules



;;; load third-party packages
(straight-use-package 'dired-rsync)
(straight-use-package 'dired-quick-sort)



;;; autoload
(autoload 'dired-jump "dired-x" nil t nil)
(autoload 'hydra-dired-quick-sort/body "dired-quick-sort" nil t nil)



;;; self defined functions



;;; customize variables
(setq dired-listing-switches "-Afhlv"
      dired-auto-revert-buffer t
      dired-dwim-target t
      dired-recursive-copies 'always
      dired-kill-when-opening-new-dired-buffer t
      dired-recursive-deletes 'top
      dired-guess-shell-alist-user '(("\\.doc\\'" "libreoffice")
                                     ("\\.docx\\'" "libreoffice")
                                     ("\\.ppt\\'" "libreoffice")
                                     ("\\.pptx\\'" "libreoffice")
                                     ("\\.xls\\'" "libreoffice")
                                     ("\\.xlsx\\'" "libreoffice"))
      image-dired-dir (w/locate-emacs-var-file "image-dired"))



;;; lazy setup
(with-eval-after-load 'dired
  ;; TODO 4.5 set faces
  ;; 4.1 require packages
  (require 'dired-x)
  ;; 4.2 local mode map hook
  (add-hook 'dired-mode-hook #'dired-quick-sort)
  ;; 4.3 lazy set up
  ;; TODO use dired-kill-when-opening-new-dired-buffer for emacs 28
  ;; do not open extra dired buffer
  (put 'dired-find-alternate-file 'disabled nil)
  ;; 4.4 local mode map keybindings set up
  (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)
  (define-key dired-mode-map
    (kbd "^") (lambda () (interactive) (find-alternate-file "..")))
  (define-key dired-mode-map (kbd "s") #'hydra-dired-quick-sort/body))




;;; global hooks



;;; global key bindings
(global-set-key (kbd "M-SPC ^") #'dired-jump)



;;; extra third-party set up



;;; provide feature
(provide 'w-dired)
