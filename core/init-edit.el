;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; project
(projectile-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yasnippet
(setq yas--default-user-snippets-dir (format "%ssnippets" freedom-emacs-directory))
(setq yas-snippet-dirs '("~/.freedom.d/snippets"))
(yas-global-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ace-link
(ace-link-setup-default)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; volatile-highlights, Highlight some operations 
(volatile-highlights-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; diff 高亮
(use-package diff-hl
  :hook '((after-init . global-diff-hl-mode)
          (magit-pre-refresh . diff-hl-magit-pre-refresh)
          (magit-post-refresh . diff-hl-magit-post-refresh)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 高亮括号匹配
(use-package paren
  :ensure nil
  :hook (after-init . show-paren-mode)
  :init
  (setq show-paren-when-point-in-periphery t
        show-paren-when-point-inside-paren t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package undo-tree
  :hook (after-init . global-undo-tree-mode)
  :init
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree")))
  (setq undo-tree-visualizer-diff t
        undo-tree-visualizer-timestamps t)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dired 文件浏览器
(use-package dired
  :ensure nil
  :commands (dired)
  :hook '((dired-mode . all-the-icons-dired-mode)
          )
  :bind (:map dired-mode-map
         ("U" . dired-up-directory))
  :config
  (use-package all-the-icons-dired :ensure t)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elec-pair 自动补全括号
(use-package elec-pair
  :ensure nil
  :hook (after-init . electric-pair-mode)
  :init (setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rainbow-delimiters 彩虹括号
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 指导线
(add-hook 'prog-mode-hook #'highlight-indent-guides-mode)
(add-hook 'text-mode-hook #'highlight-indent-guides-mode)
(add-hook 'conf-mode-hook #'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character
      highlight-indent-guides-suppress-auto-error t)
(defun +indent-guides-init-faces-h (&rest _)
  (when (display-graphic-p)
    (highlight-indent-guides-auto-set-faces)))
(add-hook 'org-mode-local-vars-hook
          (defun +indent-guides-disable-maybe-h ()
            (and highlight-indent-guides-mode
                 (bound-and-true-p org-indent-mode)
                 (highlight-indent-guides-mode -1))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; evil-nerd-commenter
(use-package evil-nerd-commenter
  :bind ("C-x C-;" . evilnc-comment-or-uncomment-lines))
(provide 'init-edit)
