;;; -*- lexical-binding: t; -*-
;;; font-lock
(with-eval-after-load 'font-lock
  (set-face-attribute 'font-lock-comment-face nil :height 0.9))

;;; hi-lock
(setq hi-lock-face-defaults '("hi-pink" "hi-green" "hi-blue" "hi-salmon" "hi-aquamarine" "hi-black-b" "hi-blue-b" "hi-red-b" "hi-green-b" "hi-black-hb"))
(global-set-key (kbd "M-SPC h f") #'hi-lock-find-patterns)
(global-set-key (kbd "M-SPC h l") #'highlight-lines-matching-regexp)
(global-set-key (kbd "M-SPC h p") #'highlight-phrase)
(global-set-key (kbd "M-SPC h r") #'highlight-regexp)
(global-set-key (kbd "M-SPC h s") #'highlight-symbol-at-point)
(global-set-key (kbd "M-SPC h u") #'unhighlight-regexp)
(global-set-key (kbd "M-SPC h w") #'hi-lock-write-interactive-patterns)
(with-eval-after-load 'hi-lock
  (diminish 'hi-lock-mode "亮"))

;;; frame
(add-hook 'after-init-hook #'blink-cursor-mode)

;;; olivetti
(straight-use-package 'olivetti)

;;; posframe
(straight-use-package 'posframe)

;;; transient for magit,org-ql,rg...
(straight-use-package 'transient)

(provide 'w-ui)
