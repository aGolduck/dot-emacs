;;; cursor-type
(add-hook 'view-mode-hook
          (lambda () (if view-mode (setq cursor-type 'box) (setq cursor-type 'bar))))
(add-hook 'vterm-copy-mode-hook
          (lambda () (if vterm-copy-mode (setq cursor-type 'box) (setq cursor-type 'bar))))
(dolist (writeonly-mode-hook
         (list
          'eshell-mode-hook
          'lisp-interaction-mode-hook
          'org-capture-mode-hook
          'vterm-mode-hook
          'with-editor-mode-hook
          ))
  (add-hook writeonly-mode-hook (lambda () (setq cursor-type 'bar))))
(dolist (readonly-mode-hook
         (list
          'org-agenda-mode-hook
          ))
  (add-hook readonly-mode-hook (lambda () (setq cursor-type 'box))))
(add-hook 'find-file-hook
	  (lambda ()
            (if (or
		 (string-match-p "org/orgzly" (buffer-file-name))
		 (string-match-p "org/roam" (buffer-file-name))
		 (string-match-p "org/journal" (buffer-file-name))
		 (string-match-p ".git/COMMIT_EDITMSG" (buffer-file-name)))
	        (setq cursor-type 'bar)
              (view-mode))))
;; hooks provided by built-in emacs are not enough
;; (add-hook 'window-buffer-change-functions
;;           (lambda (window) (term-cursor--immediate)) nil nil)
;; (add-hook 'window-state-change-functions
;;           (lambda (window) (term-cursor--immediate)) nil nil)
;; (add-hook 'window-state-change-hook #'term-cursor--immediate)
;; (add-hook 'switch-buffer-functions
;;           (lambda (previous-buffer currrent-buffer) (term-cursor--immediate)))


;;; set up variables not categorised
(setq create-lockfiles nil
      delete-by-moving-to-trash t
      mac-command-modifier 'super
      mac-option-modifier 'meta
      nsm-trust-local-network t
      visible-bell t)
(setq-default indent-tabs-mode nil
	      line-spacing 0.2)


;;; fonts and faces
(setq wenpin/font-default-height
      (cond
       ((string-equal (getenv "HOME") "/Users/wenpin") 180)
       ((string-match "xps" (or (getenv "DESKTOP_STARTUP_ID") "")) 98)
       (t 112)))
;; default font
(set-face-attribute 'default nil :family "JetBrains Mono" :height wenpin/font-default-height)
;; fallback font
(set-fontset-font t nil "Courier New" nil 'append)
;; specific glyphs
;; (set-fontset-font t ?😊 "Segoe UI Emoji")
;; glyphs range
;; (set-fontset-font t '(?😊 . ?😎) "Segoe UI Emoji")
;; han default font
(set-fontset-font t 'han "Noto Sans CJK SC Regular")
;; han fallback font
(set-fontset-font t 'han "Source Han Sans CN Regular" nil 'append)
;; search font for han if both fonts above can't be found
(set-fontset-font t 'han (font-spec :script 'han) nil 'append)
;; other cjk
(set-fontset-font t 'kana "Noto Sans CJK JP Regular")
(set-fontset-font t 'hangul "Noto Sans CJK KR Regular")
(set-fontset-font t 'cjk-misc "Noto Sans CJK KR Regular")
;; other faces
;; TODO create fontsets for fixed-pitch and fixed-pitch-serif
(set-face-attribute 'fixed-pitch nil :family "Source Code Pro")
(set-face-attribute 'fixed-pitch-serif nil :family "Iosevka Slab Extended")