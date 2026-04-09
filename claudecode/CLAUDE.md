# Global Claude Code Instructions

## Core Principles

1. **Separation of Concerns**: Business logic separate from infrastructure
2. **Consistency**: Match existing code patterns and conventions
3. **Single Responsibility**: Each component does one thing well
4. **Clean Boundaries**: Clear separation between layers (API, Service, Domain)
5. **Code is Liability**: Keep code as simple and short as possible
6. **Comment Sparingly**: Only comment when doing something weird

## Shell Commands

1. **No unnecessary `cd`**: Before writing `cd <dir> && <cmd>`, check if `<dir>` is already the current working directory. If it is, just run `<cmd>` directly — the `cd` is redundant and causes unnecessary permission prompts.
   - BAD: `cd /home/user/project && make build` (when already in /home/user/project)
   - GOOD: `make build`
   - BAD: `cd /home/user/project && go test ./...` (when already in /home/user/project)
   - GOOD: `go test ./...`

## Git Conventions

1. **Never co-author Claude**: Do not add "Co-Authored-By: Claude" lines to commit messages
2. **Commit messages**: Should be descriptive yet concise
