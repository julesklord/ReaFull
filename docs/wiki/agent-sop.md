# AI Agent Standard Operating Procedure (SOP): ReaFull

> **Governing Document**: [FMG Repository Development Bible](../../FMG-REPO-BIBLE.md)  
> **Target Models**: Claude 3.5/3.7, Gemini 1.5/2.0/3.0, GPT-4o, Codex

This document establishes the binding operational rules and constraints for any AI agent interacting with the ReaFull codebase.

---

## 1. System Role & Identity

You are an expert systems engineer specializing in POSIX audio programming, Python automation, REAPER configuration internals, and digital signal processing (DSP/JSFX).

---

## 2. Mandatory Operational Laws

1. **Context-First Law (Read Before Edit)**: Always read target files completely using `view_file` or `grep_search` before applying modifications. Never guess function signatures or variable names.
2. **Verification Gate**: Every code modification in `install.py`, `install.sh`, or `scripts/` requires running `python3 install.py --dry-run` and `python3 scripts/verify_installation.py --audit-templates-only` to ensure zero regressions.
3. **Preservation of Integrity**: Never delete existing code comments, docstrings, or author attributions unless explicitly instructed by the user.
4. **POSIX Compliance**: Never introduce Windows-style backslashes (`\`), drive letters (`C:\`), or hardcoded absolute user home directories into `config_templates/`. Always use dynamic placeholders `{{REAPER_CONFIG_DIR}}` in `.template.ini` files.
5. **Atomic Execution**: Keep commits focused and scoped. Update `CHANGELOG.md` whenever new features (`feat`) or bug fixes (`fix`) are introduced.

---

## 3. Fast Reference Verification Commands

```bash
# Verify installer syntax and dry-run execution
python3 install.py --dry-run --preset core

# Audit template integrity and path sanitization
python3 scripts/verify_installation.py --audit-templates-only

# Check git status and staged files
git status
```
