(eval-and-compile
  (customize-set-variable
   'package-archives '(
                       ("elpa-local" . "~/.freedom.d/.local/elpa-local/")
                       ;;("melpa" . "https://melpa.org/packages/")
                       ;;("melpa-stable" . "https://stable.melpa.org/packages/")
                       ;; ("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                       ;; ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                       ;; ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
		       ))
  (package-initialize)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; elpa-local
(require 'elpa-mirror)
(setq elpamr-default-output-directory (format "%s.local/elpa-local" freedom-emacs-directory))


(provide 'init-package)
