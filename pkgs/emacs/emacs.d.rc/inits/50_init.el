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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global-key bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
   (define-key key-translation-map [?\C-h] [?\C-?])
   (global-set-key (kbd "C-t") 'other-window)
   (global-set-key (kbd "C-x C-r") (lambda ()
				     (interactive)
				     (revert-buffer t t t)
				     (message "buffer is reloaded")))
;;    (global-set-key (kbd "C-r") 'isearch-backward-regexp )
;;    (global-set-key (kbd "C-s") 'isearch-forward-regexp )
;;    (global-set-key (kbd "C-c j") 'goto-line)
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set environment UTF-8 and Japanese
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package mozc
  :config
  (set-language-environment "Japanese")
  (setq default-input-method "japanese-mozc")
  (prefer-coding-system 'utf-8)
  )

;; ((lambda ()
;;    (set-locale-environment nil)
;;    (set-language-environment "Japanese")
;;    (set-terminal-coding-system 'utf-8)
;;    (set-keyboard-coding-system 'utf-8)
;;    (set-buffer-file-coding-system 'utf-8)
;;    (setq default-buffer-file-coding-system 'utf-8)
;;    (set-default-coding-systems 'utf-8)
;;    (prefer-coding-system 'utf-8)
;;    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Color theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Light theme
;; (load-theme 'adwaita t)
;; (load-theme 'dichromacy t)
;; (load-theme 'leuven t)
;; (load-theme 'tango t)
;; (load-theme 'tsdh-light t)
;; (load-theme 'whiteboard t)
;; ;; Blue theme
;; (load-theme 'deeper-blue t)
;; (load-theme 'light-blue t)
;; ;; Dark theme
;; (load-theme 'manoj-dark t)
;; (load-theme 'misterioso t)
;; (load-theme 'tango-dark t)
;; (load-theme 'tsdh-dark t)
;; (load-theme 'wheatgrass t)
(load-theme 'wombat t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Buffer control
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; paren-mode
((lambda ()
   ;; high-light paren pare
   (show-paren-mode 1)
   ;; high-light line when paren not in window
   (setq show-paren-style 'mixed)
   ))


;; ((lambda ()
;;    ;; Do not visualize space and tabs
;;    (global-whitespace-mode -1)
;;    ;; high-light line on cursol
;;    (global-hl-line-mode -1)
;;    ;; scroll step 1
;;    (setq scroll-step 1)
;;    (setq next-screen-context-lines 1)
;;    ;; not cleanup search high-light
;;    (setq isearch-lazy-highlight-cleanup nil)
;;    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mode-line
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
;; window number
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package window-number
  :config
  (window-number-meta-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cua-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
((lambda ()
  (cua-mode t)
  (setq cua-enable-cua-keys nil)
  (define-key global-map (kbd "C-x SPC") 'cua-set-rectangle-mark)
  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ivy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ivy
  :config
  ;; Add recent files and bookmark to ivy-switch-buffer (C-x b) .
  (setq ivy-use-virtual-buffers t)
  ;; Allow run command in mini buffer
  (when (setq enable-recursive-minibuffers t)
    ;; Show level in prompt
    (minibuffer-depth-indicate-mode 1))
  ;; Exit minibuffer by ESC
  (define-key ivy-minibuffer-map (kbd "<escape>") 'minibuffer-keyboard-quit)
  ;; line truncate when prompt is long
  (setq ivy-truncate-lines nil)
  ;; loop list
  (setq ivy-wrap t)
  ;; activate ivy
  (ivy-mode 1))

;; M-o register ivy-hydra-read-action
(use-package ivy-hydra
  :config
  (setq ivy-read-action-function #'ivy-hydra-read-action))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; counsel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package counsel
  :bind
  ("M-x" . counsel-M-x)
  ("M-y" . counsel-yank-pop)
  ; TODO install fzf? ... considering what to use.
  ; ("C-M-z" . counsel-fzf)
  ("C-M-r" . counsel-recentf)
  ("C-x C-b" . counsel-ibuffer)
  ; TODO install ag.
  ; ("C-M-f" . counsel-ag)
  :config
  (counsel-mode 1)
  )

(use-package counsel-gtags
  :straight (:host github :repo "syohex/emacs-counsel-gtags"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; swiper
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package swiper
  :bind
  ("C-s" . swiper-thing-at-point)
  ("M-s M-s" . isearch-forward)
  :config
  ;; Search line-number
  (setq swiper-include-line-number-in-search t)
  )

;; (use-package avy-migemo
;;   :config
;;   (avy-migemo-mode 1)
;;   (use-package avy-migemo-e.g.swiper))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package company
  :bind
  ("C-M-i" . company-complete)
  (:map company-active-map
	("M-n" . nil)
	("M-p" . nil)
	("C-n" . coqqqmpany-select-next)
	("C-p" . company-select-previous)
	("C-s" . company-filter-candidates)
	; ("C-i" . company-complete-selection)
	("C-h" . nil))
  (:map company-search-map
	("C-n" . coqqqmpany-select-next)
	("C-p" . company-select-previous))
  (:map emacs-lisp-mode-map
	("C-M-i" . company-complete))
  :config
  ; sort order
  ; (use-package company-statistics)
  ; (setq company-transformers '(company-sort-by-statistics company-sort-by-backend-importance))
  (setq company-transformers '(company-sort-by-backend-importance))
  ; Enable in all buffer.
  (global-company-mode)
  ; begin company delay
  (setq company-idle-delay 0)
  ; show complete list
  (setq company-minimum-prefix-length 2)
  ; wrap list top-and-bottom.
  (setq company-selection-wrap-around t)
  ;
  (setq completion-ignore-case t)
  (setq company-dabbrev-downcase nil)
  ; TODO: add yasnippet settings.
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; git-complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package git-complete
  :straight (:host github :repo "zk-phi/git-complete")
  :bind
  ("C-c C-c" . git-complete))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo-tree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package undo-tree
  :config
  (global-undo-tree-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo-hist
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package undohist
  :ensure t
  :config
  (setq undohist-ignored-files '("/tmp" "COMMIT_EDITMSG" "elpa"))
  (undohist-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; highlight
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; highlihgt-symbol
(use-package highlight-symbol
  :bind
  ("M-s M-r" . 'highlight-symbol-query-replace)
  :init
  (setq highlight-symbol-idle-delay 0.1)
  (add-hook 'prog-mode-hook 'highlight-symbol-mode)
  (add-hook 'prog-mode-hook 'highlight-symbol-nav-mode)
  )

;; highlight-ymbol overlay
(use-package symbol-overlay
  :bind
  ("M-i" . 'symbol-overlay-put)
  ("<f7>" . 'symbol-overlay-mode)
  ("M-I" . 'symbol-overlay-remove-all)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; magit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package magit
  :bind
  (("C-x m" . 'magit-status)
   ("C-x l" . 'magit-blame))
  :init
  ;; (setq magit-display-buffer-function
  ;;	(lambda (buffer)
  ;;	  (display-buffer
  ;;	   buffer (if (and (derived-mode-p 'magit-mode)
  ;;			   (memq (with-current-buffer buffer major-mode)
  ;;				 '(magit-process-mode
  ;;				   magit-revision-mode
  ;;				   magit-diff-mode
  ;;				   magit-stash-mode
  ;;				   magit-status-mode)))
  ;;		      nil
  ;;		    '(display-buffer-same-window)))))
  )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; python environment
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package pipenv
  :hook (python-mode . pipenv-mode)
  :init
  (setq
   pipenv-projectile-after-switch-function
   #'pipenv-projectile-after-switch-extended))

(use-package python-black
  :demand t
  :after python)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flycheck
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package lsp-mode
  :ensure t
  :commands lsp
  :custom
  (lsp-auto-guess-root nil)
  :bind (:map lsp-mode-map ("C-c C-f" . lsp-format-buffer))
  :hook (python-mode . lsp)
  )

(use-package lsp-treemacs)

(use-package lsp-ui
  :after lsp-mode
  :diminish
  :commands lsp-ui-mode
  :custom-face
  (lsp-ui-doc-background ((t (:background nil))))
  (lsp-ui-doc-header ((t (:inherit (font-lock-string-face italic)))))
  :bind (:map lsp-ui-mode-map
	      ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
	      ([remap xref-find-references] . lsp-ui-peek-find-references)
	      ("C-c u" . lsp-ui-imenu))
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-position 'top)
  (lsp-ui-doc-border (face-foreground 'default))
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-show-code-actions nil)
  :config
  (setq lsp-ui-doc-use-webkit t)
  (defadvice lsp-ui-imenu (after hide-lsp-ui-imenu-mode-line activate)
    (setq mode-line-format nil)))

(use-package company-lsp :commands company-lsp)
(use-package helm-lsp :commands helm-lsp-workspace-symbol)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Settting swiper
;; (use-package swiper
;;   :ensure t
;;   :config
;;   (defun isearch-forward-or-swiper (use-swiper)
;;     (interactive "p")
;;     (let (current-prefix-arg)
;;       (call-interactively (if use-swiper 'swiper 'isearch-forward))))
;;   :bind
;;   ("C-s" . isearch-forward-or-swiper)
;;   )

;; ;; Settting cmigemo.
;; (use-package migemo
;;   :ensure t
;;   :config
;;   (setq migemo-command "cmigemo")
;;   (setq migemo-options '("-q" "--emacs" "-i" "\a"))
;;   (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
;;   (setq migemo-user-dictionary nil)
;;   (setq migemo-regex-dictionary nil)
;;   ;; charset encoding
;;   (setq migemo-coding-system 'utf-8-unix))

;; ;; ivy-migemo
;; (use-package avy-migemo
;;   :ensure t
;;   :config
;;   (avy-migemo-mode 1)
;;   (setq avy-timeout-seconds nil)
;;   (use-package avy-migemo-e.g.swiper)
;;   :bind
;;   ("C-M-;" . avy-migemo-goto-char-timer)
;;   ;; ("M-g m m" . avy-migemo-mode)
;;   )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; TODO: install/setting follows
;; ;;  ag, shell-mode, howm, diff-mode, mozc,
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Miscs
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Do not show startup message
;; (setq inhibit-startup-message t)
;; ;; Do not show menu bar
;; (menu-bar-mode -1)
;; ;; Do not show tool bar
;; (tool-bar-mode -1)
;; ;; "yes or no" -> "y or n"
;; (fset 'yes-or-no-p 'y-or-n-p)
;; ;; Do not use use-package if not exist
;; ;;(unless (require 'use-package nil t)
;; ;;  (defmacro use-package (&rest args)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; read only open
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ((lambda ()
;;   (defun find-file-hooks ()
;;     (when (and (file-exists-p buffer-file-name)
;;            (equal (string-match ".*-autoloads.el" buffer-file-name) nil))
;;       (read-only-mode t)
;;       (view-mode t)))
;;   (add-hook 'find-file-hook 'find-file-hooks)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; packages
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ((lambda ()
;;    (package-initialize)
;;    (setq package-archives
;;      '(("gnu" . "https://elpa.gnu.org/packages/")
;;        ("melpa-stable" . "https://stable.melpa.org/packages/")
;;        ("melpa" . "https://melpa.org/packages/")
;;        ("marmalade" . "https://marmalade-repo.org/packages/")
;;        ;; ("melpa" . "https://melpa.milkbox.net/packages/")
;;        ("org" . "http://orgmode.org/elpa/")
;;        ))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; dired-mode
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ((lambda ()
;;   (defun dired-load-hooks()
;;     ;; key-map
;;     (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
;;     (define-key dired-mode-map (kbd "C-t") nil)
;;     (define-key dired-mode-map (kbd "C-o") nil)
;;     ;; move and rename dist is other window when opened dired more than 2
;;     (setq dired-dwim-target t)
;;     ;; display
;;     (setq dired-listing-switches (purecopy "-Ahl"))
;;     (custom-set-faces
;;      '(dired-directory
;;        ((t (:inherit font-lock-function-name-face :foreground "cyan"))))))
;;   (add-hook 'dired-load-hook 'dired-load-hooks)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; recentf
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ((lambda ()
;;    (setq recentf-max-saved 1000)
;;    (setq recentf-exclude '("/recentf"
;;                "COMMIT_EDITMSG"
;;                "/.?TAGS"
;;                "^/sudo:"
;;                "/\\.emacs\\.d/games/*-scores"
;;                "/\\.emacs\\.d/\\.cask/"))
;;    (setq recentf-auto-save-timer
;;      (run-with-idle-timer 30 t 'recentf-save-list))
;;    (use-package recentf-ext)
;;    (recentf-mode 1)))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; command history
;; ;;  https://www.emacswiki.org/emacs/Desktop
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ((lambda ()
;;    (setq desktop-globals-to-save '(extended-command-history))
;;    (setq desktop-files-not-to-save "")
;;    (desktop-save-mode 1)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; kermit
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package kermit)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ruby-mode
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package ruby-mode
;;   :interpreter (("ruby"    . ruby-mode)
;;         ("rbx"     . ruby-mode)
;;         ("jruby"   . ruby-mode)
;;         ("ruby1.9" . ruby-mode)
;;         ("ruby1.8" . ruby-mode))
;;   :config
;;   ;; ruby-modeの設定
;;   )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; hungry delete
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package hungry-delete
;;   :config
;;   (global-hungry-delete-mode 1))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; color-moccur
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package occur-by-moccur
;;   :bind (("C-M-o" . occur-by-moccur)
;;      )
;;   :config
;;   (use-package moccur-edit))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; migemo
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package migemo
;;   :init
;;   (setq migemo-command "cmigemo")
;;   (setq migemo-options '("-q" "--emacs"))
;;   (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
;;   (setq migemo-user-dictionary nil)
;;   (setq migemo-regex-dictionary nil)
;;   (setq migemo-coding-system 'utf-8-unix)
;;   (load-library "migemo")
;;   (migemo-init))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; helm-mode
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package helm
;;   :bind (("M-x" . helm-M-x)
;;      ("C-x C-o" . helm-resume)
;;      ("C-x f" . helm-for-files)
;;      ("M-y" . helm-show-kill-ring)
;;      ("M-o" . helm-swoop)
;;      ("C-x C-b" . helm-buffers-list)
;;      ("C-o" . helm-mini)
;;      )
;;   :init
;;   ;; use helm config
;;   (use-package helm-config)
;;   ;; set helm-mini sources
;;   (setq helm-mini-default-sources '(helm-source-buffers-list
;;                     helm-source-recentf
;;                     helm-source-files-in-current-dir
;;                     helm-source-buffer-not-found
;;                     ))
;;   (helm-mode 1)
;;   :config
;;   ;; disable helm commands
;;   ((lambda ()
;;      ;; (add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))
;;      (add-to-list 'helm-completing-read-handlers-alist '(find-file-at-point . nil))
;;      (add-to-list 'helm-completing-read-handlers-alist '(write-file . nil))
;;      ;; (add-to-list 'helm-completing-read-handlers-alist '(helm-c-yas-complete . nil))
;;      (add-to-list 'helm-completing-read-handlers-alist '(dired-do-copy . nil))
;;      (add-to-list 'helm-completing-read-handlers-alist '(dired-do-rename . nil))
;;      (add-to-list 'helm-completing-read-handlers-alist '(dired-create-directory . nil))
;;      ))
;;   ;; helm-find-files
;;   ;; (defadvice helm-ff-kill-or-find-buffer-fname
;;   ;;     (around execute-only-if-exist activate)
;;   ;;   "Execute command only if CANDIDATE exists"
;;   ;;   (when (file-exists-p candidate)
;;   ;;     ad-do-it))
;;   ;; local key-bindings
;;   ((lambda ()
;;      (define-key helm-map (kbd "C-o") 'helm-execute-persistent-action)
;;      ;; For find-file etc.
;;      (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
;;      (define-key helm-read-file-map (kbd "C-o") 'helm-select-action)
;;      ;; For helm-find-files etc.
;;      (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
;;      (define-key helm-find-files-map (kbd "C-o") 'helm-select-action)
;;      )))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; helm-gtags
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package helm-gtags
;;   :config
;;   (add-hook 'c-mode-hook 'helm-gtags-mode)
;;   (add-hook 'c++-mode-hook 'helm-gtags-mode)
;;   (add-hook 'asm-mode-hook 'helm-gtags-mode)
;;   (add-hook 'python-mode-hook 'helm-gtags-mode)
;;   ;; Enable helm-gtags-mode
;;   (with-eval-after-load "helm-gtags"
;;     (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-find-tag)
;;     (define-key helm-gtags-mode-map (kbd "M-*") 'helm-gtags-pop-stack)
;;     (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
;;     (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
;;     (define-key helm-gtags-mode-map (kbd "M-g M-f") 'helm-gtags-parse-file)
;;     (define-key helm-gtags-mode-map (kbd "M-p") 'helm-gtags-previous-history)
;;     (define-key helm-gtags-mode-map (kbd "M-n") 'helm-gtags-next-history)
;;     )
;;   ;; update GTAGS automatic
;;   ((lambda ()
;;      (defun update-gtags ()
;;        (let* ((file (buffer-file-name (current-buffer)))
;;           (dir (directory-file-name (file-name-directory file))))
;;      (when (executable-find "global")
;;        (start-process "gtags-update" nil
;;               "global" "-uv"))))
;;      (add-hook 'after-save-hook 'update-gtags)))
;;   )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; helm-company
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; company
;; (use-package company
;;   :commands company-mode
;;   :init
;;   (add-hook 'c-mode-common-hook 'company-mode)
;;   (add-hook 'python-mode-hook 'company-mode)
;;   (add-hook 'emacs-lisp-mode-hook 'company-mode)
;;   :config
;;   ;; (global-company-mode)
;;   ;; (setq company-auto-expand t)
;;   ;; (setq company-transformers '(company-sort-by-backend-importance))
;;   (setq company-idle-delay 0) ;; no delay
;;   (setq company-minimum-prefix-length 2) ;; begining completion
;;   (setq company-selection-wrap-around t) ;; last's next is head
;;   ;; (setq completion-ignore-case t)
;;   (define-key company-active-map (kbd "C-n") 'company-select-next)
;;   (define-key company-active-map (kbd "C-p") 'company-select-previous)
;;   (define-key company-active-map [tab] 'company-complete-selection)
;;   (define-key company-active-map (kbd "M-?") 'company-show-doc-buffer)
;;   ;;;;;;;;;;;;;;;;
;;   ;; helm-company
;;   ;;;;;;;;;;;;;;;;
;;   (use-package helm-company
;;     :init
;;     (define-key company-mode-map (kbd "M-SPC") 'helm-company)
;;     (define-key company-active-map (kbd "M-SPC") 'helm-company)
;;     ))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
