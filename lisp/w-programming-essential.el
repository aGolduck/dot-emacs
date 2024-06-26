;;; lsp
(require 'w-lsp-bridge)

;;; a nice debug front end for several languages, see https://github.com/realgud/realgud/wiki/Debuggers-Available
(straight-use-package 'realgud)

;;; projectile
(require 'w-projectile)

;;; quickrun
(straight-use-package 'quickrun)
(setq quickrun-debug t)
;; quickrun-add-command, :override nil 表示增加，override t 表示覆盖原选项
(with-eval-after-load 'quickrun
  ;; TODO maven 处理多 module 的情况
  (quickrun-add-command "java/maven-test"
    '((:command . "mvn")
      (:exec . ((lambda ()
                  (concat "%c -f " (concat (projectile-project-root) "pom.xml") " test -DfailIfNoTests=false -Dtest="
                          (save-excursion
                            (setq quickrun-option-timeout-seconds 36000)
                            (beginning-of-buffer)
                            (search-forward-regexp "package \\(.+\\);" nil t)
                            (match-string 1))
                          "."
                          (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))))
      (:tempfile . nil)
      (:description . "run java unit test"))
    :default nil :mode 'java-mode :override nil)
  (quickrun-add-command "java/maven"
    '((:command . "mvn")
      (:exec . ((lambda ()
                  (concat "%c -f " (concat (projectile-project-root) "pom.xml") " compile exec:java -Dexec.mainClass=\""
                          (save-excursion
                            (beginning-of-buffer)
                            (search-forward-regexp "package \\(.+\\);" nil t)
                            (match-string 1))
                          "."
                          (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))
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
  (quickrun-add-command "typescript/deno-debug"
    '((:command . "deno")
      (:exec . ("%c run --inspect-brk -A %s --std-log-level=DEBUG"
                ;; 设置过期时间为10小时，使 debugger 不会因过期时间而挂掉
                ;; 副作用是影响别的 quickrun，不过也无所谓了
                (lambda () (setq quickrun-option-timeout-seconds 36000) "")))
      (:description . "debug TypeScript script with deno --log-level=debug"))
    :default nil
    :mode 'typescript-mode
    :override nil)
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
  (quickrun-add-command "scala"
    '((:command . "scala")
      (:cmdopt . "-Duser.language=en -Dfile.encoding=UTF-8 -explain")
      (:description . "scala"))
    :default "scala"
    :override t))


;;; languages



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
(add-hook 'clojure-mode-hook (lambda ()
                               (setq-local lispy-compat '(cider))
                               (lispy-mode 1)))
;;; TODO company 的相关配置全部转移到 w-company
;; (with-eval-after-load 'clojure-mode
;;   (with-eval-after-load 'cider
;;     (with-eval-after-load 'flycheck
;;       (flycheck-clojure-setup))))


(straight-use-package 'scala-mode)
(add-to-list 'auto-mode-alist '("\\.sc\\'" . scala-mode))

(straight-use-package 'haskell-mode)

(straight-use-package 'graphviz-dot-mode)
(setq graphviz-dot-preview-extension "svg")


(provide 'w-programming-essential)
