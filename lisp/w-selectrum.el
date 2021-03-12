;;; -*- lexical-binding: t; -*-
(straight-use-package 'selectrum)
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
(setq magit-completing-read-function #'selectrum-completing-read
      selectrum-fix-vertical-window-height t
      selectrum-max-window-height 10)
(add-hook 'after-init-hook #'selectrum-mode)

(straight-use-package 'prescient)
(use-package prescient
  :commands (prescient-persist-mode)
  :init
  (add-hook 'after-init-hook #'prescient-persist-mode))

(straight-use-package 'selectrum-prescient)
(add-hook 'selectrum-mode-hook #'selectrum-prescient-mode)

(straight-use-package 'consult)
(setq consult-preview-key nil)
(setq-default consult-project-root-function #'projectile-project-root)
;; (global-set-key (kbd "M-SPC f r") #'consult-recent-file)  ;; use crux-find-recent-file instead, no need to access tramp files just for marginalia information
(global-set-key (kbd "M-SPC s p") #'consult-ripgrep)
;; consult-isearch 作为 edit 没有历史，作为 C-s 又会清除当前搜索串
;; (define-key isearch-mode-map (kbd "M-e") #'consult-isearch)

(straight-use-package 'marginalia)
(setq-default marginalia-annotators '(marginalia-annotators-heavy))
(add-hook 'after-init-hook 'marginalia-mode)

;; (straight-use-package 'embark)
;; (straight-use-package 'embark-consult)
;; (use-package embark
;;   :config
;;   (define-key selectrum-minibuffer-map (kbd "C-c C-o") #'embark-export))

(provide 'w-selectrum)
