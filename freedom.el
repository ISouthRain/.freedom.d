(let (
      ;; 加载的时候临时增大`gc-cons-threshold'以加速启动速度。
      (gc-cons-threshold most-positive-fixnum)
      ;; 清空避免加载远程文件的时候分析文件。
      (file-name-handler-alist nil))
  (server-start)
  (setq freedom-emacs-directory "~/.freedom.d/")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; 包开始
  (add-to-list 'load-path (expand-file-name "core" freedom-emacs-directory))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (require 'init-system)
  (setq url-proxy-services '(
                             ("http" . "127.0.0.1:7890")
                             ("https" . "127.0.0.1:7890")))
  (when freedom/is-linux
    (when (not freedom/is-termux)
      (setq url-proxy-services '(
                                 ("http" . "192.168.1.8:7890")
                                 ("https" . "192.168.1.8:7890")))
      )
    )

  (require 'init-package)
  (require 'init-meow)
  (require 'init-ui)
  (require 'init-search)
  ;;(require 'init-dashboard)
  (require 'init-org)
  (require 'init-edit)
  (require 'init-navigation)
  (require 'init-reader)
  ;; corfu
  (require 'init-company)
  (require 'init-translate)
  (require 'init-calendar)
  (require 'init-sessions)
  (require 'init-markdown)
  (require 'init-pyim)
  (require 'init-vim)
  
  );; Cache Max End, Also the end of the package.

(provide 'freedom)
