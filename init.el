;; Nick Aldwin

;; Fix clipboard problems
;; ** CHANGED FOR EMACS 30: START **
;; x-select-enable-clipboard was renamed to select-enable-clipboard in Emacs 25.1
(set (if (boundp 'select-enable-clipboard)
         'select-enable-clipboard
       'x-select-enable-clipboard) t)
;; ** CHANGED FOR EMACS 30: END **

;; ** CHANGED FOR EMACS 30: START **
;; Flymake legacy variable compatibility.
;; Some older third-party Flymake integrations expect `flymake-allowed-file-name-masks`
;; to exist. In Emacs 30, the legacy proc backend uses `flymake-proc-allowed-file-name-masks`.
(require 'flymake nil t)
(require 'flymake-proc nil t)
(when (and (not (boundp 'flymake-allowed-file-name-masks))
           (boundp 'flymake-proc-allowed-file-name-masks))
  (defvaralias 'flymake-allowed-file-name-masks
    'flymake-proc-allowed-file-name-masks))
(unless (boundp 'flymake-allowed-file-name-masks)
  (defvar flymake-allowed-file-name-masks nil))
;; ** CHANGED FOR EMACS 30: END **

;; ** CHANGED FOR EMACS 30: START **
;; Shims for old cl functions used by vendored packages.
;; In Emacs 27+, cl was deprecated in favor of cl-lib.  These aliases let old
;; packages that use (require 'cl) continue to work without modification.
;; TODO @NJA: Upgrade vendored packages and remove these shims.
(require 'cl-lib)
(dolist (fn '(rotatef case block return-from loop destructuring-bind))
  (let ((cl-fn (intern (concat "cl-" (symbol-name fn)))))
    (when (and (fboundp cl-fn) (not (fboundp fn)))
      (defalias fn cl-fn))))
;; ** CHANGED FOR EMACS 30: END **

;; Add load paths (only if directory exists)
;; ** CHANGED FOR EMACS 30: START **
(when (file-directory-p "~/.emacs.d/libs/")
  (add-to-list 'load-path "~/.emacs.d/libs/"))
;; ** CHANGED FOR EMACS 30: END **
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
;; ** CHANGED FOR EMACS 30: START **
;; Use modern solarized-emacs (with selenized) on Emacs 24+, fall back to old color-theme.
;; Provides `use-theme-dark` and `use-theme-light` to switch variants interactively.
;; TODO @NJA: Once old Emacs support is dropped, remove color-theme fallback.
(defvar nja-theme-variant 'dark
  "Current theme variant: 'dark or 'light.")

(defvar nja-use-modern-theme
  (and (>= emacs-major-version 24)
       (file-directory-p "~/.emacs.d/solarized-emacs/"))
  "Non-nil if using modern solarized-emacs theme.")

(when nja-use-modern-theme
  (add-to-list 'load-path "~/.emacs.d/solarized-emacs/")
  (add-to-list 'custom-theme-load-path "~/.emacs.d/solarized-emacs/"))

(defun use-theme-dark ()
  "Switch to dark theme variant (selenized-dark or solarized dark)."
  (interactive)
  (setq nja-theme-variant 'dark)
  (if nja-use-modern-theme
      (progn
        (mapc #'disable-theme custom-enabled-themes)
        (load-theme 'solarized-selenized-dark t))
    (progn
      (set-frame-parameter nil 'background-mode 'dark)
      (set-terminal-parameter nil 'background-mode 'dark)
      (enable-theme 'solarized))))

(defun use-theme-light ()
  "Switch to light theme variant (selenized-light or solarized light)."
  (interactive)
  (setq nja-theme-variant 'light)
  (if nja-use-modern-theme
      (progn
        (mapc #'disable-theme custom-enabled-themes)
        (load-theme 'solarized-selenized-light t))
    (progn
      (set-frame-parameter nil 'background-mode 'light)
      (set-terminal-parameter nil 'background-mode 'light)
      (enable-theme 'solarized))))

(defun use-theme-toggle ()
  "Toggle between dark and light theme variants."
  (interactive)
  (if (eq nja-theme-variant 'dark)
      (use-theme-light)
    (use-theme-dark)))

;; Initialize theme
(if nja-use-modern-theme
    (load-theme 'solarized-selenized-dark t)
  (progn
    (require 'color-theme)
    (require 'color-theme-solarized)
    (setq-default solarized-termcolors 256)
    (when (not window-system)
      (setq-default solarized-degrade t))
    (color-theme-solarized)))
;; ** CHANGED FOR EMACS 30: END **

;; Smart Tab (from https://github.com/genehack/smart-tab )
(require 'smart-tab)
(global-smart-tab-mode 1)
(setq smart-tab-using-hippie-expand t)

;; Flyspell
(require 'flyspell)
(global-set-key [M-down-mouse-1] 'flyspell-correct-word)
;; ** CHANGED FOR EMACS 30: START **
;; Only enable flyspell when buffer is actually selected and idle, not during
;; desktop restore.  This prevents thundering herd of aspell processes.
;; Uses a single repeating idle timer that only processes current buffer.
(defvar nja-flyspell-pending-buffers nil
  "Buffers waiting for flyspell to be enabled.")

(defvar nja-flyspell-idle-timer nil
  "Idle timer for enabling flyspell.")

(defun nja-flyspell-maybe-enable ()
  "Enable flyspell in current buffer if it's pending.  Only runs when idle."
  (let ((buf (current-buffer)))
    (when (and (memq buf nja-flyspell-pending-buffers)
               (buffer-live-p buf)
               (executable-find "aspell"))
      (setq nja-flyspell-pending-buffers (delq buf nja-flyspell-pending-buffers))
      (flyspell-mode 1)
      (flyspell-buffer))
    ;; Cancel timer if no more pending buffers
    (when (and (null nja-flyspell-pending-buffers) nja-flyspell-idle-timer)
      (cancel-timer nja-flyspell-idle-timer)
      (setq nja-flyspell-idle-timer nil))))

(defun turn-on-flyspell-lazy ()
  "Mark buffer for flyspell, enable when buffer is viewed and idle."
  (let ((buf (current-buffer)))
    (unless (memq buf nja-flyspell-pending-buffers)
      (push buf nja-flyspell-pending-buffers))
    ;; Start the idle timer if not running (single timer handles all buffers)
    (unless nja-flyspell-idle-timer
      (setq nja-flyspell-idle-timer
            (run-with-idle-timer 2 t #'nja-flyspell-maybe-enable)))))
;; ** CHANGED FOR EMACS 30: END **

;; Markdown Mode
(require 'markdown-mode)
;; ** CHANGED FOR EMACS 30: START **
;; Old markdown-mode doesn't define header-face-7; define it to stop warnings.
;; TODO @NJA: Upgrade to newer markdown-mode and remove this workaround.
(unless (facep 'markdown-header-face-7)
  (defface markdown-header-face-7
    '((t (:inherit markdown-header-face)))
    "Face for level-7 markdown headers."))
;; ** CHANGED FOR EMACS 30: END **
(add-to-list 'auto-mode-alist
             (cons "\\.m\\(ar\\)?k?d\\(\\o?w?n\\|te?xt\\)?\\'" 'gfm-mode))
;(add-hook 'markdown-mode-hook 'turn-on-auto-fill)
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
;; ** CHANGED FOR EMACS 30: START **
;; These modes are now built-in (Emacs 25+) or provided by magit.
;; Only load vendored versions if the features aren't already available.
;; TODO @NJA: Remove vendored git-modes; rely on built-ins or magit.
(unless (featurep 'git-commit)
  (require 'git-commit-mode nil t))
(unless (featurep 'git-rebase)
  (require 'git-rebase-mode nil t))
(unless (featurep 'gitattributes-mode)
  (require 'gitattributes-mode nil t))
(unless (featurep 'gitconfig-mode)
  (require 'gitconfig-mode nil t))
(unless (featurep 'gitignore-mode)
  (require 'gitignore-mode nil t))
;; ** CHANGED FOR EMACS 30: END **

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
;; ** CHANGED FOR EMACS 30: START **
;; linum-mode was removed in Emacs 30; use display-line-numbers-mode (Emacs 26+)
(if (fboundp 'display-line-numbers-mode)
    (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (when (fboundp 'linum-mode)
    (add-hook 'prog-mode-hook 'linum-mode)))
;; ** CHANGED FOR EMACS 30: END **

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
  (use-laptop)
  (global-set-key [kp-delete] 'delete-char))

;; Go away, startup screen
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
