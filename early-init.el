;;; -*- lexical-binding: t; -*-

;; accelerate loading init files, will be reset by gcmh
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

;; Package initialize occurs automatically, before `user-init-file' is
;; loaded, but after `early-init-file'. We use straight to handle package
;; initialization, so we must prevent Emacs from doing it early!
(setq package-enable-at-startup nil)

;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t)

;; Faster to disable these here (before they've been initialized)
;; (push '(menu-bar-lines . 0) default-frame-alist)
;; (push '(tool-bar-lines . 0) default-frame-alist)  ;; this may cause emacs frame expand
;; (push '(vertical-scroll-bars) default-frame-alist)
;; (when (featurep 'ns)
;;   (push '(ns-transparent-titlebar . t) default-frame-alist))

(setq comp-deferred-compilation t)

;; disable emacs-native-comp warings
;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44746
(setq comp-async-report-waring-errors nil)

(setq native-comp-deferred-compilation-deny-list nil)
