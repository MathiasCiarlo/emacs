;; Emacs config file, name must be .emacs and must lie in your home folder
;; Much honour goes to Lars Tveito (Emacs Guru), he has tought me all I know.

(require 'cl)
(require 'package)
(require 'iso-transl) ; Fixes dead keys

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))

(package-initialize)

;; install some packages if missing
(let* ((packages '(auto-complete
                   ido-vertical-mode
                   monokai-theme
                   multiple-cursors
                   undo-tree
                   ;; if you want more packages, add them here
                   ))
       (packages (remove-if 'package-installed-p packages)))
  (when packages
    (package-refresh-contents)
    (mapc 'package-install packages)))


(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(when (file-exists-p "~/.emacs.d/site-lisp/devilry-mode.el")
  (load-library "devilry-mode"))

;; Show files beneth
(ido-vertical-mode 1)

;; use undo-tree-mode globally
(global-undo-tree-mode 1)

;; get the default config for auto-complete (downloaded with
;; package-manager)
(require 'auto-complete-config)

;; load the default config of auto-complete
(ac-config-default)

;; Your theme
(custom-set-variables
 '(custom-enabled-themes (quote (tango-dark))))

;; Change comment color to violet
(set-face-foreground 'font-lock-comment-face "violet")


(setq
 auto-save-default                      t ; nil to disable auto-save
 c-default-style                    "linux" ; Nice c indention.
 c-basic-offset                           4 ; Indentation
 default-directory                     "~/" ; Default home directory
 inhibit-startup-message                  t ; Removes start-up screen
 initial-scratch-message                 "" ; Removes default scratch text
 ring-bell-function                 'ignore ; Stop annoying system ringing noice
 )


;; To avoid file system clutter we put all auto saved files in a single
;; directory.
(defvar emacs-autosave-directory
  (concat user-emacs-directory "autosaves/")
  "This variable dictates where to put auto saves. It is set to a
directory called autosaves located wherever your .emacs.d/ is
located.")

(setq backup-directory-alist
      `((".*" . ,emacs-autosave-directory))
      auto-save-file-name-transforms
      `((".*" ,emacs-autosave-directory t)))


;; Basic looks
(blink-cursor-mode 0)  ; Self explainatory
(column-number-mode 1) ; Shows column number at the bottom
(global-linum-mode 0)  ; Shows line number on the left hand side
(show-paren-mode 1)    ; Marks matching paranthesis


;; Setting default text size
;;(set-face-attribute 'default nil :height 120) ; Useful on high dpi screens on windows


;; Less toolbars, more text. We have shortcuts
(menu-bar-mode 0)      ; Hide menu
(tool-bar-mode 0)      ; HIde toolbar
(scroll-bar-mode 0)    ; Hide scrollbar


;; Adds closing parents automatically
(electric-pair-mode 1)
(add-to-list 'electric-pair-pairs '(?\{ . ?\}))

;; Answer yes or no with y or n
(fset 'yes-or-no-p 'y-or-n-p)

;; Overwrite marked text
(delete-selection-mode 1)

;; enable ido-mode, changes the way files are selected in the minibuffer
(ido-mode 1)
;; use ido everywhere
(ido-everywhere 1)
;; show vertically
(ido-vertical-mode 1)

;; use undo-tree-mode globally
(global-undo-tree-mode 1)


;; Open config-file
(defun init()
  (interactive)
  (find-file "~/.emacs"))


;; Adding shortcuts to java-mode, writing the shortcut folowed by a
;; non-word character will cause an expansion.
(defun java-shortcuts ()
  (define-abbrev-table 'java-mode-abbrev-table
    '(("psvm" "public static void main(String[] args) {" nil 0)
      ("sopl" "System.out.println" nil 0)))
  (abbrev-mode t))


;; the shortcuts are only useful in java-mode so we'll load them to
;; java-mode-hook.
(add-hook 'java-mode-hook 'java-shortcuts)


;; Change focus between windows in emacs with Alt-left and Alt-right
(defun select-next-window ()
  "Switch to the next window"
  (interactive)
  (select-window (next-window)))

(defun select-previous-window ()
  "Switch to the previous window"
  (interactive)
  (select-window (previous-window)))


;; To tidy up a buffer we define this function borrowed from simenheg
(defun tidy ()
  "Ident, untabify and unwhitespacify current buffer, or region if active."
  (interactive)
  (let ((beg (if (region-active-p) (region-beginning) (point-min)))
        (end (if (region-active-p) (region-end) (point-max))))
    (indent-region beg end)
    (whitespace-cleanup)
    (untabify beg (if (< end (point-max)) end (point-max)))))


;; Opens a shell in the next window
(defun open-shell ()
  (interactive)
  (select-window (next-window))
  (shell)
  (select-window (previous-window)))


;; Kill process and buffer
(defun kill-shell ()
  (interactive)
  (delete-process "*shell*")
  (kill-buffer "*shell*"))


;; Tidy all buffers that are not read-only
(defun tidy-all-buffers()
  (interactive)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (switch-to-buffer buffer)
      (when (eq buffer-read-only nil)
        (tidy)))))

;; Full screen
(defun toggle-fullscreen ()
  "Toggle full screen on X11"
  (interactive)
  (when (eq window-system 'x)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))


(global-set-key (kbd "<C-tab>") 'tidy)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "M-<right>") 'select-next-window)
(global-set-key (kbd "M-2") 'select-next-window)
(global-set-key (kbd "M-<left>")  'select-previous-window)
(global-set-key (kbd "M-1")  'select-previous-window)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key [f11] 'toggle-fullscreen)

(global-set-key (kbd "C-c e")  'mc/edit-lines)
(global-set-key (kbd "C-c a")  'mc/mark-all-like-this)
(global-set-key (kbd "C-c n")  'mc/mark-next-like-this)
