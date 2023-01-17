;;; -*- lexical-binding: t; -*-
(straight-use-package 'devdocs)
(straight-use-package 'devdocs-browser)
(straight-use-package 'flycheck)
(straight-use-package 'flycheck-posframe)
(straight-use-package 'highlight-indent-guides)
(straight-use-package 'smartparens)
(straight-use-package 'yasnippet)
(straight-use-package 'yasnippet-snippets)
;; git ssh address example, don't remove this comment
;; (straight-use-package '(yasnippet-snippets :host github :repo "AndreaCrotti/yasnippet-snippets" :fork (:host nil :repo "git@github.com:wpchou/yasnippet-snippets.git")))


;;; paren
(setq show-paren-when-point-in-periphery t
      show-paren-when-point-inside-paren t)
;;; yasnippet
(with-eval-after-load 'yasnippet

  (define-key yas-minor-mode-map (kbd "TAB") nil))
;;; flycheck
(add-hook 'flycheck-mode-hook #'flycheck-posframe-mode)

;;; highlight-indent-guides
;; It is reported that highlight-indent-guides takes too much cpu time
;; https://emacs-china.org/t/highlight-indent-guides/16532/4
(setq highlight-indent-guides-method 'character
      ;; highlight-indent-guides-character ?┃
      ;; highlight-indent-guides-character ?│
      ;; highlight-indent-guides-character ?║
      highlight-indent-guides-auto-odd-face-perc 15
      highlight-indent-guides-auto-even-face-perc 55
      highlight-indent-guides-auto-character-face-perc 61.8)
(add-hook 'python-mode-hook #'highlight-indent-guides-mode)
(add-hook 'yaml-ts-mode-hook #'highlight-indent-guides-mode)

(with-eval-after-load 'smartparens
  (require 'smartparens-config)
  (define-key smartparens-mode-map (kbd "C-(") #'sp-wrap-round))
(add-hook 'nxml-mode-hook #'smartparens-mode)


;;; documentations
(setq devdocs-browser-cache-directory (w/locate-emacs-var-file "devdocs-browser"))

;;; java
(straight-use-package 'autodisass-java-bytecode)
(require 'autodisass-java-bytecode)

;;; lua
(straight-use-package 'lua-mode)



(provide 'w-programming-full)
