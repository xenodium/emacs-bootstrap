;;; -*- lexical-binding: t; -*-
(use-package s
  :ensure t)

(use-package ht
  :ensure t)

(use-package async
  :ensure t
  :config
  (async-bytecomp-package-mode +1)
  (dired-async-mode +1))

;; flet is no longer available. Use noflet as a replacement.
(use-package noflet
  :ensure t
  :after dash)

;; Timestamp and date/time library.
(use-package ts
  :ensure t)
