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

;;; crux
(straight-use-package 'crux)
(global-set-key (kbd "C-o") #'crux-smart-open-line)
(global-set-key (kbd "M-o") #'crux-smart-open-line-above)
(global-set-key (kbd "M-SPC f r") #'crux-recentf-find-file)

;;; gcmh
(straight-use-package 'gcmh)
(add-hook 'after-init-hook #'gcmh-mode)

;;; helpful
(straight-use-package 'helpful)
(global-set-key (kbd "C-h k") #'helpful-key)
(global-set-key (kbd "C-h o") #'helpful-symbol)

(require 'w-pyim)

;;; emacs/system tools
(require 'w-ace-window)
(require 'w-term-extra)
(require 'w-dired-extra)
(require 'w-git)

;;; text edit
(require 'w-search-extra)
(require 'w-edit-extra)

;;; complete anything
(require 'w-minibuffer)
(require 'w-company)

;;; programming
(require 'w-projectile)


;; dumb-jump
(straight-use-package 'dumb-jump)
;; (setq dumb-jump-force-searcher 'rg) ;; rg is not working for at least elisp files
(with-eval-after-load 'xref
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))


(provide 'w-essential)
