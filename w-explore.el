(defun zotero-random ()
  (interactive)
  (shell-command "curl -s -H 'Content-Type: application/javascript' -X POST -d 'var iv = ZoteroPane.itemsView; await iv.selectItem(iv.getRow(Zotero.Utilities.rand(0, iv.rowCount - 1)).id)' 'http://127.0.0.1:23119/debug-bridge/execute?password=CTT'")
  (sleep-for 0.5)
  (ns-do-applescript "tell application \"Zotero\" to activate"))


(with-eval-after-load 'eglot
  )

(setq doc-view-resolution 163
      doc-view-mupdf-use-svg nil)

;; pdf-tools 安装失败
;; (setenv "PKG_CONFIG_PATH" "/usr/local/opt/zlib/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/Cellar/poppler/23.08.0/lib/pkgconfig")
;; (straight-use-package 'pdf-tools)
;; (pdf-tools-install)

;; (straight-use-package 'esxml)
;; (straight-use-package 'nov.el)
;; (add-to-list 'auto-mode-alist '("\\.epub'" . nov-mode))
;; (defun nov--content-epub2-files (content manifest files)
;;     (let* ((node (esxml-query "package>spine[toc]" content))
;;            (id (esxml-node-attribute 'toc node)))
;;       (when (not id)
;;         (throw 'error "EPUB 2 NCX ID not found"))
;;       (setq nov-toc-id (intern id))
;;       (let ((toc-file (assq nov-toc-id manifest)))
;;         (when (not toc-file)
;;           (throw 'error "EPUB 2 NCX file not found"))
;;         (cons toc-file files))))
;; (defun nov--content-epub3-files (content manifest files)
;;   (let* ((node (esxml-query "package>manifest>item[properties~=nav]" content))
;;          (id (esxml-node-attribute 'id node)))
;;     (when (not id)
;;       (throw 'error "EPUB 3 <nav> ID not found"))
;;     (setq nov-toc-id (intern id))
;;     (let ((toc-file (assq nov-toc-id manifest)))
;;       (when (not toc-file)
;;         (throw 'error "EPUB 3 <nav> file not found"))
;;       (setq files (--remove (eq (car it) nov-toc-id) files))
;;       (cons toc-file files))))
;; (defun nov-content-files (directory content)
;;     "Create correctly ordered file alist for CONTENT in DIRECTORY.
;; Each alist item consists of the identifier and full path."
;;     (let* ((manifest (nov-content-manifest directory content))
;;            (spine (nov-content-spine content))
;;            (files (mapcar (lambda (item) (assq item manifest)) spine)))
;;       (catch 'error (nov--content-epub3-files content manifest files))
;;       (catch 'error (nov--content-epub2-files content manifest files))))



(define-skeleton gpt-template
  "docstring: chatgpt template"
  "prompt"
  "you are chatgpt"
  )

(define-skeleton hello-world-skeleton
  "Write a greeting"
  "Type name of user: "
  "hello, " str "!")

(defun w/uncomment-console-logging ()
  (interactive)
  (beginning-of-buffer)
  (replace-string "// console" "console"))

(defun w/comment-out-console-logging ()
    (interactive)
  (beginning-of-buffer)
  (replace-string "console." "// console."))


(when (>= emacs-major-version 29)
  (straight-use-package 'clojure-ts-mode)
  (add-hook 'clojure-ts-mode #'lispy-mode)

  (add-to-list 'auto-mode-alist '("\\.sy\\'" . json-ts-mode))
  (straight-use-package 'treesit-auto)
  (require 'treesit-auto)
  (global-treesit-auto-mode)

  (straight-use-package 'combobulate)
  (autoload 'combobulate-mode "combobulate" nil t nil)
  (add-hook 'typescript-ts-mode-hook #'combobulate-mode)
  (add-hook 'json-ts-mode-hook #'combobulate-mode))

(provide 'w-explore)
