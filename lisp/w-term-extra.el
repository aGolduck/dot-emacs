(w/straight-use-package-unless-featurep 'vterm #'vterm)

;;; vterm
(setq vterm-buffer-name-string "vterm %s"
      vterm-keymap-exceptions '("C-c" "C-x" "C-g" "C-h" "C-l" "M-x" "M-o" "C-v" "M-v" "C-y" "M-y" "M-i" "M-c")
      vterm-kill-buffer-on-exit t
      vterm-shell "zsh"
      vterm-term-environment-variable "eterm-color")
;; (add-hook 'vterm-mode-hook
;;           (lambda ()
;;             (set (make-local-variable 'buffer-face-mode-face) 'fixed-pitch-serif)
;;             (buffer-face-mode t)))
(with-eval-after-load 'vterm
  (set-face-attribute 'vterm-color-green nil :foreground "dark green"))



(provide 'w-term-extra)
