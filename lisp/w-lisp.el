;;; -*- lexical-binding: t; -*-
(straight-use-package 'lispy)

;; enable hydra-hint for lispy-x
(setq lispy-x-default-verbosity 1
      lispy-compat '(edebug
                     ;; magit-blame-mode
                     ;; macrostep
                     ))
(with-eval-after-load 'lispy
  (defun w/lispy-help ()
    "少量实用但是实用的命令提示"
    (interactive)
    ;; TODO 增加颜色配置，message 只是 print 到 echo area, echo area 不支持 text property
    (message "\
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
  ;; lispy-slurp-or-barf-left/light 比原 shrink/barf 快捷键更符合直觉，易记
  (lispy-defverb "slurp(grow)-or-barf(shrink)"
                 (("<" lispy-slurp-or-barf-left)
                  (">" lispy-slurp-or-barf-right)))

  (define-key lispy-mode-map (kbd "M-a") #'lispy-backward)
  (define-key lispy-mode-map (kbd "M-e") #'lispy-forward)
  ;; 只在括号处起作用，一定要加上 `special' 前缀，不然在非括号处会有意想不到的结果
  (define-key lispy-mode-map (kbd "<tab>") #'special-lispy-tab)
  (define-key lispy-mode-map (kbd "?") #'special-w/lispy-help)
  (define-key lispy-mode-map (kbd "<") #'special-lispy-slurp-or-barf-left)
  (define-key lispy-mode-map (kbd ">") #'special-lispy-slurp-or-barf-right)

  (define-key lispy-mode-map (kbd "i") nil)
  (define-key lispy-mode-map (kbd "M-i") nil)
  (define-key lispy-mode-map (kbd "M-o") nil)

  ;; 找不到针对具体项目的取消 lispy-indent 方法，暂时取消所有 clojure-mode 的 lispy-indent
  (define-key lispy-mode-map (kbd "RET")
              (lambda ()
                (interactive)
                (if (eq major-mode #'clojure-mode)
                    (newline-and-indent)
                  (lispy-newline-and-indent-plain)))))


(add-hook 'emacs-lisp-mode-hook #'show-paren-mode)
(add-hook 'emacs-lisp-mode-hook #'lispy-mode)
(add-hook 'treesit--explorer-tree-mode-hook #lispy-mode)


(provide 'w-lisp)
