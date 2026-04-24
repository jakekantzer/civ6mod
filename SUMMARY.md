# A Worse World — Civ VI Mod Summary

**Author:** Occidare  
**ID:** `2f92faf8-22c8-4a8b-bb6e-53a62afd37d3`  
**Version:** 1  
**Compatible With:** Civ VI 1.2, 2.0  

---

## Overview

*A Worse World* is a **Sid Meier's Civilization VI** mod that tweaks the game to make the world a slightly (or significantly) more hostile place. It ramps up natural disasters, supercharges WMDs, buffs certain units, adds configurable coastal flooding, and introduces a variety of quality-of-life and balance changes.

---

## Dependencies

- **Required:**
  - `Expansion: Gathering Storm`
  - `GranColumbiaMaya` (Gran Colombia & Maya Pack)
- **Referenced:**
  - `Ethiopia` Pack

---

## File Structure

```
A Worse World.modinfo       -- Mod manifest & action definitions
update.bat                  -- Hard-reset script to update from origin/master

Database/
  Setup.xml                 -- Game setup parameter for coastal flooding
  Text.xml                  -- Front-end/localized text for the setup option
  Apocalypse_Environment.sql    -- Climate & disaster tuning (Apocalypse Mode)
  Apocalypse_Comet37.xml        -- Giant 37-hex comet strikes (Apocalypse Mode)
  Apocalypse_Soothsayer.xml     -- Soothsayer buffs (Apocalypse Mode)
  Apocalypse_Localization.sql   -- Comet text overrides (Apocalypse Mode)
  SecretSocieties_Cultist.xml   -- Cultist & Dark Summoning buffs (Secret Societies)
  Miscellaneous.sql             -- Global unit, district, barbarian, & religion tweaks
  WMDs.xml                      -- Nuclear weapon & satellite changes
  Ultracristo/
    Ultracristo.xml           -- New wonder: Ultracristo Vinditador
    Ultracristo_Text.xml      -- Localization for Ultracristo Vinditador
    Ultracristo_Icons.xml     -- Icon definitions for Ultracristo Vinditador

Scripts/
  WMDs.lua                  -- Gameplay script: destroys cities hit by WMDs

UI/
  UltracristoVFX.xml        -- UI context for Ultracristo VFX
  UltracristoVFX.lua        -- Plays DISASTER_NUCLEAR_MELTDOWN on wonder completion

Maps/Utility/
  CoastalLowlands.lua       -- Custom map generation for coastal lowland marking

ArtDefs/
  Buildings.artdef              -- Visual binding to Cristo Redentor assets
  WonderMovie.artdef            -- Cinematic binding to Cristo Redentor assets
Ultracristo.dep                 -- Art dependency file for loading artdefs
```

---

## Mod Behavior Breakdown

### 1. Front-End Setup (`Setup.xml` + `Text.xml`)

Before the game starts, a new **Advanced Option** is added:

- **Parameter ID:** `AWW_COASTAL_FLOODS`
- **Name:** Coastal Flooding
- **Options:**
  - **Disabled** (`0`) — Lowland coastal tiles will not flood.
  - **Low** (`20`) — Only a handful of tiles will flood.
  - **Normal** (`50`) — A good few tiles will flood.
  - **High** (`100`) — Many tiles will flood.
  - **Apocalyptic** (`1000`) — *Kevin Costner's Waterworld*.

This setting is read by the custom `CoastalLowlands.lua` map script during map generation.

---

### 2. Apocalypse Mode Changes

These files only load when **Apocalypse Game Mode** is active.

#### `Apocalypse_Environment.sql`
- **Comet blast radius increased:**
  - Random Comet Strikes: `+3` hexes.
  - Targeted Comet Strikes: `+6` hexes.
- **Disaster frequency shifted to Apocalypse realism:**
  - Copies `MEGADISASTERS` frequencies into `APOCALYPSE`, then **doubles** occurrences (except for events set to `1`).
- **Custom comet/meteor frequencies:**
  - Comet Strikes and Targeted Comet Strikes set to `0` in Apocalypse (replaced by Comet37).
  - Meteor Showers set to `30` per game in Apocalypse.
- **CO2 emissions doubled:**
  - All resources with `CO2perkWh > 0` have their value multiplied by `2`.
  - Deforestation effects with `CO2PercentModifier > 0` are also doubled.
- **Diplomatic favor penalty reduced:**
  - `FAVOR_CO2_DIVISOR` lowered to `6` to offset the doubled CO2 output.
- **Coastal lowland percentage:**
  - `CLIMATE_CHANGE_PERCENT_COASTAL_LOWLANDS` set to `75`.

#### `Apocalypse_Comet37.xml`
- Defines two **massive 37-hex** comet strike events:
  - `RANDOM_EVENT_COMET_STRIKE_37`
  - `RANDOM_EVENT_COMET_STRIKE_TARGETED_37`
- **Effects:** 101% damage to improvements, districts, civilian units, land units, population, and **city destruction**.
- **Yields:** Leaves a `FEATURE_COMET_LAKE`.
- **Frequencies:**
  - Megadisasters: `4` random / `2` targeted per game.
  - Apocalypse: `400` random / `200` targeted per game.

#### `Apocalypse_Soothsayer.xml`
- Buffs the **Soothsayer** unit:
  - Base movement increased to `3`.
  - Cost progression removed (flat cost forever).
  - Gains **ignore terrain cost** and **ignore river crossing cost**.
  - Can **move after purchase** and **teleport to any city**.

#### `Apocalypse_Localization.sql`
- Updates English text for comet strikes to emphasize that they **destroy anything**, including City Centers.

---

### 3. Secret Societies Mode Changes

These files only load when **Secret Societies Game Mode** is active.

#### `SecretSocieties_Cultist.xml`
- Buffs the **Cultist** unit:
  - Base movement increased to `3`.
  - Cost progression removed (flat cost forever).
  - Gains **ignore terrain cost** and **ignore river crossing cost**.
  - Can **move after purchase** and **teleport to any city**.
- **Dark Summoning project** now sets the world realism to `REALISM_SETTING_APOCALYPSE` upon completion.
- **Loyalty damage** from Cultist abilities increased:
  - `SPREAD_DISSENT_LOYALTY_DAMAGE`: `20`
  - `SPREAD_CHAOS_ADDITIONAL_LOYALTY_DAMAGE`: `10`
- **Apocalypse realism** climate change points set to `8`.

---

### 4. Base Game Changes (Always Active)

#### `Miscellaneous.sql`
- **Unit movement buffs:**
  - All land combat units: `+1` movement.
  - Settlers: `+1` movement and `+1` sight range.
  - Embarked units: `+1` base movement.
- **Space Race tweaks:**
  - Spaceport district cost reduced by `30%`.
  - Space race projects cost reduced by `30%`.
- **Spies purchasable with Gold** (instead of Faith-only).
- **Wonder/feature buffs:**
  - Cliffs of Dover: grants double adjacent terrain yields.
  - Comet Lake: grants double adjacent terrain yields.
- **Barbarian tweaks:**
  - Bribe cost per city halved.
  - Civilization conversion increment chance increased by `50%`.
  - Boldness per kill reduced; boldness per scout/unit lost increased.
  - Boldness per camp attack set to `0`.
  - Minimum camp distance from city `+1`.
  - Barbarian defense for all units reduced by `1`.
  - Naval clans are bolder (raiding & city attack).
  - Barbarian defender tag changed from Anti-Cavalry to Melee.
- **Religious units QoL:**
  - Missionaries, Apostles, Gurus, and Inquisitors can **move after purchase** and **teleport to any city**.

#### `WMDs.xml`
- **Operation Ivy** now shares the **Nuclear Fission** tech prerequisite with the Manhattan Project (still requires Manhattan first).
- **Nuclear Device:** Blast radius increased to `3`.
- **Thermonuclear Device:**
  - Blast radius increased to `6`.
  - ICBM strike range increased to `200`.
- **Satellites technology** now reveals the **entire map** (like in Civ V).

#### `WMDs.lua`
- **Gameplay Script** that listens for `WMDDetonated` events.
- When a WMD detonates on a tile:
  - If the tile contains a **city**, that city is **immediately destroyed** (razed).
  - Logs the detonation coordinates and attacking player.

#### `Ultracristo/` (New Wonder)
- **Ultracristo Vinditador** — a new world wonder based on Cristo Redentor.
- **Prerequisite:** `CIVIC_CIVIL_ENGINEERING`
- **Cost:** `1240` Production
- **Placement:** Hills only (Grass, Plains, Tundra, Snow, Desert)
- **Yields:** `+4` Culture, `+4` Faith
- **Effect:** Enemy cities within `10` tiles lose `15` Loyalty per turn.
  - Implemented via `MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER` filtering out the owner, allies, declared friends, and teammates first, then `MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER` distributes `MODIFIER_SINGLE_CITY_ADJUST_IDENTITY_PER_TURN` to each remaining player's cities within range.
- **Visuals:** Reuses Cristo Redentor's in-game model, strategic view icon, and construction cinematic. The cinematic plays at nighttime only (`Night_Only` TimeOfDayCurve), and the closing still frame is tinted blood red via `TintColor`. On completion, a `DISASTER_NUCLEAR_MELTDOWN` VFX plays at the wonder tile. At the start of each turn, a `NUCLEAR_FALLOUT` VFX pulses on every valid enemy city within 10 tiles.
- **Flavor Quote:** *"They built a redeemer to forgive. We built an avenger to ensure there is nothing left to forgive."*

---

### 5. Map Generation (`CoastalLowlands.lua`)

A custom Lua map utility that overrides how **Coastal Lowlands** are marked for Gathering Storm flooding.

- Uses a **three-wave fixed-target system** based on the player's chosen **Coastal Flooding** percentage:
  1. **Wave 1 (1M lowlands):** Marks the best coastal tiles until 1/3 of the target is reached.
  2. **Wave 2 (2M lowlands):** Re-scores coastal tiles **and** inland tiles adjacent to 1M lowlands. Marks the next 1/3 as 2M.
  3. **Wave 3 (3M lowlands):** Re-scores again, including adjacency to 2M lowlands. Marks the final 1/3 as 3M.

#### Scoring Logic
- **Excluded:** Volcanoes, lakes, floodplains, natural wonders, hills, mountains.
- **Prioritized:**
  - Marsh tiles (score `1000`).
  - River tiles (`+200`).
  - Adjacent marsh/floodplain (`+50`).
  - Adjacent water (`+50`).
- **Deprioritized:**
  - Adjacent hills/mountains (`-50`).

This creates a cascading flood-vulnerability effect where lowlands spread inland from the coast in a realistic pattern.

---

## Load Order

All database updates use a **LoadOrder of `15`** to ensure they apply after base game data but before most other mods. The `WMDs.lua` script uses a high load order of `20500` with priority `10`.

---

## How to Update

The included `update.bat` script will:
1. `git fetch --all`
2. `git reset --hard origin/master`
3. `git clean -fd -e update.bat`

**Warning:** This is a destructive hard reset. Any local changes will be lost.

---

## Summary of Design Intent

| System | Change | Effect |
|--------|--------|--------|
| **Climate** | Doubled CO2, more disasters | Faster, deadlier climate change |
| **Comets** | 37-hex mega comets | Total devastation, city deletion |
| **WMDs** | Larger blast radius, city razing | Nuclear weapons are genuinely terrifying |
| **Units** | +1 movement, teleport purchases | Faster-paced early/mid game |
| **Barbarians** | Cheaper bribes, more aggression | More persistent early threat |
| **Space Race** | Cheaper spaceport & projects | Slightly easier science victory |
| **Coastal Flooding** | Configurable cascading lowlands | Player-controlled apocalyptic flooding |
| **Secret Societies** | Cultists teleport, Dark Summoning triggers Apocalypse | Stronger secret society synergy |
| **Wonders** | Ultracristo Vinditador | Massive area-of-effect loyalty drain on enemies |
