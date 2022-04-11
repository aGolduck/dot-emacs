;;; -*- lexical-binding: t; -*-

;;; fonts and faces, wrapped in window-system block, because there is no set-font-font function for emacs-nox
;; to use in multiple frames, wrap in after-make-frame-functions, see https://stackoverflow.com/a/5801740
(when window-system
  (setq w/font-default-height
        (cond
         ((string-match w/HOST "wenpin-iMac") 180)
         ((string-match w/HOST "BINGEZHOU-MB0") 130)
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
  (set-face-attribute 'variable-pitch nil :family "Noto Sans CJK SC"))


(provide 'w-font)
