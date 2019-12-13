;;; -*- lexical-binding: t; -*-
(when (memq window-system '(mac ns))
  ;; No icon on window.
  (setq ns-use-proxy-icon nil)

  ;; Easily insert # on macOS/UK keyboard.
  ;; https://coffeeandcode.neocities.org/emacs-keyboard-config-on-mac.html
  (global-set-key (kbd "M-3") '(lambda ()
                                 (interactive) (insert "#")))

  ;; Transparent titlebar on macOS (prettier).
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark)))


(when (string-equal system-type "darwin")
  ;; Want menu bar on macOS.
  (use-package menu-bar
    :config
    (menu-bar-mode 1))

  ;; Fixes mode line separator issues on macOS.
  (setq ns-use-srgb-colorspace nil)

  ;; Make ⌘ meta modifier.
  (setq mac-command-modifier 'meta))

;; macOS color picker.
(use-package color-picker
  :commands color-picker)
