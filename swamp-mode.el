;; -*- lexical-binding: t; -*-

(defvar swamp-indent-offset 4
  "Number of spaces per indentation level in `swamp-mode'.")

(defvar swamp-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?/ ". 124b" st)
    (modify-syntax-entry ?\n "> b" st)
    (modify-syntax-entry ?_ "_" st)
    (modify-syntax-entry ?' "\"" st)
    st)
  "Syntax table for `swamp-mode'.")

(defun swamp-indent-line ()
  "Indent the current line according to brace nesting."
  (interactive)
  (let* ((ppss (save-excursion (syntax-ppss (line-beginning-position))))
         (in-string (nth 3 ppss)))
    (if in-string
        'noindent                       ; leave multi-line strings alone
      (let ((indent
             (save-excursion
               (beginning-of-line)
               (skip-chars-forward " \t")
               (let ((depth (car ppss)))
                 (when (looking-at "[]})]")
                   (setq depth (1- depth)))
                 (* swamp-indent-offset (max depth 0))))))
        (if (> (current-column) (current-indentation))
            (save-excursion (indent-line-to indent))
          (indent-line-to indent))))))

(define-derived-mode swamp-mode prog-mode "Swamp"
  "Major mode for the Swamp programming language."
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  (setq-local indent-line-function #'swamp-indent-line)
  (setq-local electric-indent-chars
              (append "{}()[]" electric-indent-chars))
  (setq-local case-fold-search nil))

(defun swamp-run ()
  (interactive)
  (shell-command "swamp run"))

(defun swamp-build ()
  (interactive)
  (shell-command "swamp build"))

(defvar swamp-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-k") #'swamp-build)
    (define-key map (kbd "C-c C-b") #'swamp-build)
    (define-key map (kbd "C-c C-r") #'swamp-run)
    map)
  "Keymap for Swamp major mode.")

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(swamp-mode . ("swamp" "lsp"))))

(add-hook 'swamp-mode-hook #'eglot-ensure)
(autoload 'swamp-mode "swamp-mode" "Major mode for Swamp code." t)
(add-to-list 'auto-mode-alist '("\\.sw\\'" . swamp-mode))

(defun swamp-mode-reload ()
  (interactive)
  (unload-feature 'swamp-mode)
  (require 'swamp-mode)
  (swamp-mode))

(provide 'swamp-mode)
