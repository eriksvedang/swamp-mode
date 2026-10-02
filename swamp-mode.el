(define-derived-mode swamp-mode prog-mode "Swamp"
  "Major mode for the Swamp programming language."
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

(add-to-list 'eglot-server-programs '(swamp-mode . ("swamp" "lsp")))
(add-hook 'swamp-mode-hook #'eglot-ensure)
(autoload 'swamp-mode "swamp-mode" "Major mode for Swamp code." t)
(add-to-list 'auto-mode-alist '("\\.sw\\'" . swamp-mode))

(defun swamp-mode-reload ()
  (interactive)
  (unload-feature 'swamp-mode)
  (require 'swamp-mode)
  (swamp-mode))

(provide 'swamp-mode)
