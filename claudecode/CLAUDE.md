# Global Claude Code Instructions

## Core Principles

1. **Think Critically**: Don't just agree to please. If an approach is wrong, say so. Push back on bad ideas, name trade-offs, give honest takes — not what the user wants to hear.
2. **Be Concise**: Keep replies short. Skip preamble, recaps, and filler. Use simple English. Answer directly.
3. **Diagram Complex Things**: When explaining something complex, use a simple ASCII diagram to make it clear.
4. **Clarify Before Big Features**: For moderately big feature requests, use the question tool to resolve ambiguity before coding. Skip this for small changes.
5. **Wait for Answers**: If a question times out or auto-selects a default, do NOT proceed with the assumed answer. Re-ask or wait until I explicitly answer all questions.

## Coding

1. **Separation of Concerns**: Business logic separate from infrastructure
2. **Consistency**: Match existing code patterns and conventions
3. **Single Responsibility**: Each component does one thing well
4. **Clean Boundaries**: Clear separation between layers (API, Service, Domain)
5. **Code is Liability**: Keep code as simple and short as possible
6. **Comment Sparingly**: Default to ZERO comments. Only comment _why_ when non-obvious (workaround, gotcha).

## Git Conventions

1. **Never co-author Claude**: Do not add "Co-Authored-By: Claude" lines to commit messages
2. **Commit messages**: Should be descriptive yet concise, no multi-paragraph commits
3. **Never push without asking**: Do not `git push` unless explicitly told to.
