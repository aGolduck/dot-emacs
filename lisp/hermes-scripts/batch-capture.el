;;; batch-capture.el --- 通过 org-capture 模板创建结构化条目
;; 用法: emacs --batch -l batch-capture.el TEMPLATE_KEY ENTRY_TEXT [TARGET_FILE]
;; 参数：
;;   TEMPLATE_KEY  模板键（如 "t"、"n"、"j"）
;;   ENTRY_TEXT    条目内容（可含 %? 等占位符）
;;   TARGET_FILE   目标文件（可选，默认从模板解析）
;;
;; 示例：
;;   emacs --batch -l batch-capture.el t "* TODO \u4e70\u4e00\u628a\u5927\u4f1e\nSCHEDULED: <2026-04-28 Tue>\n:PROPERTIES:\n:AI_ACTION: remind\n:END:"

(require 'org)
(require 'org-capture)
(load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))

(defvar hermes-template-key nil)
(defvar hermes-entry-text nil)
(defvar hermes-target-file nil)

(setq hermes-template-key (pop command-line-args-left))
(setq hermes-entry-text (pop command-line-args-left))
(when command-line-args-left
  (setq hermes-target-file (pop command-line-args-left)))

(unless (and hermes-template-key hermes-entry-text)
  (error "用法: emacs --batch -l batch-capture.el TEMPLATE_KEY ENTRY_TEXT [TARGET_FILE]"))

(condition-case err
    (progn
      ;; 如果指定了目标文件，动态创建临时模板
      (if hermes-target-file
          (setq org-capture-templates
                (list (list hermes-template-key "batch" 'entry
                            (list 'file hermes-target-file)
                            hermes-entry-text)))
        ;; 否则使用现有模板（需要文件内或 init 中定义）
        (unless org-capture-templates
          (error "未提供目标文件且没有定义的 capture 模板")))

      ;; 执行 capture
      (org-capture-string hermes-entry-text hermes-template-key)
      (message "SUCCESS: captured with template '%s'" hermes-template-key))

  (error
   (message "ERROR: %s" (error-message-string err))
   (kill-emacs 1)))
