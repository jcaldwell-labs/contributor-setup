# Open Questions - RESOLVED

Decisions finalized on 2025-01-27.

---

## Decision Summary

| # | Question | Decision |
|---|----------|----------|
| 1 | Windows PATH | `false` - clean Linux environment |
| 2 | Default editor | Unset - user's choice |
| 3 | my-context | Optional - aliases present if installed |
| 4 | Java version | OpenJDK 21 LTS (optional install) |
| 5 | Node.js | System LTS via NodeSource |
| 6 | Rust | Optional prompt in install-tools.sh |
| 7 | Shell | bash only |
| 8 | Clipboard | clip.exe approach |
| 9 | User account | `jcdev` + sudo + docker groups |
| 10 | PR disposition | Supersede PR #1 |
| 11 | Documentation | This repository |
| 12 | Testing | CI/automation |

---

## Detailed Decisions

### 1. Windows PATH Integration
**Decision**: `appendWindowsPath = false`

Rationale: Clean Linux environment is preferred. WSL-specific aliases in bashrc-additions provide access to common Windows tools when needed (`explorer`, `clip`, `wopen`).

### 2. Default Editor
**Decision**: Unset

Rationale: Vim config is provided and comprehensive, but `$EDITOR` left to user preference. Contributors can set it themselves.

### 3. my-context Requirement
**Decision**: Optional

Rationale: Aliases activate automatically if my-context is installed, but tool not required. Keeps setup minimal for general contributors.

### 4. Java Version
**Decision**: OpenJDK 21 LTS (optional)

Rationale: Latest LTS, available from Debian repos, good for new jcaldwell-labs OSS projects. Install prompt in install-tools.sh.

**Note**: This setup is for jcaldwell-labs open source projects, not Accesso PaymentService.

### 5. Node.js Version Management
**Decision**: System Node via NodeSource LTS

Rationale: Simpler setup, one consistent version. No jcaldwell-labs projects currently require multiple Node versions.

### 6. Rust Toolchain
**Decision**: Optional prompt

Rationale: install-tools.sh asks user. Keeps default setup lean while supporting Rust-based CLI projects.

### 7. Shell Choice
**Decision**: bash only

Rationale: Debian default, lower complexity. zsh configs can be added later if team members request.

### 8. Clipboard Integration
**Decision**: clip.exe / powershell approach

Rationale: Native WSL interop, no additional tools needed. Aliases provided in bashrc-additions.

### 9. User Account
**Decision**: `jcdev` with `sudo` and `docker` groups

Creation command:
```bash
sudo useradd -m -s /bin/bash -G sudo,docker jcdev
sudo passwd jcdev
```

### 10. PR #1 Disposition
**Decision**: Supersede

Action: Close PR #1, create new PR with this human-curated work. PR #1 was Copilot-generated generic configs; this work cherry-picks from battle-tested be-dev-agent and javadev setups.

### 11. Documentation Location
**Decision**: This repository

The README.md provides comprehensive setup guide. No need for separate docs site at this time.

### 12. Testing
**Decision**: CI/automation

Implement GitHub Actions workflow to:
1. Create fresh Debian container
2. Create jcdev user
3. Run bootstrap.sh
4. Verify vim plugins load
5. Verify tmux config works
6. Verify fzf integration works

---

## Next Steps

1. [ ] Create `jcdev` user in WSL Debian
2. [ ] Copy files to contributor-setup repo
3. [ ] Close PR #1 with note about superseding
4. [ ] Create new PR with this work
5. [ ] Set up CI workflow for testing
6. [ ] Merge and document in jcaldwell-labs org README
