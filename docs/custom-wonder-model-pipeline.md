# Shit We Learned: How Custom Wonder Models Actually Work in Civ VI

**Date:** 2025-04-22  
**Based on:** Sukritact's Wat Arun (Workshop ID `3357874053`)  
**Topic:** The complete end-to-end pipeline for adding a custom world wonder with its own 3D model, textures, icons, audio, and cinematic.

---

## The Big Picture

Custom wonders in Civ VI are **not** defined by pointing an XML file at a 3D model. The engine loads geometry by **naming convention** from compiled `.blp` archives. Your `.artdef` files only handle 2D sprites and configuration flags. The actual 3D model is invisible magic pulled from compressed packages.

Here is the full pipeline, from database row to rendered statue.

---

## 1. File Structure of a Complete Wonder Mod

```
MyCustomWonder/
├── ArtDefs/
│   ├── Buildings.artdef          ← Behavior flags + strategic view states
│   ├── StrategicView.artdef      ← 2D map icon definitions
│   └── WonderMovie.artdef        ← Construction cinematic config
├── Core/
│   ├── Gameplay/
│   │   └── MyWonder_Buildings.sql    ← Database: building, yields, modifiers
│   ├── Common/
│   │   └── MyWonder_Icons.sql        ← Icon atlas + icon definitions
│   └── Localisation/
│       └── MyWonder_EN_US.sql        ← Name, description, quote, pedia
├── Platforms/
│   ├── Windows/
│   │   ├── Audio/
│   │   │   ├── WON_MyWonder.bnk
│   │   │   ├── WON_MyWonder.ini
│   │   │   └── 12345678.wem
│   │   └── BLPs/
│   │       ├── landmarks/
│   │       │   └── tilebases.blp     ← THE 3D MODEL lives here
│   │       ├── SHARED_DATA/
│   │       │   └── TEXTURE_*         ← Raw textures (no extensions)
│   │       ├── strategicview/
│   │       │   └── strategicview_buildings.blp
│   │       ├── UITextures.blp
│   │       └── WonderMovie.blp
│   └── MacOS/                        ← Same structure, same textures
│       └── BLPs/
│           └── (mirrors Windows minus Audio)
├── MyCustomWonder.dep              ← Tells engine which BLPs to mount
└── MyCustomWonder.modinfo          ← Registers all files + actions
```

**Critical observation:** There are **no** loose `.ast`, `.mtl`, or `.dds` files. Everything is packed into `.blp` archives.

---

## 2. The Database Layer (SQL)

The gameplay side is straightforward SQL. Wat Arun uses three files:

### `Core/Gameplay/Suk_WatArun_Buildings.sql`
- **`Types`** → `BUILDING_SUK_WAT_ARUN` (`KIND_BUILDING`)
- **`Buildings`** → Cost, prereq civic, wonder flag, placement rules (copied from Potala Palace in this case)
- **`Building_YieldChanges`** → Base yields (+4 Culture)
- **`Modifiers`** → Three custom gameplay effects:
  1. Commercial Hubs grant Culture equal to their Gold adjacency
  2. Commercial Hubs grant Tourism from Gold adjacency (requires Flight)
  3. +4 Great Person points for every river-adjacent district
- **`DynamicModifiers`** → A new effect type for the tourism adjacency bonus

### `Core/Common/Suk_WatArun_Icons.sql`
- **`IconTextureAtlases`** → Registers `ICON_ATLAS_SUK_WATARUN` with 18 size variants (256 down to 22)
- **`IconDefinitions`** → `ICON_BUILDING_SUK_WAT_ARUN` → atlas index 0

The actual icon atlas images are baked into `UITextures.blp`.

### `Core/Localisation/Suk_WatArun_EN_US.sql`
- Standard `BaseGameText` entries for name, description, quote, and Civilopedia paragraphs.

---

## 3. The `.modinfo` — How Files Are Loaded

```xml
<InGameActions>
  <UpdateDatabase id="Gameplay">
    <Properties><LoadOrder>20</LoadOrder></Properties>
    <File>Core/Gameplay/Suk_WatArun_Buildings.sql</File>
  </UpdateDatabase>
  <UpdateArt id="Art">
    <File>Sukritact_s_Wat_Arun.dep</File>
  </UpdateArt>
  <UpdateText id="Text">
    <File>Core/Localisation/Suk_WatArun_EN_US.sql</File>
  </UpdateText>
  <UpdateIcons id="Icons">
    <File>Core/Common/Suk_WatArun_Icons.sql</File>
  </UpdateIcons>
  <UpdateAudio id="Audio">
    <File>Platforms/Windows/Audio/WON_Suk_WatArun.ini</File>
  </UpdateAudio>
</InGameActions>
```

The `<Files>` block must explicitly list **every single file** (132 entries in Wat Arun's case), including all `.artdef` files, all SQL files, both platforms' BLP archives, and every raw texture inside `SHARED_DATA`.

---

## 4. The `.dep` File — The Glue That Mounts Archives

The `.dep` is an **art dependency manifest**. It tells the asset loader which "consumers" need which "libraries," and which `.blp` packages provide them.

### Identity Block
```xml
<ID>
  <name text="Sukritact_s_Wat_Arun"/>
  <id text="e3052708-b650-4f3a-8e5c-da8f2a287524"/>
</ID>
```

### SystemDependencies (Consumers)
These declare which engine subsystems need data:

| Consumer | Libraries Loaded | Purpose |
|----------|------------------|---------|
| `Landmarks` | `CityBuildings`, `TileBase`, `RouteDecalMaterial` | **This is where the 3D model comes from** |
| `StrategicView_Sprite` | `StrategicView_Sprite`, `StrategicView_DirectedAsset` | 2D map icons |
| `WonderMovie` | `WonderMovie`, `TileBase`, `GameLighting`, `ColorKey` | Construction cinematic |
| `UI` | `UITexture` | HUD/building panel icons |
| `VFX` | `VFX`, `Light` | Particle effects |

### LibraryDependencies (Packages)
These map abstract libraries to concrete `.blp` files:

```xml
<LibraryDependencies>
  <Element>
    <LibraryName text="CityBuildings"/>
    <PackageDependencies>
      <Element text="landmarks/tilebases.blp"/>
    </PackageDependencies>
  </Element>
  <Element>
    <LibraryName text="StrategicView_Sprite"/>
    <PackageDependencies>
      <Element text="strategicview/strategicview_buildings.blp"/>
    </PackageDependencies>
  </Element>
  <Element>
    <LibraryName text="WonderMovie"/>
    <PackageDependencies>
      <Element text="WonderMovie.blp"/>
    </PackageDependencies>
  </Element>
  <Element>
    <LibraryName text="UITexture"/>
    <PackageDependencies>
      <Element text="UITextures.blp"/>
    </PackageDependencies>
  </Element>
</LibraryDependencies>
```

**How the engine resolves it:**
1. `.modinfo` triggers `UpdateArt` → loads `.dep`
2. `.dep` mounts the four `.blp` archives into memory
3. When the game creates `BUILDING_SUK_WAT_ARUN`, the `Landmarks` consumer searches the `CityBuildings` library for an asset named `BUILDING_SUK_WAT_ARUN`
4. If found → render it. If not → fallback or invisible.

---

## 5. The `.artdef` Files — Configuration, Not Model References

### `Buildings.artdef` — Behavior Flags + Strategic View States

```xml
<Element>
  <m_Fields>
    <m_Values>
      <Element class="AssetObjects..BoolValue">
        <m_bValue>true</m_bValue>
        <m_ParamName text="IsWonderBuilding"/>
      </Element>
      <Element class="AssetObjects..StringValue">
        <m_Value text="AVERAGE"/>
        <m_ParamName text="TerrainFollowMode"/>
      </Element>
      <Element class="AssetObjects..BoolValue">
        <m_bValue>false</m_bValue>
        <m_ParamName text="UsesDecalMaterialOverrides"/>
      </Element>
    </m_Values>
  </m_Fields>
  <m_ChildCollections>
    <Element>
      <m_CollectionName text="StrategicView"/>
      <!-- Completed state -->
      <Element>
        <m_Fields>
          <m_Values>
            <Element class="AssetObjects..ArtDefReferenceValue">
              <m_ElementName text="Suk_WatArun"/>
              <m_RootCollectionName text="Buildings"/>
              <m_ArtDefPath text="StrategicView.artdef"/>
              <m_ParamName text="XrefName"/>
            </Element>
            <Element class="AssetObjects..ArtDefReferenceValue">
              <m_ElementName text="Completed"/>
              <m_RootCollectionName text="BuildStates"/>
              <m_ArtDefPath text="Buildings.artdef"/>
              <m_ParamName text="State"/>
            </Element>
          </m_Values>
        </m_Fields>
      </Element>
      <!-- Pillaged and UnderConstruction states follow same pattern -->
    </Element>
  </m_ChildCollections>
  <m_Name text="BUILDING_SUK_WAT_ARUN"/>
</Element>
```

**What this actually does:**
- Declares the building is a wonder
- Sets terrain following mode
- Says "do not use decal material overrides" (render as full 3D model)
- Points three build states to entries in `StrategicView.artdef`

**It does NOT reference a 3D model anywhere.**

---

### `StrategicView.artdef` — 2D Map Icons

```xml
<!-- BuildingEntries collection -->
<Element>
  <m_Name text="Suk_WatArun"/>
  <m_Fields>
    <m_Values>
      <Element class="AssetObjects..BLPEntryValue">
        <m_EntryName text="Wonders_WatArun_Visible"/>
        <m_XLPClass text="StrategicView_Sprite"/>
        <m_XLPPath text="StrategicView_Buildings.xlp"/>
        <m_BLPPackage text="strategicview/strategicview_buildings"/>
        <m_LibraryName text="StrategicView_Sprite"/>
        <m_ParamName text="Visible_XLPEntry"/>
      </Element>
      <Element class="AssetObjects..BLPEntryValue">
        <m_EntryName text="Wonders_WatArun_Revealed"/>
        <m_XLPClass text="StrategicView_Sprite"/>
        <m_XLPPath text="StrategicView_Buildings.xlp"/>
        <m_BLPPackage text="strategicview/strategicview_buildings"/>
        <m_LibraryName text="StrategicView_Sprite"/>
        <m_ParamName text="Revealed_XLPEntry"/>
      </Element>
    </m_Values>
  </m_Fields>
</Element>
```

Each state gets a `Visible` and `Revealed` sprite from the `strategicview_buildings.blp` package.

---

### `WonderMovie.artdef` — Construction Cinematic

```xml
<Element>
  <m_Name text="BUILDING_SUK_WAT_ARUN"/>
  <m_Fields>
    <m_Values>
      <Element class="AssetObjects..BLPEntryValue">
        <m_EntryName text="WON_Suk_WatArun_Movie"/>
        <m_XLPClass text="WonderMovie"/>
        <m_XLPPath text="WonderMovie.xlp"/>
        <m_BLPPackage text="WonderMovie"/>
        <m_LibraryName text="WonderMovie"/>
        <m_ParamName text="Asset"/>
      </Element>
      <Element class="AssetObjects..ColorValue">
        <m_r>255</m_r><m_g>255</m_g><m_b>255</m_b>
        <m_ParamName text="TintColor"/>
      </Element>
      <Element class="AssetObjects..StringValue">
        <m_Value text="DEFAULT_NIGHT"/>
        <m_ParamName text="TimeOfDayCurve"/>
      </Element>
      <Element class="AssetObjects..StringValue">
        <m_Value text="WONDER_TOD"/>
        <m_ParamName text="TimeOfDayLighting"/>
      </Element>
      <Element class="AssetObjects..BoolValue">
        <m_bValue>true</m_bValue>
        <m_ParamName text="FlattensTerrain"/>
      </Element>
      <Element class="AssetObjects..BoolValue">
        <m_bValue>true</m_bValue>
        <m_ParamName text="FollowTerrainHeight"/>
      </Element>
      <Element class="AssetObjects..IntValue">
        <m_nValue>7</m_nValue>
        <m_ParamName text="MinVisualProgress"/>
      </Element>
      <Element class="AssetObjects..IntValue">
        <m_nValue>87</m_nValue>
        <m_ParamName text="MaxVisualProgress"/>
      </Element>
    </m_Values>
  </m_Fields>
</Element>
```

This controls the cinematic that plays on completion. The actual movie geometry is inside `WonderMovie.blp`.

---

## 6. The `.blp` Archives — Where Everything Actually Lives

`.blp` files are **proprietary compiled archives** (header starts with `CIVBLP`). They are not ZIP files and cannot be opened with standard tools.

| Archive | Size (Windows) | Contents |
|---------|---------------|----------|
| `landmarks/tilebases.blp` | ~19 MB | **The 3D world model**, materials, and base tile geometry |
| `strategicview/strategicview_buildings.blp` | ~560 KB | 2D sprite sheet for strategic view |
| `UITextures.blp` | ~350 KB | HUD/building panel icon atlas |
| `WonderMovie.blp` | ~21 MB | Construction cinematic geometry, textures, and animation |

### How the Model Is Named Inside `tilebases.blp`

The engine searches the `CityBuildings` library (loaded from `tilebases.blp`) for an asset with the exact name `BUILDING_SUK_WAT_ARUN`. **This is pure naming convention.** There is no XML pointer to the model.

---

## 7. The `SHARED_DATA/` Textures

These are **39 raw binary files** (no extensions) that the engine loads alongside `tilebases.blp`:

### Main Wonder Model (`T_SukWatArun`)
| File | Purpose |
|------|---------|
| `TEXTURE_T_SukWatArun_ao` | Ambient Occlusion |
| `TEXTURE_T_SukWatArun_E` | Emissive |
| `TEXTURE_T_SukWatArun_G` | Glossiness / Roughness |
| `TEXTURE_T_SukWatArun_L` | Lightmap |
| `TEXTURE_T_SukWatArun_M` | Metallic / Material mask |
| `TEXTURE_T_SukWatArun_N0` | Normal map (primary) |
| `TEXTURE_T_SukWatArun_N1` | Normal map (detail) |
| `TEXTURE_DiffuseTint_T_SukWatArun_B_null` | Diffuse / Base color tint |

### Construction Props (`WON_Construction_props`)
| File | Purpose |
|------|---------|
| `TEXTURE_WON_Construction_props_G` | Glossiness |
| `TEXTURE_WON_Construction_props_M` | Metallic |
| `TEXTURE_WON_Construction_props_N0` | Normal (primary) |
| `TEXTURE_WON_Construction_props_N1` | Normal (detail) |
| `TEXTURE_DiffuseTint_WON_Construction_props_B_null` | Diffuse / Base color |

### Wonder Movie Materials (`WON_Movie_Brick`, `WON_Movie_Wall`)
Multiple texture sets for the construction cinematic, following the same `_G`, `_M`, `_N0`, `_N1`, `DiffuseTint` pattern.

### Era Decals
For each era (Ancient, Industrial, Modern):
- `_B` — Base color / Diffuse
- `_FOW` — Fog of War variant
- `_H` — Height or secondary blend map
- `_null` DiffuseTint

### Utility Textures
- `TEXTURE_Ancient_dirt_base_op` — Dirt/ground overlay
- `TEXTURE_Burn_BaseColor` — Damage/burn overlay
- `TEXTURE_Burn_G` — Burn glossiness
- `TEXTURE_ProceduralNoiseTexture2D_0x304656c5` — Procedural noise lookup

---

## 8. Audio

| File | Purpose |
|------|---------|
| `WON_Suk_WatArun.bnk` | Wwise soundbank stub (~450 bytes) |
| `84434908.wem` | Streamed audio file (~309 KB, the actual music) |
| `WON_Suk_WatArun.ini` | Bank registration: `[InGame] WON_Suk_WatArun.bnk` |
| `WON_Suk_WatArun.xml` | Wwise bank metadata |
| `WON_Suk_WatArun.txt` | Human-readable event IDs |

**Audio events:**
- `Play_Wonder_Music_Suk_Wat_Arun`
- `Stop_Wonder_Music_Suk_Wat_Arun`

The `.modinfo` loads audio via `UpdateAudio` pointing at the `.ini` file.

---

## 9. The Complete Data Flow

```
Game starts
    ↓
.modinfo loads
    ↓
UpdateDatabase → SQL files create BUILDING_SUK_WAT_ARUN
UpdateText     → Localized strings loaded
UpdateIcons    → Icon atlas + definitions loaded
UpdateArt      → .dep file loaded
    ↓
.dep mounts BLP archives into memory:
    - landmarks/tilebases.blp      (CityBuildings library)
    - strategicview_buildings.blp  (StrategicView_Sprite library)
    - UITextures.blp               (UITexture library)
    - WonderMovie.blp              (WonderMovie library)
    ↓
.artdef files parsed:
    - Buildings.artdef      → "BUILDING_SUK_WAT_ARUN is a wonder, here are its states"
    - StrategicView.artdef  → "state X maps to sprite Y in strategicview_buildings.blp"
    - WonderMovie.artdef    → "completion cinematic is Z in WonderMovie.blp"
    ↓
Player builds wonder
    ↓
Engine searches CityBuildings library for asset named "BUILDING_SUK_WAT_ARUN"
    ↓
Found inside tilebases.blp → Renders 3D model + loads SHARED_DATA textures
    ↓
Wonder completes
    ↓
WonderMovie.artdef config + WonderMovie.blp asset = plays cinematic
```

---

## 10. What You Need to Make a Custom Wonder Model

If you want to build something from scratch (not reuse existing assets):

1. **Model the geometry** in Blender, Maya, or 3ds Max
2. **Export to FBX** (or whatever the Civ VI Asset Editor accepts)
3. **Open Civ VI Asset Editor** (part of the SDK)
4. **Import the model** and name the asset exactly `BUILDING_YOUR_WONDER_NAME`
5. **Assign materials** and link to your texture files
6. **Build/Pack** — the editor outputs:
   - `landmarks/tilebases.blp` (your model + materials)
   - `SHARED_DATA/TEXTURE_*` files (your textures)
   - Optionally `WonderMovie.blp` (if you also authored a cinematic)
7. **Write the SQL** for gameplay definition
8. **Write the `.artdef` files** for configuration
9. **Write the `.dep` file** to mount your `.blp` packages
10. **Write the `.modinfo`** to register everything

**There is no way to point Buildings.artdef at a loose `.ast` file.** The 3D model pipeline is entirely `.blp` + naming convention + `.dep` registration.

---

## 11. Comparison: What We Did for Ultracristo (Asset Reuse)

Our current approach skips the entire asset creation pipeline:

| Component | Wat Arun (Custom) | Ultracristo (Reuse) |
|-----------|-------------------|---------------------|
| 3D Model | Custom in `tilebases.blp` | Piggybacks on base game Cristo Redentor by convention |
| Strategic View | Custom sprites in `strategicview_buildings.blp` | Reuses base game `CristoRedentor` sprites |
| Icons | Custom atlas in `UITextures.blp` | Reuses base game `ICON_ATLAS_WONDERS` index 27 |
| Wonder Movie | Custom `WonderMovie.blp` | Reuses base game `WonderMovie.blp` |
| Audio | Custom Wwise bank | Reuses base game `Play_CRISTOREDENTOR_QUOTE` |
| `.dep` | Registers `Landmarks`, `CityBuildings`, `TileBase` | Only registers `StrategicView_Sprite` and `WonderMovie` |

Because our `.dep` does **not** register a `Landmarks` consumer or a custom `CityBuildings` library, the engine falls back to base game assets by convention. This is why the model works even though we never explicitly told it to load one.

---

## Key Takeaway

**`.artdef` files are configuration routers, not asset loaders.** The actual geometry is pulled from compiled `.blp` archives by naming convention. To make a truly custom wonder, you must author assets in the Civ VI Asset Editor, package them into `.blp` files, and register those packages in your `.dep` file under the correct consumer/library mapping.
