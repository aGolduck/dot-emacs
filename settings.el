;;;  -*- lexical-binding: t; -*-
;;; set up variables not categorised
(setq create-lockfiles nil
      ;; confirm-kill-emacs nil
      delete-by-moving-to-trash t
      frame-inhibit-implied-resize t ;; stop resizing when toggling tab-bar-mode
      frame-resize-pixelwise t
      initial-major-mode 'fundamental-mode
      mac-command-modifier 'super
      mac-option-modifier 'meta
      next-screen-context-lines 5
      nsm-trust-local-network t
      visible-bell t
      word-wrap-by-category t)
(setq-default indent-tabs-mode nil
	      line-spacing 0.2)


;;; fonts and faces
(setq w/font-default-height
      (cond
       ((string-match w/HOST "wenpin-iMac") 180)
       ((string-match w/HOST "xps") 120) ;; font size: 16, 1.0 屏幕缩放
       ;; ((string-match w/HOST "xps") 96) ;; font size: 16, 1.25 屏幕缩放
       ((string-match w/HOST "mo") 108)
       (t 108)))
;; default font, default background for emacs-native-comp is too light for background of region face
(set-face-attribute 'default nil :background "#fcfcfc" :family "JetBrains Mono" :height w/font-default-height)
;; fallback font
(set-fontset-font t nil "Courier New" nil 'append)
;; specific glyphs
;; (set-fontset-font t ?😊 "Segoe UI Emoji")
;; glyphs range
;; (set-fontset-font t '(?😊 . ?😎) "Segoe UI Emoji")
;; emoji
(set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)
;; (set-fontset-font t 'han "Source Han Sans CN")
(set-fontset-font t 'han "Noto Sans CJK SC")
;; han fallback font
;; (set-fontset-font t 'han "Noto Sans CJK SC" nil 'append)
(set-fontset-font t 'han "Source Han Sans CN" nil 'append)
;; search font for han if both fonts above can't be found
(set-fontset-font t 'han (font-spec :script 'han) nil 'append)
;; other cjk
(set-fontset-font t 'kana "Noto Sans CJK JP")
(set-fontset-font t 'hangul "Noto Sans CJK KR")
(set-fontset-font t 'cjk-misc "Noto Sans CJK SC")
;; other faces
;; TODO try face-spec-set
(set-face-attribute 'fixed-pitch nil :family "Source Code Pro")
;; TODO Iosevka was deleted from system
(set-face-attribute 'fixed-pitch-serif nil :family "Iosevka Slab Extended")
;; using Noto Sans CJK to stop hight changing of tab-bar
(set-face-attribute 'variable-pitch nil :family "Noto Sans CJK SC")

;;; extra keybindings
;;; -*- lexical-binding: t; -*-
(define-key key-translation-map (kbd "C-.") (kbd "C-x 4 ."))
;; (defun w/ivy-switch-buffer-in-other-window ()
;;   (interactive)
;;   (call-interactively #'ivy-switch-buffer-other-window)
;;   (other-window 1))
;;; available punctuations
;; (global-set-key (kbd "C-;"))
;; (global-set-key (kbd "C-'"))
;; (global-set-key (kbd "C-="))
;; (global-set-key (kbd "C--"))
;; (global-set-key (kbd "M-="))
;;; Commands of these keybindings are almost never used, just rebind them
;; (global-set-key (kbd "C-l"))
;; (global-set-key (kbd "C-o"))
;; (global-set-key (kbd "C-z"))
;; (global-set-key (kbd "M-`"))
;; (global-set-key (kbd "M-j"))
;; (global-set-key (kbd "M-m"))
;; (global-set-key (kbd "M-r"))
;; (global-set-key (kbd "M-z"))
;;; C-M-x keybindings
;; (global-set-key (kbd "C-m-...") ...)
;;; abbrev keybindings which need to be research
;; (global-set-key (kbd "M-/"))
;;; These keybindings are for English writing, which I rarely used,
;; So they are worth rebinding
;; (global-set-key (kbd "M-c"))
;; (global-set-key (kbd "M-h"))
;; (global-set-key (kbd "M-l"))
;; (global-set-key (kbd "M-k"))
;; (global-set-key (kbd "M-q"))
;; (global-set-key (kbd "M-u"))
;;; 下面几种键位可能只能用于图形界面
;; F1 -- F12
;; menu
;; some win +
;; first class keybindings, 1 key
;; C-c zone
;;; M-Spc 2 key strokes zone
;; (global-set-key (kbd "M-SPC SPC") #'w/snails)
;;; M-SPC 3 key strokes zone
;; (global-set-key (kbd "M-SPC B B") #'w/ivy-switch-buffer-in-other-window)
