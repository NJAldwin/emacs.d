;; Nick Aldwin

;; Fix clipboard problems
(setq x-select-enable-clipboard t)

;; Add load paths
(add-to-list 'load-path "~/.emacs.d/utils/")
(add-to-list 'load-path "~/.emacs.d/modes/")
(add-to-list 'load-path "~/.emacs.d/modes/coffee-mode")
(add-to-list 'load-path "~/.emacs.d/modes/markdown-mode")
(add-to-list 'load-path "~/.emacs.d/modes/json-mode")
(add-to-list 'load-path "~/.emacs.d/color-theme/")
(add-to-list 'load-path "~/.emacs.d/emacs-color-theme-solarized/")
(add-to-list 'load-path "~/.emacs.d/deft/")

;; Get machine name
(defvar this-machine "default"
  "The hostname of this machine.")
(if (getenv "HOST")
    (setq this-machine (getenv "HOST")))
(if (string-match "default" this-machine)
    (if (getenv "HOSTNAME")
        (setq this-machine (getenv "HOSTNAME"))))
(if (string-match "default" this-machine)
    (setq this-machine system-name))

;; Set font if on Windows
(if (equal system-type 'windows-nt)
    (custom-set-faces
     '(default ((t (:inherit nil :stipple nil :background "SystemWindow" :foreground "SystemWindowText" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "outline" :family "Consolas"))))))

;; Kill toolbar
(tool-bar-mode -1)

;; Interactively do
(ido-mode 'both)
;; Fuzzy Matching
(setq ido-enable-flex-matching t)

;; Bar cursor
(setq-default cursor-type 'bar)

;; Select & type deletes text
(delete-selection-mode 1)

;; Indent using spaces only
(setq-default indent-tabs-mode nil)

;; Column number
(column-number-mode t)

;; Color theme
(require 'color-theme)
(require 'color-theme-solarized)
(setq-default solarized-termcolors 256)
(color-theme-solarized-dark)

;; Smart Tab (from https://github.com/genehack/smart-tab )
(require 'smart-tab)
(global-smart-tab-mode 1)
(setq smart-tab-using-hippie-expand t)

;; Markdown Mode
(require 'markdown-mode)
(add-to-list 'auto-mode-alist
             (cons "\\.m\\(ar\\)?k?d\\(\\o?w?n\\|te?xt\\)?\\'" 'markdown-mode))

;; Coffee Mode
(require 'coffee-mode)

;; JSON Mode
(require 'json-mode)
(add-to-list 'auto-mode-alist
             (cons ".json" 'json-mode))

;; Intelligent buffer renaming
(require 'uniquify)
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*") ; ignore special buffers
(setq uniquify-buffer-name-style 'post-forward)

;; Cache passwords in Tramp
(require 'tramp)
(setq password-cache-expiry nil)

;; Deft
(require 'deft)
(setq
 deft-extension "md"
 deft-text-mode 'markdown-mode)
(global-set-key (kbd "<f9>") 'deft)

;; PuTTY fix. Ugly. Bad. But it works. (Good)
;; from http://www.emacswiki.org/emacs/PuTTY
(define-key global-map "\M-[1~" 'beginning-of-line) ; HOME
(define-key global-map [select] 'end-of-line) ; END

;; Go away, startup screen
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
