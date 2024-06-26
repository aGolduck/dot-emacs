;;;  -*- lexical-binding: t; -*-
(straight-use-package 'ace-window)

;;; ace-window
;; (defun w/get-window-list ()
;;   (if (<= (length (window-list)) 2)
;;       (window-list)
;;     (save-excursion
;;       (let ((windows nil))
;;         (ignore-errors (dotimes (i 10) (windmove-left)))
;;         (ignore-errors (dotimes (i 10) (windmove-up)))
;;         (add-to-list 'windows (selected-window) t)
;;         (ignore-errors (dotimes (i 10) (windmove-right)))
;;         (ignore-errors (dotimes (i 10) (windmove-up)))
;;         (add-to-list 'windows (selected-window) t)
;;         (ignore-errors (dotimes (i 10) (windmove-left)))
;;         (ignore-errors (dotimes (i 10) (windmove-down)))
;;         (add-to-list 'windows (selected-window) t)
;;         (ignore-errors (dotimes (i 10) (windmove-right)))
;;         (ignore-errors (dotimes (i 10) (windmove-down)))
;;         (add-to-list 'windows (selected-window) t)
;;         windows))))
;; (advice-add 'aw-window-list :override #'w/get-window-list)
;; TODO disable ace-window
(setq aw-keys '(?i ?u ?d ?h ?5 ?6 ?7 ?8 ?9 ?0 ?1 ?2 ?3 ?4)
      aw-dispatch-alist '((?x aw-delete-window "Delete Window")
	                  (?m aw-swap-window "Swap Windows")
	                  (?M aw-move-window "Move Window")
	                  (?c aw-copy-window "Copy Window")
	                  (?j aw-switch-buffer-in-window "Select Buffer")
	                  (?n aw-flip-window)
	                  (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
	                  (?c aw-split-window-fair "Split Fair Window")
	                  (?v aw-split-window-vert "Split Vert Window")
	                  (?b aw-split-window-horz "Split Horz Window")
	                  (?o delete-other-windows "Delete Other Windows")
	                  (?? aw-show-dispatch-help)))
(global-set-key (kbd "M-i") #'ace-window)

(with-eval-after-load 'ace-window
  (require 'w-ui-minimal)
  (advice-add 'ace-window :after #'w/闪烁上下文))

(provide 'w-ace-window)
