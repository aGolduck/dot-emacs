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
(defvar wenpin/view-mode-buffers nil)
(defun wenpin/view-mode-hook-for-find-file ()
  (if (or
       (string-match-p "org/orgzly" (buffer-file-name))
       (string-match-p "org/roam" (buffer-file-name))
       (string-match-p "org/journal" (buffer-file-name))
       (string-match-p ".git/COMMIT_EDITMSG" (buffer-file-name)))
      (setq cursor-type 'bar)
    (view-mode 1)))
;; TODO: add variable watcher for buffer-read-only to set cursor-type
(defun set-default-view-mode ()
  "add view mode to find-file-hook"
  (interactive)
  (dolist (buffer wenpin/view-mode-buffers)
    (save-excursion
      (set-buffer buffer)
      (view-mode 1)))
  (setq wenpin/view-mode-buffers nil)
  (add-hook 'find-file-hook #'wenpin/view-mode-hook-for-find-file))
(defun unset-default-view-mode ()
  "remove view mode from find-file-hook"
  (interactive)
  (dolist (buffer (buffer-list))
    (save-excursion
      (set-buffer buffer)
      (when view-mode
        (view-mode -1)
        (add-to-list 'wenpin/view-mode-buffers buffer))))
  (remove-hook 'find-file-hook #'wenpin/view-mode-hook-for-find-file))
(set-default-view-mode)

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
       ((string-match "xps" (or (getenv "DESKTOP_STARTUP_ID") "")) 108)
       (t 112)))
;; default font
(set-face-attribute 'default nil :family "JetBrains Mono" :height wenpin/font-default-height)
;; fallback font
(set-fontset-font t nil "Courier New" nil 'append)
;; specific glyphs
;; (set-fontset-font t ?😊 "Segoe UI Emoji")
;; glyphs range
;; (set-fontset-font t '(?😊 . ?😎) "Segoe UI Emoji")
;; han default font, DO NOT USE "noto cjk", not working!!!
(set-fontset-font t 'han "Source Han Sans CN")
;; han fallback font
(set-fontset-font t 'han "Source Han Sans CN" nil 'append)
;; search font for han if both fonts above can't be found
(set-fontset-font t 'han (font-spec :script 'han) nil 'append)
;; other cjk
(set-fontset-font t 'kana "Source Han Sans CN")
(set-fontset-font t 'hangul "Source Han Sans CN")
(set-fontset-font t 'cjk-misc "Source Han Sans CN")
;; other faces
(set-face-attribute 'fixed-pitch nil :family "Source Code Pro")
(set-face-attribute 'fixed-pitch-serif nil :family "Iosevka Slab Extended")
;; using Source Han Sans to stop hight chaning of tab-bar
(set-face-attribute 'variable-pitch nil :family "Source Han Sans CN")
