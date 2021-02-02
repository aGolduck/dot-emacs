;;;  -*- lexical-binding: t; -*-
;;; 包安装与配置分离，利于包版本集中管理，利于灵活调整包管理工具

(dolist (wenpin/package
         (list
	  '(org :type built-in)
          '(color-rg :host github :repo "manateelazycat/color-rg")
          '(emacs-application-framework :host github :repo "manateelazycat/emacs-application-framework" :files ("*"))
          '(flymake-posframe :host github :repo "Ladicle/flymake-posframe")
          '(fuz :host github :repo "rustify-emacs/fuz.el" :files ("src" "Cargo*" "*.el"))
          '(ob-groovy :host github :repo "zweifisch/ob-groovy")
          '(paredit :repo "http://mumble.net/~campbell/git/paredit.git/")
          '(term-cursor :host github :repo "h0d/term-cursor.el")
          '(thing-edit :host github :repo "manateelazycat/thing-edit")
          '(valign :host github :repo "casouri/valign")
          '(yasnippet-snippets :host github :repo "AndreaCrotti/yasnippet-snippets" :fork (:host nil :repo "git@github.com:wpchou/yasnippet-snippets.git"))
          'ace-window
          'ag
          'autodisass-java-bytecode
          'avy
          'ccls
          'cider
          'clojure-mode
          'company
          'counsel ;; ivy, counsel and swiper belongs to the same repo, but straight.el builds them into different packages
          'crux
          'dap-mode
          'devdocs
          'diminish
          'dired-rsync
          'direnv
          'dotenv-mode
          'emmet-mode
          'esh-autosuggest
          'eshell-z
          'eterm-256color
          'expand-region
          'flycheck-posframe
          'gcmh
          'git-link
          'go-translate
          'graphql-mode
          'groovy-mode
          'guix
          'haskell-mode
          'helpful
          'highlight-indent-guides
          'hl-todo
          'ivy
          'ivy-hydra
          'ivy-posframe
          'ivy-rich
          'ivy-xref
          'json-mode
          'keyfreq
          'lsp-ivy
          'lsp-java
          'lsp-mode
          'lsp-python-ms
          'lsp-treemacs
          'lsp-ui
          'magit
          'magit-delta
          'magit-todos
          'markdown-mode
          'ob-typescript
          'olivetti
          'org-cliplink
          'org-download
          'org-journal
          'org-pomodoro
          'org-ql
          'org-roam
          'org-roam-server
          'ox-hugo
          'pdf-tools
          'pkgbuild-mode
          'pocket-reader
          'posframe
          'projectile
          'ranger
          'rime
          'rust-mode
          's
          'selectric-mode
          'shackle
          'smartparens
          'sudo-edit
          'swiper
          'tide
          'transient
          'treemacs
          'typescript-mode
          'vterm
          'yaml-mode
          'yasnippet
          'zeal-at-point
          'crux
          ;; 'selectrum
          'epc
          'ctable
          'deferred
          'prescient
          'ivy-prescient
          'company-prescient
          ))
  (straight-use-package wenpin/package))

(provide 'init-packages)
