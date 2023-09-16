;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

(setq doom-font (font-spec :family "Menlo" :size 14 :weight 'regular))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'monokai-pro-spectrum)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how


;; ==== USER CONFIG ====

;; == Startup ==
; Start emacs in fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; == Evil Mode ==
(map! :n "U" #'evil-redo
      :nv "C-j" #'evil-scroll-line-down
      :nv "C-k" #'evil-scroll-line-up)

;; == Projectile ==
; Tell projectile to look for projects here
(setq projectile-project-search-path
      ; ("dir" . 1) finds projects "dir/proj1", "dir/proj2", ...
      '(("~/Projects" . 1)))

;; == Company ==
; Disable company in org mode
(after! company
  (setq company-global-modes '(not org-mode)))
(map! :after company
      :map company-active-map
      "<tab>" #'company-complete-selection)

;; == Org mode ==
; Default directory
(setq org-directory "~/Notes/")
; Default notes file
(setq org-default-notes-file (concat org-directory "notes.org"))
; Set code folding keybinds. Also works in doom-docs-mode
(map! :after evil-org
      :mode evil-org-mode
      :n "s-j" #'org-forward-element ; Navigation
      :n "s-k" #'org-backward-element
      :n "s-h" #'org-up-element
      :n "s-l" #'org-down-element
      :n "s-K" #'org-metaup
      :n "s-J" #'org-metadown
      :n "s-K" #'org-metaup
      :n "s-H" #'org-do-promote
      :n "s-L" #'org-do-demote
      :n "C-s-j" #'org-shiftmetadown
      :n "C-s-k" #'org-shiftmetaup

      :n "z o" #'org-fold-show-subtree ; Code folding
      :n "z O" #'org-fold-show-all
      :n "z c" #'org-fold-hide-subtree
      :n "z C" #'org-fold-hide-sublevels)

;; = Org Chef =
(after! org
  (setq org-capture-templates
      (append org-capture-templates
              '(("c" "Cookbook" entry (file "~/Notes/cookbook.org")
                 "%(org-chef-get-recipe-from-url)"
                 :empty-lines 1)
                ("m" "Manual Cookbook" entry (file "~/Notes/cookbook.org")
                 "* %^{Recipe title: }\n\
                  :PROPERTIES:\n  :source-url:\n  :servings:\n  :prep-time:\n  :cook-time:\n\
                  :ready-in:\n  :END:\n** Ingredients\n   %?\n** Directions\n\n")))))



;; == Workspaces ==
; Have emacsclient open in the main workspace instead of a new one
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; == Eshell ==
; Set command-backspace to delete to shell line start
(map! :after eshell
      ;; :map (eshell-mode-map eshell-command-map)
      :mode eshell-mode
      :i "s-<backspace>" #'eshell-kill-input)

;; == Comint (repl modes) ==
; Set the normal terminal keybinds to work in repl modes
(map! :after comint-mode-hook
      :map comint-mode-map
      "C-d" #'comint-send-eof ; FIXME overridden
      "C-c" #'comint-interrupt-subjob ; FIXME overridden
      "s-l" #'comint-clear-buffer)


;; ==== MAJOR MODE CONFIG ===

;; == Dired ==
; FIXME Doesn't work?
(remove-hook 'dired-mode-hook 'dired-omit-mode)

;; == Ruby ==

(after! ruby-mode
  (setq ruby-indent-level 2))

; Use robe functions for lookup handlers
(set-lookup-handlers! 'ruby-mode
  :definition #'robe-jump)
