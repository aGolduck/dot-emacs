;;; -*- lexical-binding: t; -*-
(straight-use-package 'lispy)

;; enable hydra-hint for lispy-x
(setq lispy-x-default-verbosity 1
      lispy-compat '(edebug
                     ;; magit-blame-mode
                     ;; macrostep
                     ))
(with-eval-after-load 'lispy
  (define-key lispy-mode-map (kbd "M-a") #'lispy-backward)
  (define-key lispy-mode-map (kbd "M-e") #'lispy-forward)
  ;; 只在括号处起作用，一定要加上 `special' 前缀，不然在非括号处会有意想不到的结果
  (define-key lispy-mode-map (kbd "<tab>") #'special-lispy-tab)

  (define-key lispy-mode-map (kbd "i") nil)
  (define-key lispy-mode-map (kbd "M-i") nil)
  (define-key lispy-mode-map (kbd "M-o") nil)

  (defun w/lispy-help ()
    "少量实用但是实用的命令提示"
    (interactive)
    ;; TODO 增加颜色配置，message 只是 print 到 echo area, echo area 不支持 text property
    (message "\
> -> lispy-slurp, aka grow
< -> lispy-barf, aka shrink
s -> lispy-move-down
w -> lispy-move-up
x -> IDE like features
C -> lispy-convolute `(a (b |(c)))' -> `(b (a (c)))
/ -> lispy-splice `( |(a) (b) (c))' -> `(a (b) (c))'
r -> lispy-raise `(let ((foo 1)) |(+ bar baz))' -> `(+ bar baz)'
M -> lispy-multiline
O -> lispy-oneline
C-1 -> lispy-describe-inline"))
  ;; 增加 `special' 即只在括号处起作用的命令的方法
  (lispy-defverb "help" (("?" w/lispy-help)))
  (define-key lispy-mode-map (kbd "?") #'special-w/lispy-help)

  ;; 找不到针对具体项目的取消 lispy-indent 方法，暂时取消所有 clojure-mode 的 lispy-indent
  (define-key lispy-mode-map (kbd "RET")
              (lambda ()
                (interactive)
                (if (eq major-mode #'clojure-mode)
                    (newline-and-indent)
                  (lispy-newline-and-indent-plain)))))


(add-hook 'emacs-lisp-mode-hook #'show-paren-mode)
(add-hook 'emacs-lisp-mode-hook #'lispy-mode)


;; TODO define hydra or transient for lispy?
;; 以下是 sachachua 利用脚本自动生成的，太多了没有必要
;; 需要自行学习如何定义 hydra 或者 transient
;; from https://sachachua.com/blog/2021/04/emacs-making-a-hydra-cheatsheet-for-lispy/
;; (setq w/bindings '("j" "lispy-down" "move"))
;; (eval
;;  (append
;;   '(defhydra my/lispy-cheat-sheet (:hint nil :foreign-keys run)
;;      ("<f14>" nil :exit t))
;;   (cl-loop for x in w/bindings
;;            unless (string= "" (elt x 2))
;;            collect
;;            (list (car x)
;;                  (intern (elt x 1))
;;                  (when (string-match "lispy-\\(?:eval-\\)?\\(.+\\)"
;;                                      (elt x 1))
;;                    (match-string 1 (elt x 1)))
;;                  :column
;;                  (elt x 2)))))
;; (with-eval-after-load "lispy"
;;   (define-key lispy-mode-map (kbd "?") 'my/lispy-cheat-sheet/body))

;; repeat-mode 是系统提供的 hydra/transient 的简易替代品，需要的 hack 过多
;; 不是以 cheatsheet 为目的的，不建议深度使用
;; https://karthinks.com/software/it-bears-repeating/
;; (repeat-mode 1)
;; Disable the built-in repeat-mode hinting
;; (with-eval-after-load 'embark
;;   (setq repeat-echo-function #'ignore)
;;   (defun repeat-help--embark-indicate ()
;;     (if-let ((cmd (or this-command real-this-command))
;;              (keymap (or repeat-map
;;                          (repeat--command-property 'repeat-map))))
;;         (run-at-time
;;          0 nil
;;          (lambda ()
;;            (let* ((bufname "*Repeat Commands*")
;;                   (embark-verbose-indicator-buffer-sections
;;                    '(bindings))
;;                   (embark--verbose-indicator-buffer bufname)
;;                   (embark-verbose-indicator-display-action
;;                    '(display-buffer-at-bottom
;;                      (window-height . fit-window-to-buffer)
;;                      (window-parameters . ((no-other-window . t)
;;                                            (mode-line-format))))))
;;              (funcall
;;               (embark-verbose-indicator)
;;               (symbol-value keymap))
;;              (setq other-window-scroll-buffer (get-buffer bufname)))))
;;       (when-let ((win
;;                   (get-buffer-window
;;                    "*Repeat Commands*" 'visible)))
;;         (kill-buffer (window-buffer win))
;;         (delete-window win)))))
;; (advice-add 'repeat-post-hook :after #'repeat-help--embark-indicate)
;; (defvar-keymap w/lispy-help-repeat-map
;;   :doc "keymap to repeat w/lispy-help"
;;   :repeat t
;;   "j" #'special-lispy-down
;;   "k" #'special-lispy-up)
;; (put 'w/lispy-help 'repeat-map 'w/lispy-help-repeat-map)

(provide 'w-lisp)
