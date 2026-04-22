# Agent Notes: A Worse World

## Project Context

This is a personal mod for **Sid Meier's Civilization VI**, built by **Occidare** for private use with a friend. It is not published or supported for general distribution. Changes should be conservative and well-tested in actual multiplayer games before being committed.

**Core rule:** If something is working reliably, leave it alone unless there is a clear functional need to change it. Do not refactor for consistency.

---

## Important File Locations

### Official Civ VI Assets (Reference)

When figuring out how to implement something, official game files are the best (and often only) documentation. Look up gameplay logic, database schemas, and XML/SQL patterns here:

- **Base Game:**
  - `C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization VI\Base\Assets\`
  - `C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization VI\Base\Binaries\`

- **Expansions & DLC:**
  - `C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization VI\DLC\`
  - `C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization VI\Expansion1\`
  - `C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization VI\Expansion2\`

*(The exact drive letter and Steam library path may vary per machine. Search for `Sid Meier's Civilization VI` under the appropriate `steamapps\common` path if different.)*

### Steam Workshop Mods (Working Examples)

When you need to see how something is *actually* done in a working mod, browse the installed Workshop content:

```
C:\Program Files (x86)\Steam\steamapps\workshop\content\289070\
```

*(Each subfolder is a Workshop item ID. Use Steam or the in-game Mods menu to identify which ID belongs to which mod.)*

This is often more useful than base-game files because:
- Workshop mods use the same modding pipeline we do.
- They show complete, working examples of custom wonders, units, civilizations, etc.
- They demonstrate how to package artdefs, icons, and assets properly.

Key subdirectories to search:
- `Gameplay/` — Core SQL database definitions, XML data
- `Text/` — Localization files
- `UI/` — Front-end and in-game UI scripts
- `Lua/` — Gameplay scripts, plot/district/city helpers
- `Maps/` — Map scripts and utilities

### This Mod's Location

```
C:\Users\<username>\Documents\My Games\Sid Meier's Civilization VI\Mods\ApocMode\
```

*(Mac paths are unknown and unsupported.)*

---

## Documentation Policy

- **`SUMMARY.md`** must be kept up to date with any structural or behavioral changes. If you add a new file, change a modifier value, alter load conditions, or modify a script, update `SUMMARY.md` accordingly.
- This `AGENTS.md` should be updated if build steps, file references, or project conventions change.
- **`docs/`** is our library of *Shit We Learned* — implementation research, reference guides, and notes on base-game file structures. See [`docs/README.md`](docs/README.md). Add to it whenever we explore something nontrivial.

---

## Architecture & Conventions

### Mod Manifest (`A Worse World.modinfo`)
- Defines load order (`15` for database, `20500` for gameplay scripts).
- Uses `ActionCriteria` to conditionally load files based on game mode (Apocalypse, Secret Societies).
- **Do not change mod ID, version, or dependencies without explicit instruction.**

### Database Files
- Prefer `.sql` for bulk updates (`UPDATE`, `INSERT OR REPLACE`).
- Prefer `.xml` for defining new rows or complex nested structures (e.g., `RandomEvents`, `Modifiers`).
- All database actions target `LoadOrder=15`.

### Scripts
- `WMDs.lua` hooks into `Events.WMDDetonated`. Keep it minimal and deterministic.
- `CoastalLowlands.lua` is a map-generation utility. It must remain self-contained and not depend on game-state objects that don't exist during map creation.

### Code Style
- Copy or reimplement existing functionality exactly. Do not get creative.
- Reuse existing classes and patterns from the base game.
- Modularize when possible. Avoid giant monolithic files.

---

## Git & Updates

- The `update.bat` script performs a hard reset from `origin/master`. It will destroy local uncommitted changes.
- **Do not commit secrets, credentials, or `.env` files.**
- This repo is private/personal. Do not push to public remotes or create releases without explicit confirmation.

---

## Testing Checklist (Before Committing)

When making changes, verify in an actual game or with reference files:

- [ ] XML/SQL files parse without errors (check `Modding.log` or in-game Database.log).
- [ ] Lua scripts have no runtime errors on load.
- [ ] Conditional files (Apocalypse/Secret Societies) only load in the correct modes.
- [ ] `SUMMARY.md` reflects the change.
- [ ] No unintended side effects on base-game systems.

---

## Useful Logs

Civ VI writes modding logs that are essential for debugging:

```
C:\Users\<username>\Documents\My Games\Sid Meier's Civilization VI\Logs\
```

Key files:
- `Modding.log` — General mod loading errors and SQL failures.
- `Database.log` — Database update conflicts and missing references.
- `Lua.log` — Lua runtime errors and `print()` output.

---

## Contact / Ownership

- **Author:** Occidare
- **Audience:** Occidare + one friend
- **Support level:** Best effort, no guarantees.
