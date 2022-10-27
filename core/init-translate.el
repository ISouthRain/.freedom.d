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


(provide 'init-translate)
