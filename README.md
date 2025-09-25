# hide-comnt.el

 A refresh over the old hide-comnt.el plugin. So far it only works for inline comments in C, Java, asm (including nasm-mode) and python.

`C-x w` to hide the comments on a single line

`C-x r` to hide comments on lines in the marked region

install by opening the scratch page `C-x b RET *scratch* RET` or the mini-buffer `M-:` and paste the following line:

```lisp

(package-install-file "/path/to/here/hide-comnt.el")
```

replace the path then hit `C-j` and voila it should be installed. Make sure you also add `(require 'hide-comnt)` to your init file (usually ~/.emacs) to get it to work.