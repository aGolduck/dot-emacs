;;;  -*- lexical-binding: t; -*-
;;; 包安装与配置分离，利于包版本集中管理，利于灵活调整包管理工具

(dolist (wenpin/package
         (list
	  '(org :type built-in)
          '(color-rg :host github :repo "manateelazycat/color-rg")
          '(emacs-application-framework :host github :repo "manateelazycat/emacs-application-framework" :files ("app" "core" "*.el" "*.py"))
          '(flymake-posframe :host github :repo "Ladicle/flymake-posframe")
          '(fuz :host github :repo "rustify-emacs/fuz.el" :files ("src" "Cargo*" "*.el"))
          '(paredit :repo "http://mumble.net/~campbell/git/paredit.git/")
          '(snails :host github :repo "manateelazycat/snails" :fork (:host nil :repo "git@github.com:wpchou/snails.git") :files ("*.el" "*.sh" "*.ps1") :no-byte-compile t)
          '(term-cursor :host github :repo "h0d/term-cursor.el")
          '(thing-edit :host github :repo "manateelazycat/thing-edit")
          '(valign :host github :repo "casouri/valign")
          'ace-window
          'ag
          'autodisass-java-bytecode
          'avy
          'ccls
          'company
          'counsel ;; ivy, counsel and swiper belongs to the same repo, but straight.el builds them into different packages
          'dap-mode
          'devdocs
          'diminish
          'dired-rsync
          'dotenv-mode
          'esh-autosuggest
          'eshell-z
          'eterm-256color
          'expand-region
          'flycheck-posframe
          'gcmh
          'git-link
          'graphql-mode
          'groovy-mode
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
          'org-alert
          'org-cliplink
          'org-download
          'org-journal
          'org-roam
          'org-roam-server
          'ox-hugo
          'pdf-tools
          'pkgbuild-mode
          'pocket-reader
          'posframe
          'projectile
          'ranger
          'rust-mode
          'selectric-mode
          'shackle
          'smartparens
          'smex
          'sudo-edit
          'swiper
          'tide
          'treemacs
          'typescript-mode
          'vterm
          'yaml-mode
          'yasnippet
          '(yasnippet-snippets :host github :repo "AndreaCrotti/yasnippet-snippets" :fork (:host nil :repo "git@github.com:wpchou/yasnippet-snippets.git"))
          'zeal-at-point
          'direnv
          'org-ql
          '(ob-groovy :host github :repo "zweifisch/ob-groovy")
          'rime
          'company-org-roam
          ))
  (straight-use-package wenpin/package))

(provide 'init-packages)
