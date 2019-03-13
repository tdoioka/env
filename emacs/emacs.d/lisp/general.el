;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO: install/setting follows
;;  ag, shell-mode, howm, diff-mode, mozc,
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Miscs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Do not show startup message
(setq inhibit-startup-message t)
;; Do not show menu bar
(menu-bar-mode -1)
;; Do not show tool bar
(tool-bar-mode -1)
;; "yes or no" -> "y or n"
(fset 'yes-or-no-p 'y-or-n-p)
;; Do not use use-package if not exist
;;(unless (require 'use-package nil t)
;;  (defmacro use-package (&rest args)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set environment UTF-8 and Japanese
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
   (set-locale-environment nil)
   (set-language-environment "Japanese")
   (set-terminal-coding-system 'utf-8)
   (set-keyboard-coding-system 'utf-8)
   (set-buffer-file-coding-system 'utf-8)
   (setq default-buffer-file-coding-system 'utf-8)
   (set-default-coding-systems 'utf-8)
   (prefer-coding-system 'utf-8)
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Buffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
   ;; Do not visualize space and tabs
   (global-whitespace-mode -1)
   ;; high-light line on cursol
   (global-hl-line-mode -1)
   ;; high-light paren pare
   (show-paren-mode 1)
   ;; high-light line when paren not in window
   (setq show-paren-style 'mixed)
   (set-face-background 'show-paren-match-face "grey")
   (set-face-foreground 'show-paren-match-face "black")
   ;; theme
   ;; (load-theme 'misterioso t)
   (load-theme 'manoj-dark t)
   ;; scroll step 1
   (setq scroll-step 1)
   (setq next-screen-context-lines 1)
   ;; not cleanup search high-light
   (setq isearch-lazy-highlight-cleanup nil)
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Status bar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
   ;; show linefeed code
   (setq eol-mnemonic-dos "(CRLF)")
   (setq eol-mnemonic-mac "(CR)")
   (setq eol-mnemonic-unix "(LF)")
   ;; show column number
   (column-number-mode t)
   ;; show line number
   (global-linum-mode -1)
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; read only open
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
  (defun find-file-hooks ()
    (when (and (file-exists-p buffer-file-name)
           (equal (string-match ".*-autoloads.el" buffer-file-name) nil))
      (read-only-mode t)
      (view-mode t)))
  (add-hook 'find-file-hook 'find-file-hooks)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
   (package-initialize)
   (setq package-archives
     '(("gnu" . "http://elpa.gnu.org/packages/")
       ("melpa" . "http://melpa.org/packages/")
       ;; ("melpa2" . "http://melpa.milkbox.net/packages/")
       ("marmalade" . "http://marmalade-repo.org/packages/")
       ("org" . "http://orgmode.org/elpa/")
       ))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cua-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
  (cua-mode t)
  (setq cua-enable-cua-keys nil)
  (define-key global-map (kbd "C-x SPC") 'cua-set-rectangle-mark)
  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dired-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
  (defun dired-load-hooks()
    ;; key-map
    (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
    (define-key dired-mode-map (kbd "C-t") nil)
    (define-key dired-mode-map (kbd "C-o") nil)
    ;; move and rename dist is other window when opened dired more than 2
    (setq dired-dwim-target t)
    ;; display
    (setq dired-listing-switches (purecopy "-Ahl"))
    (custom-set-faces
     '(dired-directory
       ((t (:inherit font-lock-function-name-face :foreground "cyan"))))))
  (add-hook 'dired-load-hook 'dired-load-hooks)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; recentf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
   (setq recentf-max-saved 1000)
   (setq recentf-exclude '("/recentf"
               "COMMIT_EDITMSG"
               "/.?TAGS"
               "^/sudo:"
               "/\\.emacs\\.d/games/*-scores"
               "/\\.emacs\\.d/\\.cask/"))
   (setq recentf-auto-save-timer
     (run-with-idle-timer 30 t 'recentf-save-list))
   (use-package recentf-ext)
   (recentf-mode 1)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; command history
;;  https://www.emacswiki.org/emacs/Desktop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
   (setq desktop-globals-to-save '(extended-command-history))
   (setq desktop-files-not-to-save "")
   (desktop-save-mode 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo-tree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package undo-tree
  :config (global-undo-tree-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo-hist
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package undohist
  :ensure t
  :config
  (setq undohist-ignored-files '("/tmp" "COMMIT_EDITMSG" "elpa"))
  (undohist-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ruby-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ruby-mode
  :interpreter (("ruby"    . ruby-mode)
        ("rbx"     . ruby-mode)
        ("jruby"   . ruby-mode)
        ("ruby1.9" . ruby-mode)
        ("ruby1.8" . ruby-mode))
  :config
  ;; ruby-modeの設定
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hungry delete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package hungry-delete
  :config
  (global-hungry-delete-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; window number
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package window-number
  :config
  (window-number-meta-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; color-moccur
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package occur-by-moccur
  :bind (("C-M-o" . occur-by-moccur)
     )
  :config
  (use-package moccur-edit))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; migemo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package migemo
  :init
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--emacs"))
  (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (load-library "migemo")
  (migemo-init))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; highlight
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package highlight-symbol
  :bind
  ("M-s M-r" . highlight-symbol-query-replace)
  :init
  (setq highlight-symbol-idle-delay 0.1)
  (add-hook 'prog-mode-hook 'highlight-symbol-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helm-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package helm
  :bind (("M-x" . helm-M-x)
     ("C-x C-o" . helm-resume)
     ("C-x f" . helm-for-files)
     ("M-y" . helm-show-kill-ring)
     ("M-o" . helm-swoop)
     ("C-x C-b" . helm-buffers-list)
     ("C-o" . helm-mini)
     )
  :init
  ;; use helm config
  (use-package helm-config)
  ;; set helm-mini sources
  (setq helm-mini-default-sources '(helm-source-buffers-list
                    helm-source-recentf
                    helm-source-files-in-current-dir
                    helm-source-buffer-not-found
                    ))
  (helm-mode 1)
  :config
  ;; disable helm commands
  ((lambda ()
     ;; (add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(find-file-at-point . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(write-file . nil))
     ;; (add-to-list 'helm-completing-read-handlers-alist '(helm-c-yas-complete . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(dired-do-copy . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(dired-do-rename . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(dired-create-directory . nil))
     ))
  ;; helm-find-files
  ;; (defadvice helm-ff-kill-or-find-buffer-fname
  ;;     (around execute-only-if-exist activate)
  ;;   "Execute command only if CANDIDATE exists"
  ;;   (when (file-exists-p candidate)
  ;;     ad-do-it))
  ;; local key-bindings
  ((lambda ()
     (define-key helm-map (kbd "C-o") 'helm-execute-persistent-action)
     ;; For find-file etc.
     (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
     (define-key helm-read-file-map (kbd "C-o") 'helm-select-action)
     ;; For helm-find-files etc.
     (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
     (define-key helm-find-files-map (kbd "C-o") 'helm-select-action)
     )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helm-gtags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package helm-gtags
  :config
  (add-hook 'c-mode-hook 'helm-gtags-mode)
  (add-hook 'c++-mode-hook 'helm-gtags-mode)
  (add-hook 'asm-mode-hook 'helm-gtags-mode)
  (add-hook 'python-mode-hook 'helm-gtags-mode)
  ;; Enable helm-gtags-mode
  (with-eval-after-load "helm-gtags"
    (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-find-tag)
    (define-key helm-gtags-mode-map (kbd "M-*") 'helm-gtags-pop-stack)
    (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
    (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
    (define-key helm-gtags-mode-map (kbd "M-g M-f") 'helm-gtags-parse-file)
    (define-key helm-gtags-mode-map (kbd "M-p") 'helm-gtags-previous-history)
    (define-key helm-gtags-mode-map (kbd "M-n") 'helm-gtags-next-history)
    )
  ;; update GTAGS automatic
  ((lambda ()
     (defun update-gtags ()
       (let* ((file (buffer-file-name (current-buffer)))
          (dir (directory-file-name (file-name-directory file))))
     (when (executable-find "global")
       (start-process "gtags-update" nil
              "global" "-uv"))))
     (add-hook 'after-save-hook 'update-gtags)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helm-company
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company
(use-package company
  :commands company-mode
  :init
  (add-hook 'c-mode-common-hook 'company-mode)
  (add-hook 'python-mode-hook 'company-mode)
  (add-hook 'emacs-lisp-mode-hook 'company-mode)
  :config
  ;; (global-company-mode)
  ;; (setq company-auto-expand t)
  ;; (setq company-transformers '(company-sort-by-backend-importance))
  (setq company-idle-delay 0) ;; no delay
  (setq company-minimum-prefix-length 2) ;; begining completion
  (setq company-selection-wrap-around t) ;; last's next is head
  ;; (setq completion-ignore-case t)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map [tab] 'company-complete-selection)
  (define-key company-active-map (kbd "M-?") 'company-show-doc-buffer)
  ;;;;;;;;;;;;;;;;
  ;; helm-company
  ;;;;;;;;;;;;;;;;
  (use-package helm-company
    :init
    (define-key company-mode-map (kbd "M-SPC") 'helm-company)
    (define-key company-active-map (kbd "M-SPC") 'helm-company)
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; key-binding
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
   (define-key key-translation-map [?\C-h] [?\C-?])
   (global-set-key (kbd "C-t") 'other-window)
   (global-set-key (kbd "C-r") 'isearch-backward-regexp )
   (global-set-key (kbd "C-s") 'isearch-forward-regexp )
   (global-set-key (kbd "C-c j") 'goto-line)
   (global-set-key (kbd "C-x C-r")
           (lambda ()
             (interactive)
             (revert-buffer t t t)
             (message "buffer is reloaded")))
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
