;;; -*- lexical-binding: t; -*-



;;; load common packages for selectrum/vertico/icomplete

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



;;;  choose one minibuffer completion framework

;; selectrum
(straight-use-package 'selectrum)
(straight-use-package 'prescient)
(straight-use-package 'selectrum-prescient)

(setq selectrum-fix-vertical-window-height t
      selectrum-max-window-height 10)
(autoload 'prescient-persist-mode "prescient")
(add-hook 'selectrum-mode-hook #'selectrum-prescient-mode)
;; (add-hook 'after-init-hook #'selectrum-mode)
;; (add-hook 'after-init-hook #'prescient-persist-mode)


;; vertico
(straight-use-package 'vertico)
(with-eval-after-load 'vertico
  (require 'orderless)
  (add-hook 'minibuffer-setup-hook #'w/use-orderless-in-minibuffer))
(add-hook 'after-init-hook #'vertico-mode)


;; icomplete-vertical
(straight-use-package 'icomplete-vertical)
(with-eval-after-load 'icomplete
  (icomplete-vertical-mode 1)
  (require 'orderless)
  (add-hook 'minibuffer-setup-hook #'w/use-orderless-in-minibuffer)

  ;; <RETURN> is not available for command line, see http://ergoemacs.org/emacs/emacs_key_notation_return_vs_RET.html
  (define-key icomplete-minibuffer-map (kbd "RET") #'icomplete-force-complete-and-exit)
  (define-key icomplete-minibuffer-map (kbd "TAB") #'icomplete-force-complete)
  (define-key icomplete-minibuffer-map (kbd "C-j") #'icomplete-ret)
  (define-key icomplete-minibuffer-map (kbd "<down>") #'icomplete-forward-completions)
  (define-key icomplete-minibuffer-map (kbd "C-n") #'icomplete-forward-completions)
  (define-key icomplete-minibuffer-map (kbd "<up>") #'icomplete-backward-completions)
  (define-key icomplete-minibuffer-map (kbd "C-p") #'icomplete-backward-completions))
;; (add-hook 'after-init-hook #'icomplete-mode)
;; (icomplete-vertical-mode)



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
  (define-key isearch-mode-map (kbd "M-e") #'consult-isearch))

(setq-default marginalia-annotators '(marginalia-annotators-heavy))
(add-hook 'after-init-hook 'marginalia-mode)

;; (with-eval-after-load 'embark
;;   (define-key selectrum-minibuffer-map (kbd "C-c C-o") #'embark-export))

(provide 'w-minibuffer)
