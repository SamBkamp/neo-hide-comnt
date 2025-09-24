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
  "//"
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



;;;###autoload
(defun hide/show-comments (&optional hide/show start end)
  "Hide or show comments from START to END.
Interactively, hide comments, or show them if you use a prefix arg.
Interactively, START and END default to the region limits, if active.
Otherwise, including non-interactively, they default to `point-min'
and `point-max'.

Uses `save-excursion', restoring point.

Be aware that using this command to show invisible text shows *all*
such text, regardless of how it was hidden.  IOW, it does not just
show invisible text that you previously hid using this command.

From Lisp, a HIDE/SHOW value of `hide' hides comments.  Other values
show them.

This function does nothing in Emacs versions prior to Emacs 21,
because it needs `comment-search-forward'."
  (interactive
   (cons (if current-prefix-arg 'show 'hide)
         (if (or (not mark-active) (null (mark)) (= (point) (mark)))
             (list (point-min) (point-max))
           (if (< (point) (mark)) (list (point) (mark)) (list (mark) (point))))))
  (when (require 'newcomment nil t)     ; `comment-search-forward', Emacs 21+.
    (unless start (setq start  (point-min)))
    (unless end   (setq end    (point-max)))
    (unless (<= start end) (setq start  (prog1 end (setq end  start))))
    (let ((bufmodp           (buffer-modified-p))
          (buffer-read-only  nil)
          cbeg cend)
      (unwind-protect
           (save-excursion
             (goto-char start)
             (while (and (< start end) (setq cbeg  (comment-search-forward end 'NOERROR)))
               (setq cend  (if (string= "" comment-end)
                               (min (1+ (line-end-position)) (point-max))
                             (search-forward comment-end end 'NOERROR)))
               (when (and cbeg cend)
                 (if (eq 'hide hide/show)
                     (put-text-property cbeg cend 'invisible t)
                   (put-text-property cbeg cend 'invisible nil)))))
        (set-buffer-modified-p bufmodp)))))

;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'hide-comnt)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; hide-comnt.el ends here
