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


(provide 'default-view)
