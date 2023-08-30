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

(provide 'w-explore)
