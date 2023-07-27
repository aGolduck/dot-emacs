;;; -*- lexical-binding: t; -*-



;;; load common packages for selectrum/vertico/icomplete/fido

(straight-use-package 'consult)
(straight-use-package 'marginalia)
(straight-use-package 'orderless)
(straight-use-package 'embark)
(straight-use-package 'embark-consult)
;; (straight-use-package 'mini-frame)




;;; self-defined function
(defun w/use-orderless-in-minibuffer ()
  (setq-local completion-styles '(substring orderless)
              completion-category-overrides '((file (styles basic partial-completion)))))



;; vertico
(straight-use-package 'vertico)
(with-eval-after-load 'vertico
  (require 'orderless)
  (add-hook 'minibuffer-setup-hook #'w/use-orderless-in-minibuffer))
(add-hook 'after-init-hook #'vertico-mode)

;; fido-mode 启动后无法使用 orderless, 切 vertico 再切 fido 好像又可以，应该是 hook 有问题
;; fido-mode 界面不友好，fido-vertical-mode 卡顿较严重
(with-eval-after-load 'fido-mode
  (require 'orderless)
  (add-hook 'minibuffer-setup-hook #'w/use-orderless-in-minibuffer))
;; (if (fboundp 'fido-vertical-mode)
;;     (add-hook 'after-init-hook 'fido-vertical-mode)
;;   (add-hook 'after-init-hook 'fido-mode))



;;; set up minibuffer common packages

(setq enable-recursive-minibuffers t
      completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)
(setq savehist-file (w/locate-emacs-var-file "history"))
(add-hook 'after-init-hook #'savehist-mode)

;; consult
;; (setq consult-preview-key nil)          ;; consult-buffer previews files too, just inhibit preview, 副作用：全局禁止
(with-eval-after-load 'consult
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; my/command-wrapping-consult    ;; disable auto previews inside my command
   :preview-key '(:debounce 0.4 any) ;; Option 1: Delay preview
   ;; :preview-key "M-.")            ;; Option 2: Manual preview
   ))
(setq-default consult-project-root-function #'projectile-project-root)
;; (global-set-key (kbd "M-SPC f r") #'consult-recent-file)  ;; use crux-find-recent-file instead, no need to access tramp files just for marginalia information
(global-set-key [remap switch-to-buffer] 'consult-buffer)
(global-set-key [remap switch-to-buffer-other-window] 'consult-buffer-other-window)
(if (executable-find "rg")
    (global-set-key (kbd "M-SPC s p") #'consult-ripgrep)
  (global-set-key (kbd "M-SPC s p") #'consult-grep))


;; consult-isearch 作为 edit 没有历史，作为 C-s 又会清除当前搜索串
;; (define-key isearch-mode-map (kbd "M-e") #'consult-isearch)
(with-eval-after-load 'isearch
  (define-key isearch-mode-map (kbd "M-e") #'consult-isearch-history))
(with-eval-after-load 'em-hist
  (define-key eshell-hist-mode-map (kbd "M-r") #'consult-history))

(setq-default marginalia-annotators '(marginalia-annotators-heavy))
(add-hook 'after-init-hook 'marginalia-mode)

(global-set-key (kbd "C-.") #'embark-act)

(provide 'w-minibuffer)
