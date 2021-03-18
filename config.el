;;; -*- lexical-binding: t; -*-
(use-package abbrev :config (diminish 'abbrev-mode "缩")) ;; just to diminish

(use-package ansi-color
  :init
  (add-hook 'compilation-filter-hook
            (lambda ()
              (let ((buffer-read-only nil))
                (ansi-color-apply-on-region (point-min) (point-max))))))

(use-package auth-source
  :init (setq auth-sources '((:source (w/locate-emacs-var-file ".authinfo.gpg")))))

(use-package avy
  :init
  (global-set-key (kbd "M-SPC g g") #'avy-goto-char-timer)
  (global-set-key (kbd "M-SPC g l") #'avy-goto-line)
  (global-set-key (kbd "M-SPC g w") #'avy-goto-word-0))

(use-package bookmark
  :init
  (setq bookmark-default-file (w/locate-emacs-var-file "bookmarks"))
  (global-set-key (kbd "M-SPC b s") #'bookmark-set))

;; (use-package browse-url
;;   :init
;;   (when (string-equal w/HOST "xps")
;;     (setq browse-url-browser-function 'eaf-open-browser)))

(use-package calendar :init (setq calendar-chinese-all-holidays-flag t))

(use-package clojure-mode
  :init
  (add-hook 'clojure-mode-hook #'electric-pair-local-mode)
  (use-package cider))

(use-package crux
  :init
  (global-set-key (kbd "C-o") #'crux-smart-open-line)
  (global-set-key (kbd "M-o") #'crux-smart-open-line-above)
  (global-set-key (kbd "M-SPC f r") #'crux-recentf-find-file))

(use-package desktop
  :init
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
                (desktop-save-mode)))))

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

;; (use-package eldoc
;;   :commands (eldoc-add-command)
;;   :config (diminish 'eldoc-mode "册"))

(use-package emmit-mode)

(use-package epg-config :init (setq epg-pinentry-mode 'loopback))

(use-package eww :init (add-hook 'eww-mode #'visual-line-mode))

(use-package expand-region
  :init
  (setq expand-region-contract-fast-key "V")
  (global-set-key (kbd "M-SPC v") #'er/expand-region))

(use-package find-func
  :init
  (setq find-function-C-source-directory "~/b/gnu.org/emacs/emacs-native-comp/src")
  (global-set-key (kbd "M-SPC F F") #'find-function-other-window)
  (global-set-key (kbd "M-SPC F f") #'find-function)
  (global-set-key (kbd "M-SPC F V") #'find-variable-other-window)
  (global-set-key (kbd "M-SPC F v") #'find-variable))

(use-package font-lock
  :config
  (set-face-attribute 'font-lock-comment-face nil :height 0.9))

(use-package frame :init (add-hook 'after-init-hook #'blink-cursor-mode))

;; (use-package fuz :config (unless (require 'fuz-core nil t) (fuz-build-and-load-dymod)))

(use-package gcmh
  :init (add-hook 'after-init-hook #'gcmh-mode)
  :config (diminish 'gcmh-mode))

(use-package go-translate
  :init
  ;; (setq go-translate-base-url "https://translate.google.cn")
  (setq go-translate-local-language "zh-CN")
  :config
  (defun go-translate-token--extract-tkk () (cons 430675 2721866130)))

(use-package goto-addr :init (add-hook 'after-init-hook #'goto-address-mode))

(use-package graphql-mode)

(use-package groovy-mode
  :init
  (setq lsp-groovy-server-file (locate-user-emacs-file "resources/groovy-language-server-all.jar"))
  (when (equal w/lsp-client "lsp")
    (add-hook 'groovy-mode-hook #'lsp))
  (add-hook 'groovy-mode-hook #'company-mode)
  (add-hook 'groovy-mode-hook #'electric-pair-local-mode))

(use-package guix)

(use-package helpful
  :init
  ;; (setq counsel-describe-function-function #'helpful-callable
  ;;       counsel-describe-variable-function #'helpful-variable)
  ;; (global-set-key (kbd "C-h f") #'helpful-callable)
  ;; (global-set-key (kbd "C-h v") #'helpful-variable)
  ;; (global-set-key (kbd "C-h F") #'helpful-function)
  ;; (global-set-key (kbd "C-h C") #'helpful-command)
  (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-h o") #'helpful-symbol))

(use-package hexl :init (add-hook 'hexl-mode-hook #'view-mode))

(use-package hi-lock
  :init
  ;; remove ugly hi-yellow from default
  (setq hi-lock-face-defaults '("hi-pink" "hi-green" "hi-blue" "hi-salmon" "hi-aquamarine" "hi-black-b" "hi-blue-b" "hi-red-b" "hi-green-b" "hi-black-hb"))
  (global-set-key (kbd "M-SPC h f") #'hi-lock-find-patterns)
  (global-set-key (kbd "M-SPC h l") #'highlight-lines-matching-regexp)
  (global-set-key (kbd "M-SPC h p") #'highlight-phrase)
  (global-set-key (kbd "M-SPC h r") #'highlight-regexp)
  (global-set-key (kbd "M-SPC h s") #'highlight-symbol-at-point)
  (global-set-key (kbd "M-SPC h u") #'unhighlight-regexp)
  (global-set-key (kbd "M-SPC h w") #'hi-lock-write-interactive-patterns)
  :config (diminish 'hi-lock-mode "亮"))

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

(use-package isearch
  :config
  (diminish 'isearch-mode)
  (global-set-key (kbd "C-s") #'isearch-forward-regexp)
  (global-set-key (kbd "C-M-s") #'isearch-forward)
  (define-key isearch-mode-map (kbd "C-w") #'isearch-yank-symbol-or-char)
  (define-key isearch-mode-map (kbd "C-M-w") #'isearch-yank-word-or-char))

(use-package js-mode
  :init
  (setq js-indent-level 2)
  (add-hook 'js-mode-hook (lambda ()
                            (when (executable-find "tsserver")
                              (tide-setup)
                              (unless (tide-current-server) (tide-restart-server))
                              (tide-hl-identifier-mode 1))))
  (dolist (hooked (list
                   #'company-mode
                   #'eldoc-mode
                   #'electric-pair-local-mode
                   ))
    (add-hook 'js-mode-hook hooked)))

(use-package json-mode)

(use-package keyfreq
  :init
  (setq keyfreq-excluded-commands 'nil)
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
  (add-hook 'after-init-hook #'keyfreq-autosave-mode))

(use-package link-hint)

(use-package make-mode
  :init (add-to-list 'auto-mode-alist '("\\.gmk" . makefile-mode)))

(use-package markdown-mode
  :init
  (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (setq markdown-command "multimarkdown"))

(use-package nxml-mode
  :init
  (setq lsp-xml-jar-file (expand-file-name (locate-user-emacs-file "resources/org.eclipse.lemminx-uber.jar")))
  (when (equal w/lsp-client "lsp")
    ;; download from http://mirrors.ustc.edu.cn/eclipse/lemminx/
    (add-hook 'nxml-mode-hook #'lsp))
  (add-hook 'nxml-mode-hook #'smartparens-mode))

(use-package olivetti)

(use-package pdf-tools)

(use-package pkgbuild-mode)

(use-package pocket-reader)

(use-package projectile
  :init
  (defun w/projectile-shortened-mode-line ()
    "Report project name shortened and type in the modeline."
    (let* ((project-name (projectile-project-name))
           (project-type (projectile-project-type))
           (shortened-project-name (if (< (length project-name) 10)
                                       project-name
                                     (concat (substring project-name 0 7) "..." (substring project-name -3 nil)))))
      (format "%s[%s]"
              projectile-mode-line-prefix
              (or shortened-project-name "-")
              ;; (if project-type
              ;;     (format ":%s" project-type)
              ;;   "")
              )))
  (setq ;; projectile-completion-system 'ivy
   projectile-cache-file (w/locate-emacs-var-file "projectile.cache")
   projectile-known-projects-file (w/locate-emacs-var-file "projectile-bookmarks.eld")
   projectile-mode-line-function 'w/projectile-shortened-mode-line
   projectile-mode-line-prefix "项"
   projectile-project-search-path '("~/g" "~/r" "~/b"))
  (when (executable-find "rg")
    (setq-default projectile-generic-command "rg --files --hidden"))
  (add-hook 'after-init-hook #'projectile-mode)
  (global-set-key (kbd "M-SPC p f") #'projectile-find-file)
  (global-set-key (kbd "M-SPC p t") #'projectile-run-vterm)
  (use-package treemacs-projectile))

(use-package python
  :init
  ;; (setq lsp-python-ms-auto-install-server nil
  ;;       lsp-python-ms-executable "~/g/Microsoft/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")
  ;; (add-hook 'python-mode-hook (lambda () (require 'lsp-python-ms) (lsp)))
  (add-hook 'python-mode-hook #'highlight-indent-guides-mode))

(use-package re-builder :init (setq reb-re-syntax 'string))

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

(use-package smartparens :config (require 'smartparens-config))

(use-package subword
  :init (add-hook 'after-init-hook #'global-subword-mode)
  :config (diminish 'subword-mode))

(use-package tab-bar
  :if (>= emacs-major-version 27)
  :init
  (setq tab-bar-show t
        tab-bar-select-tab-modifiers '(meta)
        tab-bar-tab-hints t)
  ;; (setq tab-bar-tab-name-function
  ;;       (defun w/tab-bar-show-file-name ()
  ;;         (let* ((buffer (window-buffer (minibuffer-selected-window)))
  ;;                (file-name (buffer-file-name buffer)))
  ;;           (if file-name file-name (format "%s" buffer)))))
  )

(use-package thing-edit)

(use-package tide
  :init
  (setq tide-completion-detailed t
        tide-always-show-documentation t
        ;; Fix #1792: by default, tide ignores payloads larger than 100kb. This
        ;; is too small for larger projects that produce long completion lists,
        ;; so we up it to 512kb.
        tide-server-max-response-length 524288)
  :config (diminish 'tide-mode "型"))

(use-package transient :init (setq transient-history-file (w/locate-emacs-var-file "transient/history.el")))

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

(use-package typescript-mode
  :init
  (setq typescript-indent-level 2)
  ;; (add-hook 'typescript-mode-hook #'lsp)
  ;; (add-hook 'typescript-mode-hook #'lsp-deferred)
  (dolist (hooked (list
                   #'company-mode
                   #'eldoc-mode
                   #'electric-pair-local-mode
                   ))
    (add-hook 'typescript-mode-hook hooked))
  (when (executable-find "tsserver")
    (dolist (hooked (list #'tide-setup #'tide-hl-identifier-mode))
      (add-hook 'typescript-mode-hook hooked)))
  ;; :config
  ;; (require 'company-lsp)
  ;; (push 'company-lsp company-backends)
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

(use-package yaml-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\.'" . yaml-mode))
  (add-hook 'yaml-mode-hook #'highlight-indent-guides-mode))

;; (use-package battery)

;; (use-package counsel
;;   :init
;;   (global-set-key (kbd "M-y") #'counsel-yank-pop)
;;   (global-set-key (kbd "M-SPC SPC") #'counsel-M-x)
;;   (global-set-key (kbd "M-SPC b j") #'counsel-bookmark)
;;   (global-set-key (kbd "M-SPC f r") #'counsel-recentf)
;;   (global-set-key (kbd "C-h f") #'counsel-describe-function)
;;   (global-set-key (kbd "C-h v") #'counsel-describe-variable))

;; (use-package embark-consult)

;; (use-package hl-todo :init (add-hook 'after-init-hook #'global-hl-todo-mode))

;; (use-package ivy
;;   :init
;;   (setq ivy-use-virtual-buffers t
;; 	enable-recursive-minibuffers t)
;;   (add-hook 'after-init-hook #'ivy-mode)
;;   (global-set-key (kbd "M-SPC b b") #'ivy-switch-buffer)
;;   (global-set-key (kbd "M-SPC b B") #'ivy-switch-buffer-other-window))

;; (use-package ivy-hydra)

;; (use-package ivy-posframe
;;   :init
;;   (setq ivy-posframe-display-functions-alist
;; 	'(
;; 	  ;; (swiper . ivy-posframe-display-at-point)
;; 	  (t . ivy-posframe-display-at-frame-center)))
;;   ;; (ivy-posframe-height-alist '((swiper . 20) (t . 40)))
;;   ;; (ivy-posframe-parameters '((left-fringe . 8) (right-fringe . 8)))
;;   (add-hook 'ivy-mode-hook #'ivy-posframe-mode)
;;   (global-set-key (kbd "M-SPC T p") #'ivy-posframe-mode))

;; (use-package ivy-prescient :init
;;   (add-hook 'ivy-mode-hook (lambda () (ivy-prescient-mode -1) (ivy-prescient-mode 1)))
;;   (add-hook 'counsel-mode-hook (lambda () (ivy-prescient-mode -1) (ivy-prescient-mode 1))))

;; (use-package ivy-rich :init (add-hook 'ivy-mode-hook #'ivy-rich-mode))

;; (use-package ivy-xref
;;   :init
;;   ;; xref initialization is different in Emacs 27 - there are two different
;;   ;; variables which can be set rather than just one
;;   (when (>= emacs-major-version 27)
;;     (setq xref-show-definitions-function #'ivy-xref-show-defs))
;;   ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
;;   ;; commands other than xref-find-definitions (e.g. project-find-regexp)
;;   ;; as well
;;   (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

;; (use-package lsp-ivy)

;; (use-package mini-frame
;;   :init
;;   (setq mini-frame-show-parameters
;;                              `((left . ,(truncate (/ (frame-pixel-width) 10)))
;;                                (top . ,(truncate (* (frame-pixel-height) 0.3)))
;;                                (width . 0.8)
;;                                (height . 10)
;;                                (vertical-scroll-bars . nil)))
;;   (add-hook 'window-configuration-change-hook
;;             (lambda () (when (> (frame-pixel-height) 400)  ;; exclude mini-frame
;;                          (setq mini-frame-show-parameters
;;                                `((left . ,(truncate (/ (frame-pixel-width) 10)))
;;                                  (top . ,(truncate (* (frame-pixel-height) 0.3)))
;;                                  (width . 0.8)
;;                                  (height . 10)
;;                                  (vertical-scroll-bars . nil))))))
;;   (add-hook 'after-init-hook #'mini-frame-mode))

;; (use-package shackle
;;   ;; TODO try shackle-mode/display-buffer-alist some day maybe
;;   :init
;;   ;; TODO 1. split if needed, 2. display buffer in target window, 3. return target window
;;   ;; (defun w/shackle-diplay-in-right-most-window (buffer alist plist)
;;   ;;   (let (window (select-window))
;;   ;;     window))
;;   ;; https://emacs.stackexchange.com/questions/34779/using-shackle-to-split-current-window-instead-of-root
;;   (setq w/left-window-size
;;         (cond
;;          ((> (frame-width) 200) (- (frame-width) 100))
;;          ((> (frame-width) 180) (- (frame-width) 90))
;;          (t (/ (frame-width) 2))))
;;   (setq shackle-rules `(("*Agenda Commands*" :other t :select t)
;;                         (eaf-mode :select t :align below :size 0.3)
;;                         ("\\*Help\\*" :regexp t :other t :align right
;;                          :size ,(/ (* 1.0 (- (frame-width) w/left-window-size))
;;                                   (frame-width))))
;;         ;; shackle-inhibit-window-quit-on-same-windows t
;;         ;; shackle-select-reused-windows t
;;         ;; shackle-default-rule nil
;;    )
;;   (add-hook 'after-init-hook #'shackle-mode))

;; (use-package smex
;;   ;; smex is needed to order candidates for ivy
;;   :init (setq smex-save-file (w/locate-emacs-var-file "smex-items")))

;; (use-package so-long :if (>= emacs-major-version 27) :init (add-hook 'after-init-hook #'global-so-long-mode))

;; (use-package treemacs-magit :demand t)

(use-package delsel :init (add-hook 'after-init-hook #'delete-selection-mode))

(provide 'w-config)
;;; init-config ends here
