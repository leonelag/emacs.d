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

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1)) ;; Remove bars.
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;
;; Magit. http://magit.vc/manual/magit/Getting-started.html#Getting-started
;;
(global-set-key (kbd "C-x g") 'magit-status)

;;
;; IDO
;; http://emacsist.com/10480
;;
(require 'ido)
(ido-mode)
(ido-everywhere)
(setq ido-use-filename-at-point 'guess)
(require 'ido-ubiquitous)
(ido-ubiquitous-mode)

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
(require 'nrepl)
(defun nrepl-interactive-eval-handler (buffer)
  (nrepl-make-response-handler buffer
                               ;; (lambda (buffer value)
                               ;;   (message (format "%s" value)))
                               (lambda (buffer value)
                                 (nrepl-emit-interactive-output value))
                               (lambda (buffer value)
                                 (nrepl-emit-interactive-output value))
                               (lambda (buffer err)
                                 (message (format "%s" err)))
                               '()))


;;
;; http://stackoverflow.com/questions/885793/emacs-error-when-calling-server-start/1566618#1566618
;;
(require 'server)
(when (equal window-system 'w32)
  (defun server-ensure-safe-dir (dir) "Noop" t)) ; Suppress error "directory
                                                 ; ~/.emacs.d/server is unsafe"
                                                 ; on windows.
(server-start)

