;;;  -*- lexical-binding: t; -*-
(straight-use-package 'pyim)
(straight-use-package '(pyim-wbdict :host github :repo "tumashu/pyim-wbdict"
                                    :fork (:host github :repo "aGolduck/pyim-wbdict")))


(require 'w-ui)                         ;; posframe is needed for pyim
(setq default-input-method "pyim"
      pyim-default-scheme 'wubi
      pyim-dcache-directory (w/locate-emacs-var-file "pyim/cache"))
(global-set-key (kbd "M-t") #'toggle-input-method)
(add-hook 'after-init-hook #'pyim-wbdict-v86-single-enable)
(with-eval-after-load 'pyim
  (set-face-attribute 'pyim-page nil :background "#dcdccc" :foreground "#333333"))


(provide 'w-pyim)
