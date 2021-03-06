;; -*- lexical-binding: t; -*-
(when (executable-find "aspell")
  (setq flyspell-issue-message-flag t
        ispell-program-name "aspell"
        ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together"))
  (add-hook 'text-mode-hook #'flyspell-mode)
  (add-hook 'outline-mode-hook #'flyspell-mode)
  (add-hook 'prog-mode #'flyspell-prog-mode)
  (straight-use-package 'flyspell-correct)
  (with-eval-after-load 'flyspell
    (diminish 'flyspell-mode)
    (define-key flyspell-mode-map (kbd "C-;") #'flyspell-correct-wrapper)
    (define-key flyspell-mode-map (kbd "C-,") nil)
    (define-key flyspell-mode-map (kbd "C-.") nil)))

(provide 'init-flyspell)
