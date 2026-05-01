;;; batch-reminder-scan.el --- 扫描到期任务并标记已提醒
;; 用法: emacs --batch -l batch-reminder-scan.el FILE [PROPERTY_NAME]
;; 默认给所有到期且未标记的 TODO 添加 :NOTIFIED_AT: 属性
;; 可通过 org-map-entries 的 MATCH 参数调整触发条件

(require 'org)
(load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))

(defvar hermes-file nil)
(defvar hermes-property "NOTIFIED_AT")

(setq hermes-file (pop command-line-args-left))
(when command-line-args-left
  (setq hermes-property (pop command-line-args-left)))

(unless hermes-file
  (error "用法: emacs --batch -l batch-reminder-scan.el FILE [PROPERTY]"))

(find-file hermes-file)

(let ((count 0)
      (now (format-time-string "%Y-%m-%dT%H:%M:%S")))
  (condition-case err
      (progn
        (org-map-entries
         (lambda ()
           (unless (org-entry-get (point) hermes-property)
             (org-entry-put (point) hermes-property now)
             (setq count (1+ count))
             (message "MARKED: %s" (org-get-heading t t t t))))
         "TODO=\"TODO\"+DEADLINE<\"<now>\""
         (quote file))
        (save-buffer)
        (message "DONE: 标记了 %d 个到期任务" count))
    (error
     (message "ERROR: %s" (error-message-string err))
     (kill-emacs 1))))
