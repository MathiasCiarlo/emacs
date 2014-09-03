;; Emacs konfigurasjonsfil. Heter ".emacs" og må ligge på hjemmeområdet.

(custom-set-variables
 '(custom-enabled-themes (quote (tango-dark)))
)

(global-linum-mode 1)  ;; Viser linjenr på venstre side
(show-paren-mode 1)    ;; Markerer paranteser
(column-number-mode 1) ;; Viser kolonnenr
(blink-cursor-mode 1)  ;; Deaktiverer blinkende markør? (irriterende)

;; Følgende kan aktiveres for en smoothere look (sett 0 til 1)
(menu-bar-mode 1)      ;; Skjuler menyen
(tool-bar-mode 1)      ;; Skjuler toolbar
(scroll-bar-mode 0)    ;; Skjuler scrollbar

;; Ender kommentarfargen til lilla
(set-face-foreground 'font-lock-comment-face "violet")

;; Removes start-up screen
(setq inhibit-startup-message t)

;; Adds closing parents automatically
;;(electric-pair-mode 1)
;;(add-to-list 'electric-pair-pairs '(?\{ . ?\}))


;; JAVATING''''''''''''''''''''''''''''''''''''''''''''''''''''''''

;; adding shortcuts to java-mode, writing the shortcut folowed by a
;; non-word character will cause an expansion.
(defun java-shortcuts ()
  (define-abbrev-table 'java-mode-abbrev-table
    '(("psvm" "public static void main(String[] args) {" nil 0)
      ("sopl" "System.out.println" nil 0)))
  (abbrev-mode t))

;; the shortcuts are only useful in java-mode so we'll load them to
;; java-mode-hook.
(add-hook 'java-mode-hook 'java-shortcuts)

;; ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

;; Bytte mellom vinduer med Alt+pilvenstre og hoyre
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
