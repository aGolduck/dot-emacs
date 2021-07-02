;;; -*- lexical-binding: t; -*-
(setq calendar-chinese-all-holidays-flag t)
(with-eval-after-load 'abbrev (diminish 'abbrev-mode "缩"))

;;; makefile
(add-to-list 'auto-mode-alist '("\\.gmk" . makefile-mode))
;;; python
;; (setq lsp-python-ms-auto-install-server nil
;;       lsp-python-ms-executable "~/g/Microsoft/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")
;; (add-hook 'python-mode-hook (lambda () (require 'lsp-python-ms) (lsp)))
(add-hook 'python-mode-hook #'highlight-indent-guides-mode)
;;; xml
(setq lsp-xml-jar-file (expand-file-name (locate-user-emacs-file "resources/org.eclipse.lemminx-uber.jar")))
(when (equal w/lsp-client "lsp")
  ;; xml lsp server is downloaded from http://mirrors.ustc.edu.cn/eclipse/lemminx/
  (add-hook 'nxml-mode-hook #'lsp))
(add-hook 'nxml-mode-hook #'smartparens-mode)
;;; groovy
(straight-use-package 'groovy-mode)
(setq lsp-groovy-server-file (locate-user-emacs-file "resources/groovy-language-server-all.jar"))
(when (equal w/lsp-client "lsp")
  (add-hook 'groovy-mode-hook #'lsp))
(add-hook 'groovy-mode-hook #'company-mode)
(add-hook 'groovy-mode-hook #'electric-pair-local-mode)
;;; markdown
(straight-use-package 'markdown-mode)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(setq markdown-command "multimarkdown")
;;; yaml
(straight-use-package 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\.'" . yaml-mode))
(add-hook 'yaml-mode-hook #'highlight-indent-guides-mode)

(straight-use-package 'ccls)
(straight-use-package 'graphql-mode)
(straight-use-package 'pkgbuild-mode)
(straight-use-package 'rust-mode)
(straight-use-package 'link-hint)
(straight-use-package 'pdf-tools)
(straight-use-package 'pocket-reader)


;;; TODO to organise
(straight-use-package 'avy)
(global-set-key (kbd "M-SPC g g") #'avy-goto-char-timer)
(global-set-key (kbd "M-SPC g l") #'avy-goto-line)
(global-set-key (kbd "M-SPC g w") #'avy-goto-word-0)
(straight-use-package 'go-translate)
;; (setq go-translate-base-url "https://translate.google.cn")
(setq go-translate-local-language "zh-CN")
(with-eval-after-load 'go-translate
  (defun go-translate-token--extract-tkk () (cons 430675 2721866130)))
;;; auth-source
(setq auth-sources '((:source (w/locate-emacs-var-file ".authinfo.gpg"))))
;;; ediff-wind
(setq ediff-merge-split-window-function 'split-window-vertically
      ediff-split-window-function 'split-window-horizontally
      ediff-window-setup-function 'ediff-setup-windows-plain)
(with-eval-after-load 'ediff-wind
  (add-hook 'ediff-after-quit-hook-internal #'winner-undo))
;;; epg-config
(setq epg-pinentry-mode 'loopback)
;;; go-to-address
(add-hook 'after-init-hook #'goto-address-mode)
;;; hideshow
(add-hook 'prog-mode-hook #'hs-minor-mode)
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
  (diminish 'hs-minor-mode "折"))
(require 'screenshot-svg)
;;; simple
(add-hook 'after-init-hook #'global-visual-line-mode)
(global-set-key (kbd "M-SPC SPC") #'execute-extended-command)
(global-set-key (kbd "M-SPC u") #'universal-argument)
(with-eval-after-load 'simple
  (diminish 'visual-line-mode "⮒"))
;;; url-cookie
(setq url-cookie-file (w/locate-emacs-var-file "url/cookies"))

(straight-use-package 'zotero)
(straight-use-package 'lua-mode)


(straight-use-package 'csv-mode)
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(setq csv-separators '("," ";" "|" " "))


(straight-use-package 'page-break-lines)
(add-hook 'emacs-lisp-mode-hook #'page-break-lines-mode)

(provide 'w-z)
