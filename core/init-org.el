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
                            )))
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
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;
  ;;Windows系统日历乱码
  (setq system-time-locale "C")
  (format-time-string "%Y-%m-%d %a")
  ;;自动换行
  (add-hook 'org-mode-hook 'toggle-truncate-lines)
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; org 通知设置
  (require 'appt)
  ;; 每小时同步一次appt,并且现在就开始同步
  (run-at-time nil 3600 'org-agenda-to-appt)
  ;; 更新agenda时，同步appt
  (add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;
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
            ("a" "日程安排" plain (file+function (format "%s" freedom-org-capture-Agenda) find-month-tree)
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

(provide 'init-org)
