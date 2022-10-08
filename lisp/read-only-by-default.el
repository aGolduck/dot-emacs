;; -*- lexical-binding: t; -*-
(require 'simple)                       ;; for read-only-mode

(setq view-read-only nil)

(define-minor-mode w/extra-read-only-mode
  "add a keymap to read-only-mode which does not have a keymap"
  :lighter nil
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map "i" (lambda () (interactive) (read-only-mode -1)))
            map))

(add-hook 'read-only-mode-hook
          (lambda () (if buffer-read-only
                         (progn
                           (setq cursor-type 'box)
                           (w/extra-read-only-mode 1))
                       (progn
                         (setq cursor-type 'bar)
                          (w/extra-read-only-mode -1)))))

;;; cursor-type for not file buffer
(with-eval-after-load 'vterm
  (add-hook 'vterm-copy-mode-hook
            (lambda () (if vterm-copy-mode (setq cursor-type 'box) (setq cursor-type 'bar)))))
(dolist (write-mode-hook
         (list
          'eshell-mode-hook
          'lisp-interaction-mode-hook
          'org-capture-mode-hook
          'vterm-mode-hook
          'with-editor-mode-hook
          ))
  (add-hook write-mode-hook (lambda () (setq cursor-type 'bar))))
(dolist (read-mode-hook
         (list
          'org-agenda-mode-hook
          ))
  (add-hook read-mode-hook (lambda () (setq cursor-type 'box))))

;;; read-only-mode for file buffers
(defun w/read-only-mode-hook-for-find-file ()
  (if (可达鸭/是要排除的文件 (buffer-file-name))
      (setq cursor-type 'bar)
    (read-only-mode 1)))

(defun 可达鸭/是要排除的文件 (目标文件名)
  (cl-some (lambda (白名单文件) (string-match 白名单文件 目标文件名))
           '(".emacs/var"
             "org/orgzly"
             "org/roam"
             "org/journal"
             ".git/COMMIT_EDITMSG"
             ".dir-locals.el"
             ".emacs.d/straight"        ;; for straight compiling packages
             ".org-src-babel"
             )))
;; TODO: add variable watcher to 'buffer-read-only for buffer-read-only to set cursor-type
(defvar w/original-read-only-mode-buffers nil)
(defvar w/read-only-by-default nil)
(defun set-read-only-mode-by-default ()
  "add read-only-mode to find-file-hook"
  (interactive)
  (dolist (buffer w/original-read-only-mode-buffers)
    (save-excursion
      ;; in case buffer is deleted
      (ignore-errors
        (set-buffer buffer)
        (read-only-mode 1))))
  (setq w/original-read-only-mode-buffers nil)
  (add-hook 'find-file-hook #'w/read-only-mode-hook-for-find-file)
  (setq w/read-only-by-default t))
(defun unset-read-only-mode-by-default ()
  "remove remove-read-only-mode from find-file-hook"
  (interactive)
  (dolist (buffer (buffer-list))
    (save-excursion
      (set-buffer buffer)
      ;; for file buffers only
      (when (and buffer-read-only buffer-file-name)
        ;; some files are trully read-only, just ignore errors when failed
        (ignore-errors
          (read-only-mode -1)
          (add-to-list 'w/original-read-only-mode-buffers buffer)))))
  (remove-hook 'find-file-hook #'w/read-only-mode-hook-for-find-file)
  (setq w/read-only-by-default nil))
(defun toggle-read-only-mode-by-default ()
  "set or unset read-only-mode by default"
  (interactive)
  (if w/read-only-by-default
      (unset-read-only-mode-by-default)
    (set-read-only-mode-by-default)))
(set-read-only-mode-by-default)

;; hooks provided by built-in emacs are not enough
;; (add-hook 'window-buffer-change-functions
;;           (lambda (window) (term-cursor--immediate)) nil nil)
;; (add-hook 'window-state-change-functions
;;           (lambda (window) (term-cursor--immediate)) nil nil)
;; (add-hook 'window-state-change-hook #'term-cursor--immediate)
;; (add-hook 'switch-buffer-functions
;;           (lambda (previous-buffer currrent-buffer) (term-cursor--immediate)))

(provide 'read-only-by-default)
