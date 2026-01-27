# Config Inventory: Discovery Phase Results

**Date**: 2025-01-27
**Target**: `~jcdev` contributor environment for WSL Debian

---

## 1. Source Configuration Summary

| User | tmux | vim | shell | bin/ scripts |
|------|------|-----|-------|--------------|
| `be-dev-agent` | Comprehensive | Basic (unused) | Rich aliases + prompt | 30+ tools |
| `javadev` | None | Minimalist + vim-plug | Java-focused | 1 (jira) |
| `psdev` | None | None | Default | None |

---

## 2. be-dev-agent Inventory

### tmux Configuration (`~/.tmux.conf`)
**Status**: Production-ready, PaymentService-optimized

| Feature | Implementation | Notes |
|---------|---------------|-------|
| Prefix key | `Ctrl-a` | Ergonomic choice |
| Mouse support | Enabled | Full scrolling/selection |
| Pane navigation | vim-style (`h/j/k/l`) | Also Alt-arrow |
| Window numbering | 1-based | Keyboard-friendly |
| Scrollback | 50,000 lines | Generous for log review |
| Copy mode | vi-style | `v` select, `y` yank |
| Status bar | Custom | Shows my-context, pwd, time |
| Escape time | 0ms | Fast for vim users |

**Custom Bindings**:
- `Prefix + P` - Load PaymentService dev layout
- `Prefix + J` - Jira issues popup
- `Prefix + M` - my-context status
- `Prefix + G` - Git status popup

**Layout File** (`~/.tmux/layouts/paymentservice-dev.conf`):
```
+------------------+----------+
|   Main Editor    |  Logs    |
+------------------+----------+
|   Commands/Tests            |
+-----------------------------+
```

### Shell Configuration (`~/.bash_aliases`)
**Status**: Production-ready

**my-context Aliases**:
```bash
cx   = my-context
cxs  = my-context start
cxn  = my-context note
cxf  = my-context file
cxl  = my-context list
cxw  = my-context show
cxe  = my-context export
```

**Database-mode Shortcuts** (preferred):
```bash
mcn  = MY_CONTEXT_HOME=db my-context note
mcs  = MY_CONTEXT_HOME=db my-context show
mcl  = MY_CONTEXT_HOME=db my-context list
mce  = MY_CONTEXT_HOME=db my-context export
mcr  = MY_CONTEXT_HOME=db my-context resume
mcst = MY_CONTEXT_HOME=db my-context start
```

**Prompt Toggle Functions**:
- `prompt-min` - Minimal green prompt (agent-friendly)
- `prompt-full` - Full prompt with my-context, git branch, worktree indicator
- `prompt-toggle` - Switch between modes

**Markdown Viewing**:
```bash
mdview = glow --pager
mdless = glow | less -RSX
mdcat  = glow (no paging)
```

### Profile (`~/.profile`)
**Environment Variables**:
```bash
MY_CONTEXT_HOME=db
DATABASE_URL="host=172.27.0.144 port=5432 ..."
```

### Custom Scripts (`~/bin/`)
**30+ tools including**:
- `my-context` - Context tracking CLI
- `start-day.sh`, `end-day.sh` - Daily workflow
- `ps-config`, `ps-status` - PaymentService tools
- `mcp-setup`, `mcp-status` - MCP server management
- `webm-convert`, `process-video` - Media tools
- `pomodoro.sh` - Focus timer

### Git Configuration (`~/.gitconfig`)
**Minimal** - Uses `nano` as editor, `cat` as pager (agent-optimized)

---

## 3. javadev Inventory

### vim Configuration (`~/.vimrc`)
**Status**: Production-ready, minimalist

**Plugin Manager**: vim-plug (auto-installs if missing)

**Plugins**:
| Plugin | Purpose |
|--------|---------|
| `junegunn/fzf` | Fuzzy file finder |
| `junegunn/fzf.vim` | fzf vim integration |
| `preservim/nerdtree` | File tree sidebar |
| `morhetz/gruvbox` | Dark colorscheme |

**Key Settings**:
- Relative line numbers (zero-based)
- 4-space tabs, expandtab
- True color support (`termguicolors`)
- System clipboard integration

**Key Bindings**:
| Binding | Action |
|---------|--------|
| `Ctrl+P` | Files (fzf) |
| `Ctrl+F` | Grep (rg) |
| `,b` | Buffers |
| `,n` | NERDTree toggle |
| `,t` | Terminal |
| `,w` | Save |
| `,q` | Quit |
| `,/` | Clear search |

**Dependencies Required**:
- `fzf` - Fuzzy finder
- `fd` - Fast file find (for `$FZF_DEFAULT_COMMAND`)
- `ripgrep` (rg) - Fast grep

### Shell Configuration (`~/.bashrc`)
**Java-focused additions**:

```bash
# Default Java (Corretto 17 for PaymentService)
export JAVA_HOME="/usr/lib/jvm/java-17-amazon-corretto"

# Version switchers
java17()  # Switch to Corretto 17
java21()  # Switch to OpenJDK 21
```

**Prompt**: Cyan-colored (distinguishes from other users)

---

## 4. Existing WSL System Configuration

### /etc/wsl.conf (Current)
```ini
[boot]
systemd=true

[interop]
appendWindowsPath = false
```
**Note**: `appendWindowsPath=false` keeps Linux PATH clean

---

## 5. Installed System Tools (Debian)

| Tool | Status | Version |
|------|--------|---------|
| vim | Installed | 9.1 (patches 1-1230+) |
| nano | Installed | - |
| tmux | Available | - |
| git | Installed | - |
| gh (GitHub CLI) | Installed | - |
| starship | Not installed | - |
| nvm | Not installed | - |
| rustup | Not installed | - |
| pyenv | Not installed | - |

---

## 6. Key Patterns Identified

### Pattern 1: Dual-Mode Prompts
`be-dev-agent` uses togglable prompts - minimal for agent interactions, full for human development. This is a **best practice** for Claude Code workflows.

### Pattern 2: Context Tracking Integration
Heavy integration with `my-context` CLI for tracking work sessions, decisions, and artifacts. Status bar shows active context.

### Pattern 3: Java Version Management
`javadev` has manual version switching functions rather than using `sdkman` or `jenv`. Simple but effective for 2-version scenarios.

### Pattern 4: Agent-Friendly Git Config
`be-dev-agent` uses `cat` as pager, avoiding interactive output that confuses agents.

### Pattern 5: Minimal Dependencies
Both vim configs rely on minimal plugins. No heavyweight IDE features, keeping startup fast.

---

## 7. Files to Cherry-Pick

| Source | File | Recommendation |
|--------|------|----------------|
| `be-dev-agent` | `.tmux.conf` | Use as base (remove PaymentService-specific) |
| `be-dev-agent` | `.bash_aliases` | Cherry-pick prompt toggle + my-context aliases |
| `javadev` | `.vimrc` | Use as base (minimalist + vim-plug) |
| `javadev` | `.bashrc` | Cherry-pick java version functions |
| PR #1 | `wsl.conf` | Merge with existing |
| PR #1 | `.wslconfig` | Use as-is |
| PR #1 | `setup.sh` | Use as base, enhance |
