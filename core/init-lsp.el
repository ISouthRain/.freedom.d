(use-package dumb-jump
  :ensure t
  :hook '((xref-backend-functions . dumb-jump-xref-activate))
  :bind (:map dumb-jump-mode-map
              ("j" . next-line)
              ("k" . previous-line))
  :config
  (setq xref-show-definitions-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(use-package lsp-mode
  :ensure t
  :hook '((c-mode . lsp)))

(provide 'init-lsp)
