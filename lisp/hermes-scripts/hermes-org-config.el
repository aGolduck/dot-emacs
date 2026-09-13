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
;;
;; ⚠️ org-ledger canonical 契约（六变量）──────────────────────────────────────
;; ~/s/org-ledger 的 Elisp 应用器跑 `emacs -Q --batch`（不带本配置），改为**自带并 pin**
;; 下列变量、启动时断言（ADR-014 ⑤ / docs/02-data-model.md「配置 pin」）。
;; 本文件是同一套值的**真机侧副本**：两处必须同值，改一处必须同步另一处——
;; 否则 AI 写入（应用器）与人工写入（本配置）风格分叉，账本出现两种格式。
;;   system-time-locale            "C"   否则中文 locale 下 CLOSED 写成「周五」
;;   org-log-done                  time  DONE 写 CLOSED（账本 63 处）
;;   org-todo-state-tags-triggers  ↓     状态-标签联动（账本 26 处 :CANCELLED:）
;;   org-tags-column               67    必须正值，理由见下
;;   org-adapt-indentation         nil   正文零缩进（账本 depth≥2 实测 322/323 处为 0）
;;   org-archive-location          不设   账本 #+ARCHIVE 指令优先，默认值与之一致

(require 'org)

;; ── 时间戳使用英文星期（覆盖 LC_TIME=zh_CN 的影响，batch 与 GUI 一致）──
(setq system-time-locale "C")

;; ── 标签对齐列：必须用正值 ──
;; 负值随 window-width 漂移：batch 下 window-width=80，-77 实测把标签推到起始列 70，
;; 而 GUI（约 133 列）下是 56 —— 同一份配置产出两种格式。
;; 正值是绝对列。67 = 账本 136 个带标签 headline 标签起始「显示列」的加权中位数
;; （改动 93/136 行，中文按双宽计）。60 会动 136 行，偏差是 67 的 3.4 倍。
(setq org-tags-column 67)

;; ── 正文缩进：账本实测 depth≥2 的正文前导空格全为 0 ──
(setq org-adapt-indentation nil)

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
;; org-archive-location 不在此设置：账本文件头 #+ARCHIVE 指令优先，且默认值与之一致

;; ── Stuck Project 定义 ──
(setq org-stuck-projects '("+LEVEL>1/-DONE-CANCELLED" ("NEXT") nil ""))

(provide 'hermes-org-config)
;;; hermes-org-config.el ends here
