;;;  -*- lexical-binding: t; -*-

(when (string-match w/HOST "BINGEZHOU-MB0")
  (setq lsp-java-java-path "/Users/w/.sdkman/candidates/java/11.0.2-open/bin/java"
        rime-emacs-module-header-root "/usr/local/Cellar/emacs-mac/emacs-27.2-mac-8.2/include")
  (setq-default line-spacing 0)

  (set-face-attribute 'default nil :background "#fcfcfc" :family "PragmataPro" :height w/font-default-height)


  (add-hook 'nxml-mode-hook #'lsp)
  )

(provide 'w-local)
