;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elfeed
(use-package elfeed
  :ensure t
  :commands (elfeed)
  :init
  (setq url-queue-timeout 30
        elfeed-search-filter "@6-months-ago")
  (setq elfeed-db-directory (concat +user-emacs-directory ".local/.elfeed/db/"))
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
  (setq rmh-elfeed-org-files (list (expand-file-name "elfeed.org" +user-emacs-directory)))
  )

(provide 'init-reader)
