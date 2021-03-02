;; -*- lexical-binding: t; -*-

;; set PATH manually, https://blog.galeo.me/path-environment-variable-on-mac-os-x-emacs-app.html
;; TODO: add other variables like MANPATH
;; when more and more env vars need to be set, referece doom-load-envvars-file
(when (and (eq system-type 'darwin) window-system)
  (setenv "PATH"
	  (concat "~/.rbenv/shims:~/.rbenv/bin:~/.gem/ruby/2.7.0/bin:~/.cargo/bin:~/bin:~/.local/bin:/usr/local/opt/node@10/bin:/usr/local/opt/ruby/bin:/usr/pkg/bin:/usr/pkg/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/snap/bin:/Applications/VMware Fusion.app/Contents/Public:/Library/TeX/texbin:/opt/X11/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:~/Library/Android/sdk/tools:~/Library/Android/sdk/platform-tools:~/.antigen/bundles/robbyrussell/oh-my-zsh/lib:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/colored-man-pages:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/extract:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/z:~/.antigen/bundles/zsh-users/zsh-syntax-highlighting:~/.antigen/bundles/zsh-users/zsh-completions:~/.antigen/bundles/zsh-users/zsh-autosuggestions:~/.antigen/bundles/denisidoro/navi"
		  path-separator (getenv "PATH")))
  (setq exec-path (split-string (getenv "PATH") path-separator)))

(provide 'init-exec-path)
