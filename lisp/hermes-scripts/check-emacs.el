;;; check-emacs.el --- 检测 Emacs 和 Org-mode 环境
;; 用法: emacs --batch -l check-emacs.el [MIN_ORG_VERSION]
;; 输出 JSON 格式的检测结果，方便 AI agent 解析
;; 示例: emacs --batch -l check-emacs.el 9.2

(require 'json)

(defvar hermes-min-org "9.2")
(when command-line-args-left
  (setq hermes-min-org (pop command-line-args-left)))

(let ((result (make-hash-table :test 'equal)))
  ;; Emacs 版本
  (puthash "emacs_version" emacs-version result)
  (puthash "emacs_major" emacs-major-version result)

  ;; Org 版本
  (condition-case nil
      (progn
        (require 'org)
        (puthash "org_version" org-version result)
        (puthash "org_available" t result))
    (error
     (puthash "org_available" nil result)
     (puthash "org_version" nil result)))

  ;; 版本比较
  (when (gethash "org_version" result)
    (let ((parts (split-string (gethash "org_version" result) "\\."))
          (min-parts (split-string hermes-min-org "\\.")))
      (puthash "org_version_ok"
               (version-list->= (version-to-list (gethash "org_version" result))
                                (version-to-list hermes-min-org))
               result)))

  ;; 关键函数可用性
  (puthash "has_org_todo" (fboundp 'org-todo) result)
  (puthash "has_org_schedule" (fboundp 'org-schedule) result)
  (puthash "has_org_entry_put" (fboundp 'org-entry-put) result)
  (puthash "has_org_map_entries" (fboundp 'org-map-entries) result)
  (puthash "has_org_capture" (fboundp 'org-capture) result)

  ;; 输出 JSON
  (princ (json-encode result))
  (princ "\n"))
