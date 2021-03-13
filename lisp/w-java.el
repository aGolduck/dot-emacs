;;; install lsp-java no matter what lsp client is, avoiding changing straigt version file
(straight-use-package 'lsp-java)

(add-hook 'java-mode-hook #'company-mode)
(add-hook 'java-mode-hook #'display-line-numbers-mode)
(add-hook 'java-mode-hook #'electric-pair-local-mode)
(add-hook 'java-mode-hook
          (lambda ()
            (face-remap-add-relative 'font-lock-function-name-face :height 1.5)))

(when (equal w/lsp-client "eglot")
  (defconst my-eglot-eclipse-jdt-home (w/locate-emacs-var-file ".cache/lsp/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar"))
  (defun my-eglot-eclipse-jdt-contact (interactive)
    "Contact with the jdt server input INTERACTIVE."
    (let ((cp (getenv "CLASSPATH")))
      (setenv "CLASSPATH" (concat cp ":" my-eglot-eclipse-jdt-home))
      (unwind-protect (eglot--eclipse-jdt-contact nil)
        (setenv "CLASSPATH" cp))))

  (with-eval-after-load 'eglot
    (setcdr (assq 'java-mode eglot-server-programs) #'my-eglot-eclipse-jdt-contact)))

;;; lsp-java
(when (equal w/lsp-client "lsp")
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
