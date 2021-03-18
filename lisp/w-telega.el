 ;;;  -*- lexical-binding: t; -*-
(straight-use-package '(telega :host github :repo "zevlg/telega.el" :branch "releases"))

(defun w/my-telega-chat-mode ()
  (set (make-local-variable 'company-backends)
       (append (list telega-emoji-company-backend
                     'telega-company-username
                     'telega-company-hashtag)
               (when (telega-chat-bot-p telega-chatbuf--chat)
                 '(telega-company-botcmd))))
  (toggle-input-method)
  (company-mode 1))
(setq telega-avatar-text-compose-chars nil
      telega-chat-show-avatars nil
      telega-directory (w/locate-emacs-var-file "telega")
      telega-server-libs-prefix "~/.guix-profile")
(add-hook 'telega-load-hook #'telega-appindicator-mode)
(add-hook 'telega-load-hook #'telega-mode-line-mode)
(add-hook 'telega-load-hook #'telega-notifications-mode)
(add-hook 'telega-chat-mode-hook #'w/my-telega-chat-mode)

(with-eval-after-load 'telega
  (require 'telega-transient)
  (telega-transient-mode 1))

(provide 'w-telega)
