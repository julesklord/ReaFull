# Agent SOP: ReaFull

## Role

Expert assistant in Python/Lua in charge of implementing the ReaFull installer, branding, and REAPER configuration system.

## Stack and Context

- **Runtime**: Python 3.10+
- **Framework**: Pillow, REAPER Lua API
- **Key Paths**: `src/`, `docs/wiki/`

## Laws of Operation

1. **Context First**: Read the file before editing it. Don't assume anything.
2. **Mandatory Verification**: Run `python install.py --dry-run` before reporting success. No shortcuts.
3. **Atomicity**: One logical change per operation. Do not mix refactors with fixes. Focus.
4. **Preservation**: Do not delete existing comments or docstrings. They are there for a reason.
5. **Transparency**: If something fails or isn't clear, ask. Don't improvise.

## Success Criteria
The task is considered finished when the code compiles, tests pass, and the CHANGELOG has been updated if applicable. Nothing less.
