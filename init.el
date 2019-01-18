;; -*- coding: utf-8-dos -*- 

;;
;; Custom code
;;
(add-to-list 'load-path "~/.emacs.d/lisp")


;;
;; https://stable.melpa.org/#/getting-started
;;
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https"))
       (stable nil))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa"
                                       (concat proto "://"
                                               (if stable "stable." "")
                                               "melpa.org/packages/"))
               t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/")
;; ;             '("melpa" . "http://melpa.org/packages/")
;;              )

;(when (< emacs-major-version 24)
;  ;; For important compatibility libraries like cl-lib
;  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
;;  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
                                        ;  )

(add-to-list 'load-path "~/.emacs.d/lisp/monroe")

(set-default-font "Consolas 12")
; (set-default-font "Inconsolata 14")

(package-initialize)

(defun lag-prev-window ()
  (interactive)
  (other-window -1))

;;
;; Kill line ending.
;;
(defun my-kill-line ()
  (interactive)
  (kill-line t))

;;
;; http://emacs.stackexchange.com/a/360/11422
;; Bind keys but prevent major and minor modes to override settings
;;
(bind-keys*
 ("C-;" . delete-horizontal-space)
 ("C-." . join-line)
; ("C-o" . other-window)
 ("C-S-o" . other-window)
 ("C-c 3" . comment-region)
 ("C-c 4" . uncomment-region)
 ("C-S-k" . my-kill-line)
 ("C-x t" . delete-trailing-whitespace)
 ("C-c C-l" . browse-url-at-point)
 ("C-c C-d" . insert-date))

;;
;; https://masteringemacs.org/article/introduction-to-ido-mode
;;
(setq ido-use-filename-at-point 'guess)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1)) ;; Remove bars.
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;
;; https://stackoverflow.com/a/1819405/15649
;;
(setq indent-tabs-mode t)
(setq tab-width 4)
(setq indent-line-function ')
;; Python Hook
(add-hook 'javascript-mode-hook
          (function (lambda ()
                      (setq indent-tabs-mode nil
                            tab-width 2))))

;;
;; 2019-01-18
;; The Ultimate Guide To Indentation in Emacs (Tabs and Spaces)
;; https://dougie.io/emacs/indentation/
;;



;;
;; Magit. http://magit.vc/manual/magit/Getting-started.html#Getting-started
;;
(global-set-key (kbd "C-x g") 'magit-status)

;;
;; IDO
;; http://emacsist.com/10480
;;
; (require 'ido)
; (ido-mode)
; (ido-everywhere)
; (setq ido-use-filename-at-point 'guess)
; (require 'ido-ubiquitous)
; (ido-ubiquitous-mode)

;;
;; UTF-8
;;
(prefer-coding-system 'utf-8-unix)

;;
;; ibuffer
;;
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;
;; scratch buffer
;;
(require 'scratch)
(global-set-key [f5] 'new-scratch-buffer)

;;
;; http://emacs-fu.blogspot.com/2010/04/navigating-kill-ring.html
;;
(when (require 'browse-kill-ring nil 'noerror)
  (browse-kill-ring-default-keybindings))

;;
;; Maximize-frame
;;
(defun w32-maximize-frame ()
  "Maximize the current frame"
  (interactive)
  (w32-send-sys-command 61488))
(global-set-key [f12] 'w32-maximize-frame)
(defun w32-restore-frame ()
  "Restore a minimized frame"
  (interactive)
  (w32-send-sys-command 61728))
(global-set-key [f11] 'w32-restore-frame)


;;
;; Replace current buffer text with the text of the visited file on disk.
;; This undoes all changes since the file was visited or saved.
;; With a prefix argument, offer to revert from latest auto-save file, if
;; that is more recent than the visited file.
;;
(global-set-key [f10] 'revert-buffer)

;;
;; A workaround function `kill-buffer', which asks which buffer to kill. My
;; function kills the current buffer, period.
;;
(defun lag-kill-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key [f9] 'lag-kill-buffer)


;;
;; As suggested in http://irreal.org/blog/?p=753
;;
(autoload 'dired-jump "dired-x"
  "Jump to Dired buffer corresponding to current buffer." t)
(autoload 'dired-jump-other-window "dired-x"
  "Like \\[dired-jump] (dired-jump) but in other window." t)
(define-key global-map "\C-x\C-j" 'dired-jump)
(define-key global-map "\C-x4\C-j" 'dired-jump-other-window)


;;
;; Monkey-patch nrepl.el to show stdout messages on *nrepl* buffer
;;
;(require 'nrepl)
;(defun nrepl-interactive-eval-handler (buffer)
;  (nrepl-make-response-handler buffer
;                               ;; (lambda (buffer value)
;                               ;;   (message (format "%s" value)))
;                               (lambda (buffer value)
;                                 (nrepl-emit-interactive-output value))
;                               (lambda (buffer value)
;                                 (nrepl-emit-interactive-output value))
;                               (lambda (buffer err)
;                                 (message (format "%s" err)))
;                               '()))

;;
;; http://emacs-fu.blogspot.com/2011/09/quick-note-taking-with-deft-and-org.html
;;
;; (require 'deft)
;; (when (require 'deft nil 'noerror) 
;;    (setq
;;       deft-extension "org"
;;       deft-directory "~/Documents/deft/"
;;       deft-text-mode 'org-mode)
;;    (global-set-key (kbd "<f8>") 'deft))

;;
;; http://stackoverflow.com/questions/885793/emacs-error-when-calling-server-start/1566618#1566618
;;
(require 'server)
(when (equal window-system 'w32)
  (defun server-ensure-safe-dir (dir) "Noop" t)) ; Suppress error "directory
                                                 ; ~/.emacs.d/server is unsafe"
                                                 ; on windows.
(server-start)

;;
;; Change ENV var PATH to be the same as contents of exec-path.
;; I use it to make sure java.exe is on the PATH, to run cider.
;;
(setenv "PATH" (mapconcat 'identity exec-path ";"))

;;
;; Enable paredit automatically for a few modes.
;; https://www.emacswiki.org/emacs/ParEdit
;;
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'clojure-mode-hook          #'enable-paredit-mode)


;;
;; Some org keywords
;; https://www.reddit.com/r/emacs/comments/4ipmxe/toodledo_and_org_still_relevant/
;;
(setq org-todo-keywords '((sequence
			   "TODO"
			   "|"
			   "DONE"
			   "|"
			   "Active(a)"
			   "Next Action(n)"
			   "Canceled(c)"
			   "Hold(h)"
			   "Reference(r)"
			   "Delegated(d)"
			   "Waiting(w)"
			   "Postponed(P)"
			   "Someday(s)"
			   "Planning(p)")))

;;
;; Insert current date
;; http://ergoemacs.org/emacs/elisp_datetime.html
;;
(defun insert-date ()
  "Insert current date yyyy-mm-dd."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))
(global-set-key (kbd "C-c d") 'insert-date)

(defun insert-week-number ()
  "Inserts a header for current week number."
  (interactive)
  (insert (format-time-string "* Week %U")))
(global-set-key (kbd "C-c u") 'insert-week-number)

;;
;; Password generator
;;
;(load-file "~/.emacs.d/lisp/password-generator.el")


;;
;; Save backup files to ~/.emacs.d/backup
;; http://stackoverflow.com/a/151946/15649
;;
(setq backup-directory-alist `(("." . "~/.emacs.d/backup")))

;;
;; https://www.emacswiki.org/emacs/WoMan
;;
(setq woman-manpath '("c:/cygwin64/usr/share/man/"))

;;
;; https://www.emacswiki.org/emacs/AlarmBell
;; Turn off annoying alarm bell
;;
(setq ring-bell-function 'ignore)

;;
;; https://www.gnu.org/software/emacs/manual/html_node/efaq/Displaying-the-current-file-name-in-the-titlebar.html#Displaying-the-current-file-name-in-the-titlebar
;; Display path of current file in title bar.
;;
(setq frame-title-format "%f")

(setq lag-variable-width-font-name "Consolas")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-delimiter-face ((t (:foreground "slate gray"))))
 '(font-lock-comment-face ((t (:foreground "slate gray")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(cider-cljs-lein-repl
   "(do (require 'weasel.repl.websocket) (cemerick.piggieback/cljs-repl (weasel.repl.websocket/repl-env :ip \"127.0.0.1\" :port 58864)))")
 '(custom-enabled-themes (quote (lavender)))
 '(custom-safe-themes
   (quote
	("9398969cf7214748a41a02e35c660b5325cfa0832ea2a04bd1eb2b600665dd74" "47ac4658d9e085ace37e7d967ea1c7d5f3dfeb2f720e5dec420034118ba84e17" default)))
 '(exec-path
   (quote
	("C:/Java/jdk1.8.0_102/bin" "C:/local/Git/bin" "C:/local/Git/usr/bin" "c:/Windows/system32" "C:/Windows" "C:/Windows/System32/Wbem" "C:/Windows/System32/WindowsPowerShell/v1.0/" "C:/Windows/CCM" "c:/work/emacs-25.1/libexec/emacs/25.1/x86_64-w64-mingw32" "C:/path")))
 '(ffap-machine-p-known (quote reject))
 '(js-indent-level 2)
 '(neo-window-width 50)
 '(package-archives (quote (("melpa" . "http://stable.melpa.org/packages/"))))
 '(package-selected-packages
   (quote
	(flymake-haskell-multi haskell-mode ensime groovy-mode bind-key scala-mode monroe treemacs cider markdown-preview-mode writeroom-mode fsharp-mode markdown-mode markdown-mode+ lua-mode js2-mode use-package neotree projectile clojure-mode paredit lavender-theme deft ido-ubiquitous magit)))
 '(standard-indent 2)
 '(tab-width 4))
