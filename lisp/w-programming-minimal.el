(add-hook 'prog-mode-hook #'electric-pair-local-mode)
(global-set-key [remap comment-dwim] #'comment-line)
(setq xref-show-definitions-function #'xref-show-definitions-completing-read)

;;; treesit
(add-hook 'treesit--explorer-tree-mode-hook #'lispy-mode)

;;; gdb
(defun w/打开gdb调试时自动显示行号 ()
  (if gdb-many-windows
      (global-display-line-numbers-mode 1)
    (global-display-line-numbers-mode -1)))
(add-hook 'gdb-many-windows-hook #'w/打开gdb调试时自动显示行号)

;;; eglot
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
  (define-key eglot-mode-map (kbd "M-<return>") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "M-\"") #'xref-find-references)
  (define-key eglot-mode-map (kbd "M-r") #'w/eglot-rename-with-initial-contents))


;;; auto-insert
(setq auto-insert-directory "~/.emacs.d/auto-insert-templates"
      auto-insert-query t)
;; `.lc.ts' 结尾
(define-auto-insert "\\.lc\\.ts\\'" "with-logger.lc.ts")
;; 非点 + `.ts'，一般文件名不会有 `.' ，可以认为是除 `.lc.ts' 的所有情况
(define-auto-insert "^[^\\.]*\\.ts\\'" "with-logger.ts")
(define-auto-insert "CMakeLists\\.txt\\'" "CMakeLists.txt")
(define-auto-insert '("\\.lc\\.scala\\'" . "leetcode scala")
  '(
    "leetcode scala template"
    "import java.util.logging.Logger" "\n"
    "import java.util.logging.Level" "\n"
    "object " (nth 0 (split-string
                      (nth 1 (split-string
                              (file-name-base (buffer-file-name)) "-"))
                      "\\.")) " {" "\n"
    "  val log: Logger = Logger.getLogger(\"\")" "\n"
    "\n"
    "  def main(args: Array[String]): Unit = {" "\n"
    "    log.setLevel(Level.FINE)" "\n"
    "    log.getHandlers().foreach(handler => handler.setLevel(Level.FINE))" "\n"
    _ "\n"
    "\n"
    "  }" "\n"
    "}"
    ))
(add-hook 'after-init-hook #'auto-insert-mode)


;;; auto-mode-alist
(add-to-list 'auto-mode-alist '("requirements\\.txt\\'" . conf-mode))
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
