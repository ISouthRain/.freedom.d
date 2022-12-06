(require 'subr-x)
(setq freedom/is-termux
    (string-suffix-p "Android" (string-trim (shell-command-to-string "uname -a"))))
(setq freedom/is-linux (and (eq system-type 'gnu/linux)))
(setq freedom/is-darwin (and (eq system-type 'darwin)))
(setq freedom/is-windows (and (eq system-type 'windows-nt)))
(setq freedom/is-gui (if (display-graphic-p) t))
(setq freedom/is-tui (not (display-graphic-p)))

(provide 'init-system)