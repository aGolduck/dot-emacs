;;; copied from https://github.com/magit/git-modes/blob/main/gitignore-mode.el

(require 'compat)
(require 'conf-mode)

(defvar gitignore-mode-font-lock-keywords
  '(("^\\s<.*$"   . font-lock-comment-face)
    ("^!"         . font-lock-negation-char-face) ; Negative pattern
    ("/"          . font-lock-constant-face)      ; Directory separators
    ("[*?]"       . font-lock-keyword-face)       ; Glob patterns
    ("\\[.+?\\]"  . font-lock-keyword-face)))     ; Ranged glob patterns

;;;###autoload
(define-derived-mode gitignore-mode conf-unix-mode "Gitignore"
  "A major mode for editing .gitignore files."
  (conf-mode-initialize "#")
  ;; Disable syntactic font locking, because comments are only valid at
  ;; beginning of line.
  (setq font-lock-defaults '(gitignore-mode-font-lock-keywords t t))
  (setq-local conf-assignment-sign nil))

;;;###autoload
(dolist (pattern (list "/\\.gitignore\\'"
                       "/info/exclude\\'"
                       "/git/ignore\\'"))
  (add-to-list 'auto-mode-alist (cons pattern 'gitignore-mode)))

;;; _
(provide 'gitignore-mode)
