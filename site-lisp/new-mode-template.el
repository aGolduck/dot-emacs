;; https://manateelazycat.github.io/emacs/elisp/2022/11/18/write-emacs-plugin.html

(define-derived-mode new-plugin-mode text-mode "new-plugin"
  (interactive)
  (kill-all-local-variables) ; 删除 buffer 下所有的局部变量， 避免其他 mode 的干扰
  (setq major-mode 'new-plugin-mode) ; 设置当前的 mode 为 new-plugin-mode
  (setq mode-name "new-plugin")      ; 设置 mode 的名称
  (new-plugin-highlight-keywords)    ; 根据正则表达式提供语法高亮
  (use-local-map new-plugin-mode-map)   ; 加载 mode 对应的快捷键
  (run-hooks 'new-plugin-mode-hook))          ; 加载 mode 对应的 hook, 注意 new-plugin-mode-hook 会自动生成
  
(defvar new-plugin-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-m")       #'new-plugin-function)   ; 绑定 new-plugin-function 函数到快捷键 C-m 上
    map)
  "Keymap used by `new-plugin-mode'.")
  
(defun new-plugin-highlight-keywords ()
  "Highlight keywords."
  ;; Add keywords for highlight.
  (font-lock-add-keywords
   nil
   '(
     ("regexp-string" . 'font-lock-constant-face)   ; 当 buffer 内容匹配正则， 就会自动按照 font-lock-constant-face 提供颜色高亮
     ))
  ;; Enable font lock.
  (font-lock-mode 1)) 
