;;; init-grep.el --- Settings for grep and grep-like tools -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(straight-use-package 'rg)
(straight-use-package 'wgrep)

(when (executable-find "rg")
  ;; rg
  ;; TODO how to organise commands and their coresponding consult commands
  ;; (global-set-key (kbd "M-SPC s p") #'rg-project)
  (global-set-key (kbd "M-SPC s") #'rg-menu))

;;; isearch
(setq-default isearch-lazy-count t
              search-ring-max 200
              regexp-search-ring-max 200)
(with-eval-after-load 'isearch
  (diminish 'isearch-mode)
  (global-set-key (kbd "C-s") #'isearch-forward-regexp)
  (global-set-key (kbd "C-r") #'isearch-backward-regexp)
  (global-set-key (kbd "C-M-s") #'isearch-forward)
  (define-key isearch-mode-map (kbd "C-w") #'isearch-yank-symbol-or-char)
  (define-key isearch-mode-map (kbd "C-M-w") #'isearch-yank-word-or-char))

(provide 'w-search)
