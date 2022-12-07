;; 设置Emacs标题
(setq frame-title-format '("Happy Emacs - %b")
      icon-title-format frame-title-format)
(find-file-read-only "~/.freedom.d/logo.txt")
;; 光标闪烁
(blink-cursor-mode 0)
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
(toggle-truncate-lines 1)
;; 行号
(setq display-line-numbers 'relative
      display-line-numbers-type 'relative)
(setq display-line-numbers-width 3
      display-line-numbers-widen 1)
(global-display-line-numbers-mode t)
;;显示时间
(setq display-time-mode t) ;; 常显
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
;; 简化yes和no
(fset 'yes-or-no-p 'y-or-n-p)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 设置编码
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
;; 关闭 native-comp 错误警告
(setq comp-async-report-warnings-errors nil)
;; 为防止不小心按到C-c C-x,在退出Emacs前需要确认, 60 秒后自动退出
(setq confirm-kill-emacs (lambda (prompt) (y-or-n-p-with-timeout "Quit Emacs :)   " 60 "y")))

;;隐藏菜单栏工具栏滚动条
(menu-bar-mode 0)
(tool-bar-mode 0)
(tooltip-mode 0)
(when (not freedom/is-termux)
  (scroll-bar-mode 0))
(when freedom/is-linux
  (when (not freedom/is-termux)
    ;; 调整启动时窗口大小/最大化/全屏
    (set-face-attribute 'default nil :height 155)
    (setq initial-frame-alist
          '((top . 60) (left . 400) (width . 85) (height . 39)))
    ;; (add-hook 'window-setup-hook #'toggle-frame-maximized t)
    ;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen t)
    ;; )
    ))
(when (string= "windows-nt" system-type)
  ;; 调整启动时窗口位置/大小/最大化/全屏
  (setq initial-frame-alist
        '((top . 20) (left . 450) (width . 105) (height . 48)))
  ;; (add-hook 'window-setup-hook #'toggle-frame-maximized t)
  ;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen t)
  ;; )
  )
(when (string= "darwin" system-type)
  (custom-set-faces
   '(default ((t (:family "Courier New" :foundry "outline" :slant normal :weight normal :height 195 :width normal)))))
  )
  ;;; Proxy
(setq url-proxy-services '(
                           ("http" . "127.0.0.1:7890")
                           ("https" . "127.0.0.1:7890")))
(when freedom/is-linux
  (when (not freedom/is-termux)
    (setq url-proxy-services '(
                               ("http" . "192.168.1.3:7890")
                               ("https" . "192.168.1.3:7890")))
    )
  )
;;; function
(defun freedom/sudo-this-file ()
  "Open the current file as root."
  (interactive)
  (find-file
   (freedom--sudo-file-path
    (or buffer-file-name
        (when (or (derived-mode-p 'dired-mode)
                  (derived-mode-p 'wdired-mode))
          default-directory)))))
(defun freedom--sudo-file-path (file)
  (let ((host (or (file-remote-p file 'host) "localhost")))
    (concat "/" (when (file-remote-p file)
                  (concat (file-remote-p file 'method) ":"
                          (if-let (user (file-remote-p file 'user))
                              (concat user "@" host)
                            host)
                          "|"))
            "sudo:root@" host
            ":" (or (file-remote-p file 'localname)
                    file))))
(defun Myconfig ()
  (interactive)
  (find-file "~/.freedom.d/config.org"))
  
(recentf-mode 1)
(save-place-mode 1)

(provide 'init-basic)
