;;; 最小配置，只使用自带包  -*- lexical-binding: t; -*-

;; M-SPC is key to my emacs world
(global-unset-key (kbd "M-SPC"))

;;; bookmark
(setq bookmark-default-file (w/locate-emacs-var-file "bookmarks"))
(global-set-key (kbd "M-SPC b s") #'bookmark-set)

;;; buffer
(global-set-key (kbd "M-SPC b k") #'kill-buffer)

;;; calendar
(setq calendar-chinese-all-holidays-flag t)

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

;;; dired
(setq dired-listing-switches "-Afhlv"
      dired-auto-revert-buffer t
      dired-dwim-target t
      dired-recursive-copies 'always
      dired-kill-when-opening-new-dired-buffer t
      dired-recursive-deletes 'top
      dired-guess-shell-alist-user '(("\\.doc\\'" "libreoffice")
                                     ("\\.docx\\'" "libreoffice")
                                     ("\\.ppt\\'" "libreoffice")
                                     ("\\.pptx\\'" "libreoffice")
                                     ("\\.xls\\'" "libreoffice")
                                     ("\\.xlsx\\'" "libreoffice"))
      image-dired-dir (w/locate-emacs-var-file "image-dired"))
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)
  (define-key dired-mode-map
    (kbd "^") (lambda () (interactive) (find-alternate-file ".."))))
(global-set-key (kbd "M-SPC ^") #'dired-jump)

;;; edit
(add-hook 'after-init-hook #'delete-selection-mode)
(add-hook 'after-init-hook #'global-subword-mode)
(add-hook 'hexl-mode-hook #'view-mode)

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

;;; hideshow
(add-hook 'prog-mode-hook #'hs-minor-mode)
(global-set-key (kbd "M-SPC z H") #'hs-hide-all)
(global-set-key (kbd "M-SPC z S") #'hs-show-all)
(global-set-key (kbd "M-SPC z h") #'hs-hide-block)
(global-set-key (kbd "M-SPC z s") #'hs-show-block)
(global-set-key (kbd "M-SPC z z") #'hs-toggle-hiding)
(with-eval-after-load 'hideshow
  (defconst w/hideshow-folded-face '((t (:inherit 'font-lock-comment-face :box t))))
  (defun w/hide-show-overlay-fn (w/overlay)
    (when (eq 'code (overlay-get w/overlay 'hs))
      (let* ((nlines (count-lines (overlay-start w/overlay)
                                  (overlay-end w/overlay)))
             (info (format " ... #%d " nlines)))
        (overlay-put w/overlay 'display (propertize info 'face w/hideshow-folded-face)))))
  (setq hs-set-up-overlay 'w/hide-show-overlay-fn)
)


;;; isearch
(setq-default isearch-lazy-count t
              search-ring-max 200
              regexp-search-ring-max 200)
(with-eval-after-load 'isearch

  (global-set-key (kbd "C-s") #'isearch-forward-regexp)
  (global-set-key (kbd "C-r") #'isearch-backward-regexp)
  (global-set-key (kbd "C-M-s") #'isearch-forward)
  (define-key isearch-mode-map (kbd "C-w") #'isearch-yank-symbol-or-char)
  (define-key isearch-mode-map (kbd "C-M-w") #'isearch-yank-word-or-char))

;;; makefile
(add-to-list 'auto-mode-alist '("\\.gmk" . makefile-mode))

;;; programming
(require 'w-programming-minimal)

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


;;; misc
(setq reb-re-syntax 'string)


(require 'w-file-built-in)
(require 'w-ui-built-in)
(require 'w-font)

(provide 'w-minimal)
