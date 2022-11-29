;;; -*- lexical-binding: t; -*-

;; accelerate loading init files, will be reset by gcmh
(setq gc-cons-threshold most-positive-fixnum
      ;; gc-cons-percentage 0.6
      )

;; Package initialize occurs automatically, before `user-init-file' is
;; loaded, but after `early-init-file'. We use straight to handle package
;; initialization, so we must prevent Emacs from doing it early!
(setq package-enable-at-startup nil)

;; [From DOOM Emacs]
;; In noninteractive sessions, prioritize non-byte-compiled source files to
;; prevent the use of stale byte-code. Otherwise, it saves us a little IO time
;; to skip the mtime checks on every *.elc file.
(setq load-prefer-newer noninteractive)

;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t)

;; Faster to disable these here (before they've been initialized)
;; (push '(menu-bar-lines . 0) default-frame-alist)
;; (push '(tool-bar-lines . 0) default-frame-alist)  ;; this may cause emacs frame expand
;; (push '(vertical-scroll-bars) default-frame-alist)
;; (when (featurep 'ns)
;;   (push '(ns-transparent-titlebar . t) default-frame-alist))

;; (when (and (fboundp 'native-comp-available-p)
;; 	   (native-comp-available-p))
  
;;   (setq comp-deferred-compilation t)

;;   ;; disable emacs-native-comp warings
;;   ;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44746
;;   (setq comp-async-report-waring-errors nil)

;;   ;; (setq native-comp-deferred-compilation-deny-list '("vertico\\.el$" "vertico-.+\\.el$"))
;;   )
(setq no-native-compile t
      native-comp-deferred-compilation nil)
