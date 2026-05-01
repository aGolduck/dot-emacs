;;; hermes-org-config.el --- 统一 org 配置，batch 脚本与 Emacs GUI 唯一信息源
;; 所有 batch 脚本开头先加载此文件（相对路径，同目录）：
;; (load (expand-file-name "hermes-org-config.el" (file-name-directory load-file-name)))
;;
;; w-org.el 通过 load-file 加载此文件：
;; (load-file (expand-file-name "lisp/hermes-scripts/hermes-org-config.el" user-emacs-directory))
;;
;; 位置：/data/home/bingezhou/.emacs.d/lisp/hermes-scripts/hermes-org-config.el
;; hermes-todo/scripts/ 是到此目录的 symlink
;;
;; 注意：TODO 关键词不在此定义——由 todo.org 文件头 #+TODO: 统一管理

(require 'org)

;; ── 状态-标签联动 ──
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

;; ── 归档时行为 ──
(setq org-archive-mark-done nil)          ; 归档后保持原状态

;; ── Stuck Project 定义 ──
(setq org-stuck-projects '("+LEVEL>1/-DONE-CANCELLED" ("NEXT") nil ""))

(provide 'hermes-org-config)
;;; hermes-org-config.el ends here
