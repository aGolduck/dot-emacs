;; -*- lexical-binding: t; -*-

;; M-SPC is key to my emacs world
(global-unset-key (kbd "M-SPC"))

(defconst w/HOST (substring (shell-command-to-string "hostname") 0 -1))
(defconst w/EMACS-VAR (locate-user-emacs-file "var"))
(unless (file-exists-p w/EMACS-VAR) (mkdir w/EMACS-VAR))
(defun w/locate-emacs-var-file (file)
  (expand-file-name file w/EMACS-VAR))

(provide 'init-utils)
