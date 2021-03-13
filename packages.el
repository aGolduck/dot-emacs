;;;  -*- lexical-binding: t; -*-
;;; 包安装与配置分离，利于包版本集中管理，利于灵活调整包管理工具

(dolist (w/package
         (list
          '(color-rg :host github :repo "manateelazycat/color-rg")
          '(emacs-application-framework :host github :repo "manateelazycat/emacs-application-framework" :files ("*"))
          '(fuz :host github :repo "rustify-emacs/fuz.el" :files ("src" "Cargo*" "*.el"))
          ;; '(paredit :repo "http://mumble.net/~campbell/git/paredit.git/")
          '(telega :host github :repo "zevlg/telega.el" :branch "releases")
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
          'crux
          'ctable
          'dap-mode
          'deferred
          'direnv
          'dotenv-mode
          'emmet-mode
          'epc
          'esh-autosuggest
          'eshell-z
          'eterm-256color
          'expand-region
          'flycheck
          'flycheck-posframe
          'gcmh
          'git-link
          'go-translate
          'graphql-mode
          'groovy-mode
          'guix
          'helpful
          'highlight-indent-guides
          'hl-todo
          'json-mode
          'keyfreq
          'link-hint
          'lsp-mode
          'lsp-python-ms
          'lsp-treemacs
          'lsp-ui
          'magit
          'magit-delta
          'magit-todos
          'markdown-mode
          'mini-frame
          'olivetti
          'orderless
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
          'tide
          'transient
          'treemacs
          'typescript-mode
          'vterm
          'yaml-mode
          'yasnippet
          ;; 'counsel ;; ivy, counsel and swiper belongs to the same repo, but straight.el builds them into different packages
          ;; 'ivy
          ;; 'ivy-hydra
          ;; 'ivy-posframe
          ;; 'ivy-prescient
          ;; 'ivy-rich
          ;; 'ivy-xref
          ;; 'lsp-ivy
          ;; 'swiper
          ))
  (straight-use-package w/package))

(provide 'w-packages)
