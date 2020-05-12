;;; pre-init
;; set PATH manually, https://blog.galeo.me/path-environment-variable-on-mac-os-x-emacs-app.html
;; TODO: add othen variables like MANPATH
;; when more and more env vars need to be set, referece doom-load-envvars-file
(when (and (eq system-type 'darwin) window-system)
  (setenv "PATH"
	  (concat "~/.rbenv/shims:~/.rbenv/bin:~/.gem/ruby/2.7.0/bin:~/.cargo/bin:~/bin:~/.local/bin:/usr/local/opt/node@10/bin:/usr/local/opt/ruby/bin:/usr/pkg/bin:/usr/pkg/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/snap/bin:/Applications/VMware Fusion.app/Contents/Public:/Library/TeX/texbin:/opt/X11/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:~/Library/Android/sdk/tools:~/Library/Android/sdk/platform-tools:~/.antigen/bundles/robbyrussell/oh-my-zsh/lib:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/colored-man-pages:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/extract:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/z:~/.antigen/bundles/zsh-users/zsh-syntax-highlighting:~/.antigen/bundles/zsh-users/zsh-completions:~/.antigen/bundles/zsh-users/zsh-autosuggestions:~/.antigen/bundles/denisidoro/navi"
		  path-separator (getenv "PATH")))
  (setq exec-path (split-string (getenv "PATH") path-separator)))
;; M-SPC is key to my emacs world
(global-unset-key (kbd "M-SPC"))
;; accelerate loading init files, will be reset by gcmh
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

;;; bootstrap straight.el and use-package
(unless (file-exists-p "~/.emacs.d/repos") (mkdir "~/.emacs.d/repos"))
(setq straight-base-dir (concat "~/.emacs.d/straight-" emacs-version))
(setq wenpin-straight-self-dir (expand-file-name "straight" straight-base-dir))
(setq wenpin-straight-repos-dir (expand-file-name "repos" wenpin-straight-self-dir))
(unless (file-exists-p straight-base-dir) (mkdir straight-base-dir))
(unless (file-exists-p wenpin-straight-self-dir) (mkdir wenpin-straight-self-dir))
(unless (file-exists-p wenpin-straight-repos-dir)
  (shell-command (concat "ln -s ../../repos " wenpin-straight-repos-dir)))
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "repos/straight.el/bootstrap.el" user-emacs-directory))
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
;; extra keybindings
(load (concat (file-name-directory (or load-file-name buffer-file-name)) "keybindings"))

(dolist (hook
         (list
          'view-mode-hook
          'vterm-copy-mode-hook
          ))
  (add-hook hook (lambda () (if view-mode (setq cursor-type 'box) (setq cursor-type 'bar)))))
(dolist (writable-major-mode-hook
         (list
          'eshell-mode-hook
          'lisp-interaction-mode-hook
          'org-capture-mode-hook
          'vterm-mode-hook
          ))
  (add-hook writable-major-mode-hook (lambda () (setq cursor-type 'bar))))
(add-hook 'find-file-hook
	  (lambda ()
	     (when (or
		    (string-match-p "org/orgzly" (buffer-file-name))
		    (string-match-p ".git/COMMIT_EDITMSG" (buffer-file-name))
		    )
	       (setq cursor-type 'bar))))

(tool-bar-mode -1)
(toggle-frame-maximized)

;;; query magit's dependences
;; (nth 1 (gethash "magit" straight--build-cache))
;;; query dash's dependents
;; (cl-remove-if-not
;;  (lambda (package)
;;    (member "dash" (nth 1 (gethash package straight--build-cache))))
;;  (hash-table-keys straight--recipe-cache))

(setq wenpin-font-default-height
      (cond
       ((string-equal (getenv "HOME") "/Users/wenpin") 180)
       (t 112)))
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'no-error 'no-message)
