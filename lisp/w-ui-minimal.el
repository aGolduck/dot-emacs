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
           ;; FIXME buffer-file-name for dired buffer is nil
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
(setq frame-inhibit-implied-resize t ;; stop resizing when toggling tab-bar-mode
      frame-resize-pixelwise t)
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
(setq next-screen-context-lines 5)
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
;; 切换窗口时闪烁
(setq pulse-delay 0.05
      pulse-iterations 10)
(with-eval-after-load 'pulse
  ;; TODO 调色彩
  (set-face-attribute 'pulse-highlight-start-face nil :background "red"))
(defun w/闪烁上下文 (&rest _)
  ;; TODO 考虑光标在文件结尾处的情况
  (let ((saved-point (point))
        (start-point nil)
        (end-point nil))
    (beginning-of-line)
    (setq start-point (point))
    (forward-char 80)
    (end-of-line)
    (setq end-point (point))
    (pulse-momentary-highlight-region start-point end-point)
    (goto-char saved-point)))
;; TODO 尽量不要搞 dirty hack, 自主可控的入口复合函数即可, advice-add 仅适用于有不可控的系统或第三方代码
(advice-add 'other-window :after #'w/闪烁上下文)
;; dedicated window
;; copied from https://emacs.stackexchange.com/questions/58590/why-set-window-dedicated-p-doesnt-work-with-certain-buffers
(defun toggle-current-window-dedication-and-fix ()
  (interactive)
  (let* ((window    (selected-window))
         (dedicated-and-fixed-p (window-dedicated-p window)))
    (set-window-dedicated-p window (not dedicated-and-fixed-p))
    (set-window-parameter window 'no-delete-other-windows (not dedicated-and-fixed-p))
    (message "Window fixed and %sdedicated to %s"
             (if dedicated-and-fixed-p "no longer " "")
             (buffer-name))))

(defun toggle-current-window-dedication-and-fix ()
  (interactive)
  (let* ((window    (selected-window))
         (dedicated-and-fixed-p (window-dedicated-p window)))
    (set-window-dedicated-p window (not dedicated-and-fixed-p))
    (set-window-parameter window 'no-delete-other-windows (not dedicated-and-fixed-p))
    (message "Window fixed and %sdedicated to %s"
             (if dedicated-and-fixed-p "no longer " "")
             (buffer-name))))

;;; winner
(add-hook 'after-init-hook #'winner-mode)
(global-set-key (kbd "M-SPC w u") #'winner-undo)
(global-set-key (kbd "M-SPC w r") #'winner-redo)

;; others
(defvaralias 'scratch-major-mode 'initial-major-mode)
(setq initial-major-mode 'fundamental-mode
      mac-command-modifier 'super
      mac-option-modifier 'meta
      visible-bell t
      word-wrap-by-category t)
(setq-default indent-tabs-mode nil
	      line-spacing 0.2)


(provide 'w-ui-minimal)

