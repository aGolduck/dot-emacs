;; 禁用从右往左的编辑模式可明显加速超长行显示，见 https://emacs-china.org/t/topic/25811/9
;; doom-emacs 也提供了另外的方案，是基于 `bidi-display-reordering' 的文档给出的建议
;; 哪个效果更好未知
;; (setq-default bidi-display-reordering 'left-to-right
;;               bidi-paragraph-direction 'left-to-right)
;; (setq bidi-inhibit-bpa t)
(setq-default bidi-display-reordering nil)
(setq bidi-inhibit-bpa t
      long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)


(straight-use-package '(dape :type git :host github :repo "svaante/dape"))
(require 'dape)
(add-to-list 'dape-configs
             `(debugpy
               modes (python-ts-mode python-mode)
               command "python3"
               command-args ("-m" "debugpy.adapter")
               :type "executable"
               :request "launch"
               :cwd dape-cwd-fn
               :program dape-find-file-buffer-default))

;; (add-to-list 'auto-mode-alist '("\\.jmod\\'" . archive-mode))
;; (add-to-list 'jka-compr-compression-info-list
;;              ["\\.jmod\\'"
;;               nil
;;               nil
;;               nil
;;               nil
;;               "unzip"
;;               ("-q" "-c")
;;               nil
;;               nil
;;               "JM"
;;               ])

(require 'dired-aux)
(add-to-list 'dired-compress-file-suffixes '("\\.jmod\\'" "" "unzip -o -d %o %i"))

(setq zotero-random-current-pane-item-views "
var iv = ZoteroPane.itemsView;
await iv.selectItem(iv.getRow(Zotero.Utilities.rand(0, iv.rowCount - 1)).id)
")

;; const searchCondition = new Zotero.Search()
;; searchCondition.libraryID = Zotero.Libraries.userLibraryID;
;; const itemIDs = await searchCondition.search()
;; const zoteroPane = Zotero.getActiveZoteroPane();
;; zoteroPane.selectItem(itemIDs[1])

(defun zotero-random ()
  (interactive)
  (let ((url-request-method "POST")
        (url-request-extra-headers '(("Content-Type" . "application/javascript")))
        (url-request-data zotero-random-current-pane-item-views)
        (url-show-status nil))
    (url-retrieve-synchronously "http://127.0.0.1:23119/debug-bridge/execute?password=CTT"))
  (ns-do-applescript "tell application \"Zotero\" to activate"))

(defun file-random ()
  (interactive)
  (shell-command "fd -t f . ~ -0 | shuf -zn1 | xargs -0 open -R"))

(straight-use-package 'curl-to-elisp)

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


(straight-use-package '(typst-ts-mode :host sourcehut :repo "meow_king/typst-ts-mode"))

(provide 'w-explore)
