(require 'w-built-in)

(require 'w-straight)
(require 'w-exec-path)

;;; declare built-in packages, in case to be installed from other sources by other third party packages
(straight-use-package '(bui :type built-in))
(straight-use-package '(eldoc :type built-in))
(straight-use-package '(flymake :type built-in))
(straight-use-package '(jsonrpc :type built-in))
(straight-use-package '(let-alist :type built-in))
(straight-use-package '(map :type built-in))
(straight-use-package '(org :type built-in))
(straight-use-package '(project :type built-in))
(straight-use-package '(transient :type built-in))
(straight-use-package '(xref :type built-in))

(require 'w-diminish)

;;; utils
(require 'w-utils)
(require 'w-emacs)
(require 'w-pyim)

;;; emacs/system tools
(require 'w-window)
(require 'w-buffer)
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

(straight-use-package 'csv-mode)
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(setq csv-separators '("," ";" "|" " "))
;; TODO truncate after align mode is on, revert if getting off
(add-hook 'csv-align-mode-hook (lambda () (setq-local truncate-lines nil)))



(provide 'w-core)
