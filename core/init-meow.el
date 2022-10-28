(use-package meow
  :ensure t
  :config
  (defun meow-setup ()
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    (meow-motion-overwrite-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("h" . meow-left)
     '("l" . meow-right)
     '("." . meow-inner-of-thing)
     '("," . meow-bounds-of-thing)
     '("<escape>" . ignore))
    (meow-leader-define-key
     ;; SPC j/k will run the original command in MOTION state.
     '("j" . "H-j")
     '("k" . "H-k")
     '("bb" . consult-buffer)
     '("bi" . ibuffer)
     '("bk" . kill-this-buffer)
     ;; '("c SPC" . align-regexp)
     '("fr" . consult-recent-file)
     '("fy" . gts-do-translate)
     '("qR" . restart-emacs)
     '("qq" . save-buffers-kill-terminal)
     '("wk" . windmove-up)
     '("wj" . windmove-down)
     '("wh" . windmove-left)
     '("wl" . windmove-right)
     '("wd" . delete-window)
     '("ws" . split-window-below)
     '("wv" . split-window-right)
     '("ww" . ace-window)
     '("sp" . consult-ripgrep)
     '("si" . consult-imenu)
     '("oa" . org-agenda)
     '("op" . dired)
     '("pf" . projectile-find-file)
     '("pd" . projectile-find-dir)
     '("ps" . projectile-ripgrep)
     '("pa" . projectile-add-known-project)
     '("pb" . projectile-switch-to-buffer)
     '("pS" . projectile-switch-project)
     '("nn" . org-capture)
     '("nrf" . org-roam-node-find)
     '("nrs" . org-roam-db-sync)
     ;; Use SPC (0-9) for digit arguments.
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument)
     '("/" . meow-keypad-describe-key)
     '("?" . meow-cheatsheet))
    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("-" . negative-argument)
     '(";" . meow-reverse)
     '("." . meow-inner-of-thing)
     '("," . meow-bounds-of-thing)
     '("[" . meow-beginning-of-thing)
     '("]" . meow-end-of-thing)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . meow-change)
     '("d" . meow-delete)
     '("D" . meow-backward-delete)
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     '("f" . meow-find)
     '("F" . avy-goto-char)
     '("g" . meow-cancel-selection)
     ;; '("gb" . end-of-buffer)
     ;; '("gg" . beginning-of-buffer)
     ;; '("gd" . xref-find-definitions)
     ;; '("gD" . xref-pop-marker-stack)
     '("G" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("m" . meow-join)
     '("n" . meow-search)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     '("q" . meow-quit)
     '("Q" . meow-goto-line)
     '("r" . meow-replace)
     '("R" . meow-swap-grab)
     '("s" . meow-clipboard-kill)
     '("t" . meow-till)
     '("u" . undo-tree-undo)
     '("U" . meow-undo-in-selection)
     ;;'("v" . meow-visit)
     '("v" . +meow-visual)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("x" . meow-line)
     '("X" . avy-goto-line)
     '("y" . meow-save)
     '("Y" . meow-sync-grab)
     '("z" . meow-pop-selection)
     '("'" . repeat)
     '("$" . move-end-of-line)
     '("/" . consult-line)
     '("C-s" . consult-line)
     '("=" . meow-indent)
     '(">" . indent-rigidly-right)
     '("<" . indent-rigidly-left)
     '("C-r" . undo-tree-redo)
     '("\"" . consult-yank-pop)
     '("<f12>" . dumb-jump-go)
     ;; '("<escape>" . ignore)
     '("<escape>" . meow-cancel-selection)
     ))
  (meow-setup)
  (meow-global-mode 1)
  (setq meow-expand-hint-remove-delay 3
        meow-use-clipboard t)


  (defun +meow-insert-chord-two (s otherfunction keydelay)
    "类似 key-chord 功能"
    (when (meow-insert-mode-p)
      (let ((modified (buffer-modified-p))
            (undo-list buffer-undo-list))
        (insert (elt s 0))
        (let* ((second-char (elt s 1))
               (event
                (if defining-kbd-macro
                    (read-event nil nil)
                  (read-event nil nil keydelay))))
          (when event
            (if (and (characterp event) (= event second-char))
                (progn
                  (backward-delete-char 1)
                  (set-buffer-modified-p modified)
                  (setq buffer-undo-list undo-list)
                  (apply otherfunction nil))
              (push event unread-command-events)))))))

  (defun +meow-chord-pyim ()
    (interactive)
    (+meow-insert-chord-two ";;" #'toggle-input-method 0.5))
  (define-key meow-insert-state-keymap (substring ";;" 0 1)
    #'+meow-chord-pyim)
  (defun +meow-chord-insert-exit ()
    (interactive)
    (+meow-insert-chord-two "jk" #'+meow-insert-exit 0.5))
  (define-key meow-insert-state-keymap (substring "jk" 0 1)
    #'+meow-chord-insert-exit)
  (defun +meow-insert-exit ()
    (interactive)
    (meow-insert-exit)
    (corfu-quit))

  
  )
(defun +meow-visual ()
  (interactive)
  (meow-left-expand)
  (meow-right-expand))

(provide 'init-meow)
