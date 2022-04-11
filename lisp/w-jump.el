;;;  -*- lexical-binding: t; -*-
(straight-use-package 'dumb-jump)
;; (straight-use-package 'citre)


;;; dumb-jump
;; (setq dumb-jump-force-searcher 'rg) ;; rg is not working for at least elisp files
(with-eval-after-load 'xref
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(setq citre-enable-capf-integration t
      citre-enable-xref-integration t
      citre-enable-imenu-integration t
      citre-auto-enable-citre-mode-modes '(java-mode nxml-mode)
      citre-tags-file-global-cache-dir (w/locate-emacs-var-file ".cache/ctags"))

;; citre 用着不顺手
;; (add-hook 'after-init-hook (lambda () (require 'citre-config)))

(with-eval-after-load 'citre-peek
  (define-key citre-peek-keymap (kbd "M-SPC M-.") #'citre-peek-through))

(defun citre-peek-or-dump-jump ()
  (interactive)
  (if (and (boundp 'citre-mode) citre-mode) (citre-peek) (dumb-jump-go)))


(global-set-key (kbd "M-SPC M-.") #'citre-peek-or-dump-jump)
(global-set-key (kbd "M-SPC M-,") #'citre-jump-back)

(provide 'w-jump)
