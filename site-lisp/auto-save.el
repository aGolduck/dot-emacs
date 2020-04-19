;;; copied from https://github.com/manateelazycat/auto-save/blob/25ebe49d3da5ff050d97bbda408083375d78e479/auto-save.el

(defgroup auto-save nil
  "Save file(s) automatically when emacs is idle."
  :group 'auto-save)

(defcustom auto-save-idle 1
  "How many seconds after emacs is idle to save file."
  :type 'integer
  :group 'auto-save)

(defcustom auto-save-silent nil
  "Do not notify in minibuffer if not-nil."
  :type 'boolean
  :group 'auto-save)

(defcustom auto-save-delete-trailing-whitespace nil
  "Delete trailing whitespace except current line before saving if not-nil."
  :type 'boolean
  :group 'auto-save)

(defvar auto-save-disable-predicates nil
  "Disable auto-save in these cases")

(setq auto-save-default nil)

(defun auto-save-buffers ()
  (interactive)
  (let ((autosave-buffer-list))
    (ignore-errors
      (save-excursion
        (dolist (buf (buffer-list))
          (set-buffer buf)
          (when (and
                 ;; Buffer associate with a filename?
                 (buffer-file-name)
                 ;; Buffer is modifiable?
                 (buffer-modified-p)
                 ;; Yassnippet is not active?
                 (or (not (boundp 'yas--active-snippets))
                     (not yas--active-snippets))
                 ;; Company is not active?
                 (or (not (boundp 'company-candidates))
                     (not company-candidates))
                 ;; tell auto-save don't save
                 (not (seq-some (lambda (predicate)
                                  (funcall predicate))
                                auto-save-disable-predicates)))
            (push (buffer-name) autosave-buffer-list)
            (if auto-save-silent
                ;; `inhibit-message' can shut up Emacs, but we want
                ;; it doesn't clean up echo area during saving
                (with-temp-message ""
                  (let ((inhibit-message t))
                    (basic-save-buffer)))
              (basic-save-buffer))
            ))
        ;; Tell user when auto save files.
        (unless auto-save-silent
          (cond
           ;; It's stupid tell user if nothing to save.
           ((= (length autosave-buffer-list) 1)
            (message "# Saved %s" (car autosave-buffer-list)))
           ((> (length autosave-buffer-list) 1)
            (message "# Saved %d files: %s"
                     (length autosave-buffer-list)
                     (mapconcat 'identity autosave-buffer-list ", ")))))
        ))))

(defun auto-save-delete-trailing-whitespace-except-current-line ()
  (interactive)
  (when auto-save-delete-trailing-whitespace
    (let ((begin (line-beginning-position))
          (end (line-end-position)))
      (save-excursion
        (when (< (point-min) begin)
          (save-restriction
            (narrow-to-region (point-min) (1- begin))
            (delete-trailing-whitespace)))
        (when (> (point-max) end)
          (save-restriction
            (narrow-to-region (1+ end) (point-max))
            (delete-trailing-whitespace)))))))

(defvar auto-save-timer nil)

(defun auto-save-set-timer ()
  "Set auto-saveTime. Cancel all previous timers."
  (auto-save-cancel-timer)
  (setq auto-save-timer
	(run-with-idle-timer auto-save-idle t 'auto-save-buffers)))

(defun auto-save-cancel-timer ()
  (when auto-save-timer
    (cancel-timer auto-save-timer)
    (setq auto-save-timer nil)))


(defun auto-save-enable ()
  (interactive)
  (auto-save-set-timer)
  (add-hook 'before-save-hook 'auto-save-delete-trailing-whitespace-except-current-line)
  (add-hook 'before-save-hook 'font-lock-flush))

(defun auto-save-disable ()
  (auto-save-cancel-timer)
  (remove-hook 'before-save-hook 'auto-save-delete-trailing-whitespace-except-current-line)
  (remove-hook 'before-save-hook 'font-lock-flush))

(provide 'auto-save)
