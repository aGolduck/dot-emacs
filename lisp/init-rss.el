(straight-use-package 'elfeed)
;; (straight-use-package 'elfeed-org)
(straight-use-package 'elfeed-protocol)

(setq elfeed-use-curl t)
(setq elfeed-curl-extra-arguments '("--insecure"))
(setq elfeed-feeds `(,w/nextcloud-feed))
(add-hook 'after-init-hook #'elfeed-protocol-enable)

(provide 'init-rss)
