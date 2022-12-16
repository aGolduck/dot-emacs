;;; mode-line, header-line, frame-title
(setq-default
 header-line-format '(
                      "%e"
                      mode-line-front-space
                      mode-line-mule-info
                      mode-line-position
                      (vc-mode vc-mode)
                      " "
                      ;; mode-line-modes
                      mode-line-buffer-identification
                      ;; mode-line-misc-info
                      mode-line-end-spaces)
 mode-line-format '(
                    "%e"
                    mode-line-front-space
                    ;; mode-line-mule-info
                    ;; mode-line-position
                    ;; (vc-mode vc-mode)
                    mode-line-modes
                    ;; mode-line-buffer-identification
                    mode-line-misc-info
                    mode-line-end-spaces)
 frame-title-format ;; '(buffer-file-name "%f" "%b")
 '((:eval (concat
           "emacs-"
           emacs-version
           " "
           (if (and (boundp 'org-pomodoro-mode-line) org-pomodoro-mode-line)
               (if (listp org-pomodoro-mode-line)
                   (apply #'concat org-pomodoro-mode-line)
                 org-pomodoro-mode-line)
             "")
           (if (and (boundp 'org-mode-line-string) org-mode-line-string)
               org-mode-line-string
             "")
           (if (buffer-file-name)
               (abbreviate-file-name (buffer-file-name))
             "%b")))))

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

;;; frame
(add-hook 'after-init-hook #'blink-cursor-mode)

;;; tab-bar
(when (>= emacs-major-version 27)
  (setq tab-bar-show 1
        tab-bar-select-tab-modifiers '(meta)
        tab-bar-tab-hints t)

  ;; (setq tab-bar-tab-name-function
  ;;       (defun w/tab-bar-show-file-name ()
  ;;         (let* ((buffer (window-buffer (minibuffer-selected-window)))
  ;;                (file-name (buffer-file-name buffer)))
  ;;           (if file-name file-name (format "%s" buffer)))))

  (global-set-key (kbd "C-<tab>") #'tab-bar-switch-to-next-tab))

;;; window
(defun w/split-window-right ()
  "split-window-right with right window having a max width of 100 columns"
  (interactive)
  (if (> (window-total-width) 200)
      (split-window-right -100)
    (if (> (window-total-width) 180)
        (split-window-right -90)
      (split-window-right))))
(defun w/split-window-right-and-focus ()
  (interactive)
  (w/split-window-right)
  (other-window 1))
(global-set-key (kbd "M-SPC b b") #'switch-to-buffer)
(global-set-key (kbd "M-SPC b B") #'switch-to-buffer-other-window)
(global-set-key (kbd "M-SPC w D") #'delete-other-windows)
(global-set-key (kbd "M-SPC w S") #'w/split-window-right-and-focus)
(global-set-key (kbd "M-SPC w V") (defun w/split-window-and-focus () (interactive) (split-window-below) (other-window 1)))
(global-set-key (kbd "M-SPC w X") (defun w/swap-window-and-focus () (interactive) (window-swap-states) (other-window 1)))
(global-set-key (kbd "M-SPC w d") #'delete-window)
(global-set-key (kbd "M-SPC w s") #'w/split-window-right)
(global-set-key (kbd "M-SPC w v") #'split-window-below)
(global-set-key (kbd "M-SPC w x") #'window-swap-states)

;;; winner
(add-hook 'after-init-hook #'winner-mode)
(global-set-key (kbd "M-SPC w u") #'winner-undo)
(global-set-key (kbd "M-SPC w r") #'winner-redo)

(provide 'w-ui-minimal)

