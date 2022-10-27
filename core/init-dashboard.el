
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; restart emacs 重新启动 Emacs
(use-package restart-emacs
  :ensure t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dashboard 启动界面
(use-package dashboard
  :ensure t
  :pin elpa-local
  :diminish dashboard-mode
  :config
  ;; 依赖最近文件
  ;; (recentf-mode 1)
  ;; (add-hook 'dashboard-mode-hook '(lambda () (evil-insert 1)))
  (setq recentf-max-menu-items 20)
  (setq recentf-max-saved-items 20)
  ;; 标题
  (setq dashboard-banner-logo-title "🎉 Wecome to Freedom Emacs 🎉")
  ;; Logo 图标 路径
  (if (display-graphic-p)
      ;; GUI 代码放置，多行代码的话用 (progn) 包一下
      ;; (setq dashboard-startup-banner (expand-file-name "logo.png" freedom-emacs-directory))
      (setq dashboard-startup-banner (expand-file-name "banner/emacs-gnu-logo.png" freedom-emacs-directory))
    ;; TUI 代码放置
    (setq dashboard-startup-banner (expand-file-name "logo.txt" freedom-emacs-directory)))
  ;; 导航目录
  (setq dashboard-items '(
                          (recents  . 10)
                          (bookmarks . 5)
                          ;; (agenda . 5)
                          ;;(projects . 5)
                          ;; (registers . 5)
                          ))
  ;; 使用图标
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  ;; 图标更换
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))
  ;; 显示被加载的包的信息和初始化时间:
  (setq dashboard-set-init-info t)
  ;; 此外，消息可以这样定制:
  ;; (setq dashboard-init-info "This is an init message!")
  ;; 最下面的仪表盘
  (setq dashboard-footer-messages '("🎉 Freedom and Peace 🎉"))
  (setq dashboard-footer-icon (all-the-icons-octicon "dashboard"
                                                     :height 1.1
                                                     :v-adjust -0.05
                                                     :face 'font-lock-keyword-face))
  ;; 在横幅下面显示导航器:
  (setq dashboard-set-navigator t)
  
  (dashboard-setup-startup-hook)
  (defun open-dashboard ()
    "Open the *dashboard* buffer and jump to the first widget."
    (interactive)
    ;; Check if need to recover layout
    (if (> (length (window-list-1))
           ;; exclude `treemacs' window
           (if (and (fboundp 'treemacs-current-visibility)
                    (eq (treemacs-current-visibility) 'visible))
               2
             1))
        (setq dashboard-recover-layout-p t))

    (delete-other-windows)

    ;; Refresh dashboard buffer
    (when (get-buffer dashboard-buffer-name)
      (kill-buffer dashboard-buffer-name))
    (dashboard-insert-startupify-lists)
    (switch-to-buffer dashboard-buffer-name)

    ;; Jump to the first section
    (dashboard-goto-recent-files)
    )

  (defun dashboard-goto-recent-files ()
    "Go to recent files."
    (interactive)
    (let ((func (local-key-binding "r")))
      (and func (funcall func))))

  )

(global-set-key (kbd "<f2>") 'open-dashboard)

(provide 'init-dashboard)
