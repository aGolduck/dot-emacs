;;;  -*- lexical-binding: t; -*-

(when (string-match w/HOST "BINGEZHOU-MB0")
  (setq lsp-java-java-path "/Users/w/.sdkman/candidates/java/11.0.2-open/bin/java"
        org-clock-watch-play-sound-command-str "afplay"
        rime-emacs-module-header-root "/usr/local/Cellar/emacs-mac/emacs-27.2-mac-8.2/include")

  (setq-default line-spacing 0)

  ;; (add-hook 'nxml-mode-hook #'lsp)

  ;; erlang
  (setq erlang-root-dir
        (concat "/usr/local/Cellar/erlang/"
                (substring (shell-command-to-string "brew info erlang | head -n1 | cut -f3 -d' '") 0 -1)))
  (setq load-path
        (cons
         (substring
          (shell-command-to-string
           (concat "ls -d " erlang-root-dir "/lib/erlang/lib/tools-*" "/emacs"))
          0 -1)
         load-path))
  ;; (require 'erlang-start)
  
  (when window-system
    (set-face-attribute 'default nil :background "#fcfcfc" :family "PragmataPro" :height w/font-default-height)))

(provide 'w-local)
