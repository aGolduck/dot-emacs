(straight-use-package 'diminish)

;;; utils
(require 'w-utils)
(require 'w-emacs)
(require 'w-ui)
(require 'w-pyim)

;;; emacs/system tools
(require 'w-window)
(require 'w-buffer)
(require 'w-file)
(require 'w-term-core)
(require 'w-dired)
(require 'w-git)

;;; text edit
(require 'w-search)
(require 'w-edit)

;;; complete anything
(require 'w-minibuffer)
(require 'w-company)

;;; programming
(require 'w-prog-core)
(require 'w-jump)

(setq calendar-chinese-all-holidays-flag t)
(with-eval-after-load 'abbrev (diminish 'abbrev-mode "缩"))

;;; makefile
(add-to-list 'auto-mode-alist '("\\.gmk" . makefile-mode))

;;; simple
(add-hook 'after-init-hook #'global-visual-line-mode)
(global-set-key (kbd "M-SPC SPC") #'execute-extended-command)
(global-set-key (kbd "M-SPC u") #'universal-argument)
(with-eval-after-load 'simple
  (diminish 'visual-line-mode "⮒"))

;;; ediff-wind
(setq ediff-merge-split-window-function 'split-window-vertically
      ediff-split-window-function 'split-window-horizontally
      ediff-window-setup-function 'ediff-setup-windows-plain)
(with-eval-after-load 'ediff-wind
  (require 'w-window)
  (add-hook 'ediff-after-quit-hook-internal #'winner-undo))

(straight-use-package 'csv-mode)
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(setq csv-separators '("," ";" "|" " "))



(provide 'w-core)
