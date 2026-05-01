;;; batch-add-todo.el --- 新增 TODO 条目（统一入口）
;; 用法: emacs --batch -l batch-add-todo.el FILE "标题" [OPTIONS]
;; 参数（顺序固定）：
;;   FILE      文件路径
;;   TITLE     任务标题
;;   STATE     TODO 状态，默认 "TODO"
;;   PRIORITY  优先级 A/B/C，默认无
;;   SCHEDULED SCHEDULED 日期，格式 2026-04-28，默认无
;;   DEADLINE  DEADLINE 日期，格式 2026-04-28，默认无
;;   TAGS      标签，格式 "tag1:tag2"，默认无
;;   PARENT    父条目标题（在此条目下插入），默认在文件末尾追加
;;   PROPS     属性 JSON，格式 '{"KEY1":"val1","KEY2":"val2"}'，默认无
;;   BODY      正文内容，默认无
;;
;; 示例：
;;   emacs --batch -l batch-add-todo.el todo.org "买一把大伞" "TODO" "A" "2026-04-28" "" "life:urgent" "" '{"AI_ACTION":"remind"}' "不要忘了带钥匙"

(require 'org)
(require 'json)
(load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))

(defvar hermes-file nil)
(defvar hermes-title nil)
(defvar hermes-state "TODO")
(defvar hermes-priority nil)
(defvar hermes-scheduled nil)
(defvar hermes-deadline nil)
(defvar hermes-tags nil)
(defvar hermes-parent nil)
(defvar hermes-props nil)
(defvar hermes-body nil)

;; 解析参数
(setq hermes-file (pop command-line-args-left))
(setq hermes-title (pop command-line-args-left))
(when command-line-args-left (setq hermes-state (pop command-line-args-left)))
(when command-line-args-left (setq hermes-priority (pop command-line-args-left)))
(when command-line-args-left (setq hermes-scheduled (pop command-line-args-left)))
(when command-line-args-left (setq hermes-deadline (pop command-line-args-left)))
(when command-line-args-left (setq hermes-tags (pop command-line-args-left)))
(when command-line-args-left (setq hermes-parent (pop command-line-args-left)))
(when command-line-args-left (setq hermes-props (pop command-line-args-left)))
(when command-line-args-left (setq hermes-body (pop command-line-args-left)))

(unless (and hermes-file hermes-title)
  (error "用法: emacs --batch -l batch-add-todo.el FILE TITLE [STATE] [PRIORITY] [SCHEDULED] [DEADLINE] [TAGS] [PARENT] [PROPS] [BODY]"))

(condition-case err
    (progn
      (find-file hermes-file)

      (if (and hermes-parent (not (string= hermes-parent "")))
          ;; 模式 1：在指定父条目下插入子级 heading
          (progn
            (goto-char (point-min))
            (unless (re-search-forward (concat "^\\*+ .*" (regexp-quote hermes-parent)) nil t)
              (error "未找到父条目: %s" hermes-parent))
            (org-back-to-heading t)
            ;; 移动到当前子树末尾
            (org-end-of-subtree t t)
            ;; 插入子级 heading（比父级多一个星号）
            (let ((parent-level (org-current-level)))
              (insert "\n" (make-string (1+ parent-level) ?*) " ")))

        ;; 模式 2：文件末尾追加
        (progn
          (goto-char (point-max))
          ;; 确保尾部有换行
          (unless (bolp) (insert "\n"))
          ;; 判断最后一个 heading 的层级，默认用 1 级
          (let ((level 1))
            (save-excursion
              (when (re-search-backward "^\\(\\*+\\) " nil t)
                (setq level (length (match-string 1)))))
            (insert (make-string level ?*) " "))))

      ;; 设置 TODO 状态
      (when (and hermes-state (not (string= hermes-state "")))
        (insert hermes-state " "))

      ;; 设置优先级
      (when (and hermes-priority (not (string= hermes-priority "")))
        (insert "[#" hermes-priority "] "))

      ;; 标题
      (insert hermes-title)

      ;; 标签
      (when (and hermes-tags (not (string= hermes-tags "")))
        (insert " :" hermes-tags ":"))

      (insert "\n")

      ;; 返回到新建条目的 heading 行
      (org-back-to-heading t)

      ;; 设置 SCHEDULED
      (when (and hermes-scheduled (not (string= hermes-scheduled "")))
        (org-schedule nil hermes-scheduled))

      ;; 设置 DEADLINE
      (when (and hermes-deadline (not (string= hermes-deadline "")))
        (org-deadline nil hermes-deadline))

      ;; 设置属性
      (when (and hermes-props (not (string= hermes-props "")))
        (let ((props-alist (json-read-from-string hermes-props)))
          (mapc (lambda (pair)
                  (org-entry-put (point) (symbol-name (car pair)) (cdr pair)))
                props-alist)))

      ;; 添加正文
      (when (and hermes-body (not (string= hermes-body "")))
        (org-end-of-subtree t t)
        (insert hermes-body "\n"))

      (save-buffer)
      (message "SUCCESS: 新增任务 '%s'" hermes-title))

  (error
   (message "ERROR: %s" (error-message-string err))
   (kill-emacs 1)))
