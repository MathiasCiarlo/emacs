;; Emacs config file, filename must be .emacs and must lie in your home folder
;; Much honour goes to Lars Tveito (Emacs Guru), he has taught me all I know.

(require 'cl)
(require 'package)
(package-initialize)

;;(require 'iso-transl) ; Fixes dead keys on Ubuntu, ish, run emacs with
;; env= XMODIFIERS= emacs

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("org" . "http://orgmode.org/elpa/")
        ("melpa" . "http://melpa.milkbox.net/packages/")))

;; install some packages if missing
(let* ((packages '(auto-complete
                   geiser
                   ido-vertical-mode
                   markdown-mode
                   monokai-theme
                   multiple-cursors
                   paredit
                   pretty-lambdada
                   undo-tree
                   slime
                   ))
       (packages (remove-if 'package-installed-p packages)))
  (when packages
    (package-refresh-contents)
    (mapc 'package-install packages)))

;; Devilry-mode
(when (file-exists-p "~/.emacs.d/plugins/devilry-mode")
  (add-to-list 'load-path "~/.emacs.d/plugins/devilry-mode/")
  (require 'devilry-mode))

;; Racket
(setq geiser-active-implementations '(racket))

;; Pretty lambda
(add-to-list 'pretty-lambda-auto-modes 'geiser-repl-mode)
(pretty-lambda-for-modes)

;; Paredit
(dolist (mode pretty-lambda-auto-modes)
  ;; add paredit-mode to all mode-hooks
  (add-hook (intern (concat (symbol-name mode) "-hook")) 'paredit-mode))

(dolist (mode '(slime-repl-mode
                geiser-repl-mode
                ielm-mode
                clojure-mode
                cider-repl-mode))
  (add-to-list 'pretty-lambda-auto-modes mode))
(pretty-lambda-for-modes)


(defun activate-slime-helper ()
  (when (file-exists-p "~/.quicklisp/slime-helper.elc")
    (load (expand-file-name "~/.quicklisp/slime-helper.elc"))
    (define-key slime-repl-mode-map (kbd "C-l")
      'slime-repl-clear-buffer))
  (remove-hook 'lisp-mode-hook #'activate-slime-helper))

(add-hook 'lisp-mode-hook #'activate-slime-helper)

(setq inferior-lisp-program "sbcl")

(setq lisp-loop-forms-indentation   6
      lisp-simple-loop-indentation  2
      lisp-loop-keyword-indentation 6)

;; E-type
(add-to-list 'load-path "~/.emacs.d/plugins/e-type/")
(when (file-exists-p "~/.emacs.d/plugins/e-type/etype.el")
  (load-library "etype"))

;; Show files beneth
(ido-vertical-mode 1)

;; use undo-tree-mode globally
(global-undo-tree-mode 1)

;; get the default config for auto-complete (downloaded with
;; package-manager)
(require 'auto-complete-config)

;; load the default config of auto-complete
;;(ac-config-default)

(unless (package-installed-p 'ac-geiser)
  (package-install 'ac-geiser))

(require 'ac-geiser)
(add-hook 'geiser-mode-hook 'ac-geiser-setup)
(add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'geiser-repl-mode))

;; Your theme
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark))))

(setq
 auto-save-default                        t ; nil to disable auto-save
 abbrev-mode                              t ; Global abbrev mode
 c-default-style                    "linux" ; Nice c indention.
 c-basic-offset                           4 ; Indentation
 js-indent-level                          2 ; js indentation
 default-directory                     "~/" ; Default home directory
 inhibit-startup-message                  t ; Removes start-up screen
 initial-scratch-message                 "" ; Removes default scratch text
 ring-bell-function                 'ignore ; Stop annoying system ringing noice
 word-wrap                                t ; Stop breaking lines splitting words
 )

;; Make sure comments indents appropriatly
(c-set-offset 'comment-intro 0)

(setq-default indent-tabs-mode nil) ; Use spaces instead of tabs


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
(global-linum-mode 1)  ; Shows line number on the left hand side
(show-paren-mode 1)    ; Marks matching paranthesis

;; Less toolbars, more text. We have shortcuts
(menu-bar-mode 0)      ; Hide menu
(tool-bar-mode 1)      ; Hide toolbar
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

;; Word-wrapping
(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'help-mode-hook 'visual-line-mode)

;; Open config-file
(defun init()
  (interactive)
  (find-file "~/.emacs"))

(define-abbrev-table 'devilry-mode-abbrev-table
  '(("kodestil" "[folk.uio.no/mathiact/kodestil](kodestil)" nil 0)))


;; Adding shortcuts to java-mode, writing the shortcut folowed by a
;; non-word character will cause an expansion.
(defun java-shortcuts ()
  (define-abbrev-table 'java-mode-abbrev-table
    '(("psvm" "public static void main (String[] args) {}" nil 0)
      ("sopl" "System.out.println()" nil 0)
      ("classHund"
       "class Hund {
    private String navn;

    Hund(String navn) {
        this.navn = navn;
    }

    public String toString() {
        return \"Hund med navn \" + navn;
    }
}" nil 0)
      ("classKatt"
       "class Katt {
    private String navn;

    Katt(String navn) {
        this.navn = navn;
    }

    public String toString() {
        return \"Katt med navn \" + navn;
    }
}" nil 0)
      ("classPerson"
       "abstract class Person {
    protected String personNummer;
    protected String navn;

    Person(String personNummer, String navn) {
        this.personNummer = personNummer;
        this.navn = navn;
    }

    public String personNummer() {
        return personNummer;
    }

    public String navn() {
        return navn;
    }

    public String toString() {
        return \"Person med navn \" + navn + \" og personnummer \" + personNummer;
    }
}" nil 0)
      ("classStudent"
       "class Student {
    private String navn;

    Student(String navn) {
        this.navn = navn;
    }

    public String toString() {
        return \"Student med navn \" + navn;
    }
}" nil 0))))

(defun general-shortcuts ()
  (define-abbrev-table 'general-abbrev-table
    '(("apple" "poop" nil 1))))


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


;; Scrolling
(defun scroll-opp()
  (interactive)
  (scroll-down 4))

(defun scroll-ned()
  (interactive)
  (scroll-up 4))

;; Scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time


(setq word-wrap t)

(global-set-key (kbd "<C-tab>") 'tidy)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "M-<right>") 'select-next-window)
(global-set-key (kbd "M-2") 'select-next-window)
(global-set-key (kbd "M-<left>")  'select-previous-window)
(global-set-key (kbd "M-1")  'select-previous-window)
(global-set-key (kbd "M-n") 'scroll-ned)
(global-set-key (kbd "M-p") 'scroll-opp)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key [f11] 'toggle-fullscreen)

(global-set-key (kbd "C-c e")  'mc/edit-lines)
(global-set-key (kbd "C-c a")  'mc/mark-all-like-this)
(global-set-key (kbd "C-c n")  'mc/mark-next-like-this)
