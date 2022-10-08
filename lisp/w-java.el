;;; -*- lexical-binding: t; -*-
;;; IMPORTANT: java 11 is needed or jdtls, the java lsp-server
(straight-use-package 'lsp-java)
(straight-use-package 'autodisass-java-bytecode)

(add-hook 'java-mode-hook #'company-mode)
(add-hook 'java-mode-hook #'display-line-numbers-mode)
(add-hook 'java-mode-hook #'yas-minor-mode)
;; (add-hook 'java-mode-hook
;;           (lambda ()
;;             (face-remap-add-relative 'font-lock-function-name-face :height 1.5)))

;;; eglot
(defconst my-eglot-eclipse-jdt-home (w/locate-emacs-var-file ".cache/lsp/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar"))
(defun my-eglot-eclipse-jdt-contact (interactive)
  "Contact with the jdt server input INTERACTIVE."
  (let ((cp (getenv "CLASSPATH")))
    (setenv "CLASSPATH" (concat cp ":" my-eglot-eclipse-jdt-home))
    (unwind-protect (eglot--eclipse-jdt-contact nil)
      (setenv "CLASSPATH" cp))))
(with-eval-after-load 'eglot
    (setcdr (assq 'java-mode eglot-server-programs) #'my-eglot-eclipse-jdt-contact))

;;; lsp-java
;; install lsp-java no matter what lsp client is, avoiding changing straight version file
(setq w/path-to-lombok (expand-file-name (locate-user-emacs-file "resources/lombok.jar")))
(setq lsp-java-workspace-dir (w/locate-emacs-var-file "workspace")
      ;; lsp-java-java-path "/Users/w/.sdkman/candidates/java/11.0.2-open/bin/java"
      ;; lsp-java-jdt-download-url "https://download.eclipse.org/jdtls/milestones/1.0.0/jdt-language-server-1.0.0-202104151857.tar.gz"
      lsp-java-vmargs `("-noverify"
                        "-Xmx1G" "-XX:+UseG1GC"
                        "-XX:+UseStringDeduplication"
                        ,(concat "-javaagent:" w/path-to-lombok)
                        ,(concat "-Xbootclasspath/a:" w/path-to-lombok)))
(when (equal w/lsp-client "lsp")
  (add-hook 'java-mode-hook #'lsp)
  ;; (add-hook 'java-mode-hook #'lsp-ui-mode)
  ;; (add-hook 'java-mode-hook (lambda ()
  ;;                             (require 'lsp-java-boot)
  ;;                             (lsp-java-boot-lens-mode)
  ;;                             (diminish 'lsp-java-boot-lens-mode "弹")))
  )
(defun toggle-on-lsp-java ()
  (interactive)
  (add-hook 'java-mode-hook #'lsp))

(defun toggle-off-lsp-java ()
  (interactive)
  (remove-hook 'java-mode-hook #'lsp))

;;; dap-java
(autoload 'dap-java-debug "dap-java" nil t nil)
(autoload 'dap-java-debug-test-class "dap-java" nil t nil)
(autoload 'dap-java-debug-test-method "dap-java" nil t nil)
(autoload 'dap-java-run-test-class "dap-java" nil t nil)
(autoload 'dap-java-run-test-method "dap-java" nil t nil)
(setq dap-java-test-runner
        (w/locate-emacs-var-file ".cache/lsp/eclipse.jdt.ls/test-runner/junit-platform-console-standalone.jar"))
  (global-set-key (kbd "M-SPC t t") #'dap-java-run-test-method)
(with-eval-after-load 'dap-java
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
         :mainClass nil)))

;;; java bytecode
(require 'autodisass-java-bytecode)


(provide 'w-java)
