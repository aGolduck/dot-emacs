;;; init-grep.el --- Settings for grep and grep-like tools -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(straight-use-package 'rg)
(straight-use-package 'ag)
(straight-use-package 'wgrep-ag)
(straight-use-package 'wgrep)
;; (straight-use-package 'anzu)

(if (executable-find "rg")
    (progn
      ;; rg
      ;; TODO how to organise commands and their coresponding consult commands
      (global-set-key (kbd "M-SPC s p") #'rg-project))
  (if (executable-find "ag")
      (progn
        (global-set-key (kbd "M-SPC s p") #'ag-project))
    ;; for grep
    nil))

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
;; (setq anzu-mode-lighter "")
;; (add-hook 'after-init-hook #'global-anzu-mode)
;; (global-set-key [remap query-replace-regexp] #'anzu-query-replace-regexp)
;; (global-set-key [remap query-replace] #'anzu-query-replace)

(provide 'w-search)
