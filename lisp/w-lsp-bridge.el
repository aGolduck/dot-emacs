(straight-use-package 'posframe)
(straight-use-package 'markdown-mode)
(straight-use-package 'yasnippet)
(straight-use-package '(lsp-bridge :host github :repo "manateelazycat/lsp-bridge" :files ("*")))

;; 日志选项必须在启动 python 进程前设置才能生效
(setq lsp-bridge-enable-log nil
      lsp-bridge-enable-profile nil
      lsp-bridge-enable-diagnostics t)


;; org-babel js/shell 等不支持，原因不明
(setq acm-enable-search-file-words nil
      lsp-bridge-enable-diagnostics nil
      lsp-bridge-org-babel-lang-list '("css" "python"))
;; typescript 使用 deno lsp.
(setq lsp-bridge-multi-lang-server-extension-list nil)
(with-eval-after-load 'lsp-bridge
  (add-to-list 'lsp-bridge-single-lang-server-mode-list '((typescript-mode typescript-ts-mode) . "deno"))
  (define-key lsp-bridge-mode-map (kbd "M-'") #'lsp-bridge-popup-documentation)
  (define-key lsp-bridge-mode-map (kbd "M-.") #'lsp-bridge-find-def)
  (define-key lsp-bridge-mode-map (kbd "M-,") #'lsp-bridge-find-def-return)
  (define-key lsp-bridge-mode-map (kbd "M-<RET>") #'lsp-bridge-code-action)
  (define-key lsp-bridge-mode-map (kbd "M-r") #'lsp-bridge-rename)
  (define-key lsp-bridge-mode-map (kbd "M-\"") #'lsp-bridge-find-references)

  ;; If typescript file include deno.land url, then use Deno LSP server.
  ;; (setq lsp-bridge-get-single-lang-server-by-project
  ;;       (lambda (project-path filepath)
  ;;         (save-excursion
  ;;           (when (string-equal (file-name-extension filepath) "ts")
  ;;             (dolist (buf (buffer-list))
  ;;               (when (string-equal (buffer-file-name buf) filepath)
  ;;                 (with-current-buffer buf
  ;;                   (goto-char (point-min))
  ;;                   (when (search-forward-regexp (regexp-quote "from \"https://deno.land") nil t)
  ;;                     (return "deno")))))))))
  ;; prefer deno for typescript
  (add-to-list 'lsp-bridge-single-lang-server-extension-list '(("ts") . "deno")))

(add-hook 'lsp-bridge-mode-hook #'yas-minor-mode)

;;; lsp-bridge-call-hierarchy for lsp-code-action
(with-eval-after-load 'lsp-bridge-call-hierarchy
  (defun w/lsp-bridge-call-hierarchy-last ()
    (interactive)
    (while (< (+ lsp-bridge-call-hierarchy--index 1)
              (length lsp-bridge-call-hierarchy--popup-response))
      (lsp-bridge-call-hierarchy--move 1)))
  (defun w/lsp-bridge-call-hierarchy-first ()
    (interactive)
    (while (>= (- lsp-bridge-call-hierarchy--index 1) 0)
      (lsp-bridge-call-hierarchy--move -1)))
  (defun w/lsp-bridge-call-hierarchy-scroll-up ()
    (interactive)
    (if (< (+ lsp-bridge-call-hierarchy--index 5)
           (length lsp-bridge-call-hierarchy--popup-response))
        (lsp-bridge-call-hierarchy--move 5)
      (w/lsp-bridge-call-hierarchy-last)))
  (defun w/lsp-bridge-call-hierarchy-scroll-down ()
    (interactive)
    (if (>= (- lsp-bridge-call-hierarchy--index 5) 0)
        (lsp-bridge-call-hierarchy--move -5)
      (w/lsp-bridge-call-hierarchy-first)))
  ;; disable ESC to enable M- like keybindings, for example: (kbd "M-<") equals (kbd "ESC <")
  (define-key lsp-bridge-call-hierarchy-mode-map (kbd "ESC") nil)
  (define-key lsp-bridge-call-hierarchy-mode-map (kbd "M-<") #'w/lsp-bridge-call-hierarchy-first)
  (define-key lsp-bridge-call-hierarchy-mode-map (kbd "M->") #'w/lsp-bridge-call-hierarchy-last)
  (define-key lsp-bridge-call-hierarchy-mode-map (kbd "C-v") #'w/lsp-bridge-call-hierarchy-scroll-up)
  (define-key lsp-bridge-call-hierarchy-mode-map (kbd "M-v") #'w/lsp-bridge-call-hierarchy-scroll-down))


;;; programming languages setting
;; (add-hook 'cmake-ts-mode-hook #'lsp-bridge-mode)
;; (add-hook 'emacs-lisp-mode-hook #'lsp-bridge-mode)
;; (add-hook 'css-mode-hook #'lsp-bridge-mode)
;; (add-hook 'js-mode-hook #'lsp-bridge-mode)
;; (add-hook 'sh-mode-hook #'lsp-bridge-mode)
;; (add-hook 'typescript-ts-mode-hook #'lsp-bridge-mode)
;; (add-hook 'python-mode-hook #'lsp-bridge-mode)
;; (add-hook 'go-mode-hook #'lsp-bridge-mode)
;; java
(setq lsp-bridge-jdtls-workspace (expand-file-name "~/.emacs.d/var/.cache/lsp-bridge-jdtls")
      lsp-bridge-jdtls-jvm-args `(,(concat "-javaagent:" (expand-file-name "~/.emacs.d/resources/lombok.jar"))
                                  ,(concat "-Xbootclasspath/a:" (expand-file-name "~/.emacs.d/resources/lombok.jar"))))
;; jdtls 会干扰 idea 编译，java 文件仅当非 idea 项目时启动 lsp-bridge
(defun w/maybe-enable-lsp-bridge-for-java ()
  "enable lsp-bridge-mode for java files if not in idea project"
  (message (concat (project-root (project-current)) ".idea"))
  (unless (file-exists-p (concat (project-root (project-current)) ".idea"))
    (message "echo")
    (lsp-bridge-mode 1)))
;; 仅 lsp-bridge-mode 无法激活 jdtls 的参数配置
(add-hook 'java-mode-hook (lambda ()
                            (setq-local lsp-bridge-get-single-lang-server-by-project
                                        'lsp-bridge-get-jdtls-server-by-project)
                            (w/maybe-enable-lsp-bridge-for-java)))


;; preferred deno already, no need to set specifically
;; (setq lsp-bridge-get-single-lang-server-by-project
;;       (lambda (project-path filepath)
;;         (when (string-equal (file-name-base project-path) "deno-bridge")
;;           "deno")))

;; TODO projectile-project-root 找不到 root 时会给一个默认值，不符合要求，需要一个返回 nil 使得 lsp-bridge-mode 能够启动单文件模式
;; (defun w/lsp-bridge-get-project-path-by-filepath (filepath)
;;   ;; filepath 是当前文件的文件夹
;;   ;; (project-root (project-current nil filepath))
;;   (require 'projectile)
;;   (projectile-project-root filepath))
;; lsp-bridge-get-project-path-by-filepath 的参数实际是文件所在目录
;; (setq lsp-bridge-get-project-path-by-filepath #'w/lsp-bridge-get-project-path-by-filepath)

(provide 'w-lsp-bridge)
