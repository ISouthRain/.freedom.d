;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; avy 单词跳跃
(setq ace-pinyin-use-avy t)
(ace-pinyin-global-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ace-window 窗口跳跃
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?r ?i ?t ?o ?u ?t ?v ?n))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; zoom 自动调整窗口大小
(custom-set-variables
'(zoom-mode t))
(custom-set-variables
'(zoom-size '(0.618 . 0.618)))
(defun size-callback ()
(cond ((> (frame-pixel-width) 1280) '(90 . 0.75))
        (t                            '(0.5 . 0.5))))
(custom-set-variables
'(zoom-size 'size-callback))

(provide 'init-navigation)