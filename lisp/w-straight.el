;;; bootstrap straight.el  -*- lexical-binding: t; -*-

;; constants
(defconst w/STRAIGHT (locate-user-emacs-file "straight"))
(defconst w/STRAIGHT-REPOS (locate-user-emacs-file "straight/repos"))
(defconst w/STRAIGHT-VERSIONS (locate-user-emacs-file "straight/versions"))
(setq straight-base-dir (expand-file-name (concat "straight-" emacs-version "-" (replace-regexp-in-string "/" "-" (symbol-name system-type))) w/STRAIGHT))
(defconst w/STRAIGHT-SELF-DIR (expand-file-name "straight" straight-base-dir))
(defconst w/STRAIGHT-REPOS-DIR (expand-file-name "repos" w/STRAIGHT-SELF-DIR))
(defconst w/STRAIGHT-VERSIONS-DIR (expand-file-name "versions" w/STRAIGHT-SELF-DIR))

;; directories
(unless (file-exists-p w/STRAIGHT) (mkdir w/STRAIGHT))
(unless (file-exists-p w/STRAIGHT-REPOS) (mkdir w/STRAIGHT-REPOS))
(unless (file-exists-p w/STRAIGHT-VERSIONS) (mkdir w/STRAIGHT-VERSIONS))
(unless (file-exists-p straight-base-dir) (mkdir straight-base-dir))
(unless (file-exists-p w/STRAIGHT-SELF-DIR) (mkdir w/STRAIGHT-SELF-DIR))
(unless (file-exists-p w/STRAIGHT-REPOS-DIR)
  (shell-command (concat "ln -s ../../repos " w/STRAIGHT-REPOS-DIR)))
(unless (file-exists-p w/STRAIGHT-VERSIONS-DIR)
  (shell-command (concat "ln -s ../../versions " w/STRAIGHT-VERSIONS-DIR)))

;; straight options
(setq straight-repository-branch "master"
      ;; straight-check-for-modifications
      straight-disable-native-compile nil
      straight-use-package-by-default nil
      ;; straight-vc-git-default-clone-deptha 1  ;; shallow clone causes lots of headache when thawing or freezing versions
      straight-default-vc 'git)

;; bootstrap straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (locate-user-emacs-file "straight/repos/straight.el/bootstrap.el"))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(defun w/straight-use-package-unless-featurep (package function)
  "in case package is installed by guix for now"
  (unless (fboundp function)
    (straight-use-package package)))

(provide 'w-straight)
