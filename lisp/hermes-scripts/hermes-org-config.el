;;; hermes-org-config.el --- 统一 org 配置，确保 batch 与 Emacs 行为一致
;; 所有 batch 脚本开头先加载此文件（相对路径，同目录）：
;; (load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))
;;
;; 位置：~/.emacs.d/lisp/hermes-scripts/hermes-org-config.el
;; hermes-todo/scripts/ 是到此目录的 symlink
;;
;; Emacs 端在 w-org.el 中同步同等配置（须保持一致）

(require 'org)

;; ── TODO 关键词 ──
(setq org-todo-keywords
      '((sequence "TODO" "NEXT" "WAITING" "DELEGATED" "SOMEDAY" "|" "DONE" "CANCELLED")))

;; ── 状态-标签联动（与 Emacs 端 w-org.el 逐条对齐，修改须同步）──
(setq org-todo-state-tags-triggers
      '(("CANCELLED" ("CANCELLED" . t))
        ("WAITING" ("WAITING" . t))
        ("DELEGATED" ("WAITING" . t))
        ("SOMEDAY" ("WAITING") ("CANCELLED"))
        (done ("WAITING"))
        ("TODO" ("WAITING") ("CANCELLED"))
        ("NEXT" ("WAITING") ("CANCELLED"))
        ("DONE" ("WAITING") ("CANCELLED"))))

;; ── DONE 自动加 CLOSED ──
(setq org-log-done 'time)

;; ── 归档位置（与 Emacs 端 w-org.el 一致）──
(setq org-archive-location "%s_archive::* Archived Tasks")
(setq org-archive-mark-done nil)

;; ── Stuck Project 定义（与 Emacs 端一致）──
(setq org-stuck-projects '("+LEVEL>1/-DONE-CANCELLED" ("NEXT") nil ""))

;; ── 全局属性（Effort 估计）──
(setq org-global-properties
      '(("Effort_ALL" . "0 0:05 0:10 0:20 0:30 1:00 2:00 3:00 4:00 5:00 6:00 7:00")))

(provide 'hermes-org-config)
;;; hermes-org-config.el ends here
