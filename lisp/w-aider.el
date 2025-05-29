;;; w-aider.el --- use aider with aidermacs          -*- lexical-binding: t; -*-

(straight-use-package '(aidermacs :host github :repo "MatthewZMD/aidermacs"))
(require 'auth-source)

(setenv "AIDER_COMMIT_PROMPT" "You are an expert software engineer that generates concise, \
one-line Git commit messages based on the provided diffs.
Review the provided context and diffs which are about to be committed to a git repo.
Review the diffs carefully.
Generate a one-line commit message for those changes.

Ensure the commit message:
- 结构为 [module] <type>: 描述文字(Use these for <type>: fix, feat, build, chore, ci, docs, style, refactor, perf, test)
- 使用中文写 commit 消息
- Is in the imperative mood (e.g., \"Add feature\" not \"Added feature\" or \"Adding feature\").
- Does not exceed 72 characters.
- 如果变更比较复杂，commit 有详情列表，且不要超过三条，按重要性排序，每条以 - 开头
- 如果变更比较简单，则不需要详情列表
- commit 消息与详情列表中间必须有空行
")

;; (setq aidermacs-backend 'vterm)
(global-set-key (kbd "M-SPC a") 'aidermacs-transient-menu)

(setenv "OPENAI_API_BASE" "https://dashscope.aliyuncs.com/compatible-mode/v1")

(setenv "OPENROUTER_API_KEY" (auth-source-pick-first-password :host "openrouter.ai"))
(setenv "OPENAI_API_KEY" (auth-source-pick-first-password :host "dashscope.aliyuncs.com"))
(setenv "DEEPSEEK_API_KEY" (auth-source-pick-first-password :host "deepseek.com"))


;; 注意不要设置全局的 .aider.confg.yaml，否则以下的 default-model extra-args 等启动参数设置均会失效
;; 项目下如果 .aider.config.yaml 文件，这些参数设置也会失效
;; aidermacs 低版本无此参数，高版本(V1.2以下) commit 时进度条会卡住
;; (setq aidermacs-project-read-only-files '("CONVENTIONS.md"))
(setq aidermacs-auto-commits t)
;; extra-args 不能包含 model 设置
(setq aidermacs-extra-args '("--read" "CONVENTIONS.md"))

;; weak-mode 用于 commit message 和总结历史聊天，用便宜的 deepseek
(setq aidermacs-weak-model "deepseek")

(setq aidermacs-default-model "openrouter/anthropic/claude-opus-4")
(setq aidermacs-default-model "openrouter/anthropic/claude-sonnet-4")
;; o4-mini 调用一直失败
(setq aidermacs-default-model "openrouter/openai/o4-mini")
;; gemini 太啰嗦了，花长时间输出一大堆 thinking 才改好
(setq aidermacs-default-model "openrouter/google/gemini-2.5-pro-preview")
;; qwen 用着总感觉说不出的哪里不顺手
(setq aidermacs-default-model "openai/qwen3-235b-a22b")
;; 默认 deepseek, 便宜，总体没有大毛病
(setq aidermacs-default-model "deepseek")

;; When Architect mode is enabled, the `aidermacs-default-model` setting is ignored
(setq aidermacs-use-architect-mode nil)
(setq aidermacs-editor-model "openai/qwen3-235b-a22b")
(setq aidermacs-architect-model "deepseek/deepseek-reasoner")
;; (setq aidermacs-editor-model "deepseek/deepseek-chat")

(setq aidermacs-show-diff-after-change nil)

;;; 以下是残留的 aider.el 包的设置
;; (setenv "OPENAI_API_BASE" "https://api.hunyuan.cloud.tencent.com/v1")
;; (setenv "OPENAI_API_KEY" (auth-source-pick-first-password :host "api.hunyuan.cloud.tencent.com"))
;; (setq aider-args '("--model" "openai/hunyuan-pro"))
;; (setq aider-args '("--no-auto-commits" "--model" "openai/hunyuan-pro"))
;; (setenv "OPENAI_API_BASE" "http://hunyuanapi.woa.com/openapi/v1")
;; (setenv "OPENAI_API_KEY" (auth-source-pick-first-password :host "hunyuanapi.woa.com"))
;; (setq aider-args '("--no-auto-commits" "--model" "openai/hunyuan-turbo" "--map-tokens" "1024"))
;; (setq aider-args '("--no-auto-commits" "--model" "deepseek/deepseek-reasoner"))
;; (setq aider-args '("--model" "deepseek/deepseek-reasoner"))
;; (setq aider-args '("--model" "deepseek/deepseek-chat"))

(provide 'w-aider)

