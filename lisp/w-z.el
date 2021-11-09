;;; -*- lexical-binding: t; -*-
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
(straight-use-package 'link-hint)
(straight-use-package 'pdf-tools)


;;; TODO to organise
(straight-use-package 'avy)
(global-set-key (kbd "M-SPC g g") #'avy-goto-char-timer)
(global-set-key (kbd "M-SPC g l") #'avy-goto-line)
(global-set-key (kbd "M-SPC g w") #'avy-goto-word-0)
;;; auth-source
(setq auth-sources '((:source (w/locate-emacs-var-file ".authinfo.gpg"))))
;;; epg-config
(setq epg-pinentry-mode 'loopback)
;;; go-to-address
(add-hook 'after-init-hook #'goto-address-mode)

(require 'screenshot-svg)
;;; url-cookie
(setq url-cookie-file (w/locate-emacs-var-file "url/cookies"))

;; (straight-use-package 'oauth)
;; (require 'oauth)
;; (straight-use-package 'zotero)
;; (autoload 'zotero-auth-token-create "zotero-auth")
;; (require 'zotero-browser)
;; (autoload 'zotero-browser "zotero-browser")


(straight-use-package 'lua-mode)

;; url
(setq url-cache-directory (w/locate-emacs-var-file ".cache/url"))

;;; git link
(straight-use-package 'git-link)
(global-set-key (kbd "M-SPC g L") #'git-link)

(provide 'w-z)
