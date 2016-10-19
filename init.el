(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

; (set-default-font "-outline-Consolas-normal-normal-normal-mono-18-*-*-*-c-*-iso8859-1")
(set-default-font "Consolas 11")

(package-initialize)

(global-set-key (kbd "C-;") 'delete-horizontal-space)
(global-set-key (kbd "C-.") 'join-line)

;;
;; https://masteringemacs.org/article/introduction-to-ido-mode
;;
(setq ido-use-filename-at-point 'guess)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(tool-bar-mode -1)
(menu-bar-mode -1)

;;
;; Magit. http://magit.vc/manual/magit/Getting-started.html#Getting-started
;;
(global-set-key (kbd "C-x g") 'magit-status)


(server-start)
