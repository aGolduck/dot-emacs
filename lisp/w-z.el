;;; -*- lexical-binding: t; -*-
;;; markdown
;; edit-indirect for editing markdown source code in delicated buffer
(straight-use-package 'edit-indirect)
(straight-use-package 'markdown-mode)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(setq markdown-command "multimarkdown")

(straight-use-package 'graphql-mode)
(straight-use-package 'pkgbuild-mode)
(straight-use-package 'link-hint)


;;; TODO to organize
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

;; url
(setq url-cache-directory (w/locate-emacs-var-file ".cache/url"))

;;; git link
(straight-use-package 'git-link)
(global-set-key (kbd "M-SPC g L") #'git-link)
;; TODO use add-to-list instead of setq
;; (setq git-link-remote-alist
;;       '(("git.sr.ht" git-link-sourcehut)
;;         ("github" git-link-github)
;;         ("bitbucket" git-link-bitbucket)
;;         ("gitorious" git-link-gitorious)
;;         ("gitlab" git-link-gitlab)
;;         ("git\\.\\(sv\\|savannah\\)\\.gnu\\.org" git-link-savannah)
;;         ("visualstudio\\|azure" git-link-azure)
;;         ("sourcegraph" git-link-sourcegraph)
;;         ("git.woa.com" git-link-gitlab)))

(provide 'w-z)
