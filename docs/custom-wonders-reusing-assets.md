# Shit We Learned: Creating a Custom Wonder (Reusing Existing Assets)

**Date:** 2025-04-21  
**Topic:** How to add a new world wonder to Civ VI by cloning an existing one (Cristo Redentor) with different gameplay effects, and what the hard limits are for art/VFX/scale.

---

## The Goal

Create `BUILDING_ULTRACRISTO_VINDITADOR` — functionally a new wonder, visually reusing Cristo Redentor's assets, ideally with some different graphical flavor and/or a different size.

---

## What's Easy

### 1. Gameplay Definition (XML/SQL)

Wonders are just rows in the `Buildings` table. Reference files:

- `Base/Assets/Gameplay/Data/Buildings.xml` — full wonder definitions
- `Base/Assets/Gameplay/Data/Buildings.xml` lines 180, 282-286, 391, 691, 1202, 1655 — Cristo Redentor specifics

You need:
- `<Types>` row (`KIND_BUILDING`)
- `<Buildings>` row (cost, prereq, yields, placement rules, quote audio, etc.)
- `<Building_YieldChanges>` for base yields
- `<BuildingModifiers>` + `<Modifiers>` + `<ModifierArguments>` for special effects
- `<BuildingValidTerrains>` or `<BuildingValidFeatures>` for placement restrictions

### 2. Reusing Existing Art Assets

Civ VI uses **`.artdef` files** to bind database building types to visual assets. You can create a modded `.artdef` that points your new `BuildingType` to existing assets.

Key reference files:

| File | Purpose |
|------|---------|
| `Base/ArtDefs/Buildings.artdef` | Maps `BuildingType` → strategic view states (completed, pillaged, under construction) |
| `Base/ArtDefs/StrategicView.artdef` | Defines the actual 2D strategic view sprites |
| `Base/ArtDefs/WonderMovie.artdef` | Defines the construction cinematic (wonder movie) |

For Cristo Redentor, the existing references are:

**Buildings.artdef** (around line 5740-5820):
- `BUILDING_CRISTO_REDENTOR`
- Strategic view states point to:
  - `CristoRedentor` (completed)
  - `CristoRedentor_Pillaged`
  - `CristoRedentor_UnderConstruction`

**WonderMovie.artdef** (around line 2624-2710):
- `BUILDING_CRISTO_REDENTOR`
- Asset: `WonderMovie.xlp` / `WonderMovie` library
- TintColor: RGB 255,255,255 (white/no tint)
- `FlattensTerrain: true`
- `FollowTerrainHeight: true`
- `MaxVisualProgress: 68`

To reuse these for a new wonder, create a mod `.artdef` file and copy the structure, just changing `BUILDING_CRISTO_REDENTOR` to `BUILDING_ULTRACRISTO_VINDITADOR`.

### 3. Icons

Wonder icons are defined in:

- `Base/Assets/UI/Icons/Icons_Wonders.xml`

Cristo Redentor uses:
- `ICON_BUILDING_CRISTO_REDENTOR` → `ICON_ATLAS_WONDERS`, Index `27`
- `ICON_BUILDING_CRISTO_REDENTOR_FOW` → `ICON_ATLAS_WONDERS_FOW`, Index `27`

You can point your new wonder to the **same atlas index** (reuses the icon) or create a new atlas entry with custom DDS textures.

### 4. Localization

Standard `LocalizedText` entries needed:
- `LOC_BUILDING_ULTRACRISTO_VINDITADOR_NAME`
- `LOC_BUILDING_ULTRACRISTO_VINDITADOR_DESCRIPTION`
- `LOC_BUILDING_ULTRACRISTO_VINDITADOR_QUOTE`
- `LOC_PEDIA_BUILDING_ULTRACRISTO_VINDITADOR` (Civilopedia)

---

## What's Hard / Limited

### 5. "Different Graphical Effects"

**Without the Civ VI Asset Editor (SDK), you cannot create new particle effects, shaders, or VFX from scratch.**

What you *can* do via `.artdef` tweaks:
- **TintColor** in `WonderMovie.artdef` — tints the **final postcard/freeze-frame** at the end of the construction movie. It does **not** tint the entire cinematic. Tested: a blood-red tint only appeared momentarily on the closing still image.
- **TimeOfDayCurve** — controls the time-of-day progression during the wonder cinematic. You can create custom curves (e.g., `Night_Only` with `TimeOfDay=2.0`) to keep the entire movie at nighttime. The curve lives in the `TimeOfDayCurves` root collection of `WonderMovie.artdef`.
- **One-shot VFX via Lua UI script** — you can create a UI script (loaded via `AddUserInterfaces`) that hooks `Events.WonderCompleted` and calls `WorldView.PlayEffectAtXY("DISASTER_NUCLEAR_MELTDOWN", x, y)` to play existing disaster/explosion effects at the wonder tile. This is UI-side only; `WorldView` is not available in gameplay scripts.
- **VFX references** — if you can find existing VFX entries in `VFX.artdef` that work for buildings, you might be able to cross-reference them.

What you *cannot* do without the SDK:
- Create custom particle emitters
- Create custom materials or shaders
- Alter the model's geometry or UVs

### 6. Model Scale (The Big No)

**There is no exposed in-engine parameter to scale a wonder's world model on the map.**

We searched every `.artdef` in `Base/ArtDefs/`:
- `Buildings.artdef` — no scale parameter
- `StrategicView.artdef` — no scale parameter
- `GraphicsTweaks.artdef` — global AO/bounce lighting tweaks, not per-building
- `CityGenerators.artdef` — has `Var_ModelScale`, but that's for procedurally generated city buildings, not hand-placed wonders
- `WonderMovie.artdef` — has `ModelScale` (found at lines ~6370 and ~6403), but **this only controls scale during the construction movie cinematic**, not the persistent in-game model.

**To change the physical size of the model on the map tile, you must:**
1. Open the **Civ VI Asset Editor** (part of the official SDK)
2. Import the Cristo Redentor geometry (`.ast`/`.geo` files from the BLP packages)
3. Rescale it in the editor
4. Re-export as a new asset
5. Package the new `.blp`/`.ast` files with your mod

This is a full asset-creation pipeline, not a data tweak.

---

## Practical Implementation Path

If you actually want to build this, the files to create/modify in this mod would be:

1. **`Database/Ultracristo.xml`** — wonder definition (type, building, yields, modifiers, terrains)
2. **`Database/Ultracristo_Localization.sql`** — name, description, quote text
3. **`ArtDefs/Ultracristo.artdef`** — bind `BUILDING_ULTRACRISTO_VINDITADOR` to Cristo's existing visual assets (and optionally a different TintColor)
4. **`A Worse World.modinfo`** — register the new XML/SQL/artdef files, set `LoadOrder=15`
5. **`SUMMARY.md`** — document the new wonder

If you want a different-sized model or truly custom VFX, you need the SDK Asset Editor and custom asset files — not something we can do from text files alone.

---

## Key Base Game References (Exact Paths)

```
C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization VI\
├── Base\Assets\Gameplay\Data\Buildings.xml
│   └── Lines 180, 282-286, 391, 691, 1202, 1655 (Cristo Redentor)
├── Base\Assets\UI\Icons\Icons_Wonders.xml
│   └── Lines 40, 71 (Cristo icon index 27)
├── Base\ArtDefs\Buildings.artdef
│   └── Lines ~5740-5820 (BUILDING_CRISTO_REDENTOR visual states)
├── Base\ArtDefs\StrategicView.artdef
│   └── Lines ~29250-29378 (CristoRedentor, CristoRedentor_Pillaged, CristoRedentor_UnderConstruction)
├── Base\ArtDefs\WonderMovie.artdef
│   └── Lines ~2624-2710 (BUILDING_CRISTO_REDENTOR cinematic)
└── Base\Platforms\Windows\BLPs\
    └── SHARED_DATA\TEXTURE_WON_Cristo_Redentor_* (diffuse, AO, normal, etc.)
```

---

## Open Questions

- Can we reuse the **audio quote** (`Play_CRISTOREDENTOR_QUOTE`) or do we need a custom one?
- Does changing `TintColor` in the mod's `WonderMovie.artdef` actually override the base game entry, or do we need to match the exact collection merge behavior?
- Are there existing VFX entries in `VFX.artdef` that can be cross-referenced to building births for a different "aura"?
