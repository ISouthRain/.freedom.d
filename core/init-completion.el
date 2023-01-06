(use-package corfu
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode)
         (corfu-mode . corfu-history-mode)
         (corfu-mode . corfu-indexed-mode)
         (after-init . global-corfu-mode)
         )
  :bind
  (:map corfu-map
   ("TAB" . corfu-next)
   ([tab] . corfu-next)
   ("S-TAB" . corfu-previous)
   ([backtab] . corfu-previous)
   ;; ("M-SPC" . corfu-insert-separator) ;; 空格后依然补全
   ("M-SPC" . corfu-quick-complete) ;; 快速补全
   ("M-m" . corfu-move-to-minibuffer) ;; 在 minibuffer 中补全
   )
  :config
  (setq global-corfu-mode
        '(not erc-mode
              circe-mode
              message-mode
              help-mode
              gud-mode
              vterm-mode))
  (setq corfu-auto-delay 0.1
        corfu-auto-prefix 2)
  :config
  (setq corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (setq corfu-auto t)                 ;; Enable auto completion
  (setq corfu-separator ?\s)          ;; Orderless field separator
  (setq corfu-quit-at-boundary t)   ;; 空格后要不要退出补全 Never quit at completion boundary
  (setq corfu-quit-no-match 'separator)      ;; Never quit, even if there is no match
  (setq corfu-preview-current nil)    ;; Disable current candidate preview
  (setq corfu-preselect-first nil)    ;; Disable candidate preselection
  (setq corfu-on-exact-match nil)     ;; Configure handling of exact matches
  (setq corfu-echo-documentation nil) ;; Disable documentation in the echo area
  (setq corfu-scroll-margin 5)        ;; Use scroll margin
  ;; 在 minibuffer 中补全
  (defun corfu-move-to-minibuffer ()
    (interactive)
    (let ((completion-extra-properties corfu--extra)
          completion-cycle-threshold completion-cycling)
      (apply #'consult-completion-in-region completion-in-region--data)))
  )
  ;;;;; 图标
(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  (setq kind-icon-blend-frac 0.08)
  )
  ;;;;; TUI 支持
(use-package corfu-terminal
  :config
  (unless (display-graphic-p)
    (corfu-terminal-mode 1)))


(provide 'init-completion)
