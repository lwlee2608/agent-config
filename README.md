# Agent Config

Centralized configuration files for AI coding agents: [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Codex](https://github.com/openai/codex), [OpenCode](https://github.com/opencode-ai/opencode), and [Pi](https://pi.dev).

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
| `claudecode/statusline-command.sh` | `~/.claude/statusline-command.sh` | Custom statusline script |
| `claudecode/output-styles/simple.md` | `~/.claude/output-styles/simple.md` | "Simple" output style (ASD-STE100) |
| `codex/AGENTS.md` | `~/.codex/AGENTS.md` | Global instructions |
| `codex/config.toml` | `~/.codex/config.toml` | Model, approval and sandbox settings (merged; machine-local `[projects]`, `[notice]`, `[tui]` tables are preserved) |
| `opencode/AGENTS.md` | `~/.config/opencode/AGENTS.md` | Global instructions |
| `opencode/opencode.json` | `~/.config/opencode/opencode.json` | Provider and model config |
| `pi/AGENTS.md` | `~/.pi/agent/AGENTS.md` | Global instructions |
| `pi/settings.json` | `~/.pi/agent/settings.json` | Default model, theme, and packages |

## Pi

Pi settings contain portable preferences and package sources, not credentials or runtime state. Pi installs missing packages on startup. Authenticate separately on each machine.

Pi also writes to `settings.json` through `/settings` and package commands. Review the sync diff before accepting: the script replaces the whole file, so copy any local preferences you want to keep back into this repo first.

Do not commit `auth.json`, session history, trust decisions, downloaded packages, or generated model catalogs. If you add `models.json`, use environment references such as `"apiKey": "$MY_API_KEY"` instead of literal credentials.

## Agent Skills

Claude Code skills are managed in a separate repo: [lwlee2608/agent-skills](https://github.com/lwlee2608/agent-skills)

Install via https://skills.sh/lwlee2608/agent-skills

Pi automatically discovers skills in `~/.agents/skills/`. Keep shared skills there; no separate copy under `~/.pi/agent/skills/` is needed.
