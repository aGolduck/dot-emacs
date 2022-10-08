;;; -*- lexical-binding: t; -*-



;;; load common packages for selectrum/vertico/icomplete/fido

(straight-use-package 'consult)
(straight-use-package 'marginalia)
(straight-use-package 'orderless)
;; (straight-use-package 'embark)
;; (straight-use-package 'embark-consult)
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
(setq consult-preview-key nil)          ;; consult-buffer previews files too, just inhibit preview
(setq-default consult-project-root-function #'projectile-project-root)
;; (global-set-key (kbd "M-SPC f r") #'consult-recent-file)  ;; use crux-find-recent-file instead, no need to access tramp files just for marginalia information
(global-set-key [remap switch-to-buffer] 'consult-buffer)
(global-set-key [remap switch-to-buffer-other-window] 'consult-buffer-other-window)
;; (defun sanityinc/consult-ripgrep-at-point (&optional dir initial)
;;   (interactive (list prefix-arg (when-let ((s (symbol-at-point)))
;;                                   (symbol-name s))))
;;   (consult-ripgrep dir initial))

;; consult-isearch 作为 edit 没有历史，作为 C-s 又会清除当前搜索串
;; (define-key isearch-mode-map (kbd "M-e") #'consult-isearch)
(with-eval-after-load 'isearch
  (define-key isearch-mode-map (kbd "M-e") #'consult-isearch-history))

(setq-default marginalia-annotators '(marginalia-annotators-heavy))
(add-hook 'after-init-hook 'marginalia-mode)

;; (with-eval-after-load 'embark
;;   (define-key selectrum-minibuffer-map (kbd "C-c C-o") #'embark-export))

(provide 'w-minibuffer)
