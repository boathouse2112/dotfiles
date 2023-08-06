(setq inhibit-startup-message t)

(scroll-bar-mode -1)	; Disable visible scroll bar
(tool-bar-mode -1)		; Disable toolbar
; (tooltip-mode -1)		; Disable tooltips
(set-fringe-mode 10)	; Give some breathing room

(menu-bar-mode -1)		; Disable menu bar

;; Font face
(set-face-attribute 'default nil :font "Menlo" :height 150)

(load-theme 'wombat)

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
	(ivy-mode 1))

(use-package monokai-pro-theme)
(use-package doom-modeline
	:ensure t
	:init (doom-modeline-mode 1))
(use-package all-the-icons) ; Modeline icons

;; General

;; Paren settings
(setq blink-matching-delay 0)

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
	:config
	(evil-mode 1)
	)

(use-package evil-collection
  :config
  (evil-collection-init)) ; Evil keybindings for other modes

;; Hydra -- Helix-like popup palettes
;(use-package hydra)

;(defhydra hydra-goto (global-map "<f2>")
;  "goto"
;  ("g" evil-goto-first-line "Goto file start"))
  


;; Keybindings
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "s-<backspace>")
		(lambda ()
		    (interactive)
		    (kill-line 0)
		    (indent-according-to-mode)))


;; Auto-generated garbage

