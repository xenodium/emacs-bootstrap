;;; -*- lexical-binding: t; -*-
(require 'faces)

(when (display-graphic-p)
  ;; No title. See init.el for initial value.
  (setq frame-title-format nil)
  ;; Avoid native dialogs.
  (setq use-dialog-box nil))

;; Set font face height. Value is 1/10pt.
(set-face-attribute 'default nil
                    :height 160)

(use-package frame
  :init
  ;; Mispressing C-z invokes `suspend-frame' (disable).
  (global-unset-key (kbd "C-z")))

;; Ensure window is maximized after window setup.
(use-package maxframe
  :ensure t
  :hook (window-setup . maximize-frame))

;; Use y/n instead of yes/no confirms.
;; From http://pages.sachachua.com/.emacs.d/Sacha.html#sec-1-4-8
(fset 'yes-or-no-p 'y-or-n-p)

(use-package menu-bar
  ;; No need to confirm killing buffers.
  :bind ("C-x k" . kill-this-buffer))

(use-package face-remap
  :bind(("C-+" . text-scale-increase)
        ("C--" . text-scale-decrease)))

;; From https://www.reddit.com/r/emacs/comments/b5n1yh/weekly_tipstricketc_thread/ejessje?utm_source=share&utm_medium=web2x
(progn
  (defun ar/list-faces-for-color (color &optional distance)
  "List faces which use COLOR as fg or bg color.

            Accept colors within DISTANCE which defaults to 0."
  (interactive (list (read-color "Color: ")
                     (and current-prefix-arg
                          (prefix-numeric-value current-prefix-arg))))
  (with-help-window (get-buffer-create (format " *%s*" this-command))
    (dolist (face (sort
                   (ar/list-faces--for-color color distance)
                   (lambda (f1 f2)
                     (string< (symbol-name f1)
                              (symbol-name f2)))))
      (ar/list-faces--print-face face)
      (terpri))))

(defun ar/list-faces--print-face (face)
  "Print face and its parents if any."
  (with-current-buffer standard-output
    (let ((fchain (cdr (ar/list-faces--inheritance-chain face :foreground)))
          (bchain (cdr (ar/list-faces--inheritance-chain face :background))))
      (insert (propertize (format "%s" face) 'face face))
      (cond (fchain
             (dolist (face fchain)
               (insert " > " (propertize (format "%s" face) 'face face))))
            (bchain
             (dolist (face bchain)
               (insert " > " (propertize (format "%s" face) 'face face))))))))

(defun ar/list-faces--inheritance-chain (face attr)
  "Return inheritence change for face and attr."
  (let ((g (face-attribute face attr)))
    (if (and (stringp g)
             (not (string= "unspecified" g)))
        (list face)
      (let ((inherit (face-attribute face :inherit)))
        (when inherit
          (if (facep inherit)
              (cons face
                    (ar/list-faces--inheritance-chain inherit attr))
            (if (consp inherit)
                (cl-dolist (face inherit)
                  (let ((res nil))
                    (when (and (facep face)
                               (setq res (ar/list-faces--inheritance-chain face attr)))
                      (cl-return res)))))))))))


(defun ar/list-faces--attribute (face attr)
  "Get face attribute of face as defined or inherited."
  (let* ((chain (ar/list-faces--inheritance-chain face attr)))
    (cl-dolist (f (nreverse chain))
      (let ((g (face-attribute f attr)))
        (when (and (stringp g)
                   (not (string= "unspecified" g)))
          (cl-return g))))))

(defun ar/list-faces--for-color (color &optional distance)
  "Return all faces with COLOR as fg or bg withing DISTANCE."
  (let ((faces ())
        (distance (or distance 0)))
    (mapatoms (lambda (atom)
                (when (facep atom)
                  (let ((fg (ar/list-faces--attribute atom :foreground))
                        (bg (ar/list-faces--attribute atom  :background)))
                    (when (or (and fg
                                   (<= (color-distance
                                        fg
                                        color)
                                       distance))
                              (and bg
                                   (<= (color-distance
                                        bg
                                        color)
                                       distance)))
                      (push atom faces))))))
    (delete-dups faces))))

(defun ar/pick-font ()
  (interactive)
  (let ((font-name (completing-read "Select font:"
                                    (font-family-list))))
    (if (member font-name (font-family-list))
        (set-face-attribute 'default nil :font font-name)
      (error "'%s' font not found" font-name))))
