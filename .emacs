;; Emacs config file, name must be .emacs and must lie in your home folder
;; All honour goes to Lars Tveito (Emacs Guru), he has tought me all I know.

;; To update your file, type:   Alt+x eval-buffer

;; Your theme
(custom-set-variables
 '(custom-enabled-themes (quote (tango-dark)))
)

;; Basic looks
(global-linum-mode 1)  ;; Shows line number on the left hand side
(column-number-mode 1) ;; Shows column number at the bottom
(show-paren-mode 1)    ;; Marks matching paranthesis
(blink-cursor-mode 0)  ;; Self explainatory

;; Change comment color to violet
(set-face-foreground 'font-lock-comment-face "violet")

;; Less toolbars, more text. We have shortcuts
(menu-bar-mode 0)      ;; Hide menu
(tool-bar-mode 0)      ;; HIde toolbar
(scroll-bar-mode 0)    ;; Hide scrollbar

;; Removes start-up screen
(setq inhibit-startup-message t)

;; Adds closing parents automatically
;;(electric-pair-mode 1)
;;(add-to-list 'electric-pair-pairs '(?\{ . ?\}))


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

(global-set-key (kbd "M-<right>") 'select-next-window)
(global-set-key (kbd "M-<left>")  'select-previous-window)


;; nice c indention.
(setq c-default-style "linux"
      c-basic-offset 4)


;; To tidy up a buffer we define this function borrowed from [[https://github.com/simenheg][simenheg]].
(defun tidy ()
"Ident, untabify and unwhitespacify current buffer, or region if active."
(interactive)
(let ((beg (if (region-active-p) (region-beginning) (point-min)))
(end (if (region-active-p) (region-end) (point-max))))
(indent-region beg end)
(whitespace-cleanup)
(untabify beg (if (< end (point-max)) end (point-max)))))
(global-set-key (kbd "<C-tab>") 'tidy)


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


(global-set-key (kbd "C-x k") 'kill-this-buffer)

;; Making RET indent at the same time
(global-set-key (kbd "RET") 'newline-and-indent)
