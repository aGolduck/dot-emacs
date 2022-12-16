(require 'w-minimal)

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

;;; crux
(straight-use-package 'crux)
(global-set-key (kbd "C-o") #'crux-smart-open-line)
(global-set-key (kbd "M-o") #'crux-smart-open-line-above)
(global-set-key (kbd "M-SPC f r") #'crux-recentf-find-file)

;;; edit
(straight-use-package 'expand-region)
(setq expand-region-contract-fast-key "V")
(global-set-key (kbd "M-SPC v") #'er/expand-region)

;;; gcmh
(straight-use-package 'gcmh)
(add-hook 'after-init-hook #'gcmh-mode)

;;; interaction
(straight-use-package 'interaction-log)
(require 'interaction-log)
(add-hook 'after-init-hook #'interaction-log-mode)

;;; helpful
;; disable for now, not compatible with emacs 29
;; (straight-use-package 'helpful)
;; (global-set-key (kbd "C-h k") #'helpful-key)
;; (global-set-key (kbd "C-h o") #'helpful-symbol)

;;; text input
(require 'w-pyim)
(straight-use-package 'flyspell-correct)
(with-eval-after-load 'flyspell
  (define-key flyspell-mode-map (kbd "C-;") #'flyspell-correct-wrapper)
  (define-key flyspell-mode-map (kbd "C-,") nil)
  (define-key flyspell-mode-map (kbd "C-.") nil))

;;; emacs/system tools
(require 'w-ace-window)
(require 'w-term-extra)
(require 'w-dired-extra)
(require 'w-git)

;;; search
(require 'w-search-extra)

;;; complete anything
(require 'w-minibuffer)
(require 'w-company)

;;; programming languages
(require 'w-lisp)
(require 'w-programming-essential)


(provide 'w-essential)
