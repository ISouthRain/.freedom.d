(use-package corfu-english-helper
  :ensure nil
  :defer 0.5
  :after corfu
  :load-path "~/.freedom.d/core/plugins"
  :config
  (defun +freedom-english-corfu-toggle ()
    (interactive)
    (toggle-corfu-english-helper))
  )


(provide 'init-translate)
