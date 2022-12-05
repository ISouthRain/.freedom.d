(defvar my-packages '(
                        elpa-mirror
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
  (unless (package-installed-p 'use-package)
    (customize-set-variable
     'package-archives '(("elpa-local" . "~/.freedom.d/.local/elpa-local/")))
    (package-refresh-contents)
    (package-install 'use-package))
  )
;; 打开窗口后再使用
;; (add-hook 'window-setup-hook (lambda ()
(setq freedom-emacs-directory "~/.freedom.d/"
      custom-file "~/.emacs.d/custom.el")
(setq elpamr-default-output-directory (format "%s.local/elpa-local" freedom-emacs-directory))
;; ))
;; 延迟启动
;; (run-with-idle-timer 1.0 nil (lambda ()
;; ))

(dolist (p my-packages)
  (unless (package-installed-p p)
    (package-refresh-contents)
    (package-install p))
  (add-to-list 'package-selected-packages p))

(provide 'init-package)