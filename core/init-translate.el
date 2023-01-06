;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; google-translate
(setq google-translate-default-source-language "auto"
    google-translate-default-target-language "zh-CN")
(setq google-translate-translation-directions-alist
    '(("en" . "zh-CN") ("zh-CN" . "en")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package corfu-english-helper
  :ensure nil
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
  :load-path "~/.freedom.d/core/plugins/"
  :config
  (setq insert-translated-name-translate-engine "youdao");; ;google  youdao
  (defun +freedom-english-translate ()
    (interactive))
  (advice-add #'freedom-english-translate :override #'insert-translated-name-insert)
  )

(provide 'init-translate)