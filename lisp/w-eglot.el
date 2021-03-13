(straight-use-package 'eglot)

;; (add-to-list 'eglot-server-programs '(foo-mode . ("foo-language-server" "--args")))

;; seems like flymake-posframe is broken
;; (straight-use-package '(flymake-posframe :host github :repo "Ladicle/flymake-posframe"))
;; (autoload 'flymake-posframe-mode "flymake-posframe")
;; (add-hook 'flymake-mode-hook #'flymake-posframe-mode)
;; (with-eval-after-load 'flymake-posframe-mode (diminish 'flymake-posframe-mode))

(provide 'w-eglot)
