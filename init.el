(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(set-default-font "-outline-Consolas-normal-normal-normal-mono-18-*-*-*-c-*-iso8859-1")

(package-initialize)

(global-set-key [C-\;] 'delete-horizontal-space)
(global-set-key [C-.] 'join-line)



;;
;; Magit. http://magit.vc/manual/magit/Getting-started.html#Getting-started
;;
(global-set-key (kbd "C-x g") 'magit-status)


(server-start)
