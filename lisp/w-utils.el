;; -*- lexical-binding: t; -*-

(defconst w/HOST (substring (shell-command-to-string "hostname") 0 -1))
(defconst w/EMACS-VAR (locate-user-emacs-file "var"))
(unless (file-exists-p w/EMACS-VAR) (mkdir w/EMACS-VAR))
(defun w/locate-emacs-var-file (file)
  (expand-file-name file w/EMACS-VAR))

(straight-use-package 'crux)
(global-set-key (kbd "C-o") #'crux-smart-open-line)
(global-set-key (kbd "M-o") #'crux-smart-open-line-above)
(global-set-key (kbd "M-SPC f r") #'crux-recentf-find-file)


(provide 'w-utils)
