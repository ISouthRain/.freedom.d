(use-package dired
  :ensure nil
  :commands (dired)
  :hook '((dired-mode . all-the-icons-dired-mode)
          )
  :config
  (use-package all-the-icons-dired
    :ensure t)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; aggressive-indent 自动缩进
(use-package aggressive-indent
  :ensure t
  :hook (emacs-lisp-mode . aggressive-indent-mode)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elec-pair 自动补全括号
(use-package elec-pair
  :ensure nil
  :hook (after-init . electric-pair-mode)
  :init (setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rainbow-delimiters 彩虹括号
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 指导线
(use-package highlight-indent-guides
  :ensure t
  :defer 0.5
  :hook ((prog-mode text-mode conf-mode) . highlight-indent-guides-mode)
  :init
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-suppress-auto-error t)
  :config
  (defun +indent-guides-init-faces-h (&rest _)
    (when (display-graphic-p)
      (highlight-indent-guides-auto-set-faces)))
  (add-hook 'org-mode-local-vars-hook
    (defun +indent-guides-disable-maybe-h ()
      (and highlight-indent-guides-mode
           (bound-and-true-p org-indent-mode)
           (highlight-indent-guides-mode -1)))))


(provide 'init-edit)
