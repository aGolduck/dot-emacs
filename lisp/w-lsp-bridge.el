(straight-use-package 'posframe)
(straight-use-package 'markdown-mode)
(straight-use-package 'yasnippet)
(straight-use-package '(lsp-bridge :host github :repo "manateelazycat/lsp-bridge" :files ("*")))
;; (yas-global-mode)
;; (setq lsp-bridge-enable-log t
;;       lsp-bridge-enable-debug t)
;; org-babel js/shell 等不支持，原因不明
(setq acm-enable-search-file-words nil
      lsp-bridge-enable-diagnostics nil
      lsp-bridge-org-babel-lang-list '("css" "python"))
(with-eval-after-load 'lsp-bridge
  (define-key lsp-bridge-mode-map (kbd "M-'") #'lsp-bridge-popup-documentation)
  (define-key lsp-bridge-mode-map (kbd "M-.") #'lsp-bridge-find-def)
  (define-key lsp-bridge-mode-map (kbd "M-,") #'lsp-bridge-find-def-return)
  (define-key lsp-bridge-mode-map (kbd "M-<RET>") #'lsp-bridge-code-action)
  (define-key lsp-bridge-mode-map (kbd "M-r") #'lsp-bridge-rename)
  (define-key lsp-bridge-mode-map (kbd "M-\"") #'lsp-bridge-find-references)

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
;; (add-hook 'emacs-lisp-mode-hook #'lsp-bridge-mode)
(add-hook 'css-mode-hook #'lsp-bridge-mode)
(add-hook 'js-mode-hook #'lsp-bridge-mode)
(add-hook 'sh-mode-hook #'lsp-bridge-mode)
(add-hook 'typescript-mode-hook #'lsp-bridge-mode)
(add-hook 'python-mode-hook #'lsp-bridge-mode)
(add-hook 'go-mode-hook #'lsp-bridge-mode)
;; java
(setq lsp-bridge-jdtls-workspace (expand-file-name "~/.emacs.d/var/.cache/lsp-bridge-jdtls")
      lsp-bridge-jdtls-jvm-args `(,(concat "-javaagent:" (expand-file-name "~/.emacs.d/resources/lombok.jar"))
                                  ,(concat "-Xbootclasspath/a:" (expand-file-name "~/.emacs.d/resources/lombok.jar"))))
;; jdtls 会干扰 idea 编译
;; 仅 lsp-bridge-mode 无法激活 jdtls 的参数配置
;; (add-hook 'java-mode-hook (lambda ()
;;                             (setq-local lsp-bridge-get-single-lang-server-by-project 'lsp-bridge-get-jdtls-server-by-project)
;;                             (lsp-bridge-mode 1)))
;; (add-hook 'java-mode-hook #'lsp-bridge-mode)
;; 
(setq lsp-bridge-get-single-lang-server-by-project
      (lambda (project-path filepath)
        (when (string-equal (file-name-base project-path) "deno-bridge")
          "deno")))

(provide 'w-lsp-bridge)
