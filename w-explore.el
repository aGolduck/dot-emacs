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

(straight-use-package '(aidermacs :host github :repo "MatthewZMD/aidermacs"))
;; (setq aidermacs-backend 'vterm)
(setq aidermacs-default-model "deepseek")
;; deepseek-reasoner 和 deepseek-chat 的组合作用不大
;; (setq aidermacs-use-architect-mode t)
(setq aidermacs-architect-model "deepseek/deepseek-reasoner")
(setq aidermacs-editor-model "deepseek/deepseek-chat")
(setq aidermacs-show-diff-after-change nil)
(global-set-key (kbd "M-SPC a") 'aidermacs-transient-menu)

(straight-use-package '(aider :host github :repo "tninja/aider.el" :files ("aider.el")))
;; (setenv "OPENAI_API_BASE" "https://api.hunyuan.cloud.tencent.com/v1")
;; (setenv "OPENAI_API_KEY" (auth-source-pick-first-password :host "api.hunyuan.cloud.tencent.com"))
;; (setq aider-args '("--model" "openai/hunyuan-pro"))
;; (setq aider-args '("--no-auto-commits" "--model" "openai/hunyuan-pro"))
(setenv "OPENAI_API_BASE" "http://hunyuanapi.woa.com/openapi/v1")
(setenv "OPENAI_API_KEY" (auth-source-pick-first-password :host "hunyuanapi.woa.com"))
;; (setq aider-args '("--no-auto-commits" "--model" "openai/hunyuan-turbo" "--map-tokens" "1024"))
;; (setq aider-args '("--no-auto-commits" "--model" "deepseek/deepseek-reasoner"))
;; (setq aider-args '("--model" "deepseek/deepseek-reasoner"))
(setq aider-args '("--model" "deepseek/deepseek-chat"))


(straight-use-package 'gptel)
;; (setq gptel-backend (gptel-make-openai "hunyuan-pro"
;;                       :key 'gptel-api-key
;;                       :host "api.hunyuan.cloud.tencent.com"
;;                       :models '(hunyuan-pro))
;;       gptel-model 'hunyuan-pro
;;       gptel-prompt-prefix-alist '((markdown-mode . "## ")
;;                                   (org-mode . "** ")))
(setq gptel-backend (gptel-make-openai "hunyuan"
                      :key 'gptel-api-key
                      :host "hunyuanapi.woa.com"
                      :endpoint "/openapi/v1/chat/completions"
                      :protocol "http"
                      :stream t
                      :models '(hunyuan-code hunyuan-turbo hunyuan-large))
      gptel-org-branching-context t
      gptel-model 'hunyuan-turbo
      gptel-default-mode 'markdown-mode
      gptel-prompt-prefix-alist '((markdown-mode . "## ")
                                  (org-mode . "** ")))
(with-eval-after-load 'gptel
  (setf (alist-get 'org-mode gptel-prompt-prefix-alist) "@user\n")
  (setf (alist-get 'org-mode gptel-response-prefix-alist) "@assistant\n"))

(straight-use-package '(shell-maker :host github :repo "xenodium/shell-maker"))
(straight-use-package '(chatgpt-shell :host github :repo "xenodium/chatgpt-shell" :files ("*")))
(require 'auth-source)
(setq chatgpt-shell-api-url-base "https://api.hunyuan.cloud.tencent.com"
      chatgpt-shell-openai-key (auth-source-pick-first-password :host "api.hunyuan.cloud.tencent.com")
      chatgpt-shell-model-version "hunyuan-pro")

(with-eval-after-load 'chatgpt-shell
  (add-to-list 'chatgpt-shell-models
               (chatgpt-shell-openai-make-model
                :version "hunyuan-pro"
                :token-width 3
                :context-window 128000)))


(straight-use-package '(uniline-mode :host github :repo "tbanel/uniline"))

(defun join-numbers-with-comma-and-sort ()
  "把多行数字拼接成排序好的用逗号连接的字符串"
  (interactive)
  (when (region-active-p)
    (let* ((start (region-beginning))
           (end (region-end))
           (text (buffer-substring-no-properties start end)))

      ;; TODO copy to system clipboard
      (message
       (mapconcat 'number-to-string
                  (sort
                   (mapcar 'string-to-number
                           (split-string (replace-regexp-in-string "\n" "\n" text) "\n"))
                   '<)
                  ",")))))

;;; pulsar 只会高亮当前行，当前行字数太少时不明显，不如自己定制的
;; (straight-use-package 'pulsar)
;; (setq pulsar-pulse t)
;; (setq pulsar-delay 0.055)
;; (setq pulsar-iterations 10)
;; (setq pulsar-face 'pulsar-magenta)
;; (setq pulsar-face 'pulsar-red)
;; (setq pulsar-highlight-face 'pulsar-yellow)
;; (pulsar-global-mode 1)
;; (add-to-list 'pulsar-pulse-functions #'ace-window)

;; 禁用从右往左的编辑模式可明显加速超长行显示，见 https://emacs-china.org/t/topic/25811/9
;; doom-emacs 也提供了另外的方案，是基于 `bidi-display-reordering' 的文档给出的建议
;; 哪个效果更好未知
;; (setq-default bidi-display-reordering 'left-to-right
;;               bidi-paragraph-direction 'left-to-right)
;; (setq bidi-inhibit-bpa t)
(setq-default bidi-display-reordering nil)
(setq bidi-inhibit-bpa t
      long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)

(straight-use-package 'string-inflection)
(straight-use-package '(opencc :type git :host github :repo "xuchunyang/emacs-opencc"))
(straight-use-package '(dape :type git :host github :repo "svaante/dape"))
(require 'dape)
(add-to-list 'dape-configs
             `(debugpy
               modes (python-ts-mode python-mode)
               command "python3"
               command-args ("-m" "debugpy.adapter")
               :type "executable"
               :request "launch"
               :cwd dape-cwd-fn
               :program dape-find-file-buffer-default))

;; (add-to-list 'auto-mode-alist '("\\.jmod\\'" . archive-mode))
;; (add-to-list 'jka-compr-compression-info-list
;;              ["\\.jmod\\'"
;;               nil
;;               nil
;;               nil
;;               nil
;;               "unzip"
;;               ("-q" "-c")
;;               nil
;;               nil
;;               "JM"
;;               ])

;; (require 'dired-aux)
;; (add-to-list 'dired-compress-file-suffixes '("\\.jmod\\'" "" "unzip -o -d %o %i"))

(setq zotero-random-current-pane-item-views "
var iv = Zotero.getActiveZoteroPane().itemsView;
await iv.selectItem(iv.getRow(Zotero.Utilities.rand(0, iv.rowCount - 1)).id);
")

;; const searchCondition = new Zotero.Search()
;; searchCondition.libraryID = Zotero.Libraries.userLibraryID;
;; const itemIDs = await searchCondition.search()
;; const zoteroPane = Zotero.getActiveZoteroPane();
;; zoteroPane.selectItem(itemIDs[1])
;; https://www.zotero.org/support/dev/client_coding/javascript_api
(defun zotero-random ()
  (interactive)
  (let ((url-request-method "POST")
        (url-request-extra-headers '(("Content-Type" . "application/javascript")
                                     ("Authorization" . "Bearer eingoh3OoD-ae")))
        (url-request-data zotero-random-current-pane-item-views)
        (url-show-status nil))
    (url-retrieve-synchronously "http://127.0.0.1:23119/debug-bridge/execute"))
  (ns-do-applescript "tell application \"Zotero\" to activate"))

(defun file-random ()
  (interactive)
  (shell-command "fd -t f . ~ -0 | shuf -zn1 | xargs -0 open -R"))

(straight-use-package 'curl-to-elisp)

(with-eval-after-load 'eglot
  )

(setq doc-view-resolution 163
      doc-view-mupdf-use-svg nil)

;; pdf-tools 安装失败
;; (setenv "PKG_CONFIG_PATH" "/usr/local/opt/zlib/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/Cellar/poppler/23.08.0/lib/pkgconfig")
;; (straight-use-package 'pdf-tools)
;; (pdf-tools-install)

;; (straight-use-package 'esxml)
;; (straight-use-package 'nov.el)
;; (add-to-list 'auto-mode-alist '("\\.epub'" . nov-mode))
;; (defun nov--content-epub2-files (content manifest files)
;;     (let* ((node (esxml-query "package>spine[toc]" content))
;;            (id (esxml-node-attribute 'toc node)))
;;       (when (not id)
;;         (throw 'error "EPUB 2 NCX ID not found"))
;;       (setq nov-toc-id (intern id))
;;       (let ((toc-file (assq nov-toc-id manifest)))
;;         (when (not toc-file)
;;           (throw 'error "EPUB 2 NCX file not found"))
;;         (cons toc-file files))))
;; (defun nov--content-epub3-files (content manifest files)
;;   (let* ((node (esxml-query "package>manifest>item[properties~=nav]" content))
;;          (id (esxml-node-attribute 'id node)))
;;     (when (not id)
;;       (throw 'error "EPUB 3 <nav> ID not found"))
;;     (setq nov-toc-id (intern id))
;;     (let ((toc-file (assq nov-toc-id manifest)))
;;       (when (not toc-file)
;;         (throw 'error "EPUB 3 <nav> file not found"))
;;       (setq files (--remove (eq (car it) nov-toc-id) files))
;;       (cons toc-file files))))
;; (defun nov-content-files (directory content)
;;     "Create correctly ordered file alist for CONTENT in DIRECTORY.
;; Each alist item consists of the identifier and full path."
;;     (let* ((manifest (nov-content-manifest directory content))
;;            (spine (nov-content-spine content))
;;            (files (mapcar (lambda (item) (assq item manifest)) spine)))
;;       (catch 'error (nov--content-epub3-files content manifest files))
;;       (catch 'error (nov--content-epub2-files content manifest files))))



(define-skeleton gpt-template
  "docstring: chatgpt template"
  "prompt"
  "you are chatgpt"
  )

(define-skeleton hello-world-skeleton
  "Write a greeting"
  "Type name of user: "
  "hello, " str "!")

(defun w/uncomment-console-logging ()
  (interactive)
  (beginning-of-buffer)
  (replace-string "// console" "console"))

(defun w/comment-out-console-logging ()
    (interactive)
  (beginning-of-buffer)
  (replace-string "console." "// console."))


(when (>= emacs-major-version 29)
  (straight-use-package 'clojure-ts-mode)
  (add-hook 'clojure-ts-mode #'lispy-mode)

  (add-to-list 'auto-mode-alist '("\\.sy\\'" . json-ts-mode))
  (straight-use-package 'treesit-auto)
  (require 'treesit-auto)
  (global-treesit-auto-mode)

  (straight-use-package 'combobulate)
  (autoload 'combobulate-mode "combobulate" nil t nil)
  (add-hook 'typescript-ts-mode-hook #'combobulate-mode)
  (add-hook 'json-ts-mode-hook #'combobulate-mode))



(straight-use-package '(valign :host github :repo "casouri/valign"))
(with-eval-after-load 'valign
  (add-to-list 'valign-box-charset-alist
               '(test . "
+------------------------------ +
|+-- +------------------------ + |
|+-- +------------------------ + |

")))


(straight-use-package '(typst-ts-mode :host sourcehut :repo "meow_king/typst-ts-mode"))

(straight-use-package 'sbt-mode)
(straight-use-package 'mvn)
;; use consult-mark?
(straight-use-package 'goto-chg)
(require 'goto-chg)
(straight-use-package 'pcre2el)


(straight-use-package 'realgud-lldb)
;; (require 'realgud-lldb)
(straight-use-package '(mind-wave :host github :repo "manateelazycat/mind-wave" :files ("*")))
(with-eval-after-load 'mind-wave
  (add-hook 'mind-wave-chat-mode-hook
            (lambda ()
              (require 'markdown-mode)
              (markdown-mode 1)
              (setq-local auto-revert-remote-files t)
              (auto-revert-mode 1))))
(require 'mind-wave)

;; lots of errors in treesit-explore-mode, not usable
(straight-use-package '(scala-ts-mode :type git :host github :repo "KaranAhlawat/scala-ts-mode"))



;; (with-eval-after-load 'pyim
;;   (defun w/set-pyim-cursor-color (&optional theme)
;;     (setq pyim-indicator--original-cursor-color (face-attribute 'cursor :background)))
;;   (advice-add 'load-theme :after #'w/set-pyim-cursor-color)
;;   (advice-add 'enable-theme :after #'w/set-pyim-cursor-color)
;;   (advice-add 'disable-theme :after #'w/set-pyim-cursor-color))


(with-eval-after-load 'w-full)

(provide 'w-explore)
