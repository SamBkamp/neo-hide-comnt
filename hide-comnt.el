;;; hide-comnt.el --- Hide/show comments in code.
;;
;; Filename: hide-comnt.el
;; Package-Requires: ()
;; Version: 0.1
;; Package-Version: 0.1
;;
;; Description: Hide/show comments in code.
;; Author: Sam Bonnekamp
;; Maintainer: Sam Bonnekamp
;; Created: Wed Sep 24 2025 (+0800)
;; Last-Updated: Wed Sep 24 2025 (+0800)
;; Keywords: comment, hide, show
;; Compatibility: GNU Emacs: 21.x, 22.x, 23.x
;;
;; Features that might be required by this library:
;;
;;   None
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;;; Code:

(defun hide/return-mm-comment-key ()
  "function to return the comment keycharacters based on the major mode"
  (cond
   ((derived-mode-p 'c-mode) "//")
   ((derived-mode-p 'python-mode) "#")
   ((derived-mode-p 'java-mode) "//")
   ((derived-mode-p 'asm-mode) ";")
   ((derived-mode-p 'nasm-mode) ";")
   ((derived-mode-p 'emacs-lisp-mode) ";")
   (t "//")
   )
  )

;(put-text-property cbeg cend 'invisible t)
;;;###autoload
(defun hide/hide-comment-on-line ()
  (interactive)

  (let ((regex (string-match (hide/return-mm-comment-key) (thing-at-point 'line t))))
    (if regex
	(put-text-property (+ (line-beginning-position) regex) (line-end-position) 'invisible t)
      ))

  )

(defun process-marked-lines ()
  "Process lines that are marked in the current buffer."
  (interactive)
  (let ((start (region-beginning))
        (end (region-end)))
    (save-excursion
      (goto-char start)
      (while (< (point) end)
        (hide/hide-comment-on-line)
        (forward-line 1)))))

(global-set-key (kbd "C-x w") 'hide/hide-comment-on-line)
(global-set-key (kbd "C-x r") 'process-marked-lines)



;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'hide-comnt)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; hide-comnt.el ends here
