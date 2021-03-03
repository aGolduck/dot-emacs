;;; -*- lexical-binding: t; -*-
;;; how to find out where config code goes?
;; 1. major mode, like typescript-mode, org-mode
;; 2. big minor mode, like ivy-mode, lsp-mode
;; 3. minor mode

(use-package abbrev :config (diminish 'abbrev-mode "缩"))

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

(use-package browse-url
  :init
  (when (string-equal w/HOST "xps")
    (setq browse-url-browser-function 'eaf-open-browser)))

(use-package calendar :init (setq calendar-chinese-all-holidays-flag t))

(use-package cc-mode
  :init
  (add-hook 'c-mode-hook (lambda () (require 'ccls) (lsp)))
  (use-package ccls))

(use-package clojure-mode
  :init
  (add-hook 'clojure-mode-hook #'electric-pair-local-mode)
  (use-package cider))

(use-package color-rg
  :commands
  (color-rg-search-input
   color-rg-search-symbol
   color-rg-search-input-in-project
   color-rg-search-symbol-in-project
   color-rg-search-symbol-in-current-file
   color-rg-search-input-in-current-file
   color-rg-search-project-rails
   color-rg-search-symbol-with-type
   color-rg-search-project-with-type
   color-rg-search-project-rails-with-type)
  :init
  (global-set-key (kbd "M-SPC s P") #'color-rg-search-symbol-in-project)
  ;; (global-set-key (kbd "M-SPC s p") #'color-rg-search-input-in-project)
  )

(use-package crux
  :init
  (global-set-key (kbd "C-o") #'crux-smart-open-line)
  (global-set-key (kbd "M-o") #'crux-smart-open-line-above))

(use-package css-mode :init (add-hook 'css-mode-hook #'lsp))

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

(use-package devdocs)

(use-package dired
  :init
  (setq dired-listing-switches "-Afhlv"
        dired-auto-revert-buffer t
        dired-dwim-target t
        dired-recursive-copies 'always
        dired-recursive-deletes 'top)
  (global-set-key (kbd "M-SPC ^") #'dired-jump)
  :config
  (put 'dired-find-alternate-file 'disabled nil)
  (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)
  (define-key dired-mode-map
    (kbd "^") (lambda () (interactive) (find-alternate-file "..")))
  (use-package dired-rsync)
  (use-package dired-x
    :init
    (setq dired-guess-shell-alist-user '(("\\.doc\\'" "libreoffice")
                                         ("\\.docx\\'" "libreoffice")
                                         ("\\.ppt\\'" "libreoffice")
                                         ("\\.pptx\\'" "libreoffice")
                                         ("\\.xls\\'" "libreoffice")
                                         ("\\.xlsx\\'" "libreoffice")))
    (add-hook 'dired-mode-hook (lambda () (require 'dired-x))))
  (use-package image-dired :init (setq image-dired-dir (w/locate-emacs-var-file "image-dired")))
  (use-package dired-quick-sort
    :straight t
    :commands (hydra-dired-quick-sort/body)
    :init
    (define-key dired-mode-map (kbd "s") #'hydra-dired-quick-sort/body)
    (add-hook 'dired-mode-hook #'dired-quick-sort)))

(use-package direnv
  :if (executable-find "direnv")
  :init (add-hook 'after-init-hook #'direnv-mode))

(use-package dotenv)

(use-package eaf
  :if (eq system-type 'gnu/linux)
  :commands (eaf-browser-restore-buffers eaf-open-this-from-dired)
  :init
  (use-package epc)
  (use-package ctable)
  (use-package deferred)
  (use-package s)
  (setq browse-url-browser-function 'eaf-open-browser
        eaf-browser-continue-where-left-off t
        eaf-config-location (w/locate-emacs-var-file "eaf"))
  (defalias 'browse-web #'eaf-open-browser)
  (global-set-key (kbd "M-SPC s s") #'eaf-search-it)
  (global-set-key (kbd "M-SPC b o") #'eaf-open-browser)
  (global-set-key (kbd "M-SPC b r") #'eaf-open-browser-with-history)
  (defun eaf-find-file-advice (fn file &rest args)
    (pcase (file-name-extension file)
      ("pdf" (eaf-open file nil))
      ("epub" (eaf-open file nil))
      (_ (apply fn file args))))
  (advice-add #'find-file :around #'eaf-find-file-advice)
  :config
  (when (string-equal w/HOST "xps") (eaf-setq eaf-browser-default-zoom "1.00"))
  (define-key eaf-mode-map* (kbd "M-t") #'toggle-input-method)
  (define-key eaf-mode-map* (kbd "M-i") #'ace-window)
  (eaf-bind-key toggle-input-method "M-t" eaf-browser-keybinding)
  (eaf-bind-key ace-window "M-i" eaf-browser-keybinding)
  (eaf-bind-key scroll_down_page "S-SPC" eaf-browser-keybinding)
  (eaf-bind-key scroll_down_page "S-SPC" eaf-pdf-viewer-keybinding))

(use-package ediff-wind
  :init
  (setq ediff-merge-split-window-function 'split-window-vertically
        ediff-split-window-function 'split-window-horizontally
        ediff-window-setup-function 'ediff-setup-windows-plain)
  :config
  (add-hook 'ediff-after-quit-hook-internal #'winner-undo))

(use-package eldoc
  :commands (eldoc-add-command)
  :config (diminish 'eldoc-mode "册"))

(use-package elisp-mode
  :init
  (add-hook 'emacs-lisp-mode-hook #'company-mode)
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'show-paren-mode)
  ;; :config
  ;; (define-key emacs-lisp-mode-map (kbd "M-;") #'paredit-comment-dwim)
  )

(use-package emmit-mode)

(use-package epg-config :init (setq epg-pinentry-mode 'loopback))

(use-package esh-mode
  :init
  (setq eshell-directory-name (w/locate-emacs-var-file "eshell"))
  (add-hook 'eshell-mode-hook #'esh-autosuggest-mode)
  (add-hook 'eshell-mode-hook (lambda () (require 'eshell-z)))
  (add-hook 'eshell-mode-hook
            (lambda ()
              (define-key eshell-mode-map (kbd "C-u") #'eshell-kill-input)))
  (use-package esh-autosuggest :commands (esh-autosuggest-mode))
  (use-package eshell-z))

(use-package eww :init (add-hook 'eww-mode #'visual-line-mode))

(use-package expand-region
  :init
  (setq expand-region-contract-fast-key "V")
  (global-set-key (kbd "M-SPC v") #'er/expand-region))

(use-package files
  :init
  (setq auto-save-default nil
        make-backup-files nil
        safe-local-variable-values '((flycheck-disable-checker '(emacs-lisp-checkdoc))
                                     (org-startup-with-inline-images . t)))
  (global-set-key (kbd "M-SPC f F") #'find-file-other-window)
  (global-set-key (kbd "M-SPC f f") #'find-file)
  (global-set-key (kbd "M-SPC q q") #'save-buffers-kill-terminal)
  (use-package auto-save
    :commands (auto-save-enable)
    :init
    (setq auto-save-silent t
	  auto-save-delete-trailing-whitespace t)
    (add-hook 'after-init-hook #'auto-save-enable))
  (use-package autorevert :init (add-hook 'after-init-hook #'global-auto-revert-mode))
  (use-package recentf
    :init
    (setq recentf-auto-cleanup 'never
          recentf-save-file (w/locate-emacs-var-file "recentf")
          recentf-max-saved-items nil)
    ;; https://www.emacswiki.org/emacs/RecentFiles#toc21
    (defun recentd-track-opened-file ()
      "Insert the name of the directory just opened into the recent list."
      (and (derived-mode-p 'dired-mode) default-directory
           (recentf-add-file (substring default-directory 0 -1)))
      ;; Must return nil because it is run from `write-file-functions'.
      nil)
    (defun recentd-track-closed-file ()
      "Update the recent list when a dired buffer is killed.
That is, remove a non kept dired from the recent list."
      (and (derived-mode-p 'dired-mode) default-directory
           (recentf-remove-if-non-kept (substring default-directory 0 -1))))
    (add-hook 'dired-after-readin-hook 'recentd-track-opened-file)
    (add-hook 'kill-buffer-hook 'recentd-track-closed-file)
    (add-hook 'after-init-hook #'recentf-mode))
  (use-package saveplace
    :init
    (setq auto-save-list-file-prefix nil)
    (setq save-place-file (w/locate-emacs-var-file "places"))
    (add-hook 'after-init-hook #'save-place-mode)
    (use-package sudo-edit))
  (use-package tramp :init (setq tramp-persistency-file-name (w/locate-emacs-var-file "tramp")))
  (use-package view :config (diminish 'view-mode "览")))

(use-package find-func
  :init
  (setq find-function-C-source-directory "~/b/gnu.org/emacs/emacs-native-comp/src")
  (global-set-key (kbd "M-SPC F F") #'find-function-other-window)
  (global-set-key (kbd "M-SPC F f") #'find-function)
  (global-set-key (kbd "M-SPC F V") #'find-variable-other-window)
  (global-set-key (kbd "M-SPC F v") #'find-variable))

(use-package flycheck :config (diminish 'flycheck-mode "检"))

(use-package font-lock
  :config
  (set-face-attribute 'font-lock-comment-face nil :height 0.9))

(use-package frame :init (add-hook 'after-init-hook #'blink-cursor-mode))

(use-package fuz :config (unless (require 'fuz-core nil t) (fuz-build-and-load-dymod)))

(use-package gcmh
  :init (add-hook 'after-init-hook #'gcmh-mode)
  :config (diminish 'gcmh-mode))

(use-package git-link :init (global-set-key (kbd "M-SPC g L") #'git-link))

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
  (add-hook 'groovy-mode-hook #'lsp)
  (add-hook 'groovy-mode-hook #'company-mode)
  (add-hook 'groovy-mode-hook #'electric-pair-local-mode))

(use-package guix)

(use-package haskell-mode
  :init
  (use-package lsp-haskell
    :init
    (add-hook 'haskell-mode-hook #'lsp)
    (add-hook 'haskell-mode-hook #'lsp-ui-mode)
    (add-hook 'haskell-literate-mode-hook #'lsp)
    (add-hook 'haskell-mode-hook #'lsp)))

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

(use-package highlight-indent-guides
  :init
  (setq highlight-indent-guides-method 'character
        ;; highlight-indent-guides-character ?┃
        ;; highlight-indent-guides-character ?│
        ;; highlight-indent-guides-character ?║
        highlight-indent-guides-auto-odd-face-perc 15
        highlight-indent-guides-auto-even-face-perc 55
        highlight-indent-guides-auto-character-face-perc 61.8))

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
                   #'paredit-mode
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

(use-package lsp-java
  :init
  (setq w/path-to-lombok "/usr/share/java/lombok.jar")
  (setq lsp-java-workspace-dir (w/locate-emacs-var-file "workspace")
        lsp-java-vmargs `("-noverify"
                          "-Xmx1G" "-XX:+UseG1GC"
                          "-XX:+UseStringDeduplication"
                          ,(concat "-javaagent:" w/path-to-lombok)
                          ,(concat "-Xbootclasspath/a:" w/path-to-lombok)))
  (add-hook 'java-mode-hook #'company-mode)
  (add-hook 'java-mode-hook #'display-line-numbers-mode)
  (add-hook 'java-mode-hook #'electric-pair-local-mode)
  (add-hook 'java-mode-hook #'paredit-mode)
  (add-hook 'java-mode-hook #'lsp)
  (add-hook 'java-mode-hook #'lsp-ui-mode)
  (add-hook 'java-mode-hook (lambda ()
                              (require 'lsp-java-boot)
                              (lsp-java-boot-lens-mode)
                              (diminish 'lsp-java-boot-lens-mode "弹")))
  (add-hook 'java-mode-hook
            (lambda ()
              (face-remap-add-relative 'font-lock-function-name-face :height 1.5)))
  (use-package dap-java
    :commands (dap-java-debug
               dap-java-run-test-method
               dap-java-debug-test-method
               dap-java-run-test-class
               dap-java-debug-test-class)
    :init
    (setq dap-java-test-runner
          (w/locate-emacs-var-file ".cache/lsp/eclipse.jdt.ls/test-runner/junit-platform-console-standalone.jar"))
    (global-set-key (kbd "M-SPC t t") #'dap-java-run-test-method)
    :config
    (dap-register-debug-template
     "Java run"
     (list :type "java"
           :request "launch"
           :args ""
           :noDebug t
           :cwd nil
           :host "localhost"
           :request "launch"
           :modulePaths []
           :classPaths nil
           :name "JavaRun"
           :projectName nil
           :mainClass nil)))
  (use-package autodisass-java-bytecode :demand t))

(use-package lsp-mode
  :commands (lsp-headerline-breadcrumb-mode)
  :init
  (setq lsp-file-watch-ignored '("[/\\\\]\\.git$" "[/\\\\]\\.hg$" "[/\\\\]\\.bzr$" "[/\\\\]_darcs$" "[/\\\\]\\.svn$" "[/\\\\]_FOSSIL_$" "[/\\\\]\\.idea$" "[/\\\\]\\.ensime_cache$" "[/\\\\]\\.eunit$" "[/\\\\]node_modules$" "[/\\\\]\\.fslckout$" "[/\\\\]\\.tox$" "[/\\\\]\\.stack-work$" "[/\\\\]\\.bloop$" "[/\\\\]\\.metals$" "[/\\\\]target$" "[/\\\\]\\.ccls-cache$" "[/\\\\]\\.deps$" "[/\\\\]build-aux$" "[/\\\\]autom4te.cache$" "[/\\\\]\\.reference$" "/usr/include.*" "[/\\\\]\\.ccls-cache$")
        ;; lsp-diagnostic-package :none
        ;; lsp-enable-file-watchers nil
        ;; lsp-idle-delay 0.500
        lsp-enable-completion-at-point t
        lsp-completion-enable-additional-text-edit t
        lsp-enable-folding nil
        lsp-enable-indentation nil
        lsp-enable-on-type-formatting nil
        lsp-enable-text-document-color nil
        lsp-enable-xref t
        lsp-file-watch-threshold 10000
        lsp-headerline-breadcrumb-enable t
        lsp-log-io t
        lsp-print-performance t
        lsp-semantic-highlighting nil
        read-process-output-max (* 1024 1024))
  (setq lsp-session-file (w/locate-emacs-var-file ".lsp-session-v1")
        lsp-server-install-dir (w/locate-emacs-var-file ".cache/lsp"))
  (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  ;; lsp-completion 使用 yas 补全，但没有补全完没有正确置空 yas--active-snippet，导致 auto-save 检测条件出错
  (add-hook 'lsp-mode-hook #'yas-minor-mode-on)
  ;; TODO should only start after lsp starts
  ;; (add-hook 'lsp-mode-hook
  ;;           (lambda () (run-at-time 10 nil #'lsp-headerline-breadcrumb-mode)))
  ;; (add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode)
  (global-unset-key (kbd "M--"))
  (use-package lsp-ui
    :init
    (setq lsp-ui-sideline-enable t
          lsp-ui-doc-enable t
          ;; lsp-ui-doc-delay .2
          lsp-ui-doc-position 'top)
    :config
    (diminish 'lsp-lens-mode "透")
    (set-face-attribute 'lsp-ui-sideline-code-action nil :foreground "dark green")
    (set-face-attribute 'lsp-ui-sideline-current-symbol nil :background "black")
    (set-face-attribute 'lsp-ui-doc-background nil :background "light grey"))
  (use-package dap-mode
    :init
    (setq dap-breakpoints-file (w/locate-emacs-var-file ".dap-breakpoints"))
    (add-hook 'dap-stopped-hook (lambda (arg) (call-interactively #'dap-hydra)))
    ;; (add-hook 'dap-terminated-hook (lambda (_args) (dap-hydra/nil)))
    :config
    (dap-auto-configure-mode))
  :config
  (define-key lsp-mode-map (kbd "M--") #'lsp-execute-code-action)
  (define-key lsp-mode-map (kbd "M-'") #'lsp-goto-implementation)
  (define-key lsp-mode-map (kbd "M-\"") #'lsp-find-references)
  ;; (diminish 'lsp-mode "语")
  (diminish 'lsp-lens-mode "透"))

(use-package lsp-python-ms)

(use-package magit
  :init
  (setq-default magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)
  (setq magit-process-finish-apply-ansi-colors t)
  (global-set-key (kbd "M-SPC g s") #'magit-status)
  (use-package magit-delta
    :if (executable-find "delta")
    :init (add-hook 'magit-mode-hook #'magit-delta-mode)
    :config (diminish 'magit-delta-mode ""))
  (use-package magit-todos :init (add-hook 'magit-mode-hook #'magit-todos-mode))
  :config
  (define-key magit-status-mode-map (kbd "C-<tab>") nil))

(use-package make-mode
  :init (add-to-list 'auto-mode-alist '("\\.gmk" . makefile-mode)))

(use-package markdown-mode
  :init
  (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (setq markdown-command "multimarkdown"))

(use-package newcomment
  :init
  (global-set-key [remap comment-dwim] #'comment-line)
  (global-set-key [remap paredit-comment-dwim] #'comment-line))

(use-package nxml-mode
  :init
  ;; download from http://mirrors.ustc.edu.cn/eclipse/lemminx/
  (setq lsp-xml-jar-file (expand-file-name (locate-user-emacs-file "resources/org.eclipse.lemminx-uber.jar")))
  (add-hook 'nxml-mode-hook #'smartparens-mode)
  (add-hook 'nxml-mode-hook #'lsp))

(use-package olivetti)

(use-package org
  :init
  (require 'bh-org)
  (setq org-directory "~/org"
	org-archive-location "%s_archive::* Archived Tasks"
	org-archive-mark-done nil
	org-confirm-babel-evaluate nil
	org-default-notes-file (concat org-directory "/orgzly/Inbox.org")
	org-export-with-sub-superscripts nil
	org-html-inline-images t
        org-log-done 'time
	org-outline-path-complete-in-steps nil
        org-preview-latex-default-process 'dvisvgm
	org-refile-target-verify-function 'bh/verify-refile-target
	org-refile-targets (quote ((nil :maxlevel . 9) (org-agenda-files :maxlevel . 9)))
	org-refile-use-outline-path t
        org-return-follows-link t
	org-stuck-projects (quote ("" nil nil ""))
	org-use-sub-superscripts nil)
  (setq org-todo-keywords
	(quote ((sequence "TODO(T)" "NEXT(n)" "|" "DONE(t)")
		(sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c!)" "PHONE" "MEETING")
		;; 下面这行会导致 spacemacs 的 org headings 效果消失，因为关键词重复
		;; (type "EXPERIENCE(e) DEBUG(d) | "DONE")
		(type "EXPERIENCE(e)" "DEBUG(d)" "BOOKMARK(b)" "MARKBOOK(m)")
		)))
  (setq org-todo-state-tags-triggers
	(quote (("CANCELLED" ("CANCELLED" . t))
		("WAITING" ("WAITING" . t))
		("HOLD" ("WAITING") ("HOLD" . t))
		(done ("WAITING") ("HOLD"))
		("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
		("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
		("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))
  (add-hook 'org-mode-hook #'visual-line-mode)
  ;; (add-hook 'org-mode-hook #'valign-mode)
  (use-package ol
    :init
    (defun w/org-link-search-elisp (addressing-string)
      (when (eq major-mode 'emacs-lisp-mode)
        (goto-char (point-min))
        (and (search-forward addressing-string nil t)
             (goto-char (match-beginning 0)))))
    (setq org-link-frame-setup '((file . find-file)))
    (add-hook 'org-execute-file-search-functions #'w/org-link-search-elisp)
    (global-set-key (kbd "M-SPC l s") #'org-store-link))
  (use-package org-agenda
    :init
    (setq org-agenda-restore-windows-after-quit t
  	  org-agenda-files '("~/org/orgzly")
	  org-agenda-log-mode-items '(closed)
	  org-agenda-log-mode-items (quote (closed state))
	  org-agenda-show-future-repeats 'next
	  org-agenda-span 'month
	  org-agenda-tags-todo-honor-ignore-options t)
    (setq org-agenda-custom-commands
	  (quote (("A" "My Agenda"
		   (
		    (tags-todo "-@office/!"
			       ((org-agenda-overriding-header "Next Actions")
			        (org-agenda-tags-todo-honor-ignore-options t)
			        (org-agenda-todo-ignore-scheduled 'future)
			        (org-agenda-skip-function
			         (lambda ()
				   (or (org-agenda-skip-subtree-if 'todo '("HOLD" "WAITING"))
				       (org-agenda-skip-entry-if 'nottodo '("NEXT")))))
			        (org-tags-match-list-sublevels t)
			        (org-agenda-sorting-strategy
			         '(todo-state-down priority-down effort-up category-keep))))
		    (tags-todo "-CANCELLED/!NEXT"
		               ((org-agenda-overriding-header (concat "Project Next Tasks"
		                                                      (if bh/hide-scheduled-and-waiting-next-tasks
		                                                          ""
		                                                        " (including WAITING and SCHEDULED tasks)")))
		                (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
		                (org-tags-match-list-sublevels t)
		                (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		                (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
		                (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
		                (org-agenda-sorting-strategy
		                 '(todo-state-down effort-up category-keep))))
		    (tags "REFILE/!TODO"
			  ((org-agenda-overriding-header "Tasks to Refile")
			   (org-agenda-todo-ignore-scheduled 'future)
			   (org-agenda-todo-ignore-deadlines 'future)
			   (org-tags-match-list-sublevels nil)))
		    (tags-todo "-CANCELLED/!"
		               ((org-agenda-overriding-header "Stuck Projects")
		                (org-agenda-skip-function 'bh/skip-non-stuck-projects)
		                (org-agenda-sorting-strategy
		                 '(category-keep))))
		    (tags-todo "-HOLD-CANCELLED/!"
		               ((org-agenda-overriding-header "Projects")
		                (org-agenda-skip-function 'bh/skip-non-projects)
		                (org-tags-match-list-sublevels 'indented)
		                (org-agenda-sorting-strategy
		                 '(category-keep))))
		    (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
		               ((org-agenda-overriding-header (concat "Project Subtasks"
		                                                      (if bh/hide-scheduled-and-waiting-next-tasks
		                                                          ""
		                                                        " (including WAITING and SCHEDULED tasks)")))
		                (org-agenda-skip-function 'bh/skip-non-project-tasks)
		                (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		                (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
		                (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
		                (org-agenda-sorting-strategy
		                 '(category-keep))))
		    (tags-todo "-REFILE-CANCELLED-WAITING-HOLD-CONTEXT/!"
		               ((org-agenda-overriding-header (concat "Standalone Tasks"
		                                                      (if bh/hide-scheduled-and-waiting-next-tasks
		                                                          ""
		                                                        " (including WAITING and SCHEDULED tasks)")))
		                (org-agenda-skip-function 'bh/skip-project-tasks)
		                (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		                (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
		                (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
		                (org-agenda-sorting-strategy
		                 '(category-keep))))
		    )
		   nil)
		  ("g" . "goto context")
		  ("ga" "year agenda" agenda ""  ((org-agenda-span 'year)
						  (org-agenda-start-on-weekday nil)
						  (org-agenda-show-future-repeats nil)
						  ))
		  ("go" "Office" tags-todo "@office" ((org-agenda-sorting-strategy
						       '(todo-state-down priority-down effort-up category-keep tsia-down))))
		  ("gN" "Night" tags-todo "@night")
		  ("gn" "noon" tags-todo "@noon")
		  ("gb" "bus" tags-todo "@bus")
		  ("gl" "later" tags-todo "LATER")
		  ("G" "Context block agenda"
		   ((tags-todo "@office")
		    (tags-todo "@night")
		    (tags-todo "@noon")
		    (tags-todo "@bus")
		    (tags-todo "LATER")
		    )
		   nil)
		  )))
    (global-set-key (kbd "C-c a") #'org-agenda)
    :config
    (define-key org-agenda-keymap (kbd "R") #'org-agenda-refile))
  (use-package org-capture
    :init
    (setq org-capture-templates
	  '(
	    ("t" "TODO" entry (file+headline org-default-notes-file "INBOX")
	     "* TODO %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :END:\n%i\n  %a")
	    ("n" "Today NEXT" entry (file+headline org-default-notes-file "INBOX")
	     "* NEXT %?\n  SCHEDULED:  %T\n  :PROPERTIES:\n  :CREATED:  %U\n  :END:\n%i\n  %a")
	    ("N" "NOTE" entry (file+headline org-default-notes-file "NOTES")
	     "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n%i\n")
	    ("j" "js source code" entry (file+headline org-default-notes-file "NOTES")
	     "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n  #+begin_src js\n%i  #+end_src\n")
	    ("s" "source code" entry (file+headline org-default-notes-file "NOTES")
	     "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n  #+begin_src %^{source language}\n%i%?  #+end_src\n")
	    ("g" "template group")
	    ("ga" "Template Group A holder" entry (file+headline org-default-notes-file "NOTES")
	     "* %?\n  :PROPERTIES:\n  :CREATED:  %U\n  :CONTEXT:  %a\n:END:\n  #+begin_src %^{source language}\n%i%?  #+end_src\n")
	    ))
    (global-set-key (kbd "C-c c") #'org-capture))
  (use-package org-id :init (setq org-id-locations-file (w/locate-emacs-var-file ".org-id-locations")))
  (use-package org-colview :config (define-key org-columns-map (kbd "SPC") #'org-columns-open-link))
  (use-package ob-clojure)
  (use-package ob-groovy)
  (use-package org-cliplink)
  (use-package org-download
    :demand t
    ;; :init
    ;; FIXME org-link-unescape 不能 decode link
    ;; https://emacs-china.org/t/org-download/2422/3?u=wenpin
    ;; (defun custom-org-download-method (link)
    ;;   (org-download--fullname (org-link-unescape link)))
    ;; (setq org-download-method 'custom-org-download-method) ; 注意：这里不能用lambda表达式
    ;; 顺便改下annotate，就是自动插入的那行注释，里面写的是图片来源路径
    ;; (setq org-download-annotate-function
    ;;       '(lambda (link)
    ;;          (org-download-annotate-default (org-link-unescape link))))
    )
  (use-package org-journal
    :init
    (setq org-journal-dir "~/org/journal"
          org-journal-cache-file (w/locate-emacs-var-file "org-journal.cache")
          org-journal-file-format "%Y%m%d.org"
          org-journal-find-file #'find-file
          org-journal-file-type 'daily
          org-extend-today-until 2
          ;; org-journal-carryover-items nil
          org-journal-date-prefix "* "
          org-journal-date-format "%A, %x"
          org-journal-time-prefix "** "
          org-journal-time-format "%R "))
  (use-package org-pomodoro :init (global-set-key (kbd "M-c") #'org-pomodoro))
  (use-package org-ql)
  (use-package org-roam
    :commands (org-roam-dailies-today org-roam-dailies-capture-today)
    :init
    (setq org-roam-directory (file-truename "~/org/roam")
          org-roam-db-location (w/locate-emacs-var-file "org-roam.db")
          ;; org-roam-completion-system 'ivy
          )
    ;; (add-hook 'org-roam-capture-after-find-file-hook #'winner-undo)
    (global-set-key (kbd "M-SPC n d") #'org-roam-dailies-capture-today)
    (global-set-key (kbd "M-SPC n D") #'org-roam-dailies-today)
    (global-set-key (kbd "M-SPC n n") #'org-roam-find-file)
    (global-set-key (kbd "M-SPC n N") #'org-roam-find-file-immediate)
    :config
    (define-key org-roam-mode-map (kbd "M-SPC n l") #'org-roam)
    (define-key org-roam-mode-map (kbd "M-SPC n h") #'org-roam-jump-to-index)
    (define-key org-mode-map (kbd "M-SPC n i") #'org-roam-insert)
    (diminish 'org-roam-mode "记"))
  (use-package org-roam-server
    :if window-system
    :config
    (require 'org-roam-protocol)
    (setq org-roam-server-host "127.0.0.1"
          org-roam-server-port 4242
          org-roam-server-authenticate nil
          org-roam-server-label-truncate t
          org-roam-server-label-truncate-length 60
          org-roam-server-label-wrap-length 20)
    (diminish 'org-roam-server-mode "图"))
  (use-package ox-hugo)
  :config
  ;; fix error of org-babel-js evaluation
  (setq org-babel-js-function-wrapper
        "console.log(require('util').inspect(function(){\n%s\n}(), { depth: 100 }))")
  ;; TODO ob-jshell
  ;; reference: https://stackoverflow.com/questions/10405461/org-babel-new-language
  (defun org-babel-execute:jsh (body params)
    "Execute a block of jshell code snippets or commands with org-babel"
    (message "Executing jshell snippets")
    (org-babel-eval "jshell --feedback concise" (concat body "\n/exit")))
  (add-to-list 'org-src-lang-modes '("jsh" . "java"))
  (org-babel-do-load-languages 'org-babel-load-languages
			       '((awk . t)
                                 (clojure . t)
                                 (emacs-lisp . t)
                                 (groovy . t)
                                 (haskell . t)
                                 (js . t)
                                 (shell . t)
                                 (typescript . t)))
  (defadvice org-html-paragraph (before org-html-paragraph-advice
					(paragraph contents info) activate)
    "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to html."
    (let* ((origin-contents (ad-get-arg 1))
           (fix-regexp "[[:multibyte:]]")
           (fixed-contents
            (replace-regexp-in-string
             (concat
              "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)") "\\1\\2" origin-contents)))
      (ad-set-arg 1 fixed-contents)))
  (define-key org-mode-map (kbd "C-<tab>") nil))

(use-package paredit
  :commands (enable-paredit-mode)
  :init
  (dolist (hook (list
                 'eval-expression-minibuffer-setup-hook
                 'ielm-mode-hook
                 'lisp-mode-hook
                 'lisp-interaction-mode-hook
                 'scheme-mode-hook
                 ))
    (add-hook hook #'paredit-mode))
  :config
  ;; https://emacs-china.org/t/paredit-smartparens/6727/11
  (defun paredit/space-for-delimiter-p (endp delm)
    (or (member 'font-lock-keyword-face (text-properties-at (1- (point))))
        (not (derived-mode-p 'basic-mode
                             'c++-mode
                             'c-mode
                             'coffee-mode
                             'csharp-mode
                             'd-mode
                             'dart-mode
                             'go-mode
                             'java-mode
                             'js-mode
                             'lua-mode
                             'objc-mode
                             'pascal-mode
                             'python-mode
                             'r-mode
                             'ruby-mode
                             'rust-mode
                             'typescript-mode))))
  (add-to-list 'paredit-space-for-delimiter-predicates #'paredit/space-for-delimiter-p)
  (eldoc-add-command
   'paredit-backward-delete
   'paredit-close-round)
  (define-key paredit-mode-map (kbd ";") nil) ;; conflict with lispy-comment
  (define-key paredit-mode-map (kbd "M-r") nil)
  (diminish 'paredit-mode "括"))

(use-package pdf-tools)

(use-package pkgbuild-mode)

(use-package pocket-reader)

(use-package posframe
  :init
  (use-package flycheck-posframe :init (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))
  (use-package flymake-posframe
    :commands (flymake-posframe-mode)
    :init (add-hook 'flymake-mode-hook #'flymake-posframe-mode)
    :config (diminish 'flycheck-posframe-mode)))

(use-package prescient
  :commands (prescient-persist-mode)
  :init
  (add-hook 'after-init-hook #'prescient-persist-mode)
  (use-package selectrum-prescient :init (add-hook 'selectrum-mode-hook #'selectrum-prescient-mode)))

(use-package projectile
  :init
  (defun w/projectile-shortened-mode-line ()
    "Report project name shortened and type in the modeline."
    (let* ((project-name (projectile-project-name))
           (project-type (projectile-project-type))
           (shortened-project-name (if (< (length project-name) 10)
                                       project-name
                                     (concat (substring project-name 0 7) "..." (substring project-name -3 nil)))))
      (format "%s[%s%s]"
              projectile-mode-line-prefix
              (or shortened-project-name "-")
              (if project-type
                  (format ":%s" project-type)
                ""))))
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
  (setq lsp-python-ms-auto-install-server nil
        lsp-python-ms-executable "~/g/Microsoft/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")
  (add-hook 'python-mode-hook #'highlight-indent-guides-mode)
  (add-hook 'python-mode-hook (lambda () (require 'lsp-python-ms) (lsp))))

(use-package ranger
  :init
  (setq ranger-map-style 'emacs)
  (setq ranger-key (kbd "M-R"))
  (global-set-key (kbd "M-r") #'ranger)
  :config
  (define-key ranger-emacs-mode-map (kbd "n") #'ranger-next-file)
  (define-key ranger-emacs-mode-map (kbd "p") #'ranger-prev-file)
  (define-key ranger-emacs-mode-map (kbd "b") #'ranger-up-directory)
  (define-key ranger-emacs-mode-map (kbd "f") #'ranger-find-file)
  (define-key ranger-emacs-mode-map (kbd "C-n") #'ranger-next-file)
  (define-key ranger-emacs-mode-map (kbd "C-p") #'ranger-prev-file))

(use-package re-builder :init (setq reb-re-syntax 'string))

(use-package rime
  ;; mostly copy from https://github.com/cnsunyour/.doom.d/blob/develop/modules/cnsunyour/chinese/config.el
  :init
  (setq default-input-method "rime"
	rime-translate-keybindings '("C-f" "C-b" "C-n" "C-p" "C-g")  ;; 发往 librime 的快捷键
	rime-librime-root (if (eq system-type 'darwin) (locate-user-emacs-file "rime/librime-mac/dist"))
	rime-user-data-dir (locate-user-emacs-file "rime")
	rime-show-candidate 'posframe
	rime-posframe-style 'simple)
  (global-set-key (kbd "M-t") #'toggle-input-method)
  (global-set-key (kbd "s-SPC") #'toggle-input-method)
  :config
  (define-key rime-mode-map (kbd "C-`") #'rime-send-keybinding)
  (define-key rime-mode-map (kbd "C-S-`") #'rime-send-keybinding)
  (unless (fboundp 'rime--posframe-display-content)
    (error "Function `rime--posframe-display-content' is not available.")))

(use-package rust-mode
  :init
  (add-hook 'rust-mode-hook #'lsp))

(use-package screenshot-svg)

(use-package selectric-mode
  :if (executable-find "aplay")
  :init
  ;; 不禁用会导致 <up>, <down> 等语义改变，致使 previous-line, next-line 等 remap 失败
  (setq selectric-affected-bindings-list nil)
  (add-hook 'after-init-hook #'selectric-mode)
  :config
  (diminish 'selectric-mode))

(use-package selectrum
  :init
  ;; (defun display-buffer-show-in-posframe (buffer _alist)
  ;;   (frame-root-window
  ;;    (posframe-show buffer
  ;;                   :min-height 10
  ;;                   :min-width (truncate (* (frame-width) 0.8))
  ;;                   :internal-border-width 1
  ;;                   :left-fringe 8
  ;;                   :right-fringe 8
  ;;                   :poshandler 'posframe-poshandler-frame-center)))
  ;; (setq selectrum-display-action '(display-buffer-show-in-posframe))
  ;; (add-hook 'minibuffer-exit-hook 'posframe-delete-all)
  (setq magit-completing-read-function #'selectrum-completing-read)
  (add-hook 'after-init-hook #'selectrum-mode)
  (use-package consult
    :init
    (setq consult-preview-key nil)
    (setq-default consult-project-root-function #'projectile-project-root)
    (global-set-key (kbd "M-SPC f r") #'consult-recent-file)
    (global-set-key (kbd "M-SPC s p") #'consult-ripgrep)
    ;; consult-isearch 作为 edit 没有历史，作为 C-s 又会清除当前搜索串
    ;; (define-key isearch-mode-map (kbd "M-e") #'consult-isearch)
    )
  (use-package marginalia
    :init
    (add-hook 'after-init-hook 'marginalia-mode)
    (setq-default marginalia-annotators '(marginalia-annotators-heavy))))

(use-package sgml-mode :init (add-hook 'html-mode-hook #'lsp))

(use-package simple
  :init
  (add-hook 'after-init-hook #'global-visual-line-mode)
  (global-set-key (kbd "M-SPC SPC") #'execute-extended-command)
  (global-set-key (kbd "M-SPC u") #'universal-argument)
  :config
  (diminish 'visual-line-mode "⮒"))

(use-package smartparens :config (require 'smartparens-config))

(use-package snails
  :if window-system
  ;; both w/snails snails need to be in commands, otherwise emacs can not recognize type of w/snails
  :commands (w/snails snails)
  :init
  ;; (when (eq system-type 'darwin)
  ;;   (setq snails-default-backends '(
  ;;       			    snails-backend-buffer
  ;;       			    snails-backend-recentf
  ;;       			    snails-backend-imenu
  ;;       			    snails-backend-current-buffer
  ;;       			    snails-backend-rg
  ;;       			    snails-backend-projectile
  ;;       			    snails-backend-mdfind
  ;;       			    snails-backend-fasd
  ;;       			    snails-backend-command
  ;;       			    )))
  ;; (when (eq system-type 'gnu/linux)
  ;;   (setq snails-default-backends '(
  ;; 			    snails-backend-buffer
  ;; 			    snails-backend-recentf
  ;; 			    snails-backend-imenu
  ;; 			    snails-backend-current-buffer
  ;; 			    snails-backend-rg
  ;; 			    snails-backend-projectile
  ;; 			    snails-backend-fd
  ;; 			    snails-backend-fasd
  ;; 			    snails-backend-command
  ;; 			    snails-backend-eaf-pdf-table
  ;; 			    snails-backend-eaf-browser-history
  ;; 			    snails-backend-eaf-browser-open
  ;; 			    snails-backend-eaf-browser-search
  ;; 			    snails-backend-eaf-github-search
  ;; 			    )))
  (setq snails-use-exec-path-from-shell nil))

(use-package subword
  :init (add-hook 'after-init-hook #'global-subword-mode)
  :config (diminish 'subword-mode))

(use-package tab-bar
  :if (> emacs-major-version 26)
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

(use-package tab-line
  :if (> emacs-major-version 26)
  :init
  (setq tab-line-tab-name-function 'tab-line-tab-name-truncated-buffer)
  (add-hook 'after-init-hook #'global-tab-line-mode))

(use-package telega
  :init
  (defun w/my-telega-chat-mode ()
    (set (make-local-variable 'company-backends)
         (append (list telega-emoji-company-backend
                       'telega-company-username
                       'telega-company-hashtag)
                 (when (telega-chat-bot-p telega-chatbuf--chat)
                   '(telega-company-botcmd))))
    (toggle-input-method)
    (company-mode 1))
  (setq telega-avatar-text-compose-chars nil
        telega-chat-show-avatars nil
        telega-directory (w/locate-emacs-var-file "telega")
        telega-server-libs-prefix "~/.guix-profile")
  (add-hook 'telega-load-hook #'telega-appindicator-mode)
  (add-hook 'telega-load-hook #'telega-mode-line-mode)
  (add-hook 'telega-load-hook #'telega-notifications-mode)
  (add-hook 'telega-chat-mode-hook #'w/my-telega-chat-mode)
  :config
  (require 'telega-transient)
  (telega-transient-mode 1))

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
                   #'paredit-mode
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

(use-package vc-hooks :init (setq vc-follow-symlinks t))

(use-package vterm
  :init
  (setq vterm-buffer-name-string "vterm %s"
        vterm-keymap-exceptions '("C-c" "C-x" "C-g" "C-h" "C-l" "M-x" "M-o" "C-v" "M-v" "C-y" "M-y" "M-i")
        vterm-kill-buffer-on-exit t
        vterm-shell "zsh"
        vterm-term-environment-variable "eterm-color")
  ;; (add-hook 'vterm-mode-hook
  ;;           (lambda ()
  ;;             (set (make-local-variable 'buffer-face-mode-face) 'fixed-pitch-serif)
  ;;             (buffer-face-mode t)))
  :config (set-face-attribute 'vterm-color-green nil :foreground "dark green"))

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

(use-package woman :init (global-set-key (kbd "M-SPC d m") #'woman))

(use-package yaml-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\.'" . yaml-mode))
  (add-hook 'yaml-mode-hook #'highlight-indent-guides-mode))

(use-package yasnippet
  :config
  ;; (define-key yas-minor-mode-map (kbd "<tab>") #'yas-expand)
  ;; (define-key yas-minor-mode-map (kbd "TAB") #'yas-expand)
  (diminish 'yas-minor-mode "模")
  (use-package yasnippet-snippets))

(use-package zeal-at-point)

;; (use-package battery)

;; (use-package counsel
;;   :init
;;   (global-set-key (kbd "M-y") #'counsel-yank-pop)
;;   (global-set-key (kbd "M-SPC SPC") #'counsel-M-x)
;;   (global-set-key (kbd "M-SPC b j") #'counsel-bookmark)
;;   (global-set-key (kbd "M-SPC f r") #'counsel-recentf)
;;   (global-set-key (kbd "C-h f") #'counsel-describe-function)
;;   (global-set-key (kbd "C-h v") #'counsel-describe-variable))

;; (use-package embark
;;   :config
;;   (define-key selectrum-minibuffer-map (kbd "C-c C-o") #'embark-export))

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

;; (use-package lsp-java-boot
;;   :init (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode))

;; (use-package lsp-java-boot)

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

;; (use-package org-alert
;;   :commands (org-alert-enable)
;;   :init
;;   (setq alert-default-style 'libnotify))

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

;; (use-package so-long :if (> emacs-major-version 26) :init (add-hook 'after-init-hook #'global-so-long-mode))

;; (use-package term-cursor
;;   :init
;;   (setq term-cursor-triggers '(blink-cursor-mode-hook
;;                                post-command-hook
;;                                lsp-ui-doc-frame-hook))
;;   (add-hook 'after-init-hook #'global-term-cursor-mode))

;; (use-package treemacs-magit :demand t)

(use-package dumb-jump
  :init
  ;; (setq dumb-jump-force-searcher 'rg) ;; rg is not working for at least elisp files
  (global-set-key (kbd "M-SPC M-.") #'dumb-jump-go)
  ;; (global-set-key (kbd "M-SPC M-,") #'dumb-jump-back) ;; not neccesary, use M-,
  )

(use-package delsel :init (add-hook 'after-init-hook #'delete-selection-mode))

(use-package paren
  :init
  (setq show-paren-when-point-in-periphery t
        show-paren-when-point-inside-paren t))

(provide 'init-config)
;;; init-config ends here
