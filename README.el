(eval-and-compile
  (customize-set-variable
   'package-archives '(
                       ("elpa-local" . "~/.freedom.d/.local/elpa-local/")
                       ("melpa" . "https://melpa.org/packages/")
                       ;; ("melpa-stable" . "https://stable.melpa.org/packages/")
                       ;; ("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                       ;; ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                       ;; ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
		       ))
  (package-initialize)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  )

(server-start)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 设置 deamon 乱码
(use-package emacs
  :ensure nil
  :defer t
  :config
  (when (eq system-type 'windows-nt)
    (setq locale-coding-system 'gb18030)  ;此句保证中文字体设置有效
    (setq w32-unicode-filenames 'nil)       ; 确保file-name-coding-system变量的设置不会无效
    (setq file-name-coding-system 'gb18030) ; 设置文件名的编码为gb18030
    )
  )

(use-package subr-x
  :ensure nil
  :defer t
  :config
  (setq freedom/is-termux
        (string-suffix-p "Android" (string-trim (shell-command-to-string "uname -a"))))
  (setq freedom/is-linux (and (eq system-type 'gnu/linux)))
  (setq freedom/is-darwin (and (eq system-type 'darwin)))
  (setq freedom/is-windows (and (eq system-type 'windows-nt)))
  (setq freedom/is-gui (if (display-graphic-p) t))
  (setq freedom/is-tui (not (display-graphic-p)))
  )

(setq freedom-emacs-directory "~/.freedom.d/")
(add-to-list 'load-path (expand-file-name "core" freedom-emacs-directory))
(require 'elpa-mirror)
(setq elpamr-default-output-directory (format "%s.local/elpa-local" freedom-emacs-directory))

(use-package emacs
  :ensure nil
  :defer t
  :config
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; 设置编码
  (setq default-buffer-file-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  ;; 关闭 native-comp 错误警告
  ;; Silence compiler warnings as they can be pretty disruptive
  (setq comp-async-report-warnings-errors nil)
  )

(use-package emacs
  :ensure nil
  :defer t
  :config

  (setq url-proxy-services '(
                             ("http" . "127.0.0.1:7890")
                             ("https" . "127.0.0.1:7890")))
  (when freedom/is-linux
    (when (not freedom/is-termux)
      (setq url-proxy-services '(
                                 ("http" . "192.168.1.8:7890")
                                 ("https" . "192.168.1.8:7890")))
      )
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; doom
(use-package emacs
  :ensure nil
  :defer t
  :config
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
    (find-file "~/.freedom.d/README.org"))
  )

(use-package meow
  :ensure t
  :config
  (defun meow-setup ()
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    (meow-motion-overwrite-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("h" . meow-left)
     '("l" . meow-right)
     '("." . meow-inner-of-thing)
     '("," . meow-bounds-of-thing)
     '("<escape>" . ignore))
    (meow-leader-define-key
     ;; SPC j/k will run the original command in MOTION state.
     '("j" . "H-j")
     '("k" . "H-k")
     '("bb" . consult-buffer)
     '("bi" . ibuffer)
     '("bk" . kill-this-buffer)
     ;; '("c SPC" . align-regexp)
     '("fr" . consult-recent-file)
     '("fy" . gts-do-translate)
     '("qR" . restart-emacs)
     '("qq" . save-buffers-kill-terminal)
     '("wk" . windmove-up)
     '("wj" . windmove-down)
     '("wh" . windmove-left)
     '("wl" . windmove-right)
     '("wd" . delete-window)
     '("ws" . split-window-below)
     '("wv" . split-window-right)
     '("ww" . ace-window)
     '("sp" . consult-ripgrep)
     '("si" . consult-imenu)
     '("oa" . org-agenda)
     '("op" . dired)
     '("pf" . projectile-find-file)
     '("pd" . projectile-find-dir)
     '("ps" . projectile-ripgrep)
     '("pa" . projectile-add-known-project)
     '("pb" . projectile-switch-to-buffer)
     '("pS" . projectile-switch-project)
     '("nn" . org-capture)
     '("nrf" . org-roam-node-find)
     '("nrs" . org-roam-db-sync)
     ;; Use SPC (0-9) for digit arguments.
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument)
     '("/" . meow-keypad-describe-key)
     '("?" . meow-cheatsheet))
    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("-" . negative-argument)
     '(";" . meow-reverse)
     '("." . meow-inner-of-thing)
     '("," . meow-bounds-of-thing)
     '("[" . meow-beginning-of-thing)
     '("]" . meow-end-of-thing)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . meow-change)
     '("d" . meow-delete)
     '("D" . meow-backward-delete)
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     '("f" . meow-find)
     '("F" . avy-goto-char)
     '("g" . meow-cancel-selection)
     ;; '("gb" . end-of-buffer)
     ;; '("gg" . beginning-of-buffer)
     ;; '("gd" . xref-find-definitions)
     ;; '("gD" . xref-pop-marker-stack)
     '("G" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("m" . meow-join)
     '("n" . meow-search)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     '("q" . meow-quit)
     '("Q" . meow-goto-line)
     '("r" . meow-replace)
     '("R" . meow-swap-grab)
     '("s" . meow-clipboard-kill)
     '("t" . meow-till)
     '("u" . undo-tree-undo)
     '("U" . meow-undo-in-selection)
     ;;'("v" . meow-visit)
     '("v" . +meow-visual)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("x" . meow-line)
     '("X" . avy-goto-line)
     '("y" . meow-save)
     '("Y" . meow-sync-grab)
     '("z" . meow-pop-selection)
     '("'" . repeat)
     '("$" . move-end-of-line)
     '("/" . consult-line)
     '("C-s" . consult-line)
     '("=" . meow-indent)
     '(">" . indent-rigidly-right)
     '("<" . indent-rigidly-left)
     '("C-r" . undo-tree-redo)
     '("\"" . consult-yank-pop)
     '("<f12>" . dumb-jump-go)
     ;; '("<escape>" . ignore)
     '("<escape>" . meow-cancel-selection)
     ))
  (meow-setup)
  (meow-global-mode 1)
  (setq meow-expand-hint-remove-delay 3
        meow-use-clipboard t)

  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package emacs
  :ensure nil
  :defer t
  :config
  (defun +meow-insert-chord-two (s otherfunction keydelay)
    "类似 key-chord 功能"
    (when (meow-insert-mode-p)
      (let ((modified (buffer-modified-p))
            (undo-list buffer-undo-list))
        (insert (elt s 0))
        (let* ((second-char (elt s 1))
               (event
                (if defining-kbd-macro
                    (read-event nil nil)
                  (read-event nil nil keydelay))))
          (when event
            (if (and (characterp event) (= event second-char))
                (progn
                  (backward-delete-char 1)
                  (set-buffer-modified-p modified)
                  (setq buffer-undo-list undo-list)
                  (apply otherfunction nil))
              (push event unread-command-events)))))))

  (defun +meow-chord-pyim ()
    (interactive)
    (+meow-insert-chord-two ";;" #'toggle-input-method 0.5))
  (define-key meow-insert-state-keymap (substring ";;" 0 1)
    #'+meow-chord-pyim)
  (defun +meow-chord-insert-exit ()
    (interactive)
    (+meow-insert-chord-two "jk" #'+meow-insert-exit 0.5))
  (define-key meow-insert-state-keymap (substring "jk" 0 1)
    #'+meow-chord-insert-exit)
  (defun +meow-insert-exit ()
    (interactive)
    (meow-insert-exit)
    (corfu-quit))

(defun +meow-visual ()
  (interactive)
  (meow-left-expand)
  (meow-right-expand))


  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; awesome-tab 状态栏
(use-package awesome-tab
  :ensure nil
  :load-path "~/.freedom.d/core/plugins"
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
  (cnfonts-personal-fontnames '(("Consolas" "Iosevka" "Bookerly" "Constantia" "PragmataPro Mono Liga" "Go Mono" "Fira Code" "Ubuntu Mono" "SF Mono");; 英文
                                ("微软雅黑" "Sarasa Mono SC Nerd" "Bookerly" "M 盈黑 PRC W5" "方正聚珍新仿简繁" "苹方 常规" "苹方 中等" "M 盈黑 PRC W4" "PragmataPro Mono Liga");; 中文
                                ("Simsun-ExtB" "Bookerly" "方正聚珍新仿简繁" "PragmataPro Mono Liga");; EXT-B
                                ("Segoe UI Symbol" "Bookerly" "PragmataPro Mono Liga")));; 字符
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
  ;; (global-hl-line-mode 1)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vertico minibuffer 补全
(use-package vertico
  :ensure t
  :defer 0.5
  :bind (:map vertico-map
              ("DEL" . vertico-directory-delete-char))
  :config
  (vertico-mode t)
  (setq vertico-count 15))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure nil
  :defer 0.5
  :init
  ;; (setq savehist-file (expand-file-name "emacs/history" user-emacs-directory))
  (savehist-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Optionally use the `orderless' completion style.
(use-package orderless
  :ensure t
  :defer 0.5
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion))))
  ;; 据说这样设置可以让 eglot corfu orderless
  ;; (setq completion-styles '(orderless flex)
  ;;       completion-category-overrides '((eglot (styles . (orderless flex)))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Search content in the file
(use-package consult
  :ensure t
  :defer 0.5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 显示介绍
(use-package marginalia
  :ensure t
  :defer 0.5
  :config
  (marginalia-mode))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; A few more useful configurations...
(use-package emacs
  :defer 0.5
  :ensure nil
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :ensure nil
  :defer 0.5
  :custom
  (org-ellipsis " ⭍")
  (org-pretty-entities t)
  (org-hide-leading-stars t)
  (org-hide-emphasis-markers t)
  :custom-face
  (org-level-1 ((t (:height 1.15))))
  (org-level-2 ((t (:height 1.13))))
  (org-level-3 ((t (:height 1.11))))
  (org-level-4 ((t (:height 1.09))))
  (org-level-5 ((t (:height 1.07))))
  (org-level-6 ((t (:height 1.05))))
  (org-level-7 ((t (:height 1.03))))
  (org-level-8 ((t (:height 1.01))))
  (org-todo ((t (:inherit 'fixed-pitch))))
  (org-done ((t (:inherit 'fixed-pitch))))
  (org-ellipsis ((t (:inherit 'fixed-pitch))))
  (org-property-value ((t (:inherit 'fixed-pitch))))
  (org-special-keyword ((t (:inherit 'fixed-pitch))))
  )

(use-package org
  :ensure nil
  :defer 0.5
  :config
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Agenda Soure File
  (when freedom/is-windows
    (setq org-agenda-files (list
                            "F:\\MyFile\\Org\\GTD"
                            )))
  (when freedom/is-linux
    (setq org-agenda-files (list
                            "~/MyFile/Org/GTD"
                            )))
  (when freedom/is-darwin
    (setq org-agenda-files (list
                            "~/Desktop/MyFile/Org/GTD"
                            ))))

(use-package org
  :ensure nil
  :defer 0.5
  :config
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; TODO Configuration
  ;; 设置任务流程(这是我的配置)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "DOING(i)" "HANGUP(h)" "|" "DONE(d)" "CANCEL(c)")
          (sequence "🚩(T)" "🏴(I)" "❓(H)" "|" "✔(D)" "✘(C)"))
        org-todo-keyword-faces '(("HANGUP" . warning)
                                 ("❓" . warning))
        org-priority-faces '((?A . error)
                             (?B . warning)
                             (?C . success))
        )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
(use-package org
  :ensure nil
  :defer 0.5
  :hook (org-mode . toggle-truncate-lines)
  :config
  ;;Windows系统日历乱码
  (setq system-time-locale "C")
  (format-time-string "%Y-%m-%d %a")
  ;; 当它们处于某种DONE状态时，不要在议程中显示计划的项目。
  (setq org-agenda-skip-scheduled-if-done t)
  ;; 记录任务状态变化,可能会记录对任务状态的更改，尤其是对于重复例程。如果是这样，请将它们记录在抽屉中，而不是笔记的内容。
  (setq org-log-state-notes-into-drawer t )
  ;; 打开 org 文件 默认将 列表折叠
  (setq org-cycle-include-plain-lists 'integrate)
  ;; 隐藏语法符号 例如: *粗体* , * 符号会被隐藏
  (setq-default org-hide-emphasis-markers t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;代码块高亮
  (setq org-src-fontify-natively t)
  ;;不自动tab
  (setq org-src-tab-acts-natively nil)
  ;; 直接运行语言支持
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; org 图片设置
  ;;打开Org文件自动显示图片
  (setq org-startup-with-inline-images t)
  ;;图片显示1/3尺寸
  (setq org-image-actual-width (/ (display-pixel-width) 3))
  ;;图片显示 300 高度，如果图片小于 300，会被拉伸。
  (setq org-image-actual-width '(500))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org 通知设置
(use-package appt
  :ensure nil
  :defer 0.5
  :init
  ;; 每小时同步一次appt,并且现在就开始同步
  (run-at-time nil 3600 'org-agenda-to-appt)
  :hook (org-finalize-agenda . org-agenda-to-appt)
  :config
  ;; 激活提醒
  (appt-activate 1)
  ;; 提前半小时提醒
  (setq appt-message-warning-time 1)
  (setq appt-audible t)
  ;;提醒间隔
  (setq appt-display-interval 5)
  (require 'notifications)
  (defun appt-disp-window-and-notification (min-to-appt current-time appt-msg)
    (let ((title (format "%s分钟内有新的任务" min-to-appt)))
      (notifications-notify :timeout (* appt-display-interval 60000) ;一直持续到下一次提醒
                            :title title
                            :body appt-msg
                            )
      (appt-disp-window min-to-appt current-time appt-msg))) ;同时也调用原有的提醒函数
  (setq appt-display-format 'window) ;; 只有这样才能使用自定义的通知函数
  (setq appt-disp-window-function #'appt-disp-window-and-notification)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
(use-package org
  :ensure nil
  :defer 0.5
  :config
  (setq org-capture-bookmark nil)
  (when (string= "gnu/linux" system-type)
    (setq org-capture-templates
          '(
            ;;TODO
            ;; ("t" "Todo" entry (file+headline "~/MyFile/Org/GTD/Todo.org" "2022年6月")
            ("t" "Todo" plain (file+function "~/MyFile/Org/GTD/Todo.org" find-month-tree)
             "*** TODO %^{想做什么？}\n  :时间: %^T\n  %?\n  %i\n"  :kill-buffer t :immediate-finish t)

            ;;日志
            ("j" "Journal" entry (file+datetree "~/MyFile/Org/Journal.org")
             "* %^{记些什么} %?\n  %i\n" :kill-buffer t :immediate-finish t)

            ;;日程安排
            ("a" "日程安排" plain (file+function "~/MyFile/Org/Agenda" find-month-tree)
             "*** [#%^{优先级}] %^{安排} \n SCHEDULED: %^T \n  :地点: %^{地点}\n" :kill-buffer t :immediate-finish t)

            ;;笔记
            ;; ("n" "笔记" entry (file+headline "~/MyFile/Org/Note.org" "2022年6月")
            ("n" "笔记" entry (file+headline "~/MyFile/Org/Note.org" "Note.org")
             "* %^{你想要记录的笔记} \n :时间: %T \n %?")

            ;;消费
            ("zd" "账单" plain (file+function "~/MyFile/Org/Bill.org" find-month-tree)
             " | %<%Y-%m-%d %a %H:%M:%S> | %^{prompt|Breakfast|Lunch|Dinner|Shopping|Night Snack|Fruit|Transportation|Other} | %^{金额} |" :kill-buffer t :immediate-finish t)

            ;;英语单词
            ("e" "英语单词" entry (file+datetree "~/MyFile/Org/EnglishWord.org")
             "*  %^{英语单词} ----> %^{中文翻译}\n"  :kill-buffer t :immediate-finish t)

            ;;Org-protocol网页收集
            ("w" "网页收集" entry (file "~/MyFile/Org/WebCollection.org")
             "* [[%:link][%:description]] \n %U \n %:initial \n")
            ("b" "Bookmarks" plain (file+headline "~/MyFile/Org/Bookmarks.org" "Bookmarks")
             "+  %?" :kill-buffer t :prepend 1)
            ))
    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; org-protocol-capture-html Capture Configuration darwin
  (when (string= "darwin" system-type)
    (setq org-capture-templates
          '(
            ;;TODO
            ("t" "Todo" plain (file+function "~/Desktop/MyFile/Org/GTD/Todo.org" find-month-tree)
             "*** TODO %^{想做什么？}\n  :时间: %^T\n  %?\n  %i\n"  :kill-buffer t :immediate-finish t)

            ;;日志
            ("j" "Journal" entry (file+datetree "~/Desktop/MyFile/Org/Journal.org" )
             "* %^{记些什么} %?\n  %i\n" :kill-buffer t :immediate-finish t)

            ;;日程安排
            ("a" "日程安排" plain (file+function "~/Destop/MyFile/Org/GTD/Agenda.org" find-month-tree)
             "*** [#%^{优先级}] %^{安排} \n SCHEDULED: %^T \n  :地点: %^{地点}\n" :kill-buffer t :immediate-finish t)

            ;;笔记
            ("n" "笔记" entry (file+headline "~/Desktop/MyFile/Org/Note.org" "Note")
             "* %^{你想要记录的笔记} \n :时间: %T \n %?")

            ;;消费
            ("zd" "账单" plain (file+function "~/Desktop/MyFile/Org/Bill.org" find-month-tree)
             " | %<%Y-%m-%d %a %H:%M:%S> | %^{prompt|Breakfast|Lunch|Dinner|Shopping|Night Snack|Fruit|Transportation|Other} | %^{金额} |" :kill-buffer t :immediate-finish t)

            ;;英语单词
            ("e" "英语单词" entry (file+datetree "~/Desktop/MyFile/Org/EnglishWord.org")
             "*  %^{英语单词} ----> %^{中文翻译}\n" :kill-buffer t :immediate-finish t)

            ;;Org-protocol网页收集
            ("w" "网页收集" entry (file "~/Desktop/MyFile/Org/WebCollection.org")
             "* [[%:link][%:description]] \n %U \n %:initial \n")
            ("b" "Bookmarks" plain (file+headline "~/Desktop/MyFile/Org/Bookmarks.org" "New-Bookmarks")
             "+  %?" :kill-buffer t :prepend 1)
            ))
    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; org-protocol-capture-html Capture Configuration windows-nt
  (when (string= "windows-nt" system-type)
    (setq org-capture-templates
          '(
            ;;TODO
            ("t" "Todo" plain (file+function "F:\\MyFile\\Org\\GTD\\Todo.org" find-month-tree)
             "*** TODO %^{想做什么？}\n  :时间: %^T\n  %?\n  %i\n"  :kill-buffer t :immediate-finish t)

            ;;日志
            ("j" "Journal" entry (file+datetree "F:\\MyFile\\Org\\Journal.org")
             "* %^{记些什么} %?\n  %i\n" :kill-buffer t :immediate-finish t)

            ;;日程安排
            ("a" "日程安排" plain (file+function "F:\\MyFile\\Org\\GTD\\Agenda.org" find-month-tree)
             "*** [#%^{优先级}] %^{安排} \n SCHEDULED: %^T \n  :地点: %^{地点}\n" :kill-buffer t :immediate-finish t)

            ;;笔记
            ("n" "笔记" entry (file+headline "F:\\MyFile\\Org\\Note.org" "Note")
             "* %^{你想要记录的笔记} \n :时间: %T \n %?")

            ("y" "语录" entry (file+headline "F:\\Hugo\\content\\Quotation.zh-cn.md" "2022")
             "> %^{语录}  " :kill-buffer t :immediate-finish t)

            ;;消费
            ("zd" "账单" plain (file+function "F:\\MyFile\\Org\\Bill.org" find-month-tree)
             " | %<%Y-%m-%d %a %H:%M:%S> | %^{prompt|Breakfast|Lunch|Dinner|Shopping|Night Snack|Fruit|Transportation|Other} | %^{金额} |" :kill-buffer t :immediate-finish t)

            ;;英语单词
            ("e" "英语单词" entry (file+datetree "F:\\MyFile\\Org\\EnglishWord.org")
             "*  %^{英语单词} ----> %^{中文翻译}\n" :kill-buffer t :immediate-finish t)

            ;;Org-protocol网页收集
            ("w" "网页收集" entry (file "F:\\MyFile\\Org\\WebCollection.org")
             "* [[%:link][%:description]] \n %U \n %:initial \n" :kill-buffer t :immediate-finish t)

            ("b" "Bookmarks" plain (file+headline "F:\\MyFile\\Org\\Bookmarks.org" "Bookmarks")
             "+  %?" :kill-buffer t :prepend 1)
            ))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; 创建org-capture 按键夹,必须创建才能用多按键
  (add-to-list 'org-capture-templates '("z" "账单"));;与上面的账单相对应
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Capture Configuration 记录账单函数
  ;;用 org-capture 记录账单
  (defun get-year-and-month ()
    (list (format-time-string "%Y") (format-time-string "%Y-%m")))
  (defun find-month-tree ()
    (let* ((path (get-year-and-month))
           (level 1)
           end)
      (unless (derived-mode-p 'org-mode)
        (error "Target buffer \"%s\" should be in Org mode" (current-buffer)))
      (goto-char (point-min))             ;移动到 buffer 的开始位置
      ;; 先定位表示年份的 headline，再定位表示月份的 headline
      (dolist (heading path)
        (let ((re (format org-complex-heading-regexp-format
                          (regexp-quote heading)))
              (cnt 0))
          (if (re-search-forward re end t)
              (goto-char (point-at-bol))  ;如果找到了 headline 就移动到对应的位置
            (progn                        ;否则就新建一个 headline
              (or (bolp) (insert "\n"))
              (if (/= (point) (point-min)) (org-end-of-subtree t t))
              (insert (make-string level ?*) " " heading "\n"))))
        (setq level (1+ level))
        (setq end (save-excursion (org-end-of-subtree t t))))
      (org-end-of-subtree)))
  )

(use-package ox-hugo
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-superstar 美化标题，表格，列表 之类的
(use-package org-superstar
  :ensure t
  :defer 0.5
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-headline-bullets-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷"))
  (org-superstar-item-bullet-alist '((43 . "⬧") (45 . "⬨")))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-roam
(when freedom/is-linux
  (setq emacsql-sqlite-executable-path "sqlite/Linux/emacsql-sqlite")
  (when freedom/is-termux
    (setq emacsql-sqlite-executable-path "sqlite/Termux/emacsql-sqlite")
    )
  )
(when freedom/is-darwin
  (setq emacsql-sqlite-executable-path "sqlite/Darwin/emacsql-sqlite")
  )
(use-package org-roam
  :ensure t
  :commands (org-roam-node-find org-agenda org-capture org-mode)
  :init
  (when (string= "windows-nt" system-type)
    (setq org-roam-directory (file-truename "F:\\MyFile\\Org")))
  (when (string= "gnu/linux" system-type)
    (setq org-roam-directory (file-truename "~/MyFile/Org/")))
  (when (string= "darwin" system-type)
    (setq org-roam-directory (file-truename "~/Desktop/MyFile/Org/")))
  :config
  ;;搜索
  (setq org-roam-node-display-template "${title}")
  ;;补全
  (setq org-roam-completion-everywhere t)
  ;;一个也可以设置org-roam-db-node-include-function。例如，ATTACH要从 Org-roam 数据库中排除所有带有标签的标题，可以设置：
  (setq org-roam-db-node-include-function
        (lambda ()
          (not (member "ATTACH" (org-get-tags)))))
  (setq org-roam-db-gc-threshold most-positive-fixnum)
  ;; 创建左边显示子目录分类
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))
  (setq org-roam-node-display-template
        (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (setq org-roam-db-update-on-save t)
  ;;(org-roam-db-autosync-mode)
  (setq org-roam-database-connector 'sqlite)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-roam-ui
(use-package org-roam-ui
  :ensure t
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org 标题加密， 只需添加 :crypt:
(use-package org-crypt
  :defer 1
  :ensure nil
  :config
  (org-crypt-use-before-save-magic)
  (setq org-tags-exclude-from-inheritance '("crypt"))
  (setq org-crypt-key "885AC4F89BA7A3F8")
  (setq auto-save-default nil)
  ;; 解决 ^M 解密问题
  (defun freedom/org-decrypt-entry ()
    "Replace DOS eolns CR LF with Unix eolns CR"
    (interactive)
    (goto-char (point-min))
    (while (search-forward "\r" nil t) (replace-match ""))
    (org-decrypt-entry))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq epg-gpg-program "gpg2"))

(use-package projectile
  :ensure t
  :hook (after-init . projectile-mode)
  :config
  (use-package ripgrep
    :ensure t
    :pin elpa-local)
  (use-package projectile-ripgrep
    :ensure t
    :pin elpa-local)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yasnippet 补全
(use-package yasnippet
  :ensure t
  :defer 0.5
  :hook '((prog-mode . yas-minor-mode)
          (after-init . yas-global-mode))
  :config
  (yas-reload-all)
  (setq yas--default-user-snippets-dir (format "%ssnippets" freedom-emacs-directory))
  (setq yas-snippet-dirs
        '(
          "~/.freedom.d/snippets"
          ))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 快速点击各类链接
(use-package ace-link
  :ensure t
  :config
  (ace-link-setup-default))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Highlight some operations
(use-package volatile-highlights
  :ensure t
  :diminish
  :hook (after-init . volatile-highlights-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package magit
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; diff 高亮
(use-package diff-hl
  :ensure t
  :hook '((after-init . global-diff-hl-mode)
          (magit-pre-refresh . diff-hl-magit-pre-refresh)
          (magit-post-refresh . diff-hl-magit-post-refresh)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 高亮 symbol
(use-package symbol-overlay
  :ensure t
  :hook (after-init . symbol-overlay-mode)
  :init (setq symbol-overlay-idle-time 0.1)
  :bind (("M-i" . symbol-overlay-put)
         ("M-n" . symbol-overlay-jump-next)
         ("M-p" . symbol-overlay-jump-prev)
         ("M-N" . symbol-overlay-switch-forward)
         ("M-P" . symbol-overlay-switch-backward)
         ("M-C" . symbol-overlay-remove-all)
         ([M-f3] . symbol-overlay-remove-all))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 高亮括号匹配
(use-package paren
  :ensure nil
  :hook (after-init . show-paren-mode)
  :init
  (setq show-paren-when-point-in-periphery t
        show-paren-when-point-inside-paren t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package undo-tree
  :ensure t
  :hook (after-init . global-undo-tree-mode)
  :config
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; avy 单词跳跃
(use-package avy
  :ensure t
  :defer 0.5
  )
(use-package ace-pinyin
  :defer 0.5
  :ensure t
  :after avy
  :init (setq ace-pinyin-use-avy t)
  :config (ace-pinyin-global-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ace-window 窗口跳跃
(use-package ace-window
  :ensure t
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?r ?i ?t ?o ?u ?t ?v ?n))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; zoom 自动调整窗口大小
(use-package zoom
  :ensure t
  :defer 0.5
  :config
  (custom-set-variables
   '(zoom-mode t))
  (custom-set-variables
   '(zoom-size '(0.618 . 0.618)))
  (defun size-callback ()
    (cond ((> (frame-pixel-width) 1280) '(90 . 0.75))
          (t                            '(0.5 . 0.5))))

  (custom-set-variables
   '(zoom-size 'size-callback))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elfeed
(use-package elfeed
  :ensure t
  :commands (elfeed)
  :init
  (setq url-queue-timeout 30
        elfeed-search-filter "@2-week-ago")
  (setq elfeed-db-directory (concat freedom-emacs-directory ".local/.elfeed/db/"))
  :config
  ;; recentf 排除
  (when recentf-mode
    (push elfeed-db-directory recentf-exclude))
  ;; (setq elfeed-show-entry-switch #'pop-to-buffer
  ;;       shr-max-image-proportion 0.8)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elfeed-org
(use-package elfeed-org
  :ensure t
  :defer 0.5
  :commands (elfeed)
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list (expand-file-name "elfeed.org" freedom-emacs-directory)))
  )

(use-package corfu
  :ensure t
  :defer 0.5
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-quit-at-boundary t)   ;; 空格后要不要退出补全 Never quit at completion boundary
  (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-preselect-first nil)    ;; Disable candidate preselection
  (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  (corfu-echo-documentation nil) ;; Disable documentation in the echo area
  (corfu-scroll-margin 5)        ;; Use scroll margin
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode)
         (corfu-mode . corfu-history-mode)
         (corfu-mode . corfu-indexed-mode)
         )
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)
        ;; ("SPC" . corfu-insert-separator) ;; 空格后依然补全
        )
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto-delay 0.1
        corfu-auto-prefix 2)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package go-translate
  ;; :defer-incrementally t
  :ensure t
  :commands (gts-do-translate)
  :config
  ;; 配置多个翻译语言对
  (setq gts-translate-list '(("en" "zh") ("fr" "zh")))
  ;; 设置为 t 光标自动跳转到buffer
  (setq gts-buffer-follow-p t)
  ;; (if (display-graphic-p)
  ;;     (if (posframe-workable-p)
  ;;         (setq gts-default-translator
  ;;               (gts-translator
  ;;                :picker (gts-noprompt-picker)
  ;;                :engines (list (gts-google-rpc-engine) (gts-bing-engine))
  ;;                :render (gts-posframe-pop-render :forecolor "#ffffff" :backcolor "#111111")))
  ;;       ;; :render (gts-posframe-pin-render :width 40 :height 15 :position (cons 1500 20) :forecolor "#ffffff" :backcolor "#111111")))
  ;;       )

  ;;   (setq gts-default-translator
  ;;         (gts-translator
  ;;          :picker (gts-noprompt-picker)
  ;;          :engines (list (gts-google-rpc-engine) (gts-bing-engine))
  ;;          :render (gts-buffer-render)))
  ;;   )
  (gts-translator
   :picker (gts-noprompt-picker)
   :engines (list (gts-google-rpc-engine) (gts-bing-engine))
   :render (gts-buffer-render))

  );; go-translate

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 输入中文后自动翻译
(use-package insert-translated-name
  :ensure nil
  :defer 0.5
  :load-path "~/.freedom.d/core/plugins/"
  :config
  (setq insert-translated-name-translate-engine "youdao");; ;google  youdao
  (defun freedom-english-translate ()
    (interactive))
  (advice-add #'freedom-english-translate :override #'insert-translated-name-insert)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; calfw

(use-package calfw
  :ensure t
  :defer 0.5
  :config
  (use-package calfw-org
    :ensure t)
  (use-package calfw-ical
    :ensure t
  )
  (use-package calfw-cal
    :ensure t
  )
  ;; Month
  (setq calendar-month-name-array
        ["一月" "二月" "三月" "四月" "五月"   "六月"
         "七月" "八月" "九月" "十月" "十一月" "十二月"])
  ;; Week days
  (setq calendar-day-name-array
        ["周末" "周一" "周二" "周三" "周四" "周五" "周六"])
  ;; First day of the week
  (setq calendar-week-start-day 0) ; 0:Sunday, 1:Monday
  (defun cfw:freedom-calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list
      (cfw:org-create-source "Orange")  ; orgmode source
      (cfw:ical-create-source "RainISouth" "https://calendar.google.com/calendar/ical/isouthrain%40gmail.com/public/basic.ics" "Blue") ; google calendar ICS
      (cfw:ical-create-source "ChinaHoliday" "https://calendar.google.com/calendar/ical/zh-cn.china%23holiday%40group.v.calendar.google.com/public/basic.ics" "IndianRed") ; google calendar ICS
      )))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cal-china-x
(use-package cal-china-x
  :ensure t
  :after calendar
  :commands cal-china-x-setup
  :init (cal-china-x-setup)
  :config
  ;; Holidays
  (setq calendar-mark-holidays-flag t
        cal-china-x-important-holidays cal-china-x-chinese-holidays
        cal-china-x-general-holidays '((holiday-lunar 1 15 "元宵节")
                                       (holiday-lunar 7 7 "七夕节")
                                       (holiday-lunar 8 15 "中秋节")
                                       (holiday-fixed 3 8 "妇女节")
                                       (holiday-fixed 3 12 "植树节")
                                       (holiday-fixed 5 4 "青年节")
                                       (holiday-fixed 6 1 "儿童节")
                                       (holiday-fixed 9 10 "教师节")
                                       (holiday-fixed 10 1 "国庆节")
                                       )
        holiday-other-holidays '((holiday-fixed 2 14 "情人节")
                                 (holiday-fixed 4 1 "愚人节")
                                 (holiday-fixed 12 25 "圣诞节")
                                 (holiday-float 5 0 2 "母亲节")
                                 (holiday-float 6 0 3 "父亲节")
                                 (holiday-float 11 4 4 "感恩节"))
        holiday-custom-holidays '((holiday-lunar 7 29 "Happy Birthday")
                                  (holiday-lunar 2 3 "纪念奶奶"))
        calendar-holidays (append cal-china-x-important-holidays
                                  cal-china-x-general-holidays
                                  holiday-other-holidays
                                  holiday-custom-holidays)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; markdown-toc 生成目录
(use-package markdown-toc
  :ensure t
  :hook (markdown-mode . markdown-toc-mode)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; markdown-mode
(use-package markdown-mode
  :ensure t
  :defer 1
  ;; :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
  :config
  (defun freedom-hugo-home ()
    (interactive) ; 如果不需要定义成命令，这句可以不要。
    (when freedom/is-termux
      (find-file "~/Ubuntu/ubuntu-fs/root/Hugo/content/posts/Home.md"))
    (when freedom/is-linux
      (when (not freedom/is-termux)
        (find-file "~/f/Hugo/content/posts/Home.md")))
    (when (string= "darwin" system-type)
      (find-file "~/Desktop/Hugo/content/posts/Home.md"))
    (when (string= "windows-nt" system-type)
      (find-file "F:\\Hugo\\content\\posts\\Home.md"))
    )
  ) ;; use-package end

(use-package pyim-basedict
  :ensure t
  :pin elpa-local
  )

(use-package pyim
  :ensure t
  :pin elpa-local
  :defer 0.5
  :init
  (setq pyim-dcache-directory (format "%s.local/pyim" freedom-emacs-directory))
  (setq default-input-method "pyim")
  :bind ("C-\\". freedom-english-translate)
  :config
  (pyim-basedict-enable);; 为 pyim 添加词库
  (pyim-default-scheme 'xiaohe-shuangpin) ;;
  (setq pyim-page-length 5)
  (setq pyim-page-tooltip '(posframe popup minibuffer))
  (setq-default pyim-punctuation-translate-p '(no yes auto))   ;使用半角标点。
  ;; 使用 jk 将能进入 evil-normal-mode
  (defun my-pyim-self-insert-command (orig-func)
    (interactive "*")
    (if (and (local-variable-p 'last-event-time)
             (floatp last-event-time)
             (< (- (float-time) last-event-time) 0.2))
        (set (make-local-variable 'temp-evil-escape-mode) t)
      (set (make-local-variable 'temp-evil-escape-mode) nil)
      )
    (if (and temp-evil-escape-mode
             (equal (pyim-entered-get) "j")
             (equal last-command-event ?k))
        (progn
          (push last-command-event unread-command-events)
          (pyim-process-outcome-handle 'pyim-entered)
          (pyim-process-terminate))
      (progn
        (call-interactively orig-func)
        (set (make-local-variable 'last-event-time) (float-time))
        ))
    )
  (advice-add 'pyim-self-insert-command :around #'my-pyim-self-insert-command)

  ;; 设置光标颜色
  (defun my-pyim-indicator-with-cursor-color (input-method chinese-input-p)
    (if (not (equal input-method "pyim"))
        (progn
          ;; 用户在这里定义 pyim 未激活时的光标颜色设置语句
          (set-cursor-color "red"))
      (if chinese-input-p
          (progn
            ;; 用户在这里定义 pyim 输入中文时的光标颜色设置语句
            (set-cursor-color "green"))
        ;; 用户在这里定义 pyim 输入英文时的光标颜色设置语句
        (set-cursor-color "blue"))))
  (setq pyim-indicator-list (list #'my-pyim-indicator-with-cursor-color #'pyim-indicator-with-modeline))
  ;; 百度云拼音
  (setq pyim-cloudim 'baidu)

  ;; 添加对 meow 支持 normal 进行英文输入
  (defalias 'pyim-probe-meow-normal-mode #'(lambda nil
                                             (meow-normal-mode-p)))
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-meow-normal-mode))

  );; pyim

(use-package vimrc-mode
  :ensure nil
  :defer 1
  :load-path "~/.freedom.d/lisp/plugins/"
  :config
 (add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode)))

(use-package lsp-mode
  :ensure t
  :hook '((c-mode . lsp)))

(use-package dumb-jump
  :ensure t
  :hook '((xref-backend-functions . dumb-jump-xref-activate))
  :bind (:map dumb-jump-mode-map
              ("j" . next-line)
              ("k" . previous-line))
  :config
  (setq xref-show-definitions-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(use-package restart-emacs
  :ensure t)
(use-package session
  :ensure t
  :hook (after-init . recentf-mode)
  :init
  (setq recentf-max-menu-items 20)
  (setq recentf-max-saved-items 20)

  (defun sanityinc/time-subtract-millis (b a)
    (* 1000.0 (float-time (time-subtract b a))))


  (defvar sanityinc/require-times nil
    "A list of (FEATURE LOAD-START-TIME LOAD-DURATION).
  LOAD-DURATION is the time taken in milliseconds to load FEATURE.")

  (defun sanityinc/require-times-wrapper (orig feature &rest args)
    "Note in `sanityinc/require-times' the time taken to require each feature."
    (let* ((already-loaded (memq feature features))
           (require-start-time (and (not already-loaded) (current-time))))
      (prog1
          (apply orig feature args)
        (when (and (not already-loaded) (memq feature features))
          (let ((time (sanityinc/time-subtract-millis (current-time) require-start-time)))
            (add-to-list 'sanityinc/require-times
                         (list feature require-start-time time)
                         t))))))

  (advice-add 'require :around 'sanityinc/require-times-wrapper)


  (define-derived-mode sanityinc/require-times-mode tabulated-list-mode "Require-Times"
    "Show times taken to `require' packages."
    (setq tabulated-list-format
          [("Start time (ms)" 20 sanityinc/require-times-sort-by-start-time-pred)
           ("Feature" 30 t)
           ("Time (ms)" 12 sanityinc/require-times-sort-by-load-time-pred)])
    (setq tabulated-list-sort-key (cons "Start time (ms)" nil))
    ;; (setq tabulated-list-padding 2)
    (setq tabulated-list-entries #'sanityinc/require-times-tabulated-list-entries)
    (tabulated-list-init-header)
    (when (fboundp 'tablist-minor-mode)
      (tablist-minor-mode)))

  (defun sanityinc/require-times-sort-by-start-time-pred (entry1 entry2)
    (< (string-to-number (elt (nth 1 entry1) 0))
       (string-to-number (elt (nth 1 entry2) 0))))

  (defun sanityinc/require-times-sort-by-load-time-pred (entry1 entry2)
    (> (string-to-number (elt (nth 1 entry1) 2))
       (string-to-number (elt (nth 1 entry2) 2))))

  (defun sanityinc/require-times-tabulated-list-entries ()
    (cl-loop for (feature start-time millis) in sanityinc/require-times
             with order = 0
             do (cl-incf order)
             collect (list order
                           (vector
                            (format "%.3f" (sanityinc/time-subtract-millis start-time before-init-time))
                            (symbol-name feature)
                            (format "%.3f" millis)))))

  (defun sanityinc/require-times ()
    "Show a tabular view of how long various libraries took to load."
    (interactive)
    (with-current-buffer (get-buffer-create "*Require Times*")
      (sanityinc/require-times-mode)
      (tabulated-list-revert)
      (display-buffer (current-buffer))))




  (defun sanityinc/show-init-time ()
    (message "init completed in %.2fms"
             (sanityinc/time-subtract-millis after-init-time before-init-time)))

  (add-hook 'after-init-hook 'sanityinc/show-init-time)

;;; init-benchmarking.el ends here



  ;; save a list of open files in ~/.emacs.d/.emacs.desktop
  (setq desktop-path (list user-emacs-directory)
        desktop-auto-save-timeout 600)
  (desktop-save-mode 1)

  (defun sanityinc/desktop-time-restore (orig &rest args)
    (let ((start-time (current-time)))
      (prog1
          (apply orig args)
        (message "Desktop restored in %.2fms"
                 (sanityinc/time-subtract-millis (current-time)
                                                 start-time)))))
  (advice-add 'desktop-read :around 'sanityinc/desktop-time-restore)

  (defun sanityinc/desktop-time-buffer-create (orig ver filename &rest args)
    (let ((start-time (current-time)))
      (prog1
          (apply orig ver filename args)
        (message "Desktop: %.2fms to restore %s"
                 (sanityinc/time-subtract-millis (current-time)
                                                 start-time)
                 (when filename
                   (abbreviate-file-name filename))))))
  (advice-add 'desktop-create-buffer :around 'sanityinc/desktop-time-buffer-create)

  
  ;; Restore histories and registers after saving

  (setq-default history-length 1000)
  (add-hook 'after-init-hook 'savehist-mode)

  ;; (require-package 'session)

  (setq session-save-file (locate-user-emacs-file ".session"))
  (setq session-name-disable-regexp "\\(?:\\`'/tmp\\|\\.git/[A-Z_]+\\'\\)")
  (setq session-save-file-coding-system 'utf-8)

  (add-hook 'after-init-hook 'session-initialize)

  ;; save a bunch of variables to the desktop file
  ;; for lists specify the len of the maximal saved data also
  (setq desktop-globals-to-save
        '((comint-input-ring        . 50)
          (compile-history          . 30)
          desktop-missing-file-warning
          (dired-regexp-history     . 20)
          (extended-command-history . 30)
          (face-name-history        . 20)
          (file-name-history        . 100)
          (grep-find-history        . 30)
          (grep-history             . 30)
          (ivy-history              . 100)
          (magit-revision-history   . 50)
          (minibuffer-history       . 50)
          (org-clock-history        . 50)
          (org-refile-history       . 50)
          (org-tags-history         . 50)
          (query-replace-history    . 60)
          (read-expression-history  . 60)
          (regexp-history           . 60)
          (regexp-search-ring       . 20)
          register-alist
          (search-ring              . 20)
          (shell-command-history    . 50)
          tags-file-name
          tags-table-list))
  )
;;; init-sessions.el ends here

(provide 'README)