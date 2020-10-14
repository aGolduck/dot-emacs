;;; -*- lexical-binding: t; -*-
(define-key key-translation-map (kbd "C-.") (kbd "C-x 4 ."))

(defun smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))
(defun smart-open-line-below ()
  "Insert an empty line below the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent)
  (indent-according-to-mode))
(defun wenpin/split-window-right ()
  "split-window-right with right window having a max width of 100 columns"
  (interactive)
  (if (> (window-total-width) 200)
      (split-window-right -100)
    (if (> (window-total-width) 180)
        (split-window-right -90)
      (split-window-right))))
(defun wenpin/split-window-right-and-focus ()
  (interactive)
  (wenpin/split-window-right)
  (other-window 1))
(defun wenpin/ivy-switch-buffer-in-other-window ()
  (interactive)
  (call-interactively #'ivy-switch-buffer-other-window)
  (other-window 1))

;;; available punctuations
;; (global-set-key (kbd "C-;"))
;; (global-set-key (kbd "C-'"))
;; (global-set-key (kbd "C-."))
;; (global-set-key (kbd "C-="))
;; (global-set-key (kbd "C--"))
;; (global-set-key (kbd "M-="))
;; (global-set-key (kbd "M--"))
;;; Commands of these keybindings are almost never used, just rebind them
;; (global-set-key (kbd "C-l"))
;; (global-set-key (kbd "C-o"))
;; (global-set-key (kbd "C-z"))
;; (global-set-key (kbd "M-i"))
;; (global-set-key (kbd "M-j"))
;; (global-set-key (kbd "M-m"))
;; (global-set-key (kbd "M-r"))
;; (global-set-key (kbd "M-z"))
;;; C-M-x keybindings
;; (global-set-key (kbd "C-m-...") ...)
;;; abbrev keybindings which need to be research
;; (global-set-key (kbd "M-'"))
;; (global-set-key (kbd "M-/"))
;;; These keybindings are for English writing, which I rarely used,
;; So they are worth rebinding
;; (global-set-key (kbd "M-a"))
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
(global-set-key (kbd "C-o") #'smart-open-line-below)
(global-set-key (kbd "M-o") #'smart-open-line-above)
;; C-c zone
;;; M-Spc 2 key strokes zone
;; (global-set-key (kbd "M-SPC SPC") #'wenpin/snails)
(global-set-key (kbd "M-SPC u") #'universal-argument)
;;; M-SPC 3 key strokes zone
(global-set-key (kbd "M-SPC B B") #'wenpin/ivy-switch-buffer-in-other-window)
(global-set-key (kbd "M-SPC b k") #'kill-buffer)
(global-set-key (kbd "M-SPC f F") #'find-file-other-window)
(global-set-key (kbd "M-SPC f f") #'find-file)
(global-set-key (kbd "M-SPC q q") #'save-buffers-kill-terminal)
(global-set-key (kbd "M-SPC w D") #'delete-other-windows)
(global-set-key (kbd "M-SPC w S") #'wenpin/split-window-right-and-focus)
(global-set-key (kbd "M-SPC w V") (defun wenpin/split-window-and-focus () (interactive) (split-window-below) (other-window 1)))
(global-set-key (kbd "M-SPC w X") (defun wenpin/swap-window-and-focus () (interactive) (window-swap-states) (other-window 1)))
(global-set-key (kbd "M-SPC w d") #'delete-window)
(global-set-key (kbd "M-SPC w s") #'wenpin/split-window-right)
(global-set-key (kbd "M-SPC w v") #'split-window-below)
(global-set-key (kbd "M-SPC w x") #'window-swap-states)
