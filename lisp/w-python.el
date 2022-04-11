;;; -*- lexical-binding: t; -*-

;; (straight-use-package 'jupyter)
(straight-use-package 'ein)

(add-hook 'python-mode-hook #'highlight-indent-guides-mode)

(provide 'w-python)
