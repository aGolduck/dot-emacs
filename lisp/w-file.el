;;; -*- lexical-binding: t; -*-
;;; common settings
(setq auto-save-default nil
      make-backup-files nil
      safe-local-variable-values '((flycheck-disable-checker '(emacs-lisp-checkdoc))
                                   (org-startup-with-inline-images . t)))
(global-set-key (kbd "M-SPC f F") #'find-file-other-window)
(global-set-key (kbd "M-SPC f f") #'find-file)
(global-set-key (kbd "M-SPC q q") #'save-buffers-kill-terminal)
(with-eval-after-load 'view
  (diminish 'view-mode "览"))

;;; auto-save
(require 'auto-save)
(setq auto-save-silent t
      auto-save-delete-trailing-whitespace t)
(add-hook 'after-init-hook #'auto-save-enable)
;; saveplace to save position visited last time
(setq auto-save-list-file-prefix nil)
(setq save-place-file (w/locate-emacs-var-file "places"))
(add-hook 'after-init-hook #'save-place-mode)

;;; auto-revert
(add-hook 'after-init-hook #'global-auto-revert-mode)

;;; recentf
(setq recentf-auto-cleanup 'never
      recentf-save-file (w/locate-emacs-var-file "recentf")
      recentf-max-saved-items nil)
;; https://www.emacswiki.org/emacs/RecentFiles#toc21
(defun recentd-track-opened-file ()
  "Insert the name of the directory just opened into the recent list."
  (and (derived-mode-p 'dired-mode) default-directory
       (recentf-add-file (substring default-directory 0 -1)))
  ;; Must return nil because it is run from `write-file-functions'.
  nil)
(defun recentd-track-closed-file ()
  "Update the recent list when a dired buffer is killed.
That is, remove a non kept dired from the recent list."
  (and (derived-mode-p 'dired-mode) default-directory
       (recentf-remove-if-non-kept (substring default-directory 0 -1))))
(add-hook 'dired-after-readin-hook 'recentd-track-opened-file)
(add-hook 'kill-buffer-hook 'recentd-track-closed-file)
(add-hook 'after-init-hook #'recentf-mode)

;;; tramp
(setq tramp-persistency-file-name (w/locate-emacs-var-file "tramp"))

;;; so long mode
(add-hook 'after-init-hook #'global-so-long-mode)

;;; self-defined functions
(defun w/copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let* ((file-path (if (equal major-mode 'dired-mode)
                        default-directory
                      (buffer-file-name)))
         (file-name (file-name-nondirectory file-path)))
    (when file-name
      (kill-new file-name)
      (message "Copied buffer file name '%s' to the clipboard." file-name))))

(defun w/copy-file-path-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let* ((file-path (if (equal major-mode 'dired-mode)
                        default-directory
                      (buffer-file-name))))
    (when file-path
      (kill-new file-path)
      (message "Copied buffer file path '%s' to the clipboard." file-path))))


(provide 'w-file)
