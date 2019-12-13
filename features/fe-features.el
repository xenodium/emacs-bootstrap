;; Only use ar/init--idle-load with string literal paths.
(if ar/init-debug-init
    (defmacro ar/init--idle-load (library)
      `(load ,library))
  (defmacro ar/init--idle-load (library)
    `(run-with-idle-timer 0.5 nil
                          (lambda ()
                            (load ,library)))))

;; Load before remaining. Useful for debugging init.el issues.
(ar/init--idle-load "~/.emacs.d/features/fe-maintenance")

;; Load all others features on idle. Alphabetically listed.
;; For example:
;; (ar/init--idle-load "~/.emacs.d/features/fe-python")
;; (ar/init--idle-load "~/.emacs.d/features/fe-swift")

(run-with-idle-timer
 0.5 nil
 (lambda ()
   ;; Load local elisp.
   (dolist (file (file-expand-wildcards "~/.emacs.d/local/*.el"))
     ;; Not using ar/init--idle-load explicit paths not known.
     (load file))

   ;; Load work elisp.
   (dolist (file (file-expand-wildcards "~/.emacs.d/work/*.el"))
     ;; Not using ar/init--idle-load explicit paths not known.
     (load file))))

;; Start Emacs server.
(ar/init--idle-load "~/.emacs.d/features/fe-server")
