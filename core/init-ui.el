;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; awesome-tab 状态栏
(use-package awesome-tab
  :ensure nil
  :load-path "~/.emacs.d/core/plugins"
  :defer 0.5
  :config
  (awesome-tab-mode t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; posframe
(when (not freedom/is-termux)
  (use-package posframe
    :ensure t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emojify
(when (not freedom/is-termux)
  (use-package emojify
    :ensure t
    :hook (after-init . global-emojify-mode))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cnfonts Org-mode 中英文字体对齐
(use-package cnfonts
  :ensure t
  :defer 0.5
  :init
  (when freedom/is-windows
    (setq cnfonts-directory (expand-file-name ".local/cnfonts/windows" freedom-emacs-directory)))
  (when freedom/is-linux
    (setq cnfonts-directory (expand-file-name ".local/cnfonts/linux" freedom-emacs-directory)))
  (when freedom/is-darwin
    (setq cnfonts-directory (expand-file-name ".local/cnfonts/darwin" freedom-emacs-directory)))
  :custom
  (cnfonts-personal-fontnames '(("Consolas" "Iosevka" "Constantia" "PragmataPro Mono Liga" "Go Mono" "Fira Code" "Ubuntu Mono" "SF Mono");; 英文
                                ("微软雅黑" "Sarasa Mono SC Nerd" "M 盈黑 PRC W5" "方正聚珍新仿简繁" "苹方 常规" "苹方 中等" "M 盈黑 PRC W4" "PragmataPro Mono Liga");; 中文
                                ("Simsun-ExtB" "方正聚珍新仿简繁" "PragmataPro Mono Liga");; EXT-B
                                ("Segoe UI Symbol" "PragmataPro Mono Liga")));; 字符
  :config
  (setq cnfonts-profiles
        '("program" "org-mode" "read-book"))
  (when (not freedom/is-termux)
      (cnfonts-mode)
      (cnfonts-set-font)
    )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; monokai-theme
(use-package monokai-theme
  :ensure t
  )
(use-package circadian
  :ensure t
  :config
  (setq circadian-themes '(("8:00" . monokai)
                           ("17:30" . monokai)))
  (circadian-setup))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; doom-modeline
(use-package all-the-icons
  :ensure t)
(use-package doom-modeline
  :ensure t
  :after all-the-icons
  :pin elpa-local
  :config
  (doom-modeline-mode 1)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; basic
(use-package emacs
  :ensure nil
  :defer 0.5
  :config
  ;; 设置Emacs标题
  (setq frame-title-format '("Happy Emacs - %b")
        icon-title-format frame-title-format)
  ;; 光标闪烁
  (setq blink-cursor-mode nil)
  ;; 显示电池
  (if (display-graphic-p)
      (display-battery-mode 1))
  ;; 空格代替制表符缩进
  (setq-default indent-tabs-mode nil)
  ;;高亮当前行
  (global-hl-line-mode 1)
  ;;关闭启动画面
  (setq inhibit-startup-message t)
  ;;自动换行
  (setq toggle-truncate-lines t)
  ;;显示时间
  (display-time-mode 1) ;; 常显
  (setq display-time-24hr-format t) ;;格式
  (setq display-time-day-and-date t) ;;显示时间、星期、日期
  ;; 关闭启动帮助画面
  (setq inhibit-splash-screen 1)
  ;; 关闭备份文件
  (setq make-backup-files nil)
  ;; 取消备份
  (setq create-lockfiles nil) 
  ;; 自动加载外部修改的文件
  (global-auto-revert-mode 1)
  ;; 关闭警告声
  (setq ring-bell-function 'ignore)
  ;; 设置 emacs 的配置
  (setq auto-save-list-file-prefix (format "%sauto-save-list/.saves-" user-emacs-directory))
  ;; 简化yes和no
  (fset 'yes-or-no-p 'y-or-n-p)
  ;;隐藏菜单栏工具栏滚动条
  (menu-bar-mode 0)
  (when freedom/is-linux
    (when (not freedom/is-termux)
      (tool-bar-mode 0)
      (scroll-bar-mode 0)
      (tooltip-mode 0)
      ;; 调整启动时窗口大小/最大化/全屏
      (set-face-attribute 'default nil :height 155)
      (setq initial-frame-alist
            '((top . 60) (left . 400) (width . 85) (height . 38)))
      ;; (add-hook 'window-setup-hook #'toggle-frame-maximized t)
      ;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen t)
      ;; )
      ))
  (when (string= "windows-nt" system-type)
    (tool-bar-mode 0)
    ;; 滚动条
    (scroll-bar-mode 0)
    (tooltip-mode 0)
    )
  (when (string= "darwin" system-type)
    (tool-bar-mode 0)
    (menu-bar-mode 1)
    )
  (when (string= "windows-nt" system-type)
    ;; 调整启动时窗口位置/大小/最大化/全屏
    (setq initial-frame-alist
          '((top . 20) (left . 450) (width . 110) (height . 48)))
    ;; (add-hook 'window-setup-hook #'toggle-frame-maximized t)
    ;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen t)
    ;; )
    )
  (when (string= "darwin" system-type)
    (custom-set-faces

     '(default ((t (:family "Courier New" :foundry "outline" :slant normal :weight normal :height 195 :width normal)))))
    )
  )

(provide 'init-ui)
