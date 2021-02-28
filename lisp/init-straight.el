;;; bootstrap straight.el
(defconst wenpin/STRAIGHT (locate-user-emacs-file "straight"))
(defconst wenpin/STRAIGHT-REPOS (locate-user-emacs-file "straight/repos"))
(defconst wenpin/STRAIGHT-VERSIONS (locate-user-emacs-file "straight/versions"))
(unless (file-exists-p wenpin/STRAIGHT) (mkdir wenpin/STRAIGHT))
(unless (file-exists-p wenpin/STRAIGHT-REPOS) (mkdir wenpin/STRAIGHT-REPOS))
(unless (file-exists-p wenpin/STRAIGHT-VERSIONS) (mkdir wenpin/STRAIGHT-VERSIONS))
(setq straight-base-dir (expand-file-name (concat "straight-" emacs-version "-" (replace-regexp-in-string "/" "-" (symbol-name system-type))) wenpin/STRAIGHT))
(defconst wenpin/STRAIGHT-SELF-DIR (expand-file-name "straight" straight-base-dir))
(defconst wenpin/STRAIGHT-REPOS-DIR (expand-file-name "repos" wenpin/STRAIGHT-SELF-DIR))
(defconst wenpin/STRAIGHT-VERSIONS-DIR (expand-file-name "versions" wenpin/STRAIGHT-SELF-DIR))
(unless (file-exists-p straight-base-dir) (mkdir straight-base-dir))
(unless (file-exists-p wenpin/STRAIGHT-SELF-DIR) (mkdir wenpin/STRAIGHT-SELF-DIR))
(unless (file-exists-p wenpin/STRAIGHT-REPOS-DIR)
  (shell-command (concat "ln -s ../../repos " wenpin/STRAIGHT-REPOS-DIR)))
(unless (file-exists-p wenpin/STRAIGHT-VERSIONS-DIR)
  (shell-command (concat "ln -s ../../versions " wenpin/STRAIGHT-VERSIONS-DIR)))
(defvar bootstrap-version)
(let ((bootstrap-file
       (locate-user-emacs-file "straight/repos/straight.el/bootstrap.el"))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq straight-default-vc 'git
      straight-vc-git-default-clone-depth 1)

(provide 'init-straight)
