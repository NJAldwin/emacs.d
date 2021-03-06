;; Nick Aldwin

;; Fix clipboard problems
(setq x-select-enable-clipboard t)

;; Add load paths
(add-to-list 'load-path "~/.emacs.d/libs/")
(add-to-list 'load-path "~/.emacs.d/utils/")
(add-to-list 'load-path "~/.emacs.d/modes/")
(add-to-list 'load-path "~/.emacs.d/modes/coffee-mode")
(add-to-list 'load-path "~/.emacs.d/modes/markdown-mode")
(add-to-list 'load-path "~/.emacs.d/modes/json-mode")
(add-to-list 'load-path "~/.emacs.d/modes/web-mode")
(add-to-list 'load-path "~/.emacs.d/modes/js2-mode")
(add-to-list 'load-path "~/.emacs.d/modes/yaml-mode")
(add-to-list 'load-path "~/.emacs.d/modes/haml-mode")
(add-to-list 'load-path "~/.emacs.d/modes/scss-mode")
(add-to-list 'load-path "~/.emacs.d/modes/sass-mode")
(add-to-list 'load-path "~/.emacs.d/modes/rust-mode")
(add-to-list 'load-path "~/.emacs.d/modes/toml-mode")
(add-to-list 'load-path "~/.emacs.d/modes/git-modes")
(add-to-list 'load-path "~/.emacs.d/modes/puppet-syntax-emacs")
(add-to-list 'load-path "~/.emacs.d/modes/jade-mode")
(add-to-list 'load-path "~/.emacs.d/color-theme/")
(add-to-list 'load-path "~/.emacs.d/emacs-color-theme-solarized/")
(add-to-list 'load-path "~/.emacs.d/deft/")

;; Path for executables
(if (eq system-type 'darwin)
    (add-to-list 'exec-path "/usr/local/bin/"))

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

;; Set font on OS X
(when (and (eq system-type 'darwin)
         (member "Source Code Pro" (font-family-list)))
  (set-face-attribute 'default nil :family "Source Code Pro")
  (set-face-attribute 'default nil :height 130))

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

;; Desktop & Window
(desktop-save-mode 1)
(setq desktop-restore-eager 5)
(winner-mode 1)

;; Color theme
(require 'color-theme)
(require 'color-theme-solarized)
(setq-default solarized-termcolors 256)
(if (not window-system)
    (setq-default solarized-degrade t))
(color-theme-solarized)

;; Smart Tab (from https://github.com/genehack/smart-tab )
(require 'smart-tab)
(global-smart-tab-mode 1)
(setq smart-tab-using-hippie-expand t)

;; Flyspell
(require 'flyspell)
(global-set-key [M-down-mouse-1] 'flyspell-correct-word)
(defun turn-on-flyspell-lazy ()
  "Enable flyspell and lazily flyspell the whole buffer on idle"
  (turn-on-flyspell)
  (run-with-idle-timer 5
                       nil
                       (lambda (buffer)
                         (if (buffer-live-p (get-buffer buffer))
                             (with-current-buffer buffer
                               (flyspell-buffer))))
                       (current-buffer)))

;; Markdown Mode
(require 'markdown-mode)
(add-to-list 'auto-mode-alist
             (cons "\\.m\\(ar\\)?k?d\\(\\o?w?n\\|te?xt\\)?\\'" 'gfm-mode))
(add-hook 'markdown-mode-hook 'turn-on-auto-fill)
(add-hook 'markdown-mode-hook 'turn-on-flyspell-lazy)

;; Coffee Mode
(require 'coffee-mode)
(setq coffee-tab-width 2)

;; JSON Mode
(require 'json-mode)
(setq js-indent-level 2)
(add-to-list 'auto-mode-alist
             (cons ".json" 'json-mode))

;; Protobuf Mode
(require 'protobuf-mode)
(add-to-list 'auto-mode-alist
             (cons ".proto" 'protobuf-mode))

;; Web Mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
)
(add-hook 'web-mode-hook  'web-mode-hook)

;; js2 mode
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq js2-missing-semi-one-line-override t)
(setq js2-mode-show-strict-warnings nil)
(setq js2-strict-missing-semi-warning nil)
(setq js2-strict-trailing-comma-warning nil)

;; YAML mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.[a-z]?ya?ml$" . yaml-mode))

;; SCSS mode
(require 'scss-mode)
(setq scss-compile-at-save nil)
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

;; SASS mode
(require 'haml-mode)
(require 'sass-mode)
(add-to-list 'auto-mode-alist '("\\.sass\\'" . sass-mode))

;; rust mode
(require 'rust-mode)
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

;; toml mode
(require 'toml-mode)

;; Git modes
(require 'git-commit-mode)
(require 'git-rebase-mode)
(require 'gitattributes-mode)
(require 'gitconfig-mode)
(require 'gitignore-mode)

;; Puppet mode
(require 'puppet-mode)
(autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests")
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

;; Jade mode
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.styl\\'" . sws-mode))

;; Ruby mode
(require 'ruby-mode)
(add-to-list 'auto-mode-alist
             '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist
             '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))

;; Word Count mode
;; From http://www.emacswiki.org/emacs/WordCountMode
(require 'wc-mode)
;; wc-based word counting on demand (the above doesn't work for <24)
(defun wc ()
  (interactive)
  (if (use-region-p)
      (shell-command-on-region (point) (mark) "wc")
    (shell-command-on-region (point-min) (point-max) "wc")))
(global-set-key "\C-cw" 'wc)

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
 deft-default-extension "md"
 deft-recursive t
 deft-markdown-mode-title-level 1
 deft-new-file-format "%FT%T%z")
(global-set-key (kbd "<f9>") 'deft)

;; Server
(require 'server)
(require 'server)
(when (and (= emacs-major-version 23)
           (equal window-system 'w32))
  (defun server-ensure-safe-dir (dir) "Noop" t))
(unless (server-running-p)
  (server-start))
(add-hook 'server-done-hook (lambda nil (kill-buffer nil)))

;; Number lines in programming modes
(add-hook 'prog-mode-hook 'linum-mode)

;; SQL
(setq sql-product (quote mysql))
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))

;; PuTTY fix. Ugly. Bad. But it works. (Good)
;; from http://www.emacswiki.org/emacs/PuTTY
(define-key global-map "\M-[1~" 'beginning-of-line) ; HOME
(define-key global-map [select] 'end-of-line) ; END

;; Scrolling
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)
(setq scroll-preserve-screen-position t)
(global-set-key (kbd "<M-up>") 'scroll-down-line)
(global-set-key (kbd "<M-down>") 'scroll-up-line)

;; macOS bindings
(defun use-keyboard ()
  (interactive)
  (setq mac-option-modifier 'super)
  (setq mac-command-modifier 'meta))
(defun use-laptop ()
  (interactive)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super))
(when (eq system-type 'darwin)
  (use-keyboard)
  (global-set-key [kp-delete] 'delete-char))

;; Go away, startup screen
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
