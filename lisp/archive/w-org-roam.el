;;; org roam
(straight-use-package '(org-roam :files ("*.el" "extensions/*.el")))

(setq org-roam-v2-ack t
      org-roam-verbose t
      org-roam-db-update-on-save t
      org-roam-directory (file-truename "~/org/roam")
      org-roam-dailies-directory (file-truename "~/org/roam/daily")
      org-roam-db-location (w/locate-emacs-var-file "org-roam.db"))
(global-set-key (kbd "M-SPC n d") #'org-roam-dailies-capture-today)
(global-set-key (kbd "M-SPC n D") #'org-roam-dailies-today)
(global-set-key (kbd "M-SPC n c") #'org-roam-capture)
(global-set-key (kbd "M-SPC n i") #'org-roam-node-insert)
(global-set-key (kbd "M-SPC n n") #'org-roam-node-find)
(with-eval-after-load 'org-roam
  (global-set-key (kbd "M-SPC n l") #'org-roam-buffer-toggle)
  (diminish 'org-roam-mode "记"))
;; (with-eval-after-load 'org
;;   (org-roam-db-autosync-enable))

;;; org-drill
;; (setq persist--directory-location (w/locate-emacs-var-file "persist"))

