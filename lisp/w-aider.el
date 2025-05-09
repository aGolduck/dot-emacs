;;; w-aider.el --- use aider with aidermacs          -*- lexical-binding: t; -*-

(straight-use-package '(aidermacs :host github :repo "MatthewZMD/aidermacs"))
(require 'auth-source)
(setenv "DEEPSEEK_API_KEY" (auth-source-pick-first-password :host "deepseek.com"))
(setenv "AIDER_COMMIT_PROMPT" "You are an expert software engineer that generates concise, \
one-line Git commit messages based on the provided diffs.
Review the provided context and diffs which are about to be committed to a git repo.
Review the diffs carefully.
Generate a one-line commit message for those changes.
The commit message should be structured as follows: [module] <type>: <description>
Use these for <type>: fix, feat, build, chore, ci, docs, style, refactor, perf, test

Ensure the commit message:
- Starts with the appropriate prefix.
- 使用中文写 commit 消息
- Is in the imperative mood (e.g., \"Add feature\" not \"Added feature\" or \"Adding feature\").
- Does not exceed 72 characters.
- commit 有详情列表，且不要超过三条
")

;; (setq aidermacs-backend 'vterm)
(setq aidermacs-default-model "deepseek")
;; deepseek-reasoner 和 deepseek-chat 的组合作用不大
;; (setq aidermacs-use-architect-mode t)
(setq aidermacs-architect-model "deepseek/deepseek-reasoner")
(setq aidermacs-editor-model "deepseek/deepseek-chat")
(setq aidermacs-show-diff-after-change nil)
(global-set-key (kbd "M-SPC a") 'aidermacs-transient-menu)

;; (setenv "OPENAI_API_BASE" "https://api.hunyuan.cloud.tencent.com/v1")
;; (setenv "OPENAI_API_KEY" (auth-source-pick-first-password :host "api.hunyuan.cloud.tencent.com"))
;; (setq aider-args '("--model" "openai/hunyuan-pro"))
;; (setq aider-args '("--no-auto-commits" "--model" "openai/hunyuan-pro"))
;; (setenv "OPENAI_API_BASE" "http://hunyuanapi.woa.com/openapi/v1")
;; (setenv "OPENAI_API_KEY" (auth-source-pick-first-password :host "hunyuanapi.woa.com"))
;; (setq aider-args '("--no-auto-commits" "--model" "openai/hunyuan-turbo" "--map-tokens" "1024"))
;; (setq aider-args '("--no-auto-commits" "--model" "deepseek/deepseek-reasoner"))
;; (setq aider-args '("--model" "deepseek/deepseek-reasoner"))
(setq aider-args '("--model" "deepseek/deepseek-chat"))

(provide 'w-aider)
