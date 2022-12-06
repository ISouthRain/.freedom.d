;; doom-modeline
(doom-modeline-mode 1)

(use-package awesome-tab
  :ensure nil
  :load-path "~/.freedom.d/core/plugins"
  :config
  (awesome-tab-mode t))

;; emojify
(global-emojify-mode t)
;; cnfonts
(when freedom/is-windows
  (setq cnfonts-directory (expand-file-name ".local/cnfonts/windows" freedom-emacs-directory)))
(when freedom/is-linux
  (setq cnfonts-directory (expand-file-name ".local/cnfonts/linux" freedom-emacs-directory)))
(when freedom/is-darwin
  (setq cnfonts-directory (expand-file-name ".local/cnfonts/darwin" freedom-emacs-directory)))
(setq cnfonts-profiles
      '("program" "org-mode" "read-book"))
(when (not freedom/is-termux)
  (cnfonts-mode)
  (cnfonts-set-font)
  )
(setq cnfonts-personal-fontnames '(("Iosevka" "Consolas" "Bookerly" "Constantia" "PragmataPro Mono Liga" "Go Mono" "Fira Code" "Ubuntu Mono" "SF Mono");; 英文
                                   ("霞鹜文楷" "霞鹜文楷等宽" "微软雅黑" "Sarasa Mono SC Nerd" "Bookerly" "M 盈黑 PRC W5" "方正聚珍新仿简繁" "苹方 常规" "苹方 中等" "M 盈黑 PRC W4" "PragmataPro Mono Liga");; 中文
                                   ("Simsun-ExtB" "Bookerly" "方正聚珍新仿简繁" "PragmataPro Mono Liga");; EXT-B
                                   ("Segoe UI Symbol" "Bookerly" "PragmataPro Mono Liga")));; 字符
(provide 'init-ui)
