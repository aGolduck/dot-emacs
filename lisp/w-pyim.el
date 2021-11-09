;;;  -*- lexical-binding: t; -*-
(straight-use-package 'pyim)

(defun w/pyim-wbdict-v86-single-enable ()
  "Add wubi dict (86 version, single character) to pyim."
  (interactive)
  (require 'pyim)

  (pyim-scheme-add
   '(wubi
     :document "五笔输入法。"
     :class xingma
     :first-chars "abcdefghijklmnopqrstuvwxyz"
     :rest-chars "abcdefghijklmnopqrstuvwxyz'"
     :code-prefix "wubi/" ;五笔词库中所有的 code 都以 "wubi/" 开头，防止和其它词库冲突。
     :code-prefix-history (".") ;五笔词库以前使用 "." 做为 code-prefix.
     :code-split-length 4 ;默认将用户输入切成 4 个字符长的 code 列表（不计算 code-prefix）
     :code-maximum-length 4 ;五笔词库中，code 的最大长度（不计算 code-prefix）
     :prefer-triggers nil))

  (let* ((file (expand-file-name (locate-user-emacs-file "resources/pyim-wbdict-v86-single.pyim"))))
    (when (file-exists-p file)
      (if (featurep 'pyim)
          (pyim-extra-dicts-add-dict
           `(:name "w/wbdict-v86-single-elpa" :file ,file :elpa t))
        (message "pyim 没有安装，pyim-wbdict 启用失败。")))))

(setq default-input-method "pyim"
      pyim-default-scheme 'wubi
      pyim-dcache-directory (w/locate-emacs-var-file "pyim/cache"))
(setq-default pyim-punctuation-translate-p '(auto yes no))
(global-set-key (kbd "M-t") #'toggle-input-method)
(add-hook 'after-init-hook #'w/pyim-wbdict-v86-single-enable)
(with-eval-after-load 'pyim
  (set-face-attribute 'pyim-page nil :background "#dcdccc" :foreground "#333333"))


(provide 'w-pyim)
