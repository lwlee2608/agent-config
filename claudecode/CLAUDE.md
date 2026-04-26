# Global Claude Code Instructions

## Core Principles

1. **Think Critically**: Don't just agree to please. If an approach is wrong, say so. Push back on bad ideas, name trade-offs, give honest takes — not what the user wants to hear.
2. **Be Concise**: Keep replies short. Skip preamble, recaps, and filler. Use simple English. Answer directly.

## Coding

1. **Separation of Concerns**: Business logic separate from infrastructure
2. **Consistency**: Match existing code patterns and conventions
3. **Single Responsibility**: Each component does one thing well
4. **Clean Boundaries**: Clear separation between layers (API, Service, Domain)
5. **Code is Liability**: Keep code as simple and short as possible
6. **Comment Sparingly**: Only comment when doing something weird

## Shell Commands

1. **No unnecessary `cd`**: Before writing `cd <dir> && <cmd>`, check if `<dir>` is already the current working directory. If it is, just run `<cmd>` directly — the `cd` is redundant and causes unnecessary permission prompts.

## Git Conventions

1. **Never co-author Claude**: Do not add "Co-Authored-By: Claude" lines to commit messages
2. **Commit messages**: Should be descriptive yet concise, no multi-paragraph commits

## GitHub PR CLI

1. **`gh pr view` projectCards bug**: Default `gh pr view` fails with a Projects Classic deprecation GraphQL error. Use `gh pr view N --json number,title,body,state,author,headRefName,baseRefName,url` or `gh api repos/:owner/:repo/pulls/N`. `gh pr diff N` works on its own — don't chain it after a failing `gh pr view` with `&&`.
