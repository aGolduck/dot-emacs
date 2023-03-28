# dot-emacs
personal emacs config


## 终端 true color 真彩支持

### tdlr

TERM=xterm-direct emacs -nw

可能需要将终端类型设置为 xterm-256color
不管使用不使用 tmux，远程或者非远程都好，不需要对 tmux 进行特殊设置

更多详细信息可见：https://www.gnu.org/software/emacs/manual/html_node/efaq/Colors-on-a-TTY.html

### emacs version < 27.1

```
$ cat terminfo-custom.src

xterm-emacs|xterm with 24-bit direct color mode for Emacs,
  use=xterm-256color,
  setb24=\E[48\:2\:\:%p1%{65536}%/%d\:%p1%{256}%/%{255}%&\
     %d\:%p1%{255}%&%dm,
  setf24=\E[38\:2\:\:%p1%{65536}%/%d\:%p1%{256}%/%{255}%&\
     %d\:%p1%{255}%&%dm,

$ tic -x -o ~/.terminfo terminfo-custom.src

$ TERM=xterm-emacs emacs -nw
```

### emacs version >= 27.1

```
$ TERM=xterm-direct infocmp | grep seta[bf]

  setab=\E[%?%p1%{8}%<%t4%p1%d%e48\:2\:\:%p1%{65536}%/\
     %d\:%p1%{256}%/%{255}%&%d\:%p1%{255}%&%d%;m,
  setaf=\E[%?%p1%{8}%<%t3%p1%d%e38\:2\:\:%p1%{65536}%/\
     %d\:%p1%{256}%/%{255}%&%d\:%p1%{255}%&%d%;m,

$ TERM=xterm-direct emacs -nw
```
