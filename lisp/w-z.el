;;; -*- lexical-binding: t; -*-
(setq calendar-chinese-all-holidays-flag t)
(with-eval-after-load 'abbrev (diminish 'abbrev-mode "缩"))

;;; makefile
(add-to-list 'auto-mode-alist '("\\.gmk" . makefile-mode))
;;; python
;; (setq lsp-python-ms-auto-install-server nil
;;       lsp-python-ms-executable "~/g/Microsoft/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")
;; (add-hook 'python-mode-hook (lambda () (require 'lsp-python-ms) (lsp)))
(add-hook 'python-mode-hook #'highlight-indent-guides-mode)
;;; xml
(setq lsp-xml-jar-file (expand-file-name (locate-user-emacs-file "resources/org.eclipse.lemminx-uber.jar")))
(when (equal w/lsp-client "lsp")
  ;; download from http://mirrors.ustc.edu.cn/eclipse/lemminx/
  (add-hook 'nxml-mode-hook #'lsp))
(add-hook 'nxml-mode-hook #'smartparens-mode)
;;; clojure
(straight-use-package 'clojure-mode)
(straight-use-package 'cider)
(add-hook 'clojure-mode-hook #'electric-pair-local-mode)
;;; groovy
(straight-use-package 'groovy-mode)
(setq lsp-groovy-server-file (locate-user-emacs-file "resources/groovy-language-server-all.jar"))
(when (equal w/lsp-client "lsp")
  (add-hook 'groovy-mode-hook #'lsp))
(add-hook 'groovy-mode-hook #'company-mode)
(add-hook 'groovy-mode-hook #'electric-pair-local-mode)
;;; markdown
(straight-use-package 'markdown-mode)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(setq markdown-command "multimarkdown")
;;; yaml
(straight-use-package 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\.'" . yaml-mode))
(add-hook 'yaml-mode-hook #'highlight-indent-guides-mode)

(straight-use-package 'ccls)
(straight-use-package 'graphql-mode)
(straight-use-package 'pkgbuild-mode)
(straight-use-package 'rust-mode)

(provide 'w-z)
