# Hygiene, Git Workflow and Versioning Standards

> **Governing Document**: [FMG Repository Development Bible](../../FMG-REPO-BIBLE.md)  
> **Philosophy**: *Logic dictates. AI executes.*

This document defines the strict version control, commit conventions, branch policies, and release workflows for ReaFull.

---

## 1. Atomic Commits

Every commit to ReaFull must represent a single, self-contained logical change that builds and passes all health verification checks.

### 1.1 Commit Format (Conventional Commits)

```
<type>(<scope>): <subject>

<body: Detailed technical rationale>

<footer: Closes #issue>
```

### 1.2 Allowed Types

- `feat`: New user-facing functionality (new JSFX tool, new installer flag, new template module).
- `fix`: Bug resolution (fixed INI merge bug, resolved path truncation, patched installer error).
- `docs`: Documentation updates, wiki additions, or manual revisions.
- `style`: Visual styling, splash render adjustments, theme assets (zero code logic changes).
- `refactor`: Code restructuring without modifying behavioral output.
- `perf`: Performance optimizations (faster INI parsing, reduced asset extraction time).
- `test`: Addition or modification of health verification tests.
- `chore`: Maintenance tasks, dependency bumps, asset hash updates, license catalog maintenance.

### 1.3 Permitted Scopes

- `installer`: `install.py`, `install.sh`, component definitions.
- `uninstaller`: `uninstall.sh`, backup recovery logic.
- `dsp`: JSFX plugins (Analog FX, Digital FX, Community).
- `templates`: TrackTemplates, ProjectTemplates, routing.
- `config`: `config_templates/`, INI profiles, SWS rules.
- `themes`: Theme files, splash screen, icons, UI assets.
- `fonts`: Studio typography, fontconfig registration.
- `scripts`: Maintenance utilities, verification scripts.
- `wiki`: Documentation within `docs/wiki/`.

---

## 2. Branching and Release Policy

- **`main`**: Production trunk. Must always remain in a releasable, green state.
- **Linear History**: Rebase feature branches before merging; avoid messy merge commits.
- **Banned**: `git push --force` to `main` is strictly prohibited.

---

## 3. Semantic Versioning (SemVer)

ReaFull follows calendar-anchored Semantic Versioning: `YYYY.MINOR.PATCH` (e.g. `2026.3.0`).

- **Single Source of Truth**: The root `VERSION` file defines the canonical version.
- **Synchronization**: The version string in `VERSION`, `install.py` (`VERSION = "..."`), `install.sh` (`VERSION="..."`), and `CHANGELOG.md` must match at all times.
