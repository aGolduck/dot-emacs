;;; 最小配置，只使用自带包  -*- lexical-binding: t; -*-

;; M-SPC is key to my emacs world
(global-unset-key (kbd "M-SPC"))

;;; bookmark
(setq bookmark-default-file (w/locate-emacs-var-file "bookmarks"))
(global-set-key (kbd "M-SPC b s") #'bookmark-set)

;;; desktop
(setq desktop-base-file-name (expand-file-name (concat ".emacs-" emacs-version ".desktop") w/EMACS-VAR)
      desktop-base-lock-name (expand-file-name (concat ".emacs-" emacs-version ".desktop.lock") w/EMACS-VAR)
      desktop-globals-to-save '()
      desktop-locals-to-save '()
      desktop-files-not-to-save ".*"
      desktop-buffers-not-to-save ".*"
      desktop-minor-mode-table '((defining-kbd-macro nil)
                                 (isearch-mode nil)
                                 (vc-mode nil)
                                 (vc-dir-mode nil)
                                 (erc-track-minor-mode nil)
                                 (savehist-mode nil)
                                 (tab-bar-mode nil))
      desktop-save t)
(add-hook 'desktop-save-hook (lambda () (tab-bar-mode -1)))

;;; ediff-wind
(setq ediff-merge-split-window-function 'split-window-vertically
      ediff-split-window-function 'split-window-horizontally
      ;; ediff-window-setup-function 'ediff-setup-windows-plain
      )
(with-eval-after-load 'ediff-wind
  (require 'w-window)
  (add-hook 'ediff-after-quit-hook-internal #'winner-undo))


;;; find-func
(setq find-function-C-source-directory "~/g/emacs-mirror/emacs/src")
(global-set-key (kbd "M-SPC F F") #'find-function-other-window)
(global-set-key (kbd "M-SPC F f") #'find-function)
(global-set-key (kbd "M-SPC F V") #'find-variable-other-window)
(global-set-key (kbd "M-SPC F v") #'find-variable)

;;; makefile
(add-to-list 'auto-mode-alist '("\\.gmk" . makefile-mode))

;;; simple
(add-hook 'after-init-hook #'global-visual-line-mode)
(global-set-key (kbd "M-SPC SPC") #'execute-extended-command)
(global-set-key (kbd "M-SPC u") #'universal-argument)

;;; terms
;;; ansi-color for compilation mode
(add-hook 'compilation-filter-hook
          (lambda ()
            (let ((buffer-read-only nil))
              (ansi-color-apply-on-region (point-min) (point-max)))))


;;; transient
(setq transient-history-file (w/locate-emacs-var-file "transient/history.el"))

(require 'w-file-built-in)
(require 'w-ui-built-in)

(provide 'w-built-in)
