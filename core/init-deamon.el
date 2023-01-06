(use-package server
  :ensure nil
  :config
  (unless (server-running-p)
    (server-start))
  ;; 防止 windows 使用 server 打开中文文件名乱名导致无法打开文件
  (when (eq system-type 'windows-nt)
    (setq locale-coding-system 'gb18030)  ;此句保证中文字体设置有效
    (setq w32-unicode-filenames 'nil)       ; 确保file-name-coding-system变量的设置不会无效
    (setq file-name-coding-system 'gb18030) ; 设置文件名的编码为gb18030
    )
  )

(provide 'init-deamon)
