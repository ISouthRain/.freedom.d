;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; markdown-toc 生成目录
(use-package markdown-toc
  :ensure t
  :hook (markdown-mode . markdown-toc-mode)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; markdown-mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
  :config
  (defun freedom-hugo-home ()
    (interactive) ; 如果不需要定义成命令，这句可以不要。
    (when freedom/is-termux
      (find-file "~/Ubuntu/ubuntu-fs/root/Hugo/content/posts/Home.md"))
    (when freedom/is-linux
      (when (not freedom/is-termux)
        (find-file "~/f/Hugo/content/posts/Home.md")))
    (when (string= "darwin" system-type)
      (find-file "~/Desktop/Hugo/content/posts/Home.md"))
    (when (string= "windows-nt" system-type)
      (find-file "F:\\Hugo\\content\\posts\\Home.md"))
    )
  ) ;; use-package end




(provide 'init-markdown)
