(add-hook 'c-mode-hook #'lsp t)
(add-hook 'python-mode-hook #'lsp t)

;;dumb-jump
(add-hook 'xref-backend-functions-hook #'dumb-jump-xref-activate t)
(setq xref-show-definitions-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
;; vimrc-mode
(add-to-list 'auto-mode-alist '(("\\.vim\\(rc\\)?\\'" . vimrc-mode)
(provide 'init-lsp)