;;; 包安装与配置分离，利于包版本集中管理，利于灵活调整包管理工具

(dolist (wenpin/package
         (list
	  '(org :type built-in)
          '(color-rg :host github :repo "manateelazycat/color-rg")
          '(emacs-application-framework :host github :repo "manateelazycat/emacs-application-framework" :files ("app" "core" "*.el" "*.py"))
          '(flymake-posframe :host github :repo "Ladicle/flymake-posframe")
          '(fuz :host github :repo "rustify-emacs/fuz.el" :files ("src" "Cargo*" "*.el"))
          '(paredit :repo "http://mumble.net/~campbell/git/paredit.git/")
          '(rime :host github :repo "DogLooksGood/emacs-rime" :files ("*.el" "Makefile" "lib.c"))
          '(snails :host github :repo "manateelazycat/snails" :fork (:host nil :repo "git@github.com:wpchou/snails.git") :files ("*.el" "*.sh" "*.ps1") :no-byte-compile t)
          '(term-cursor :host github :repo "h0d/term-cursor.el")
          'avy
          'ccls
          'company
          'counsel ;; ivy, counsel and swiper belongs to the same repo, but straight.el builds them into different packages
          'diminish
          'dotenv-mode
          'esh-autosuggest
          'eshell-z
          'eterm-256color
          'expand-region
          'gcmh
          'git-link
          'graphql-mode
          'highlight-indent-guides
          'hl-todo
          'ivy
          'ivy-posframe
          'ivy-xref
          'json-mode
          'lsp-ivy
          'lsp-mode
          'lsp-python-ms
          'lsp-treemacs
          'magit
          'magit-todos
          'markdown-mode
          'olivetti
          'org-journal
          'posframe
          'projectile
          'rust-mode
          'sudo-edit
          'swiper
          'tide
          'treemacs
          'typescript-mode
          'vterm
          'yaml-mode
          'org-roam
          '(company-org-roam :host github :repo "org-roam/company-org-roam")
          'flycheck-posframe
          'magit-delta
          '(valign :host github :repo "casouri/valign")
          'ivy-hydra
          ))
  (straight-use-package wenpin/package))


(provide 'init-packages)
