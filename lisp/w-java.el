(add-hook 'java-mode-hook #'company-mode)
(add-hook 'java-mode-hook #'display-line-numbers-mode)
(add-hook 'java-mode-hook #'electric-pair-local-mode)
(add-hook 'java-mode-hook
          (lambda ()
            (face-remap-add-relative 'font-lock-function-name-face :height 1.5)))

;;; lsp-java
(when (equal w/lsp-client "lsp")
  (straight-use-package 'lsp-java)
  (setq w/path-to-lombok "/usr/share/java/lombok.jar")
  (setq lsp-java-workspace-dir (w/locate-emacs-var-file "workspace")
        lsp-java-vmargs `("-noverify"
                          "-Xmx1G" "-XX:+UseG1GC"
                          "-XX:+UseStringDeduplication"
                          ,(concat "-javaagent:" w/path-to-lombok)
                          ,(concat "-Xbootclasspath/a:" w/path-to-lombok)))
  (add-hook 'java-mode-hook #'lsp)
  ;; (add-hook 'java-mode-hook #'lsp-ui-mode)
  (add-hook 'java-mode-hook (lambda ()
                              (require 'lsp-java-boot)
                              (lsp-java-boot-lens-mode)
                              (diminish 'lsp-java-boot-lens-mode "弹")))

  ;;; dap-java
  (use-package dap-java
    :commands (dap-java-debug
               dap-java-run-test-method
               dap-java-debug-test-method
               dap-java-run-test-class
               dap-java-debug-test-class)
    :init
    (setq dap-java-test-runner
          (w/locate-emacs-var-file ".cache/lsp/eclipse.jdt.ls/test-runner/junit-platform-console-standalone.jar"))
    (global-set-key (kbd "M-SPC t t") #'dap-java-run-test-method)
    :config
    (dap-register-debug-template
     "Java run"
     (list :type "java"
           :request "launch"
           :args ""
           :noDebug t
           :cwd nil
           :host "localhost"
           :request "launch"
           :modulePaths []
           :classPaths nil
           :name "JavaRun"
           :projectName nil
           :mainClass nil))))

(straight-use-package 'autodisass-java-bytecode)
(require 'autodisass-java-bytecode)



(provide 'w-java)
