;;;  -*- lexical-binding: t; -*-
;;; set up a template for complex configuration modules
;;; TODO 将 dired built-in 部分迁入 w-minimal 配置



;;; load third-party packages
(straight-use-package 'dired-rsync)
(straight-use-package 'dired-quick-sort)



;;; autoload
(autoload 'dired-jump "dired-x" nil t nil)
(autoload 'hydra-dired-quick-sort/body "dired-quick-sort" nil t nil)



;;; self defined functions



;;; customize variables



;;; lazy setup
(with-eval-after-load 'dired
  ;; TODO 4.5 set faces
  ;; 4.1 require packages
  (require 'dired-x)
  ;; 4.2 local mode map hook
  (add-hook 'dired-mode-hook #'dired-quick-sort)
  ;; 4.3 lazy set up
  ;; use dired-kill-when-opening-new-dired-buffer for emacs 28
  ;; do not open extra dired buffer
  ;; (put 'dired-find-alternate-file 'disabled nil)
  ;; 4.4 local mode map keybindings set up

  (define-key dired-mode-map (kbd "s") #'hydra-dired-quick-sort/body))




;;; global hooks



;;; global key bindings



;;; extra third-party set up



;;; provide feature
(provide 'w-dired-extra)
