# Global Claude Code Instructions

## Core Principles

1. **Separation of Concerns**: Business logic separate from infrastructure
2. **Consistency**: Match existing code patterns and conventions
3. **Single Responsibility**: Each component does one thing well
4. **Clean Boundaries**: Clear separation between layers (API, Service, Domain)
5. **Code is Liability**: Keep code as simple and short as possible
6. **Comment Sparingly**: Only comment when doing something weird

## Shell Commands

1. **No unnecessary `cd`**: Never use `cd <dir> && <cmd>` when you are already in that directory. Use absolute paths or run the command directly instead. This avoids unnecessary permission prompts for compound commands.

## Git Conventions

1. **Never co-author Claude**: Do not add "Co-Authored-By: Claude" lines to commit messages
2. **Commit messages**: Should be descriptive yet concise
