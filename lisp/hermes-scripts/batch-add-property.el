;;; batch-add-property.el --- 给指定条目添加/修改属性
;; 用法: emacs --batch -l batch-add-property.el FILE "任务标题" "KEY" "VALUE"
;; 参数: 文件路径 任务标题正则 属性名 属性值

(require 'org)
(load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))

(defvar hermes-file nil)
(defvar hermes-heading nil)
(defvar hermes-key nil)
(defvar hermes-value nil)

(setq hermes-file (pop command-line-args-left))
(setq hermes-heading (pop command-line-args-left))
(setq hermes-key (pop command-line-args-left))
(setq hermes-value (pop command-line-args-left))

(unless (and hermes-file hermes-heading hermes-key)
  (error "用法: emacs --batch -l batch-add-property.el FILE HEADING KEY [VALUE]"))

(find-file hermes-file)

(condition-case err
    (progn
      (goto-char (point-min))
      (unless (re-search-forward (concat "^\\*+ .*" (regexp-quote hermes-heading)) nil t)
        (error "未找到条目: %s" hermes-heading))
      (org-back-to-heading t)
      (if hermes-value
          (org-entry-put (point) hermes-key hermes-value)
        (org-entry-delete (point) hermes-key))
      (save-buffer)
      (message "SUCCESS: %s -> %s=%s" hermes-heading hermes-key (or hermes-value "DELETED")))
  (error
   (message "ERROR: %s" (error-message-string err))
   (kill-emacs 1)))
