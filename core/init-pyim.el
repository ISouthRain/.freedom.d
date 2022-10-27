;; core/init-pyim.el -*- lexical-binding: t; -*-

(use-package pyim
  :init
  (setq pyim-dcache-directory (format "%s.local/pyim" doom-user-dir))
  :defer 2
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

(provide 'init-pyim)
