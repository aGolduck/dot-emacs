;;; batch-archive-done.el --- 自动归档已完成的任务
;; 用法: emacs --batch -l batch-archive-done.el FILE [DAYS]
;; 默认归档 7 天前已完成的任务
;; 参数: 文件路径 [天数，默认 7]

(require 'org)
(load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))

(defvar hermes-file nil)
(defvar hermes-days 7)

(setq hermes-file (pop command-line-args-left))
(when command-line-args-left
  (setq hermes-days (string-to-number (pop command-line-args-left))))

(unless hermes-file
  (error "用法: emacs --batch -l batch-archive-done.el FILE [DAYS]"))

(find-file hermes-file)

(let ((cutoff (time-subtract (current-time) (days-to-time hermes-days)))
      (count 0))
  (condition-case err
      (progn
        ;; 从后向前遍历，避免归档时影响位置
        (goto-char (point-max))
        (while (re-search-backward "^\\*+ DONE" nil t)
          (org-back-to-heading t)
          (let* ((closed-str (org-entry-get (point) "CLOSED"))
                 (closed-time (and closed-str (org-parse-time-string closed-str))))
            (when (and closed-time
                       (time-less-p (apply 'encode-time closed-time) cutoff))
              (org-archive-subtree)
              (setq count (1+ count))
              (message "ARCHIVED: %s" (or (org-get-heading t t t t) "unknown")))))
        (org-save-all-org-buffers)
        (message "DONE: 归档了 %d 个任务" count))
    (error
     (message "ERROR: %s" (error-message-string err))
     (kill-emacs 1))))
