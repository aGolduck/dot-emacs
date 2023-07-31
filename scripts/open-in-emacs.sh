#!/bin/bash

## 可以用于 Intillij IDEA external tools 调用
## 参数: "$FilePath$" $LineNumber$ $ColumnNumber$
## 双引号处理文件名中间有空格情况

file=$1
line=$2
col=$3

eval_in_emacs="(progn
       (find-file \"$file\")
       (when (not (string= \"\" \"$line\"))
         (goto-char (point-min))
         (forward-line (- $line 1))
         (forward-char (- $col 1))
       )
       (select-frame-set-input-focus (selected-frame))
       (auto-revert-mode t))"

echo ${eval_in_emacs}

emacsclient -n -e "${eval_in_emacs}"
