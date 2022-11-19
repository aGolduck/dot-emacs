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


;;; programming languages
(straight-use-package 'typescript-mode)
(setq js-indent-level 2
      typescript-indent-leven 2)
(straight-use-package 'go-mode)
(straight-use-package 'clojure-mode)
(straight-use-package 'cider)
(straight-use-package 'scala-mode)
(add-hook 'clojure-mode-hook #'lispy-mode)
;;; TODO company 的相关配置全部转移到 w-company
(add-hook 'clojure-mode-hook #'company-mode)
;; (with-eval-after-load 'clojure-mode
;;   (with-eval-after-load 'cider
;;     (with-eval-after-load 'flycheck
;;       (flycheck-clojure-setup))))
(add-to-list 'auto-mode-alist '("\\.sc\\'" . scala-mode))
(add-hook 'scala-mode-hook #'company-mode)
(straight-use-package 'haskell-mode)


;; dumb-jump
(straight-use-package 'dumb-jump)
;; (setq dumb-jump-force-searcher 'rg) ;; rg is not working for at least elisp files
(with-eval-after-load 'xref
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;;; csv-mode
(straight-use-package 'csv-mode)
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(setq csv-separators '("," ";" "|" " "))
;; TODO truncate after align mode is on, revert if getting off
(add-hook 'csv-align-mode-hook (lambda () (setq-local truncate-lines nil)))


;;; quickrun
(straight-use-package 'quickrun)
(with-eval-after-load 'quickrun
  (quickrun-set-default "typescript" "typescript/deno"))

;;; symbol-overlay
(straight-use-package 'symbol-overlay)
(global-set-key (kbd "M-s h .") 'symbol-overlay-put)
(global-set-key (kbd "M-s h c") 'symbol-overlay-remove-all)
(global-set-key (kbd "M-p") #'symbol-overlay-switch-backward)
(global-set-key (kbd "M-n") #'symbol-overlay-switch-forward)
(with-eval-after-load 'symbol-overlay
  (transient-define-prefix symbol-overlay-transient ()
    "Symbol Overlay transient"
    ["Symbol Overlay"
     ["Overlays"
      ("." "Add/Remove at point" symbol-overlay-put)
      ("k" "Remove All" symbol-overlay-remove-all)
      ]
     ["Move to Symbol"
      ("n" "Next" symbol-overlay-switch-forward)
      ("p" "Previous" symbol-overlay-switch-backward)
      ]
     ["Other"
      ("m" "Highlight symbol-at-point" symbol-overlay-mode)
      ]
     ])
  (define-key symbol-overlay-map (kbd "?") 'symbol-overlay-transient))


(provide 'w-essential)
