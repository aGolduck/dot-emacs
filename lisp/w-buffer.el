;; -*- lexical-binding: t; -*-

;;----------------------------------------------------------------------------
;; Nicer naming of buffers for files with identical names
;;----------------------------------------------------------------------------
(require 'uniquify)

(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator " • ")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")

(global-set-key (kbd "M-SPC b k") #'kill-buffer)

(provide 'w-buffer)
