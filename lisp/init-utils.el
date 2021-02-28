;; M-SPC is key to my emacs world
(global-unset-key (kbd "M-SPC"))

(defconst wenpin/HOST (substring (shell-command-to-string "hostname") 0 -1))
(defconst wenpin/EMACS-VAR (locate-user-emacs-file "var"))
(unless (file-exists-p wenpin/EMACS-VAR) (mkdir wenpin/EMACS-VAR))
(defun wenpin/locate-emacs-var-file (file)
  (expand-file-name file wenpin/EMACS-VAR))

(provide 'init-utils)
