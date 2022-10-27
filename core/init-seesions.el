(use-package session
  :ensure t
  :hook (after-init . recentf-mode)
  :init
  (setq recentf-max-menu-items 20)
  (setq recentf-max-saved-items 20)
  :config
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
(provide 'init-sessions)
;;; init-sessions.el ends here
