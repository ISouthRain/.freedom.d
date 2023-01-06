(defvar my-packages '(
                      elpa-mirror
                      doom-themes
                      posframe
                      meow
                      emojify
                      cnfonts
                      doom-modeline
                      all-the-icons
                      use-package
                      helpful
                      vertico
                      orderless
                      consult
                      marginalia
                      ox-hugo
                      org-superstar
                      org-roam
                      org-roam-ui
                      org-download
                      org-cliplink
                      projectile
                      ripgrep
                      projectile-ripgrep
                      yasnippet
                      ace-link
                      volatile-highlights
                      magit
                      diff-hl
                      undo-tree
                      all-the-icons-dired
                      aggressive-indent
                      rainbow-delimiters
                      highlight-indent-guides
                      evil-nerd-commenter
                      avy
                      ace-pinyin
                      ace-window
                      zoom
                      elfeed
                      elfeed-org
                      corfu
                      kind-icon
                      corfu-terminal
                      google-translate
                      calfw
                      calfw-org
                      calfw-ical
                      calfw-cal
                      cal-china-x
                      markdown-mode
                      markdown-toc
                      pyim-basedict
                      pyim
                      lsp-mode
                      dumb-jump
                      nix-mode
                      vimrc-mode
))

(eval-and-compile
  (customize-set-variable
   'package-archives '(
                       ("elpa-local" . "~/.freedom.d/.local/elpa-local/")
                       ("melpa" . "http://melpa.org/packages/")
                       ("org" . "http://orgmode.org/elpa/")
                       ("gnu" . "https://elpa.gnu.org/packages/")
                       ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                       ))
  (package-initialize)
  )

(setq freedom-emacs-directory "~/.freedom.d/"
      custom-file "~/.emacs.d/custom.el")
(setq elpamr-default-output-directory (format "%s.local/elpa-local" freedom-emacs-directory))

(dolist (p my-packages)
  (unless (package-installed-p p)
    (customize-set-variable
     'package-archives '(("elpa-local" . "~/.freedom.d/.local/elpa-local/")))
    (package-refresh-contents)
    (package-install p))
  (add-to-list 'package-selected-packages p))

(provide 'init-package)