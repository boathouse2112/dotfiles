;; HACK Work around native compilation on taco's failing with 'Nd: library not
;; found for -lemutls_w'.
;; https://github.com/d12frosted/homebrew-emacs-plus/issues/554
(setenv "LIBRARY_PATH"
	(string-join
	 '("/opt/homebrew/opt/gcc/lib/gcc/13"
	   "/opt/homebrew/opt/libgccjit/lib/gcc/13"
	   "/opt/homebrew/opt/gcc/lib/gcc/13/gcc/aarch64-apple-darwin22/13")
	 ":"))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)	; Disable visible scroll bar
(tool-bar-mode -1)		; Disable toolbar
(tooltip-mode -1)		; Disable tooltips
;(set-fringe-mode 10)	; Give some breathing room

(menu-bar-mode -1)		; Disable menu bar

;; Font face
(set-face-attribute 'default nil :font "Menlo" :height 150)

;; Line numbers
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Fullscreen
(setq ns-use-native-fullscreen nil)
(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

;; Use tree sitter modes
(setq major-mode-remap-alist
      '((ruby-mode . ruby-ts-mode)))

;; Initialize package sources
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
	(package-refresh-contents))

(unless (package-installed-p 'use-package)
	(package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Install packages
(use-package diminish) ; Enable :diminish to remove pkg from modeline
(use-package ivy ; Completion
	:diminish
	:config
	(setq ivy-use-virtual-buffers t)
	(setq ivy-count-format "(%d/%d) ")
	(ivy-mode 1))

(use-package monokai-pro-theme
  :config
  (load-theme 'monokai-pro-spectrum t))
(use-package doom-modeline
	:ensure t
	:init (doom-modeline-mode 1))
(use-package all-the-icons) ; Modeline icons

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

;; General
(use-package general
    :config

    (general-unbind "C-SPC")

    (general-define-key
     :keymaps 'override 
     "s-<backspace>" (lambda ()
			(interactive)
			(kill-line 0)
			(indent-according-to-mode)))

    (general-create-definer leader-def
	:keymaps 'override
	:states '(normal visual motion insert emacs)
	:prefix "SPC"
	:global-prefix "C-SPC")

    (leader-def
	"" '(nil :which-key "leader")

	"e" '(nil :which-key "eval")
	"ee" '(eval-expression :which-key "expression")
	"eb" '(eval-buffer :which-key "buffer")

	"h" '(nil :which-key "help")
	"hp" '(describe-package :which-key "package")
	"hf" '(counsel-describe-function :which-key "function")
	"hk" '(describe-key :which-key "key")
	"hv" '(counsel-describe-variable :which-key "variable")

	"f" '(counsel-find-file :which-key "open file")
	"x" '(execute-extended-command :which-key "execute")
	"b" '(counsel-switch-buffer :which-key "open buffer")))


; Scroll settings
(setq scroll-margin 5
      scroll-conservatively 101
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      scroll-preserve-screen-position t
      auto-window-vscroll nil)

;; Evil keybindings
(use-package evil
	:init
	(setq evil-want-C-u-scroll t)
	(setq evil-want-integration t)
	(setq evil-want-keybinding nil)
	(setq evil-undo-system 'undo-redo)
	:config
	(evil-mode 1))

(use-package evil-collection
    :config
    (evil-collection-init)) ; Evil keybindings for other modes

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :general
  (leader-def "p" 'projectile-command-map)
  (general-unbind 'projectile-command-map "ESC")
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))
  
;; Avy -- jump to location
(use-package avy
  :general
  (general-define-key
   :keymaps 'override
   "s-;" 'avy-goto-char-timer))

;; Hydra -- Helix-like popup palettes
;(use-package hydra)

;(defhydra hydra-goto (global-map "<f2>")
;  "goto"
;  ("g" evil-goto-first-line "Goto file start"))

;; Keybindings
(global-set-key (kbd "<escape>") 'keyboard-quit)

(global-set-key (kbd "s-h") 'evil-window-left)
(global-set-key (kbd "s-j") 'evil-window-down)
(global-set-key (kbd "s-k") 'evil-window-up)
(global-set-key (kbd "s-l") 'evil-window-right)


;; Ruby
; TODO: There's a way to get better highlighting
(add-hook 'ruby-ts-mode-hook
	  (lambda ()
	    (make-local-variable 'treesit-font-lock-level)
	    (setq treesit-font-lock-level 4)))

;; Auto-generated garbage

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e3a1b1fb50e3908e80514de38acbac74be2eb2777fc896e44b54ce44308e5330" "fb83a50c80de36f23aea5919e50e1bccd565ca5bb646af95729dc8c5f926cbf3" default))
 '(package-selected-packages
   '(avy evil-surround projectile which-key general use-package monokai-pro-theme ivy hydra evil-collection doom-modeline diminish all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
