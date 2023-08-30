;;; 最小配置，只使用自带包  -*- lexical-binding: t; -*-

;; M-SPC is key to my emacs world
(global-unset-key (kbd "M-SPC"))

;; FIXME minimal exec-path for executable-find to work, not working
(setq exec-path '("/usr/local/bin" "/usr/bin" "/bin" "/usr/local/sbin" "/usr/sbin" "/sbin"))

;;; bookmark
(setq bookmark-default-file (w/locate-emacs-var-file "bookmarks"))
(global-set-key (kbd "M-SPC b s") #'bookmark-set)

;;; buffer
(global-set-key (kbd "M-SPC b k") #'kill-buffer)

;;; calendar
(setq calendar-chinese-all-holidays-flag t)

;;; desktop
(setq desktop-base-file-name (expand-file-name (concat ".emacs-" emacs-version ".desktop") w/EMACS-VAR)
      desktop-base-lock-name (expand-file-name (concat ".emacs-" emacs-version ".desktop.lock") w/EMACS-VAR)
      desktop-globals-to-save '()
      desktop-locals-to-save '()
      desktop-files-not-to-save ".*"
      desktop-buffers-not-to-save ".*"
      desktop-minor-mode-table '((defining-kbd-macro nil)
                                 (isearch-mode nil)
                                 (vc-mode nil)
                                 (vc-dir-mode nil)
                                 (erc-track-minor-mode nil)
                                 (savehist-mode nil)
                                 (tab-bar-mode nil))
      desktop-save t)
(add-hook 'desktop-save-hook (lambda () (tab-bar-mode -1)))

;;; dired
(setq dired-listing-switches "-Afhlv"
      dired-auto-revert-buffer t
      dired-dwim-target t
      dired-recursive-copies 'always
      dired-kill-when-opening-new-dired-buffer t
      dired-recursive-deletes 'top
      dired-guess-shell-alist-user '(("\\.doc\\'" "libreoffice")
                                     ("\\.docx\\'" "libreoffice")
                                     ("\\.ppt\\'" "libreoffice")
                                     ("\\.pptx\\'" "libreoffice")
                                     ("\\.xls\\'" "libreoffice")
                                     ("\\.xlsx\\'" "libreoffice"))
      image-dired-dir (w/locate-emacs-var-file "image-dired"))
(with-eval-after-load 'dired
  ;; (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)
  (define-key dired-mode-map
    (kbd "^") (lambda () (interactive) (find-alternate-file ".."))))
(global-set-key (kbd "M-SPC ^") #'dired-jump)

;;; display-time
(setq display-time-format "%H:%M:%S.%1N")
(setq display-time-interval 0.1)

;;; edit
(add-hook 'after-init-hook #'delete-selection-mode)
(add-hook 'after-init-hook #'global-subword-mode)
(add-hook 'hexl-mode-hook #'view-mode)

;;; ediff-wind
(setq ediff-merge-split-window-function 'split-window-vertically
      ediff-split-window-function 'split-window-horizontally
      ediff-window-setup-function 'ediff-setup-windows-plain
      )
(with-eval-after-load 'ediff-wind
  (add-hook 'ediff-after-quit-hook-internal #'winner-undo))


;;; find-func
(setq find-function-C-source-directory "~/g/emacs-mirror/emacs/src")
(global-set-key (kbd "M-SPC F F") #'find-function-other-window)
(global-set-key (kbd "M-SPC F f") #'find-function)
(global-set-key (kbd "M-SPC F V") #'find-variable-other-window)
(global-set-key (kbd "M-SPC F v") #'find-variable)
;; 不常用，与新加的包 embark embark-act 冲突
;; (define-key key-translation-map (kbd "C-.") (kbd "C-x 4 ."))

;;; flyspell
(when (executable-find "aspell")
  (setq flyspell-issue-message-flag t
        ispell-program-name "aspell"
        ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together"))
  (add-hook 'text-mode-hook #'flyspell-mode)
  (add-hook 'outline-mode-hook #'flyspell-mode)
  (add-hook 'prog-mode-hook #'flyspell-prog-mode))


;;; hideshow
;; (add-hook 'prog-mode-hook #'hs-minor-mode)
(global-set-key (kbd "M-SPC z H") #'hs-hide-all)
(global-set-key (kbd "M-SPC z S") #'hs-show-all)
(global-set-key (kbd "M-SPC z h") #'hs-hide-block)
(global-set-key (kbd "M-SPC z s") #'hs-show-block)
(global-set-key (kbd "M-SPC z z") #'hs-toggle-hiding)
(with-eval-after-load 'hideshow
  (defconst w/hideshow-folded-face '((t (:inherit 'font-lock-comment-face :box t))))
  (defun w/hide-show-overlay-fn (w/overlay)
    (when (eq 'code (overlay-get w/overlay 'hs))
      (let* ((nlines (count-lines (overlay-start w/overlay)
                                  (overlay-end w/overlay)))
             (info (format " ... #%d " nlines)))
        (overlay-put w/overlay 'display (propertize info 'face w/hideshow-folded-face)))))
  (setq hs-set-up-overlay 'w/hide-show-overlay-fn)
)


;;; isearch
(setq-default isearch-lazy-count t
              search-ring-max 200
              regexp-search-ring-max 200)
(with-eval-after-load 'isearch
  (global-set-key (kbd "C-s") #'isearch-forward-regexp)
  (global-set-key (kbd "C-r") #'isearch-backward-regexp)
  (global-set-key (kbd "C-M-s") #'isearch-forward)
  (define-key isearch-mode-map (kbd "C-w") #'isearch-yank-symbol-or-char)
  (define-key isearch-mode-map (kbd "C-M-w") #'isearch-yank-word-or-char))


;;; minimal org-mode set up
(setq org-todo-keywords '((sequence "TODO" "NEXT" "|" "DONE")))

;;; project
(defun w/project-try-local (dir)
  "Determine if DIR is a non-Git project."
  (catch 'ret
    (let ((pr-flags '((".project")
                      ("go.mod" "Cargo.toml" "project.clj" "pom.xml" "package.json") ;; higher priority
                      ("Makefile" "README.org" "README.md"))))
      (dolist (current-level pr-flags)
        (dolist (f current-level)
          (when-let ((root (locate-dominating-file dir f)))
            (throw 'ret (cons 'local root))))))))

(setq project-find-functions '(w/project-try-local project-try-vc))

;;; simple
(defalias 'w/insert-unicode 'insert-char)
(add-hook 'after-init-hook #'global-visual-line-mode)
(global-set-key (kbd "M-SPC SPC") #'execute-extended-command)
(global-set-key (kbd "M-SPC u") #'universal-argument)

;;; sqlite
;; SQLite 文件都用 sqlite-mode 打开
(when (functionp 'sqlite-available-p)
  (require 'sqlite-mode)
  (defun sqlite-file-p ()
    (let* ((ms "SQLite format 3")
	   (msl (length ms)))
      (and (> (point-max) msl)
	   (string= (buffer-substring 1 (1+ msl))
		    ms))))
  (defun sqlite-mode-open-file* ()
    (let ((f (buffer-file-name)))
      ;; 简单粗暴，先关了当前buffer, 再重新用新方法打开
      (kill-buffer (current-buffer))
      (sqlite-mode-open-file f)))
  (add-to-list 'magic-mode-alist '(sqlite-file-p . sqlite-mode-open-file*)))

;;; terms
;;; ansi-color for compilation mode
;; https://stackoverflow.com/questions/5819719/emacs-shell-command-output-not-showing-ansi-colors-but-the-code
(add-hook 'compilation-filter-hook
          (lambda ()
            (let ((buffer-read-only nil))
              (ansi-color-apply-on-region (point-min) (point-max)))))


;;; transient
(setq transient-history-file (w/locate-emacs-var-file "transient/history.el"))


;;; 正则表达式
;; 简单的正则表达式可手打，复杂的启用 re-builder 使用 rx 表达式构建
;; 输入如 '(one-or-more "a") 的表达式
(setq reb-re-syntax 'rx)


;;; 与外界交互
(defun idea ()
  (interactive)
  ;; Using shell-command runs the program as a child, even when done asynchronously
  ;; start-process also runs as a child process

  ;; (shell-command "idea" (project-root (project-current)))
  ;; sleep for 1 second, or emacs will be stuck
  ;; (sleep-for 1)
  ;; (ns-do-applescript "tell application \"IntelliJ IDEA\" to activate")

  ;; call-process start the program as its own distinct process
  (call-process "idea" nil nil nil (expand-file-name (project-root (project-current))))
  )


(require 'w-programming-minimal)
(require 'w-file-minimal)
(require 'w-ui-minimal)
(require 'w-font)

(provide 'w-minimal)
