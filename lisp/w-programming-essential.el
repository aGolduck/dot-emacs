;;; lsp
(require 'w-lsp-bridge)

;;; projectile
(require 'w-projectile)

;;; dumb-jump
(straight-use-package 'dumb-jump)
;; (setq dumb-jump-force-searcher 'rg) ;; rg is not working for at least elisp files
(with-eval-after-load 'xref
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;;; quickrun
(straight-use-package 'quickrun)
(with-eval-after-load 'quickrun
  (add-to-list 'quickrun--language-alist
               '("java/maven" .
                 ((:command . "mvn")
                  (:exec . ((lambda ()
                              (concat  "%c -f " (concat (projectile-project-root) "pom.xml") " compile exec:java -Dexec.mainClass=\""
                                       (string-replace "/" "."
                                                       (string-remove-suffix ".java"
                                                                             (string-remove-prefix
                                                                              (concat (projectile-project-root) "src/main/java/")
                                                                              (buffer-file-name))))
                                       "\""))))
                  (:tempfile . nil)
                  (:description . "run java file with maven"))))
  ;; (add-to-list 'quicklang/lang-candidates '("java" . ("" "mave")))
  (quickrun-set-default "typescript" "typescript/deno"))


;;; languages
(straight-use-package 'typescript-mode)
(setq typescript-indent-leven 2)
(straight-use-package 'go-mode)
(straight-use-package 'scala-mode)

;;; clojure
(straight-use-package 'clojure-mode)
(straight-use-package 'cider)
;; lispy-clojure 依赖，https://github.com/abo-abo/lispy/blob/42a12aeee6e472c99c49c070070d8be6eb2c3c38/lispy-clojure.clj#L25
;; 配置于 cider-jack-in-dependencies 而不是 lispy-cider-jack-in-dependencies 使得手动 cider-jack-in 后 lispy-eval 也能起作用
;; (setq lispy-cider-jack-in-dependencies '(("org.clojure/tools.namespace" "1.3.0")))
(setq cider-jack-in-dependencies '(("org.clojure/tools.namespace" "1.3.0")))

(with-eval-after-load 'cider
  ;; odd is that cider depends on org-src-mode
  (require 'org-src))
(add-hook 'clojure-mode-hook #'lispy-mode)
;;; TODO company 的相关配置全部转移到 w-company
;; (with-eval-after-load 'clojure-mode
;;   (with-eval-after-load 'cider
;;     (with-eval-after-load 'flycheck
;;       (flycheck-clojure-setup))))
(add-to-list 'auto-mode-alist '("\\.sc\\'" . scala-mode))
(straight-use-package 'haskell-mode)



(provide 'w-programming-essential)
