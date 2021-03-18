;;;  -*- lexical-binding: t; -*-
;;; 包安装与配置分离，利于包版本集中管理，利于灵活调整包管理工具

(dolist (w/package
         (list
          ;; '(paredit :repo "http://mumble.net/~campbell/git/paredit.git/")
          '(thing-edit :host github :repo "manateelazycat/thing-edit")
          '(valign :host github :repo "casouri/valign")
          'ace-window
          'avy
          'ccls
          'cider
          'clojure-mode
          'crux
          'direnv
          'dotenv-mode
          'emmet-mode
          'expand-region
          'gcmh
          'go-translate
          'graphql-mode
          'groovy-mode
          'guix
          'helpful
          'json-mode
          'keyfreq
          'link-hint
          'markdown-mode
          'mini-frame
          'orderless
          'pdf-tools
          'pkgbuild-mode
          'pocket-reader
          'projectile
          'ranger
          'rust-mode
          'selectric-mode
          'shackle
          'smartparens
          'tide
          'treemacs
          'typescript-mode
          'yaml-mode
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
