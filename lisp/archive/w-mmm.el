;;; -*- lexical-binding: t; -*-
(straight-use-package 'mmm-mode)

;; mmm-mode for mybatis sql
;; https://www.cnblogs.com/yangwen0228/p/8047805.html


(setq mmm-parse-when-idle nil)
(setq mmm-global-classes nil)
(setq mmm-classes-alist nil)
(setq mmm-mode-ext-classes-alist nil)
(setq mmm-global-mode 'maybe)
(setq mmm-submode-decoration-level 0)
;; (setq mmm-indent-line-function 'mmm-indent-line-web-sql)

(defun mmm-indent-line-web-sql-submode ()
  (web-mode-propertize)
  (let (cur-type prev-type)
    (save-excursion
      (back-to-indentation)
      (setq cur-type (get-text-property (point) 'tag-type)))
    (save-excursion
      (previous-line)
      (back-to-indentation)
      (setq prev-type (get-text-property (point) 'tag-type)))
    (if (or
         (not (or prev-type cur-type))              ; both lines sql
         (and (not prev-type) (eq cur-type 'start)) ; sql -> xml
         )
        (sql-indent-line)
      (web-mode-indent-line))))

(defun mmm-indent-line-web-sql ()
  (interactive)
  (funcall
   (save-excursion
     (back-to-indentation)
     (mmm-update-submode-region)
     (if (and mmm-current-overlay
              (> (overlay-end mmm-current-overlay) (point)))
         'mmm-indent-line-web-sql-submode
       'web-mode-indent-line))))

(mmm-add-classes
 '((xml-sql-select :submode sql-mode
                   :front "<select[^>]*>[ \t]*\n" :back "[ \t]*</select>")
   (xml-sql-insert :submode sql-mode
                   :front "<insert[^>]*>[ \t]*\n" :back "[ \t]*</insert>")
   (xml-sql-update :submode sql-mode
                   :front "<update[^>]*>[ \t]*\n" :back "[ \t]*</update>")
   (xml-sql-delete :submode sql-mode
                   :front "<delete[^>]*>[ \t]*\n" :back "[ \t]*</delete>")
   (xml-sql-fragment :submode sql-mode
                   :front "<sql[^>]*>[ \t]*\n" :back "[ \t]*</delete>")
   ))


(mmm-add-mode-ext-class 'nxml-mode nil 'xml-sql-select)
(mmm-add-mode-ext-class 'nxml-mode nil 'xml-sql-insert)
(mmm-add-mode-ext-class 'nxml-mode nil 'xml-sql-update)
(mmm-add-mode-ext-class 'nxml-mode nil 'xml-sql-delete)
(mmm-add-mode-ext-class 'nxml-mode nil 'xml-sql-fragment)

;; (with-eval-after-load 'mmm-mode
;;   (set-face-attribute 'mmm-default-submode-face nil :background "gray93"))

(add-hook 'after-init-hook (lambda () (require 'mmm-auto)))

(provide 'w-mmm)
