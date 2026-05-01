;;; batch-todo-state.el --- 批量切换 TODO 状态（使用共享配置确保与 Emacs 一致）
;; 用法: emacs --batch -l batch-todo-state.el FILE "任务标题" "DONE"
;; 参数: 文件路径 任务标题正则 目标状态

(require 'org)
(load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))

(defvar hermes-file nil)
(defvar hermes-heading nil)
(defvar hermes-state nil)

(setq hermes-file (pop command-line-args-left))
(setq hermes-heading (pop command-line-args-left))
(setq hermes-state (pop command-line-args-left))

(unless (and hermes-file hermes-heading hermes-state)
  (error "用法: emacs --batch -l batch-todo-state.el FILE HEADING STATE"))

(find-file hermes-file)

(condition-case err
    (progn
      (goto-char (point-min))
      (unless (re-search-forward (concat "^\\*+ .*" (regexp-quote hermes-heading)) nil t)
        (error "未找到条目: %s" hermes-heading))
      (org-back-to-heading t)
      ;; 统一走 org-todo-state-tags-triggers，不再手动 sync
      (org-todo hermes-state)
      (save-buffer)
      (message "SUCCESS: %s -> %s" hermes-heading hermes-state))
  (error
   (message "ERROR: %s" (error-message-string err))
   (kill-emacs 1)))
