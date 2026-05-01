;;; batch-schedule.el --- 批量设置 SCHEDULED 或 DEADLINE
;; 用法: emacs --batch -l batch-schedule.el FILE "任务标题" SCHEDULED "2026-05-01"
;;       emacs --batch -l batch-schedule.el FILE "任务标题" DEADLINE "2026-05-01"
;;       emacs --batch -l batch-schedule.el FILE "任务标题" SCHEDULED REMOVE
;; 参数: 文件路径 任务标题正则 类型(SCHEDULED|DEADLINE) 日期(或 REMOVE)

(require 'org)
(load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))

(defvar hermes-file nil)
(defvar hermes-heading nil)
(defvar hermes-type nil)
(defvar hermes-date nil)

(setq hermes-file (pop command-line-args-left))
(setq hermes-heading (pop command-line-args-left))
(setq hermes-type (pop command-line-args-left))
(setq hermes-date (pop command-line-args-left))

(unless (and hermes-file hermes-heading hermes-type)
  (error "用法: emacs --batch -l batch-schedule.el FILE HEADING TYPE DATE"))

(find-file hermes-file)

(condition-case err
    (progn
      (goto-char (point-min))
      (unless (re-search-forward (concat "^\\*+ .*" (regexp-quote hermes-heading)) nil t)
        (error "未找到条目: %s" hermes-heading))
      (org-back-to-heading t)
      (cond
       ((string= (upcase hermes-type) "SCHEDULED")
        (if (string= (upcase hermes-date) "REMOVE")
            (org-schedule (quote (4)))
          (org-schedule nil hermes-date)))
       ((string= (upcase hermes-type) "DEADLINE")
        (if (string= (upcase hermes-date) "REMOVE")
            (org-deadline (quote (4)))
          (org-deadline nil hermes-date)))
       (t (error "类型必须是 SCHEDULED 或 DEADLINE: %s" hermes-type)))
      (save-buffer)
      (message "SUCCESS: %s %s %s" hermes-heading hermes-type (or hermes-date "REMOVED")))
  (error
   (message "ERROR: %s" (error-message-string err))
   (kill-emacs 1)))
