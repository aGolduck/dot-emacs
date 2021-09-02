;;;  -*- lexical-binding: t; -*-
(straight-use-package 'pyim)
(straight-use-package 'pyim-wbdict)

(defun w/pyim-wbdict-v86-single-enable ()
  "Add wubi dict (86 version, single character) to pyim."
  (interactive)
  (require 'pyim-wbdict)
  (let* ((file (expand-file-name (locate-user-emacs-file "resources/pyim-wbdict-v86-single.pyim"))))
    (when (file-exists-p file)
      (if (featurep 'pyim)
          (pyim-extra-dicts-add-dict
           `(:name "w/wbdict-v86-single-elpa" :file ,file :elpa t))
        (message "pyim 没有安装，pyim-wbdict 启用失败。")))))

(setq default-input-method "pyim"
      pyim-default-scheme 'wubi
      pyim-dcache-directory (w/locate-emacs-var-file "pyim/cache"))
(global-set-key (kbd "M-t") #'toggle-input-method)
(add-hook 'after-init-hook #'pyim-wbdict-v86-single-enable)
(with-eval-after-load 'pyim
  (set-face-attribute 'pyim-page nil :background "#dcdccc" :foreground "#333333"))


(provide 'w-pyim)
