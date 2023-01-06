(add-to-list 'load-path "~/.freedom.d/core")
(add-to-list 'load-path "~/.freedom.d/core/plugins")
;; 打开 emacs 就加载
(require 'init-system)
(setq default-input-method "pyim")
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

;; 打开窗口后再使用
(add-hook 'window-setup-hook (lambda ()
                               (require 'init-package)
                               (require 'init-deamon)
                               (require 'init-basic)
                               (load-theme 'doom-one t)
                               (require 'init-ui)
                               
                               ))
;; 延迟启动
(run-with-idle-timer 1.0 nil (lambda ()
                              (require 'init-completion)
                              (require 'init-translate)
                               ))
(run-with-idle-timer 3.0 nil (lambda ()
                              (require 'init-edit)
                              (require 'init-navigation)
                              (require 'init-reader)
                              (require 'init-calendar)
                              (require 'init-markdown)
                              (message "所有配置加载完成")
                               ))
(run-with-idle-timer 2.0 nil (lambda ()
                              (require 'init-meow)
                              (require 'init-search)
                              (require 'init-org)
                              (require 'init-pyim)
                               ))