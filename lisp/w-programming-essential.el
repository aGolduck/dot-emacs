;;; lsp
(require 'w-lsp-bridge)

;;; a nice debug front end for several languages, see https://github.com/realgud/realgud/wiki/Debuggers-Available
(straight-use-package 'realgud)

;;; projectile
(require 'w-projectile)

;;; dumb-jump
(straight-use-package 'dumb-jump)
;; (setq dumb-jump-force-searcher 'rg) ;; rg is not working for at least elisp files
(with-eval-after-load 'xref
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;;; quickrun
(straight-use-package 'quickrun)
(setq quickrun-debug t)
;; quickrun-add-command, :override nil 表示增加，override t 表示覆盖原选项
(with-eval-after-load 'quickrun
  (quickrun-add-command "java/maven"
    '((:command . "mvn")
      (:exec . ((lambda ()
                  (concat  "%c -f " (concat (projectile-project-root) "pom.xml") " compile exec:java -Dexec.mainClass=\""
                           (string-replace "/" "."
                                           (string-remove-suffix ".java"
                                                                 (string-remove-prefix
                                                                  (concat (projectile-project-root) "src/main/java/")
                                                                  (buffer-file-name))))
                           "\""))))
      (:tempfile . nil)
      (:description . "run java file with maven"))
    :default nil :mode 'java-mode :override nil)
  (quickrun-add-command "typescript/deno"
    '((:command . "deno")
      (:exec . "%c run -A %s --std-log-level=DEBUG")
      (:compile-only . "%c compile %s")
      (:compile-conf . ((:compilation-mode . nil) (:mode . js-mode)))
      (:remove  . ("%n.js"))
      (:description . "Run TypeScript script with deno --log-level=debug"))
    :default "typescript" ;; 和 (quickrun-set-default "typescript" "typescript/deno") 效果一样, 可以是列表
    :mode 'typescript-mode
    :override t)
  (quickrun-add-command "c++/clang++"
    '((:command . "clang++")
      (:exec    . ("%c -std=c++2a -x c++ %o -o %e %s" "%e %a"))
      (:compile-only . "%c -std=c++2a -Wall -Werror %o -o %e %s")
      (:remove  . ("%e"))
      (:description . "Compile C++ file with llvm/clang++ and execute"))
    :default "c++"
    :override t)
  (quickrun-add-command "clojure/clj"
    '((:command . "clj")
      (:exec . ("TAOENSSO_TIMBRE_MIN_LEVEL_EDN=':debug' %c %s"))
      (:description . "run clojure file with plain clj"))
    :default "clojure"
    :override nil)
  )


;;; languages
(setq typescript-indent-leven 2)
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
