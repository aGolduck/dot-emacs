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
  ;; 找不到针对具体项目的取消 lispy-indent 方法，暂时取消所有 clojure-mode 的 lispy-indent
  (define-key lispy-mode-map (kbd "RET")
              (lambda ()
                (interactive)
                (if (eq major-mode #'clojure-mode)
                    (newline-and-indent)
                  (lispy-newline-and-indent-plain)))))


(add-hook 'emacs-lisp-mode-hook #'show-paren-mode)
(add-hook 'emacs-lisp-mode-hook #'lispy-mode)

(provide 'w-lisp)
