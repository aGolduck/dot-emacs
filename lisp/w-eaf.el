(straight-use-package 's)
(straight-use-package 'epc)
(straight-use-package 'ctable)
(straight-use-package 'deferred)
(straight-use-package '(emacs-application-framework :host github :repo "manateelazycat/emacs-application-framework" :files ("*")))

(when (eq system-type 'gnu/linux)
  (autoload 'eaf-browser-restore-buffers "eaf")
  (autoload 'eaf-open-this-from-dired "eaf")
  (setq browse-url-browser-function 'eaf-open-browser
        eaf-browser-continue-where-left-off t
        eaf-config-location (w/locate-emacs-var-file "eaf"))
  ;; (defalias 'browse-web #'eaf-open-browser)
  (global-set-key (kbd "M-SPC s s") #'eaf-search-it)
  (global-set-key (kbd "M-SPC b o") #'eaf-open-browser)
  (global-set-key (kbd "M-SPC b r") #'eaf-open-browser-with-history)
  (defun eaf-find-file-advice (fn file &rest args)
    (pcase (file-name-extension file)
      ("pdf" (eaf-open file nil))
      ("epub" (eaf-open file nil))
      (_ (apply fn file args))))
  (advice-add #'find-file :around #'eaf-find-file-advice)
  (with-eval-after-load 'eaf
    (when (string-equal w/HOST "xps") (eaf-setq eaf-browser-default-zoom "1.00"))
    (define-key eaf-mode-map* (kbd "M-t") #'toggle-input-method)
    (define-key eaf-mode-map* (kbd "M-i") #'ace-window)
    (eaf-bind-key toggle-input-method "M-t" eaf-browser-keybinding)
    (eaf-bind-key ace-window "M-i" eaf-browser-keybinding)
    (eaf-bind-key scroll_down_page "S-SPC" eaf-browser-keybinding)
    (eaf-bind-key scroll_down_page "S-SPC" eaf-pdf-viewer-keybinding)))


(provide 'w-eaf)
