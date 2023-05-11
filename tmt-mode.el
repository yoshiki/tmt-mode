;;; tmt-mode.el --- Major mode for editing Text::MicroTemplate syntax

;; Copyright (C) 2009  Yoshiki Kurihara

;; Author: Yoshiki Kurihara <kurihara at cpan.org>
;; Keywords: perl template mode

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This is a major mode for editing files written in Text::MicroTemplate syntax.

;;; Installation:
 
;; To install, just drop this file into a directory in your
;; `load-path' and (optionally) byte-compile it. To automatically
;; handle files ending in `.mt', add something like:
;;
;; (autoload 'tmt-mode "tmt-mode"
;;          "Major mode for editing Text::MicroTemplate syntax")
;; (add-to-list 'auto-mode-alist '("\\.mt$" . tmt-mode))
;;
;; to your .emacs file.
;;
;; To use syntax of Mojo::Template '<% ... %>',
;; set `tmt-default-tag-char' to `tmt-mode-hook'
;;
;; (add-hook 'tmt-mode-hook
;;          '(lambda () (setq tmt-default-tag-char "%")))

;;; Code:

(require 'tempo)

(defgroup tmt nil  "Support for the Text::MicroTemplate format"
  :group 'languages
  :prefix "tmt-")

(defcustom tmt-mode-hook nil
  "*Hook run by `tmt-mode'."
  :type  'hook
  :group 'tmt)

(defcustom tmt-default-tag-char "?"
  "*Text::MicroTemplate default tag charactor"
  :type  'char
  :group 'tmt)

(defconst tmt-mode-version "0.0.1" "Version of `tmt-mode.'")

(run-hooks 'tmt-mode-hook)

(defvar tmt-start-tag
  (concat "<" tmt-default-tag-char)
  "Text::MicroTemplate start tag.")

(defvar tmt-end-tag
  (concat tmt-default-tag-char ">")
  "Text::MicroTemplate start tag.")

(defvar tmt-start-line tmt-default-tag-char
  "Text::MicroTemplate start line.")

(defcustom tmt-highlight-tag-face font-lock-keyword-face
  "Face to highlight Text::MicroTemplate tag.")

(defcustom tmt-highlight-comment-face font-lock-comment-face
  "Face to highlight Text::MicroTemplate comment.")

(defvar tmt-font-lock-keywords
   `(
    ("\\(<\\(\\?\\|\%\\).+?\\(\\?\\|\%\\)>\\)?" 0 ,tmt-highlight-tag-face t)
    ("\\(<\\(\\?\\|\%\\)#.+\\(\\?\\|\%\\)>\\)?" 0 ,tmt-highlight-comment-face t)
    ("^\\(\\(\\?\\|\%\\).+\\)?" 0 ,tmt-highlight-tag-face t)
    ("^\\(\\(\\?\\|\%\\)#.+\\)?" 0 ,tmt-highlight-comment-face t)
    )
   "Additional expressions to highlight in Text::MicroTemplate mode.")

(require 'tempo)
(tempo-define-template
 "tmt-insert-tag"
 '(tmt-start-tag " "
   (p "Value: ")
   " " tmt-end-tag))

(tempo-define-template
 "tmt-insert-tag-with-equal"
 '(tmt-start-tag "= "
   (p "Value: ")
   " " tmt-end-tag))

(tempo-define-template
 "tmt-insert-start-line"
 '(tmt-start-line))

(defvar tmt-mode-map ()
  "Keymap used in `tmt-mode' buffers.")

(if tmt-mode-map
    nil
  (setq tmt-mode-map (make-sparse-keymap))
  (define-key tmt-mode-map "\C-ci" 'tempo-template-tmt-insert-tag)
  (define-key tmt-mode-map "\C-ce" 'tempo-template-tmt-insert-tag-with-equal)
  (define-key tmt-mode-map "\C-cl" 'tempo-template-tmt-insert-start-line)
  )

;;;###autoload
(define-derived-mode tmt-mode fundamental-mode "Text::MicroTemplate"
  "Simple mode to edit Text::MicroTemplate.

\\{tmt-mode-map}"
  (set (make-local-variable 'font-lock-defaults)
       '(tmt-font-lock-keywords nil nil nil nil)))

(defun tmt-mode-version ()
  "Diplay version of `tmt-mode'."
  (interactive)
  (message "tmt-mode %s" tmt-mode-version)
  tmt-mode-version)

(provide 'tmt-mode)
;;; tmt-mode.el ends here
