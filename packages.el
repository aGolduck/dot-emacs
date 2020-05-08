;;; 包安装与配置分离，利于包版本集中管理，利于灵活调整包管理工具

(dolist (wenpin-package
         (list
          'avy
          'ccls
          '(color-rg :host github :repo "manateelazycat/color-rg")
          'company
          ;; 'company-tabnine
          ;; ivy, counsel and swiper belongs to the same repo
          ;; but straight.el builds them into different packages
          'counsel
          'diminish
          'dotenv-mode
          'eglot
          '(emacs-application-framework :host github :repo "manateelazycat/emacs-application-framework" :files ("app" "core" "*.el" "*.py"))
          'expand-region
          'eyebrowse
          '(flymake-posframe :host github :repo "Ladicle/flymake-posframe")
          '(fuz :host github :repo "rustify-emacs/fuz.el" :files ("src" "Cargo*" "*.el"))
          'gcmh
          'git-link
          'graphql-mode
          'hl-todo
          'ivy
          'ivy-posframe
          'lsp-ivy
          'lsp-mode
          'lsp-treemacs
          'magit
          'magit-todos
          'markdown-mode
          '(nox :host github :repo "manateelazycat/nox")
          'olivetti
          'org
          'org-journal
          '(paredit :repo "http://mumble.net/~campbell/git/paredit.git/")
          'posframe
          'projectile
          '(rime :host github :repo "DogLooksGood/emacs-rime" :files ("*.el" "Makefile" "lib.c"))
          'rust-mode
          '(snails :host github :repo "manateelazycat/snails" :fork (:host nil :repo "git@github.com:wpchou/snails.git") :files ("*.el" "*.sh" "*.ps1") :no-byte-compile t)
          'sudo-edit
          'swiper
          'treemacs
          'vterm
          'typescript-mode
          'yaml-mode
          'yasnippet
          ))
  (straight-use-package wenpin-package))


(provide 'init-packages)
