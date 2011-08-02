;; Nick Aldwin

;; Get machine name
(defvar this-machine "default")
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

;; Interactively do
(ido-mode 'both)

;; Bar cursor
(setq-default cursor-type 'bar)

;; Select & type deletes text
(delete-selection-mode 1)

;; Indent using spaces only
(setq-default indent-tabs-mode nil)