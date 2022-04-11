;;; declare built-in packages, in case to be installed from other sources by other org third party packages
(straight-use-package '(eldoc :type built-in))
(straight-use-package '(flymake :type built-in))
(straight-use-package '(jsonrpc :type built-in))
(straight-use-package '(let-alist :type built-in))
(straight-use-package '(map :type built-in))
(straight-use-package '(org :type built-in))
(straight-use-package '(project :type built-in))
(straight-use-package '(xref :type built-in))

;;; packages which should be built-in
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

;; fonts
(require 'w-font)

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
;; TODO truncate after align mode is on, revert if getting off
(add-hook 'csv-align-mode-hook (lambda () (setq-local truncate-lines nil)))



(provide 'w-core)
