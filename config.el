;;; -*- lexical-binding: t; -*-
(use-package auth-source
  :init (setq auth-sources '((:source (w/locate-emacs-var-file ".authinfo.gpg")))))

(use-package avy
  :init
  (global-set-key (kbd "M-SPC g g") #'avy-goto-char-timer)
  (global-set-key (kbd "M-SPC g l") #'avy-goto-line)
  (global-set-key (kbd "M-SPC g w") #'avy-goto-word-0))

(use-package direnv
  :if (executable-find "direnv")
  :init (add-hook 'after-init-hook #'direnv-mode))

(use-package dotenv)

(use-package ediff-wind
  :init
  (setq ediff-merge-split-window-function 'split-window-vertically
        ediff-split-window-function 'split-window-horizontally
        ediff-window-setup-function 'ediff-setup-windows-plain)
  :config
  (add-hook 'ediff-after-quit-hook-internal #'winner-undo))

(use-package epg-config :init (setq epg-pinentry-mode 'loopback))

(use-package go-translate
  :init
  ;; (setq go-translate-base-url "https://translate.google.cn")
  (setq go-translate-local-language "zh-CN")
  :config
  (defun go-translate-token--extract-tkk () (cons 430675 2721866130)))

(use-package goto-addr :init (add-hook 'after-init-hook #'goto-address-mode))

(use-package hideshow
  :init
  (add-hook 'prog-mode-hook #'hs-minor-mode)
  (global-set-key (kbd "M-SPC z H") #'hs-hide-all)
  (global-set-key (kbd "M-SPC z S") #'hs-show-all)
  (global-set-key (kbd "M-SPC z h") #'hs-hide-block)
  (global-set-key (kbd "M-SPC z s") #'hs-show-block)
  (global-set-key (kbd "M-SPC z z") #'hs-toggle-hiding)
  :config
  (defconst w/hideshow-folded-face '((t (:inherit 'font-lock-comment-face :box t))))
  (defun w/hide-show-overlay-fn (w/overlay)
    (when (eq 'code (overlay-get w/overlay 'hs))
      (let* ((nlines (count-lines (overlay-start w/overlay)
                                  (overlay-end w/overlay)))
             (info (format " ... #%d " nlines)))
        (overlay-put w/overlay 'display (propertize info 'face w/hideshow-folded-face)))))
  (setq hs-set-up-overlay 'w/hide-show-overlay-fn)
  (diminish 'hs-minor-mode "折"))

(use-package link-hint)

(use-package pdf-tools)

(use-package pocket-reader)

(use-package screenshot-svg)

(use-package selectric-mode
  :if (executable-find "aplay")
  :init
  ;; 不禁用会导致 <up>, <down> 等语义改变，致使 previous-line, next-line 等 remap 失败
  (setq selectric-affected-bindings-list nil)
  (add-hook 'after-init-hook #'selectric-mode)
  :config
  (diminish 'selectric-mode))

(use-package simple
  :init
  (add-hook 'after-init-hook #'global-visual-line-mode)
  (global-set-key (kbd "M-SPC SPC") #'execute-extended-command)
  (global-set-key (kbd "M-SPC u") #'universal-argument)
  :config
  (diminish 'visual-line-mode "⮒"))

(use-package treemacs
  :commands (treemacs-current-visibilit)
  :init
  (setq treemacs-no-png-images t
        treemacs-persist-file (w/locate-emacs-var-file ".cache/treemacs-persist"))
  (add-hook 'treemacs-mode-hook (lambda () (setq-local line-spacing 0)))
  (defun w/treemacs-goto-treemacs ()
    (interactive)
    (pcase (treemacs-current-visibility)
      ('visible (treemacs-select-window))
      ('exists (treemacs-select-window))
      ('none (treemacs-add-and-display-current-project))))
  ;; n for navigate?
  (global-set-key (kbd "M-n") #'w/treemacs-goto-treemacs)
  :config
  (set-face-attribute 'treemacs-directory-face nil :inherit font-lock-function-name-face :height 0.9)
  ;; TODO :inherit variable-pitch
  (set-face-attribute 'treemacs-file-face nil :height 0.9)
  (set-face-attribute 'treemacs-git-ignored-face nil :inherit font-lock-comment-face :height 0.8 :weight 'light)
  ;; (define-key treemacs-mode-map (kbd "M-n") nil)
  )

(use-package url-cookie :init (setq url-cookie-file (w/locate-emacs-var-file "url/cookies")))

(use-package valign :config (diminish 'valign-mode))

(use-package window
  :init
  (defun w/split-window-right ()
    "split-window-right with right window having a max width of 100 columns"
    (interactive)
    (if (> (window-total-width) 200)
        (split-window-right -100)
      (if (> (window-total-width) 180)
          (split-window-right -90)
        (split-window-right))))
  (defun w/split-window-right-and-focus ()
    (interactive)
    (w/split-window-right)
    (other-window 1))
  (global-set-key (kbd "M-SPC b b") #'switch-to-buffer)
  (global-set-key (kbd "M-SPC w D") #'delete-other-windows)
  (global-set-key (kbd "M-SPC w S") #'w/split-window-right-and-focus)
  (global-set-key (kbd "M-SPC w V") (defun w/split-window-and-focus () (interactive) (split-window-below) (other-window 1)))
  (global-set-key (kbd "M-SPC w X") (defun w/swap-window-and-focus () (interactive) (window-swap-states) (other-window 1)))
  (global-set-key (kbd "M-SPC w d") #'delete-window)
  (global-set-key (kbd "M-SPC w s") #'w/split-window-right)
  (global-set-key (kbd "M-SPC w v") #'split-window-below)
  (global-set-key (kbd "M-SPC w x") #'window-swap-states)
  (use-package ace-window
    :init
    ;; (defun w/get-window-list ()
    ;;   (if (<= (length (window-list)) 2)
    ;;       (window-list)
    ;;     (save-excursion
    ;;       (let ((windows nil))
    ;;         (ignore-errors (dotimes (i 10) (windmove-left)))
    ;;         (ignore-errors (dotimes (i 10) (windmove-up)))
    ;;         (add-to-list 'windows (selected-window) t)
    ;;         (ignore-errors (dotimes (i 10) (windmove-right)))
    ;;         (ignore-errors (dotimes (i 10) (windmove-up)))
    ;;         (add-to-list 'windows (selected-window) t)
    ;;         (ignore-errors (dotimes (i 10) (windmove-left)))
    ;;         (ignore-errors (dotimes (i 10) (windmove-down)))
    ;;         (add-to-list 'windows (selected-window) t)
    ;;         (ignore-errors (dotimes (i 10) (windmove-right)))
    ;;         (ignore-errors (dotimes (i 10) (windmove-down)))
    ;;         (add-to-list 'windows (selected-window) t)
    ;;         windows))))
    ;; (advice-add 'aw-window-list :override #'w/get-window-list)
    (setq aw-keys '(?i ?u ?d ?h ?5 ?6 ?7 ?8 ?9 ?0 ?1 ?2 ?3 ?4)
          aw-dispatch-alist '((?x aw-delete-window "Delete Window")
	                      (?m aw-swap-window "Swap Windows")
	                      (?M aw-move-window "Move Window")
	                      (?c aw-copy-window "Copy Window")
	                      (?j aw-switch-buffer-in-window "Select Buffer")
	                      (?n aw-flip-window)
	                      (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
	                      (?c aw-split-window-fair "Split Fair Window")
	                      (?v aw-split-window-vert "Split Vert Window")
	                      (?b aw-split-window-horz "Split Horz Window")
	                      (?o delete-other-windows "Delete Other Windows")
	                      (?? aw-show-dispatch-help)))
    (global-set-key (kbd "M-i") #'ace-window))
  (use-package winner
    :init
    (add-hook 'after-init-hook #'winner-mode)
    (global-set-key (kbd "M-SPC w u") #'winner-undo)
    (global-set-key (kbd "M-SPC w r") #'winner-redo)
    :config
    (diminish 'winner-mode)))

(provide 'w-config)
;;; init-config ends here
