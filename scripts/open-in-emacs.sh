#!/bin/bash

file=$1
line=$2
col=$3

# echo "(progn
#        (find-file \"$file\")
#        (when (not (string= \"\" \"$line\"))
#          (goto-char (point-min))
#          (forward-line (- $line 1))
#          (forward-char (- $col 1))
#        )
#        (select-frame-set-input-focus (selected-frame))
#        (auto-revert-mode t))"

emacsclient -n -e "(progn
       (find-file \"$file\")
       (when (not (string= \"\" \"$line\"))
         (goto-char (point-min))
         (forward-line (- $line 1))
         (forward-char (- $col 1))
       )
       (select-frame-set-input-focus (selected-frame))
       (auto-revert-mode t))"
