(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h C-f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h C-d" . helpful-at-point)
         ("C-h F" . helpful-function)
         ("C-h C" . helpful-command)
         )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vertico minibuffer 补全
(use-package vertico
  :bind (:map vertico-map
         ("DEL" . vertico-directory-delete-char)
         )
  :init
  (vertico-mode)
  (setq vertico-count 15))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; savehist
(savehist-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Optionally use the `orderless' completion style.
;; (use-package orderless
;;   :config
;;   (setq completion-styles '(orderless basic)
;;         completion-category-defaults nil
;;         completion-category-overrides '((file (styles partial-completion))))
;;   ;; 据说这样设置可以让 eglot corfu orderless
;;   ;; (setq completion-styles '(orderless flex)
;;   ;;       completion-category-overrides '((eglot (styles . (orderless flex)))))

;;   ;; 对 vertico 进行拼音补全, 全拼的第一个字母
;;   (defun completion--regex-pinyin (str)
;;     (orderless-regexp (pinyinlib-build-regexp-string str)))
;;   (add-to-list 'orderless-matching-styles 'completion--regex-pinyin)
;;   )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; marginalia
(marginalia-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emacs
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
(setq enable-recursive-minibuffers t)

(provide 'init-search)
