(straight-use-package 'diminish)

(with-eval-after-load 'hi-lock (diminish 'hi-lock-mode "亮"))
(with-eval-after-load 'simple (diminish 'visual-line-mode "⮒"))
(with-eval-after-load 'view (diminish 'view-mode "览"))
(with-eval-after-load 'winner (diminish 'winner-mode))

(provide 'w-diminish)
