(use-package vimrc-mode
  :ensure nil
  :defer 1
  :load-path "~/.freedom.d/lisp/plugins/"
  :config
 (add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode)))

(provide 'init-vim)
