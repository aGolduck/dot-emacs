;;;  -*- lexical-binding: t; -*-
;;; 包安装与配置分离，利于包版本集中管理，利于灵活调整包管理工具

(dolist (w/package
         (list
          ;; '(paredit :repo "http://mumble.net/~campbell/git/paredit.git/")
          '(valign :host github :repo "casouri/valign")
          'ace-window
          'avy
          'ccls
          'cider
          'clojure-mode
          'direnv
          'dotenv-mode
          'emmet-mode
          'go-translate
          'graphql-mode
          'groovy-mode
          'json-mode
          'link-hint
          'markdown-mode
          'pdf-tools
          'pkgbuild-mode
          'pocket-reader
          'rust-mode
          'selectric-mode
          'shackle
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
