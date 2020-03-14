;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; indent
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun set-tab4-indent ()
  (interactive)
  (setq-default tab-width 4)
  (setq-default tab-stop-list (cnt-list 200)))

(defun set-tab8-indent ()
  (interactive)
  (setq-default tab-width 8)
  (setq-default tab-stop-list (cnt-list 200)))

(defun cnt-list (n)
  (let ((x 0) (tablist))
    (setq n (/ n tab-width))
    (while (< x n)
      (setq x (+ 1 x))
      (setq tablist (append tablist
                (list (* x tab-width)))))
    tablist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; define cc-styles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c-style-linux ()
  (interactive)
  (c-set-style "linux")
  (setq indent-tabs-mode t)
  ;(fset 'tabify-command 'tabify-buffer)
  (set-tab8-indent)
  (subword-mode t))

(defun c-style-stroustrup ()
  (interactive)
  (c-set-style "stroustrup")
  (setq indent-tabs-mode nil)
  ;(fset 'tabify-command 'untabify-buffer)
  (set-tab4-indent)
  (subword-mode t))

(defun c-style-tab4 ()
  (interactive)
  (c-set-style "tab-4")
  (setq indent-tabs-mode t)
  ;(fset 'tabify-command 'tabify-buffer)
  (set-tab4-indent)
  (subword-mode t))

(defun c-style-bsd ()
  (interactive)
  (c-set-style "bsd")
  (setq indent-tabs-mode t)
  ;(fset 'tabify-command 'tabify-buffer)
  (set-tab8-indent)
  (subword-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tabify / untabify
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; tabify command
(defun untabify-buffer ()
  "Untabify current buffer"
  (interactive)
  (untabify (point-min) (point-max)))
(defun tabify-buffer ()
  "Tabify current buffer"
  (interactive)
  (tabify (point-min) (point-max)))
(defun no-tabify-buffer())

;; program hooks
(defun set-before-save-hook ()
  "Hooks for programming modes"
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'before-save-hook 'progmodes-write-hooks))

(defun progmodes-write-hooks ()
  "Hooks which run on file write for programming modes"
  (prog1 nil
    (set-buffer-file-coding-system 'utf-8-unix)
    ;(tabify-command)
    (maybe-delete-trailing-whitespace)))

(defun delete-trailing-whitespacep ()
  "Should we delete trailing whitespace when saving this file?"
  (save-excursion
    (goto-char (point-min))
    (ignore-errors (next-line 25))
    (let ((pos (point)))
      (goto-char (point-min))
      (and (re-search-forward (concat "@author +" user-full-name) pos t) t))))

(defun maybe-delete-trailing-whitespace ()
  "Delete trailing whitespace if I am the author of this file."
  (interactive)
  (and (delete-trailing-whitespacep) (delete-trailing-whitespace)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-Coding style
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c-mode-common-hooks ()
  (c-style-linux)
  (c-set-offset 'statement-cont 'c-lineup-math)
  (set-before-save-hook)
  (setq show-trailing-whitespace t))

(add-hook 'c-mode-common-hook 'c-mode-common-hooks)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; shell script Coding style
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sh-mode-hooks ()
  (setq show-trailing-whitespace t)
  (setq indent-tabs-mode nil)
  (setq sh-basic-offset 2)
  (setq sh-indentation 2))

(add-hook 'sh-mode-hook 'sh-mode-hooks)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; python Coding style
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun python-mode-hooks ()
  (setq show-trailing-whitespace t))

(add-hook 'python-mode-hook 'python-mode-hooks)
