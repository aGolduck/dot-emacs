;;;  -*- lexical-binding: t; -*-

;; mostly copy from https://github.com/cnsunyour/.doom.d/blob/develop/modules/cnsunyour/chinese/config.el
(w/straight-use-package-unless-featurep 'rime #'rime-activate)
(setq default-input-method "rime"
      rime-translate-keybindings '("C-f" "C-b" "C-n" "C-p" "C-g") ;; 发往 librime 的快捷键
      rime-librime-root (if (eq system-type 'darwin) (locate-user-emacs-file "rime/librime-mac/dist"))
      rime-user-data-dir (locate-user-emacs-file "rime")
      rime-show-candidate 'posframe
      rime-posframe-style 'simple)
(global-set-key (kbd "M-t") #'toggle-input-method)
(global-set-key (kbd "s-SPC") #'toggle-input-method)

(with-eval-after-load 'rime
  (define-key rime-mode-map (kbd "C-`") #'rime-send-keybinding)
  (define-key rime-mode-map (kbd "C-S-`") #'rime-send-keybinding)
  (unless (fboundp 'rime--posframe-display-content)
    (error "Function `rime--posframe-display-content' is not available.")))

(provide 'w-rime)
