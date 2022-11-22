(setq gc-cons-threshold (* 100 1024 1024))

(if (file-exists-p (expand-file-name "~/.freedom.d/config.el"))
    (load-file (expand-file-name "~/.freedom.d/config.el"))
  (org-babel-load-file (expand-file-name "~/.freedom.d/config.org")))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 10 1000 1000))