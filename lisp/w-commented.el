;;; -*- lexical-binding: t; -*-
(dolist (w/package
         (list
          ;; '(paredit :repo "http://mumble.net/~campbell/git/paredit.git/")
          ;; 'counsel ;; ivy, counsel and swiper belongs to the same repo, but straight.el builds them into different packages
          ;; 'ivy
          ;; 'ivy-hydra
          ;; 'ivy-posframe
          ;; 'ivy-prescient
          ;; 'ivy-rich
          ;; 'ivy-xref
          ;; 'lsp-ivy
          ;; 'swiper
          ))
  (straight-use-package w/package))

;; (use-package battery)

;; (use-package browse-url
;;   :init
;;   (when (string-equal w/HOST "xps")
;;     (setq browse-url-browser-function 'eaf-open-browser)))

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

;; (use-package paredit
;;   :commands (enable-paredit-mode)
;;   :init
;;   (dolist (hook (list
;;                  'eval-expression-minibuffer-setup-hook
;;                  'ielm-mode-hook
;;                  'lisp-mode-hook
;;                  'lisp-interaction-mode-hook
;;                  'scheme-mode-hook
;;                  ))
;;     (add-hook hook #'paredit-mode))
;;   :config
;;   ;; https://emacs-china.org/t/paredit-smartparens/6727/11
;;   (defun paredit/space-for-delimiter-p (endp delm)
;;     (or (member 'font-lock-keyword-face (text-properties-at (1- (point))))
;;         (not (derived-mode-p 'basic-mode
;;                              'c++-mode
;;                              'c-mode
;;                              'coffee-mode
;;                              'csharp-mode
;;                              'd-mode
;;                              'dart-mode
;;                              'go-mode
;;                              'java-mode
;;                              'js-mode
;;                              'lua-mode
;;                              'objc-mode
;;                              'pascal-mode
;;                              'python-mode
;;                              'r-mode
;;                              'ruby-mode
;;                              'rust-mode
;;                              'typescript-mode))))
;;   (add-to-list 'paredit-space-for-delimiter-predicates #'paredit/space-for-delimiter-p)
;;   (eldoc-add-command
;;    'paredit-backward-delete
;;    'paredit-close-round)
;;   (define-key paredit-mode-map (kbd ";") nil) ;; conflict with lispy-comment
;;   (define-key paredit-mode-map (kbd "M-r") nil)
;;   (diminish 'paredit-mode "括"))
