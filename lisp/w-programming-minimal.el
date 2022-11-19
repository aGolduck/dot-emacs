(add-hook 'prog-mode-hook #'electric-pair-local-mode)
(global-set-key [remap comment-dwim] #'comment-line)
(setq xref-show-definitions-function #'xref-show-definitions-completing-read)


(setq js-indent-level 2)

(add-hook 'python-mode-hook #'highlight-indent-guides-mode)



(provide 'w-programming-minimal)
