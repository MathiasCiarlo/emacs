(defun devilry-bold()
  (interactive)
  (insert "****")(backward-char) (backward-char))

(defun devilry-italic()
  (interactive)
  (insert "**")(backward-char))

(defun devilry-yank-java-block()
  (interactive)
  (insert "``` java")
  (newline)(yank)(newline)
  (insert "```")(newline))


;; Smart for getting stuff on devilry, but not on disk
(defun devilry-add-old-feedback()
  (interactive)
  (save-buffer)
  (kill-buffer)
  ;; Get username and create feedback-file
  (setq username (read-string "Skriv inn brukernavn: "))
  ;; Ask for a real username
  (while (string= username "")
    (setq username (read-string "Skriv inn et ordentlig brukernavn: ")))
  (shell-command (concat "touch" feedback-dir-path username "/3.txt"))
  ;; Open the file in the new window
  (find-file (concat feedback-dir-path username "/3.txt")))


;; Kill everything without saving
(defun desktop-hard-clear ()
  (interactive)
  (dolist (buffer (buffer-list))
    (let ((process (get-buffer-process buffer)))
      (when process (process-kill-without-query process))
      (set-buffer buffer)
      (set-buffer-modified-p nil)
      (kill-this-buffer)))
  (delete-other-windows))


;; Shows readme buffer if it exists
(defun devilry-show-readme()
  (interactive)
  (if (get-buffer "README.txt")
    (switch-to-buffer "README.txt")
    (message "Could not find README.txt")))

(add-hook 'Devilry-mode-hook 'devilry-show-readme)


;; Inserts the template and adds username et end of first line
(defun insert-devilry-template (username file-path)
  (insert-file-contents file-path)
  (move-end-of-line nil)
  (insert username)
  (move-beginning-of-line nil))


;; Create a new feedback file in the right folder
;; Splits windows and shows the two previous feedback files
(defun devilry-create-new-and-show-last-feedback()
  ;; Get username
  (setq username (read-string "Skriv inn brukernavn: "))

  ;; Ask until we get a valid username
  (while (not (file-exists-p (concat feedback-dir-path username)))
    (setq username (read-string (concat "Skriv inn et gyldig brukernavn. (Må ligge i mappen" feedback-dir-path "): "))))

  ;; Calculate paths to new and previous feedback files
  (setq newFilePath (concat feedback-dir-path username "/" oblig-number ".txt"))
  (setq prevFilePath (concat feedback-dir-path username "/" (number-to-string (- (string-to-number oblig-number) 1)) ".txt"))
  (setq oldFilePath (concat feedback-dir-path username "/"  (number-to-string (- (string-to-number oblig-number) 2)) ".txt"))

  ;; Create the new feedback-file
  (shell-command (concat "touch " newFilePath))

  ;; Open new window to the right
  (setq window (split-window-right))

  ;; Open the file in the new window and show previous feedback below if it exists
  (with-selected-window window
    (find-file newFilePath)
    (insert-devilry-template username feedback-template-path)

    (with-selected-window (split-window-below)
      (when (file-exists-p prevFilePath)
        (find-file-read-only prevFilePath)
        (end-of-buffer))
      (with-selected-window (split-window-below)
        (when (file-exists-p oldFilePath)
          (find-file-read-only oldFilePath)
          (end-of-buffer))))))


;; Compile all java files, then delete output files
;; Tidy everything
;; Find README and switch to that buffer
;; Also close unneccesary buffers
(defun devilry-grl-inf1000 ()
  (interactive)
  (delete-other-windows)
  (tidy-all-buffers)

  ;; Create new and show previous feedback files on the right
  (devilry-create-new-and-show-last-feedback)

  ;; Show readme if it exists
  (devilry-show-readme)

  ;; Try to compile, show errors below
  (shell-command "javac *.java")
  ;; If compilation was successful,
  (if (eq (buffer-size (get-buffer "*Shell Command Output*")) 0)
      (progn
        (message "Compilation completed sucessfully, deleted .class files")
        ;; Delete .class files after compilation
        (if (eq system-type 'windows-nt)
            (shell-command "del *.class")
          (shell-command "rm *.class")))
    ;; Else show errors below
    (setq window (split-window-below))
    (set-window-buffer window "*Shell Command Output*"))

  ;; Kill unnessesary buffers
  (when (not(eq (get-buffer "*Completions*") nil))
    (kill-buffer "*Completions*"))
  (when (eq (buffer-size (get-buffer "*Shell Command Output*")) 0)
    (kill-buffer (get-buffer "*Shell Command Output*"))))


;; Writes updated data to file
(defun write-data ()
  ;; Make a driectory for the data file if it does not exist
  (when (not (file-exists-p "~/.emacs.d/site-lisp/devilry-mode/"))
    (shell-command "mkdir -p ~/.emacs.d/site-lisp/devilry-mode"))

  ;; Construct data-string for file-insertion
  (let ((str (concat feedback-dir-path "\n" feedback-template-path "\n" oblig-number)))
    ;; Write to file
    (write-region str nil "~/.emacs.d/site-lisp/devilry-mode/devilry-mode.data")
    (message "Updated data (devilry-mode.data)")))


;; Gets data from file
(defun read-data ()
  (with-temp-buffer
    (when (file-exists-p "~/.emacs.d/site-lisp/devilry-mode/devilry-mode.data")
      (insert-file-contents "~/.emacs.d/site-lisp/devilry-mode/devilry-mode.data")

      (let ((beg (point))) (end-of-line) (copy-region-as-kill beg (point)))
      (setq feedback-dir-path (car kill-ring-yank-pointer))
      (let ((beg (progn (goto-line 2) (point)))) (end-of-line) (copy-region-as-kill beg (point)))
      (setq feedback-template-path (car kill-ring-yank-pointer))
      (let ((beg (progn (goto-line 3) (point)))) (end-of-line) (copy-region-as-kill beg (point)))
      (setq oblig-number (car kill-ring-yank-pointer)))))


;; Initiates the system
(defun devilry-init ()
  (read-data)

  ;; Check if we need to write to file
  (let ((data-updated nil))
    ;; Check if not file exists
    (if (not (file-exists-p "~/.emacs.d/site-lisp/devilry-mode/devilry-mode.data"))
	(progn
	  (message "Data file \"devilry-mode.data\" does not exist")
	  (setq oblig-number (read-string "Oblig number: "))
	  (setq feedback-dir-path (read-string "Path to feedback directory: "))
	  (setq feedback-template-path (read-string "Path to feedback template: "))

	  (setq data-updated t))
      
      ;; Check if user wants to update data, i.e new template path
      (when (y-or-n-p (concat "Change oblig number? (is " oblig-number ") "))
	(setq oblig-number (read-string "Oblig number: "))
	(setq data-updated t))
      
      (when (y-or-n-p (concat "Change feedback directory? (is " feedback-dir-path ") "))
	(setq feedback-dir-path (read-string "Path to feedback directory: "))
	(setq data-updated t))
      
      (when (y-or-n-p (concat "Change feedback template path? (is " feedback-template-path ") "))
	(setq feedback-template-path (read-string "Path to feedback template: "))
	(setq data-updated t)))

    ;; If we have new varables or could not find data we have to write to file
    (when data-updated
      (write-data))))

;; The mode
(define-minor-mode devilry-mode
  nil
  :lighter " Devilry"
  :global t
  :init-value nil
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "<f5>") 'devilry-grl-inf1000)
            (define-key map (kbd "<f6>") 'desktop-hard-clear)
            (define-key map (kbd "C-, b") 'devilry-bold)
            (define-key map (kbd "C-, i") 'devilry-italic)
            (define-key map (kbd "C-, y") 'devilry-yank-java-block)
            map)
  ;; This will be run every time the mode is toggled on or off
  ;; If we toggled the mode on, run init function
  (when (and devilry-mode (boundp 'devilry-mode))
    (devilry-init)))
