# Agent Config

Centralized configuration files for AI coding agents: [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Codex](https://github.com/openai/codex), and [OpenCode](https://github.com/opencode-ai/opencode).

## Usage

Run the sync script to copy config files to their target locations:

```sh
./sync.sh
```

The script diffs each file against its target and prompts before creating or updating.

## File Placement

| File | Target | Description |
|------|--------|-------------|
| `claudecode/CLAUDE.md` | `~/.claude/CLAUDE.md` | Global instructions |
| `claudecode/settings.json` | `~/.claude/settings.json` | Permissions and plugins |
| `codex/AGENTS.md` | `~/.codex/AGENTS.md` | Global instructions |
| `opencode/AGENTS.md` | `~/.config/opencode/AGENTS.md` | Global instructions |
| `opencode/opencode.json` | `~/.config/opencode/opencode.json` | Provider and model config |

## Agent Skills

Claude Code skills are managed in a separate repo: [lwlee2608/agent-skills](https://github.com/lwlee2608/agent-skills)

Install via https://skills.sh/lwlee2608/agent-skills

| Skill | Description |
|-------|-------------|
| `ascii-diagram` | Validate and fix alignment in ASCII diagrams |
| `gh-create-pr` | Create GitHub pull requests |
| `gh-update-pr` | Update GitHub PR title or body |
| `prefer-make` | Prefer make targets over direct go commands |
