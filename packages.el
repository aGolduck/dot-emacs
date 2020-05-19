;;; 包安装与配置分离，利于包版本集中管理，利于灵活调整包管理工具

(dolist (wenpin-package
         (list
          '(color-rg :host github :repo "manateelazycat/color-rg")
          ;; '(emacs-application-framework :host github :repo "manateelazycat/emacs-application-framework" :files ("app" "core" "*.el" "*.py"))
          '(flymake-posframe :host github :repo "Ladicle/flymake-posframe")
          '(fuz :host github :repo "rustify-emacs/fuz.el" :files ("src" "Cargo*" "*.el"))
          '(nox :host github :repo "manateelazycat/nox")
          '(paredit :repo "http://mumble.net/~campbell/git/paredit.git/")
          '(rime :host github :repo "DogLooksGood/emacs-rime" :files ("*.el" "Makefile" "lib.c"))
          '(snails :host github :repo "manateelazycat/snails" :fork (:host nil :repo "git@github.com:wpchou/snails.git") :files ("*.el" "*.sh" "*.ps1") :no-byte-compile t)
          'avy
          'ccls
          'company
          'counsel ;; ivy, counsel and swiper belongs to the same repo, but straight.el builds them into different packages
          'diminish
          'dotenv-mode
          'eglot
          'esh-autosuggest
          'expand-region
          'eyebrowse
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
          'olivetti
	  '(org :type built-in)
          'org-journal
          'posframe
          'projectile
          'rust-mode
          'sudo-edit
          'swiper
          'treemacs
          'typescript-mode
          'vterm
          'yaml-mode
          'yasnippet
          ;; 'company-tabnine
          'ivy-xref
          'eshell-z
          'eterm-256color
          'highlight-indent-guides
          'json-mode
          'company-lsp
          'tide
          '(path-headerline-mode :host github :repo "7696122/path-headerline-mode")
          '(term-cursor :host github :repo "h0d/term-cursor.el")
          ;; 'switch-buffer-functions
          'lsp-python-ms
          ))
  (straight-use-package wenpin-package))


(provide 'init-packages)
