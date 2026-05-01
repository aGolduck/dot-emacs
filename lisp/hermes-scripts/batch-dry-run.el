;;; batch-dry-run.el --- dry-run 预览脚本（示例模板）
;; 用法: 将此逻辑复制到需要 dry-run 的脚本中
;; 原则：将 (save-buffer) 替换为 (message "DRY-RUN: 将保存以下变更...")
;;
;; 示例模式（在 batch-todo-state.el 中复制）：
;;
;;   (defvar hermes-dry-run nil)
;;   (when (and command-line-args-left
;;              (string= (car command-line-args-left) "--dry-run"))
;;     (setq hermes-dry-run t)
;;     (pop command-line-args-left))
;;
;;   ;; 在操作完成后：
;;   (if hermes-dry-run
;;       (progn
;;         (message "DRY-RUN: 将切换 '%s' 的状态为 '%s'" hermes-heading hermes-state)
;;         (message "DRY-RUN: 将写入 CLOSED: %s"
;;                  (format-time-string "[%Y-%m-%d %a %H:%M]"))
;;         (message "DRY-RUN: 文件不会被修改"))
;;     (save-buffer)
;;     (message "SUCCESS: %s -> %s" hermes-heading hermes-state))
;;
;; 对于删除/移动/归档等破坏性操作，建议始终先运行 dry-run，确认无误后再执行真实操作。

(message "DRY-RUN template loaded. Copy logic into your script.")
