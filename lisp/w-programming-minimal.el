(add-hook 'prog-mode-hook #'electric-pair-local-mode)
(global-set-key [remap comment-dwim] #'comment-line)
(setq xref-show-definitions-function #'xref-show-definitions-completing-read)

;;; treesit
;; build treesit language definitions by https://github.com/casouri/tree-sitter-module
(setq treesit-extra-load-path '("~/g/casouri/tree-sitter-module/dist"
                                "~/.emacs.d/tree-sitter"))


;;; eglot
;; (setq eglot-log-level 6)
(add-hook 'eglot-managed-mode-hook (lambda () (company-mode 1)))
(setq eglot-extend-to-xref t)
(with-eval-after-load 'eglot
  ;; deno lsp
  ;; (add-to-list 'eglot-server-programs '((typescript-mode typescript-ts-mode) . ("deno" "lsp")))
  (add-to-list 'eglot-server-programs '((typescript-ts-mode :language-id "typescript") . (eglot-deno "deno" "lsp")))
  (defclass eglot-deno (eglot-lsp-server) ()
    :documentation "A custom class for deno lsp.")
  (cl-defmethod eglot-initialization-options ((server eglot-deno))
    "Passes through required deno initialization options"
    (list :enable t
          :lint t))

  ;; TODO 原eglot-rename 的 default 参数不起作用，需要用废弃的 INITIAL-CONTENTS，不知道为什么
  ;; copy from lsp-bridge-rename
  (defun w/eglot-rename-with-initial-contents ()
    (interactive)
    (let ((new-name (read-string "Rename to: " (thing-at-point 'symbol 'no-properties))))
      (eglot-rename new-name)))
  ;; keybindings
  (define-key eglot-mode-map (kbd "M-\"") #'xref-find-references)
  (define-key eglot-mode-map (kbd "M-r") #'w/eglot-rename-with-initial-contents))


;;; auto-insert
(setq auto-insert-directory "~/.emacs.d/auto-insert-templates"
      auto-insert-query t)
(define-auto-insert "\\.ts\\'" "with-logger.ts")
(define-auto-insert "\\.java\\'" "with-Logger.java")
(define-auto-insert "CMakeLists\\.txt\\'" "CMakeLists.txt")
(add-hook 'after-init-hook #'auto-insert-mode)


;;; auto-mode-alist
(add-to-list 'auto-mode-alist '("\\.cnf\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.gmk\\'" . makefile-mode))
(add-to-list 'auto-mode-alist '("/\\.gitignore\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("/info/exclude\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("/git/ignore\\'" . conf-unix-mode))


;;; auto-mode-alist for treesit modes
(add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-ts-mode))
;; go-ts-mode 对中文标识符支持有问题，如常用需考虑回退为 go-mode
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'". yaml-ts-mode))
(add-to-list 'auto-mode-alist '("\\.yml\\'". yaml-ts-mode))


;;; java
;; java 文件经常巨长，打开行号方便定位
(add-hook 'java-mode-hook #'display-line-numbers-mode)
(add-hook 'java-mode-hook #'yas-minor-mode)

;;; js
(setq js-indent-level 2)

;;; whitespace
(with-eval-after-load 'whitespace
  (set-face-attribute 'whitespace-tab nil :background "burlywood4"))
(add-hook 'makefile-mode-hook (lambda ()
                                (setq-local whitespace-style '(
                                                               face ;; face 高亮
                                                               ;; tab-mark ;; tab 使用字符标示
                                                               tabs ;; 高亮 tab 占据的长度
                                                               space-before-tab::tab ;; 高亮 tab 前面的空格
                                                               space-after-tab::tab ;; 高亮 tab 后超过 tab 长度的空格
                                                               ))
                                (whitespace-mode 1)))

;;; xml
(setq nxml-child-indent 4
      nxml-attribute-indent 4
      lsp-xml-jar-file (expand-file-name (locate-user-emacs-file "resources/org.eclipse.lemminx-uber.jar")))

(provide 'w-programming-minimal)
