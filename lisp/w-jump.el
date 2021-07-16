;;;  -*- lexical-binding: t; -*-
(straight-use-package 'dumb-jump)
(straight-use-package 'citre)
(straight-use-package '(clue :host github :repo "AmaiKinono/clue"))


;;; dumb-jump
;; (setq dumb-jump-force-searcher 'rg) ;; rg is not working for at least elisp files
(with-eval-after-load 'xref
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(setq citre-enable-capf-integration t
      citre-enable-xref-integration t
      citre-enable-imenu-integration t
      citre-tags-file-global-cache-dir (w/locate-emacs-var-file ".cache/ctags"))

(global-set-key (kbd "M-SPC M-.") #'citre-peek)
(global-set-key (kbd "M-SPC M-,") #'citre-jump-back)

(with-eval-after-load 'cc-mode (require 'citre-lang-c))
(with-eval-after-load 'dired (require 'citre-lang-fileref))

(add-hook 'java-mode-hook #'citre-auto-enable-citre-mode)
(add-hook 'nxml-mode-hook #'citre-auto-enable-citre-mode)

(provide 'w-jump)
