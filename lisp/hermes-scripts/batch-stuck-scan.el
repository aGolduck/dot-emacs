;;; batch-stuck-scan.el --- 扫描卡住的 Project（有子任务但无 NEXT）
;; 用法: emacs --batch -l batch-stuck-scan.el FILE [OUTPUT-FORMAT]
;; OUTPUT-FORMAT: "plain"(默认) | "json"

(require 'org)
(load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))

(defvar hermes-file nil)
(defvar hermes-format "plain")

(setq hermes-file (pop command-line-args-left))
(when command-line-args-left
  (setq hermes-format (pop command-line-args-left)))

(unless hermes-file
  (error "用法: emacs --batch -l batch-stuck-scan.el FILE [OUTPUT-FORMAT]"))

;; 判断是否是 project：level >= 2 且有带 TODO 关键词的子 heading
(defun hermes/is-project-p ()
  "检查当前 heading 是否是 project。要求 level >= 2，且有带 TODO 关键词的子 heading。"
  (when (>= (or (org-current-level) 0) 2)
    (save-excursion
      (save-restriction
        (org-narrow-to-subtree)
        (let ((has-subtask nil)
              (subtree-end (point-max)))
          (forward-line 1)
          (while (and (not has-subtask)
                      (< (point) subtree-end)
                      (re-search-forward "^\\*+ " subtree-end t))
            (when (org-get-todo-state)
              (setq has-subtask t)))
          has-subtask)))))

;; 检查 project 下是否有 NEXT 状态的子任务
(defun hermes/has-next-subtask-p ()
  "检查当前 project 下是否有 NEXT 状态的子任务。"
  (save-excursion
    (save-restriction
      (org-narrow-to-subtree)
      (let ((has-next nil)
            (subtree-end (point-max)))
        (forward-line 1)
        (while (and (not has-next)
                    (< (point) subtree-end)
                    (re-search-forward "^\\*+ " subtree-end t))
          (when (string= (org-get-todo-state) "NEXT")
            (setq has-next t)))
        has-next))))

(find-file hermes-file)

(condition-case err
    (let ((stuck-projects nil)
          (total-projects 0))
      (org-map-entries
       (lambda ()
         (when (hermes/is-project-p)
           (setq total-projects (1+ total-projects))
           (unless (hermes/has-next-subtask-p)
             (let ((heading (org-get-heading t t t t))
                   (level (org-current-level))
                   (line (line-number-at-pos (point))))
               (push (list :heading heading :level level :line line) stuck-projects)))))
       nil 'file)

      (setq stuck-projects (reverse stuck-projects))

      (if (string= hermes-format "json")
          ;; JSON 输出
          (progn
            (princ "[\n")
            (let ((first t))
              (dolist (proj stuck-projects)
                (unless first (princ ",\n"))
                (setq first nil)
                (princ (format "  {\"heading\":\"%s\",\"level\":%d,\"line\":%d}"
                               (plist-get proj :heading)
                               (plist-get proj :level)
                               (plist-get proj :line)))))
            (princ "\n]\n"))

        ;; Plain text 输出
        (message "总计 Project: %d" total-projects)
        (message "卡住 Project: %d" (length stuck-projects))
        (message "============================")
        (dolist (proj stuck-projects)
          (message "[第%d行 L%d] %s"
                   (plist-get proj :level)
                   (plist-get proj :line)
                   (plist-get proj :heading)))
        (message "============================"))

      ;; 退出码：有卡住项目则返回 2，无则返回 0
      (kill-emacs (if stuck-projects 2 0)))

  (error
   (message "ERROR: %s" (error-message-string err))
   (kill-emacs 1)))
