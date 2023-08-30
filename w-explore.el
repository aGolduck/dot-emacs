(define-skeleton gpt-template
  "docstring: chatgpt template"
  "prompt"
  "you are chatgpt"
  )

(define-skeleton hello-world-skeleton
  "Write a greeting"
  "Type name of user: "
  "hello, " str "!")

(defun w/uncomment-console-logging ()
  (interactive)
  (beginning-of-buffer)
  (replace-string "// console(" "// console"))

(defun w/comment-out-console-logging ()
    (interactive)
  (beginning-of-buffer)
  (replace-string "console(" "// console("))


(when (>= emacs-major-version 29)
  (straight-use-package 'clojure-ts-mode)
  (add-hook 'clojure-ts-mode #'lispy-mode)

  (add-to-list 'auto-mode-alist '("\\.sy\\'" . json-ts-mode))
  (straight-use-package 'treesit-auto)
  (require 'treesit-auto)
  (global-treesit-auto-mode)

  (straight-use-package 'combobulate)
  (autoload 'combobulate-mode "combobulate" nil t nil)
  (add-hook 'typescript-ts-mode-hook #'combobulate-mode)
  (add-hook 'json-ts-mode-hook #'combobulate-mode))

(provide 'w-explore)
