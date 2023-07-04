;;; -*- lexical-binding: t; -*-
(straight-use-package 'lispy)

;; TODO lispy need to be customized for cider
(with-eval-after-load 'lispy
  ;; (define-key lispy-mode-map (kbd "[") nil)
  ;; (define-key lispy-mode-map (kbd "]") nil)
  (define-key lispy-mode-map (kbd "M-a") #'lispy-backward)
  (define-key lispy-mode-map (kbd "M-e") #'lispy-forward)
  ;; (define-key lispy-mode-map (kbd "h") #'lispy-move-up)
  ;; (define-key lispy-mode-map (kbd "l") #'lispy-move-down)
  (define-key lispy-mode-map (kbd "i") nil)
  (define-key lispy-mode-map (kbd "M-i") nil)
  (define-key lispy-mode-map (kbd "M-o") nil)

  (defun w/lispy-help ()
    "少量实用但是实用的命令提示"
    (interactive)
    ;; TODO 增加颜色配置
    (message "r -> lispy-raise `(let ((foo 1)) (+ bar baz))' -> `(+ bar baz)'"))
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
