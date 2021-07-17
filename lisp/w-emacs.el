;;; -*- lexical-binding: t; -*-
(straight-use-package 'gcmh)
(straight-use-package 'helpful)
(straight-use-package 'keyfreq)

;;; emacs regex builder
(setq reb-re-syntax 'string)

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
(add-hook 'after-init-hook
          (lambda ()
            (when window-system
              (desktop-save-mode))))

;;; bookmark
(setq bookmark-default-file (w/locate-emacs-var-file "bookmarks"))
(global-set-key (kbd "M-SPC b s") #'bookmark-set)

;;; find-func
(setq find-function-C-source-directory "~/b/gnu.org/emacs/emacs-native-comp/src")
(global-set-key (kbd "M-SPC F F") #'find-function-other-window)
(global-set-key (kbd "M-SPC F f") #'find-function)
(global-set-key (kbd "M-SPC F V") #'find-variable-other-window)
(global-set-key (kbd "M-SPC F v") #'find-variable)

(add-hook 'after-init-hook #'gcmh-mode)
;; restore original gc-cons-percentage
(add-hook 'after-init-hook (lambda () (setq gc-cons-percentage 0.1)))
(with-eval-after-load 'gcmh
  (diminish 'gcmh-mode))

;;; helpful
;; (setq counsel-describe-function-function #'helpful-callable
;;       counsel-describe-variable-function #'helpful-variable)
;; (global-set-key (kbd "C-h f") #'helpful-callable)
;; (global-set-key (kbd "C-h v") #'helpful-variable)
;; (global-set-key (kbd "C-h F") #'helpful-function)
;; (global-set-key (kbd "C-h C") #'helpful-command)
(global-set-key (kbd "C-h k") #'helpful-key)
(global-set-key (kbd "C-h o") #'helpful-symbol)

(setq keyfreq-file (w/locate-emacs-var-file "keyfreq")
      keyfreq-excluded-commands 'nil)
;; (setq keyfreq-excluded-commands '(
;;                                   self-insert-command
;;                                   next-line
;;                                   previous-line
;;                                   org-self-insert-command
;;                                   dired-previous-line
;;                                   dired-next-line
;;                                   mwheel-scroll
;;                                   mouse-set-point
;;                                   mouse-drag-region
;;                                   org-agenda-next-line
;;                                   backward-word
;;                                   vterm--self-insert
;;                                   magit-section-forward
;;                                   paredit-backward
;;                                   paredit-forward
;;                                   magit-section-backward
;;                                   org-agenda-previous-line
;;                                   forward-word
;;                                   backward-char
;;                                   dired-find-file
;;                                   ace-window
;;                                   ivy-done
;;                                   eaf-send-key
;;                                   rime--backspace
;;                                   scroll-up-command
;;                                   ignore
;;                                   eaf-proxy-scroll_up_page
;;                                   ivy-backward-delete-char
;;                                   magit-next-line
;;                                   isearch-repeat-forward
;;                                   delete-backward-char
;;                                   org-delete-backward-char
;;                                   eaf-proxy-scroll_down_page
;;                                   beginning-of-buffer
;;                                   ivy-next-line
;;                                   move-end-of-line
;;                                   newline
;;                                   forward-sexp
;;                                   dap-tooltip-mouse-motion
;;                                   scroll-down-command
;;                                   isearch-printing-char
;;                                   magit-section-toggle
;;                                   paredit-backward-delete
;;                                   end-of-buffer
;;                                   company-complete-selection
;;                                   forward-char
;;                                   dired-up-directory
;;                                   counsel-recentf
;;                                   minibuffer-keyboard-quit
;;                                   set-mark-command
;;                                   dired-jump
;;                                   magit-previous-line))
(add-hook 'after-init-hook #'keyfreq-mode)
(add-hook 'after-init-hook #'keyfreq-autosave-mode)


(provide 'w-emacs)
