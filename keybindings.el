(global-set-key (kbd "M-SPC b k") 'kill-buffer)
(global-set-key (kbd "M-SPC f f") 'find-file)
(global-set-key (kbd "M-SPC f F") 'find-file-other-window)
(global-set-key (kbd "M-SPC w d") 'delete-window)
(global-set-key (kbd "M-SPC w D") 'delete-other-windows)
(global-set-key (kbd "M-SPC w s") 'split-window-right)
(global-set-key (kbd "M-SPC w S") (lambda () (interactive) (split-window-right) (other-window 1)))
(global-set-key (kbd "M-SPC w v") 'split-window-below)
(global-set-key (kbd "M-SPC w V") (lambda () (interactive) (split-window-below) (other-window 1)))
(global-set-key (kbd "M-SPC w o") 'other-window)
(global-set-key (kbd "M-SPC w O") (lambda () (interactive) (other-window -1)))
(global-set-key (kbd "M-SPC q q") 'save-buffers-kill-terminal)

(defun smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))
(global-set-key (kbd "M-o") 'smart-open-line-above)


(provide 'init-keybindings)
