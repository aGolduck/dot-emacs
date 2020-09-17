;;; -*- lexical-binding: t; -*-
;;; pre-init
(setq comp-deferred-compilation t)
;; set PATH manually, https://blog.galeo.me/path-environment-variable-on-mac-os-x-emacs-app.html
;; TODO: add other variables like MANPATH
;; when more and more env vars need to be set, referece doom-load-envvars-file
(when (and (eq system-type 'darwin) window-system)
  (setenv "PATH"
	  (concat "~/.rbenv/shims:~/.rbenv/bin:~/.gem/ruby/2.7.0/bin:~/.cargo/bin:~/bin:~/.local/bin:/usr/local/opt/node@10/bin:/usr/local/opt/ruby/bin:/usr/pkg/bin:/usr/pkg/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/snap/bin:/Applications/VMware Fusion.app/Contents/Public:/Library/TeX/texbin:/opt/X11/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:~/Library/Android/sdk/tools:~/Library/Android/sdk/platform-tools:~/.antigen/bundles/robbyrussell/oh-my-zsh/lib:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/colored-man-pages:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/extract:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/z:~/.antigen/bundles/zsh-users/zsh-syntax-highlighting:~/.antigen/bundles/zsh-users/zsh-completions:~/.antigen/bundles/zsh-users/zsh-autosuggestions:~/.antigen/bundles/denisidoro/navi"
		  path-separator (getenv "PATH")))
  (setq exec-path (split-string (getenv "PATH") path-separator)))
;; M-SPC is key to my emacs world
(global-unset-key (kbd "M-SPC"))
(global-unset-key (kbd "M--"))
;; accelerate loading init files, will be reset by gcmh
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)
(defconst wenpin/HOST (substring (shell-command-to-string "hostname") 0 -1))

;;; bootstrap straight.el and use-package
(defconst wenpin/STRAIGHT (expand-file-name "straight" user-emacs-directory))
(defconst wenpin/STRAIGHT-REPOS (expand-file-name "straight/repos" user-emacs-directory))
(defconst wenpin/STRAIGHT-VERSIONS (expand-file-name "straight/versions" user-emacs-directory))
(unless (file-exists-p wenpin/STRAIGHT) (mkdir wenpin/STRAIGHT))
(unless (file-exists-p wenpin/STRAIGHT-REPOS) (mkdir wenpin/STRAIGHT-REPOS))
(unless (file-exists-p wenpin/STRAIGHT-VERSIONS) (mkdir wenpin/STRAIGHT-VERSIONS))
(setq straight-base-dir (expand-file-name (concat "straight-" emacs-version "-" (replace-regexp-in-string "/" "-" (symbol-name system-type))) user-emacs-directory))
(defconst wenpin/STRAIGHT-SELF-DIR (expand-file-name "straight" straight-base-dir))
(defconst wenpin/STRAIGHT-REPOS-DIR (expand-file-name "repos" wenpin/STRAIGHT-SELF-DIR))
(defconst wenpin/STAIGHT-VERSIONS-DIR (expand-file-name "versions" wenpin/STRAIGHT-SELF-DIR))
(unless (file-exists-p straight-base-dir) (mkdir straight-base-dir))
(unless (file-exists-p wenpin/STRAIGHT-SELF-DIR) (mkdir wenpin/STRAIGHT-SELF-DIR))
(unless (file-exists-p wenpin/STRAIGHT-REPOS-DIR)
  (shell-command (concat "ln -s ../../straight/repos " wenpin/STRAIGHT-REPOS-DIR)))
(unless (file-exists-p wenpin/STAIGHT-VERSIONS-DIR)
  (shell-command (concat "ln -s ../../straight/versions " wenpin/STAIGHT-VERSIONS-DIR)))
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq straight-default-vc 'git)
;; use-package powers all
(straight-use-package 'use-package)
;; decouple code related to straight.el and use-package
(setq straight-use-package-by-default nil)
(setq use-package-always-defer t)
;; install and load packages by straight.el
;; straight.el loads auto-load functions only
(load (concat (file-name-directory (or load-file-name buffer-file-name)) "packages"))
;; personal lisp
(add-to-list 'load-path (concat (file-name-directory (or load-file-name buffer-file-name)) "lisp"))
(add-to-list 'load-path (concat (file-name-directory (or load-file-name buffer-file-name)) "site-lisp"))
;; configs
(load (concat (file-name-directory (or load-file-name buffer-file-name)) "config"))
;; other settings
(load (concat (file-name-directory (or load-file-name buffer-file-name)) "settings"))
;; extra keybindings
(load (concat (file-name-directory (or load-file-name buffer-file-name)) "keybindings"))

(tool-bar-mode -1)
;; (toggle-frame-maximized)

(setq custom-file "~/.emacs.d/custom.el")
;; (load custom-file 'no-error 'no-message)
