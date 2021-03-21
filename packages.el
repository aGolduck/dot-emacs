;;;  -*- lexical-binding: t; -*-
;;; 包安装与配置分离，利于包版本集中管理，利于灵活调整包管理工具

(dolist (w/package
         (list
          '(valign :host github :repo "casouri/valign")
          'ace-window
          'avy
          'direnv
          'dotenv-mode
          'go-translate
          'link-hint
          'pdf-tools
          'pocket-reader
          'selectric-mode
          'shackle
          'treemacs
          ))
  (straight-use-package w/package))

(provide 'w-packages)
