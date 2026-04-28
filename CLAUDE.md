# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Emacs configuration using a modular, layered architecture. All custom modules use the `w-` prefix and reside in `lisp/`. Package management is handled by `straight.el`.

## Architecture

### Loading Hierarchy

The configuration loads in layers, each building on the previous:

```
init.el
├── w-minimal         → Built-in packages only, core settings
│   ├── w-programming-minimal
│   ├── w-file-minimal
│   ├── w-ui-minimal
│   └── w-font
├── w-straight        → Package manager bootstrap
├── w-essential       → Core third-party packages
│   ├── w-pyim, w-ace-window, w-term-extra, w-dired-extra, w-git
│   ├── w-search-extra, w-minibuffer, w-company
│   ├── w-lisp, w-programming-essential
│   └── w-projectile
└── w-full            → Full feature set
    ├── w-dired-plus, w-term-full, w-org
    ├── w-programming-full
```

### Key Directories

- `lisp/` - Core configuration modules (all prefixed `w-`)
- `site-lisp/` - Local utility packages
- `var/` - Runtime data (bookmarks, history, caches)
- `straight/` - Package management
  - `repos/` - Shared package sources (symlinked)
  - `straight-<version>/` - Version-specific builds

### Package Management

Uses `straight.el` with version-specific isolation via `straight-base-dir`. Packages declared with `(straight-use-package ...)`. Built-in packages are explicitly declared to prevent external reinstallation:

```elisp
(straight-use-package '(org :type built-in))
```

## Key Bindings

All user commands use `M-SPC` as prefix:

- `M-SPC SPC` - `execute-extended-command`
- `M-SPC g s` - magit-status
- `M-SPC s p` - consult-ripgrep (or consult-grep)
- `M-SPC f r` - crux-recentf-find-file
- `M-SPC v` - expand-region

## Completion System

- Minibuffer: vertico + orderless + consult + marginalia + embark
- In-buffer: company-mode
- Chinese input: pyim

## Project Detection

Custom `w/project-try-local` detects projects by these markers (in priority order):
1. `.project`
2. `go.mod`, `Cargo.toml`, `project.clj`, `pom.xml`, `package.json`
3. `Makefile`, `README.org`, `README.md`


## Language Support

Tree-sitter modes enabled for: Go, TypeScript, YAML, CMake, Dockerfile. Custom quickrun commands for Maven tests, Deno, Clojure, Scala.

## Tree-Sitter 故障排查

Grammar 文件存放在 `~/.emacs.d/tree-sitter/`（已 gitignore）。`w-explore.el` 中启用了 `global-treesit-auto-mode`（via `treesit-auto` 包），会自动将传统 major-mode remap 到对应的 `-ts-mode`。

### 诊断步骤

当某语言的 tree-sitter mode 不工作时，按以下顺序排查：

```elisp
;; 1. 检查 Emacs 是否编译了 tree-sitter 支持
(treesit-available-p) ; => t

;; 2. 检查某语言 grammar 是否可用，第二个参数 t 返回详细错误
(treesit-language-available-p 'rust t) ; => (t) 或 (nil reason ...)

;; 3. 检查 Emacs 支持的 ABI 版本范围
(treesit-library-abi-version)   ; 最高支持的 ABI（如 14）
(treesit-library-abi-version t) ; 最低支持的 ABI（如 13）
```

### 常见问题：ABI 版本不匹配

**症状**：`(treesit-language-available-p 'lang t)` 返回 `(nil version-mismatch N)`

**原因**：grammar `.so` 编译时使用的 tree-sitter 版本比系统安装的 libtree-sitter 更新，导致 ABI 不兼容。例如 Emacs 链接的 libtree-sitter 0.23（ABI 14），但 grammar 源码 master 分支已升级到 ABI 15。

**修复方案 A（推荐）：升级 libtree-sitter 并重编译 Emacs**

从根本上解决问题，使 grammar 可直接从 master 分支编译：

```bash
# 1. 编译安装新版 libtree-sitter（选 >= 0.25 的版本以获得 ABI 15）
cd /tmp && git clone https://github.com/tree-sitter/tree-sitter.git
cd tree-sitter && git checkout v0.25.3
make -j$(nproc) && sudo make install PREFIX=/usr/local && sudo ldconfig

# 2. 重编译 Emacs（用 emacs-30 分支 tip，包含 Bug#78754 修复）
cd /tmp && git clone --depth 1 --branch emacs-30 https://github.com/emacs-mirror/emacs.git emacs-30
cd emacs-30 && ./autogen.sh
./configure --with-tree-sitter \
  PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
  CFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib"
make -j$(nproc) && sudo make install

# 3. 重编译所有 grammar（不再需要指定旧版 tag）
# 在 Emacs 中：M-x treesit-install-language-grammar
```

**修复方案 B（备选）：指定兼容的旧版 tag 重新编译 grammar**

不升级系统组件，仅降级 grammar 版本以匹配当前 ABI：

```elisp
;; 先查看 grammar 仓库的 tag 列表，选择与系统 ABI 匹配的版本
;; 例如系统 ABI 14 对应 tree-sitter 0.23.x，选 grammar 的 v0.23.x tag
(setq treesit-language-source-alist
      '((rust "https://github.com/tree-sitter/tree-sitter-rust" "v0.23.3")))
(treesit-install-language-grammar 'rust)
```

**版本对应关系**（供参考）：
- ABI 14 → tree-sitter 0.22.x ~ 0.24.x → grammar 选 v0.23.x 或更早的 tag
- ABI 15 → tree-sitter >= 0.25 → grammar 可直接用 master 分支

**当前环境**：Emacs 30.2.50 (emacs-30 branch), libtree-sitter 0.25.3, ABI 13-15

## Terminal True Color

For true color in terminal Emacs (v27.1+):
```bash
TERM=xterm-direct emacs -nw
```
