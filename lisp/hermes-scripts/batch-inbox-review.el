;;; batch-inbox-review.el --- 列出 inbox 中无 SCHEDULED 且无 DEADLINE 的 TODO 条目
;;
;; 用法：
;;   emacs --batch -l batch-inbox-review.el todo.org
;;   emacs --batch -l batch-inbox-review.el todo.org json   # JSON 输出（给 AI agent）

(load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))

(defun h/extract-item-info ()
  "Extract key info from current heading for review."
  (let ((todo (org-get-todo-state))
        (title (org-get-heading t t t t))
        (tags (org-get-tags))
        (energy (org-entry-get (point) "ENERGY"))
        (time-est (org-entry-get (point) "TIME")))
    (list :todo todo :title title :tags tags
          :energy energy :time time-est)))

(defun h/collect-inbox-no-date ()
  "Narrow to * inbox subtree, then collect all TODO items without SCHEDULED/DEADLINE."
  (let ((results nil))
    (goto-char (point-min))
    (when (re-search-forward "^\\* inbox" nil t)
      (org-narrow-to-subtree)
      (org-map-entries
       (lambda ()
         (let ((todo (org-get-todo-state))
               (sched (org-entry-get (point) "SCHEDULED"))
               (dead (org-entry-get (point) "DEADLINE")))
           (when (and todo
                      (not (member todo '("DONE" "CANCELLED")))
                      (not sched)
                      (not dead))
             (push (h/extract-item-info) results))))
       "LEVEL=2" 'tree)
      (widen))
    (when (null results)
      (message "Warning: inbox heading not found or has no matching items"))
    (nreverse results)))

;; ── Entry point ──
(let* ((args command-line-args-left)
       (output-json (member "json" args)))
  (find-file (car args))
  (let ((items (h/collect-inbox-no-date)))
    (if output-json
        (progn
          (princ "[\n")
          (dolist (item items)
            (let* ((title (replace-regexp-in-string "\"" "\\\\\"" (or (plist-get item :title) "")))
                   (tags (plist-get item :tags))
                   (tags-str (if tags (mapconcat #'identity tags ",") ""))
                   (energy (or (plist-get item :energy) ""))
                   (time-est (or (plist-get item :time) "")))
              (princ (format "  {\"title\": \"%s\", \"tags\": \"%s\", \"energy\": \"%s\", \"time\": \"%s\"}%s\n"
                             title tags-str energy time-est
                             (if (eq item (car (last items))) "" ",")))))
          (princ "]\n"))
      (progn
        (princ (format "=== Inbox 待处理 (%d 条) ===\n" (length items)))
        (dolist (item items)
          (let ((title (plist-get item :title))
                (tags (plist-get item :tags))
                (energy (or (plist-get item :energy) "-"))
                (time-est (or (plist-get item :time) "-")))
            (princ (format "  TODO %s\n" title))
            (when tags
              (princ (format "       标签: %s\n"
                             (mapconcat (lambda (tag) (concat ":" tag ":")) tags " "))))
            (princ (format "       精力: %s  耗时: %s\n\n" energy time-est))))))
    (message "Done. %d items." (length items))))

(provide 'batch-inbox-review)
;;; batch-inbox-review.el ends here
