# Destructive & Harmful Effects Reference — All Game Data

**Date:** 2026-04-25  
**Sources:** Base game XML, DLC files, Black Death scenario, Civ Royale scenario, Cold War scenario, Alexander scenario, Napoleon scenario, DebugGameplay.sqlite database.

This is a comprehensive reference of every destructive and harmful effect system in Civ VI that could potentially be referenced or implemented in a mod. Organized by category with file locations and exact parameter names/values where available.

---

## 1. Weapons of Mass Destruction (WMDs)

### WMD Types
| Type | Blast Radius | Fallout Duration | ICBM Strike Range | Effect |
|------|-------------|------------------|-------------------|--------|
| `WMD_NUCLEAR_DEVICE` | 1 plot | 10 turns | 12 | Population, Improvements, Buildings, Units, Resources, Routes |
| `WMD_THERMONUCLEAR_DEVICE` | 2 plots | 20 turns | 15 | Same effects, larger area |

**File:** `Base\Assets\Gameplay\Data\WMDs.xml` (lines 11-13)

### WMD Projects
| ProjectType | WMD Flag | Notes |
|-------------|----------|-------|
| `PROJECT_MANHATTAN_PROJECT` | true | Requires Uranium, triggers WMD capability |
| `PROJECT_OPERATION_IVY` | true | Nuclear test project |
| `PROJECT_BUILD_NUCLEAR_DEVICE` | true | Build nuclear weapon (cost 800) |
| `PROJECT_BUILD_THERMONUCLEAR_DEVICE` | true | Build thermonuclear weapon (cost 1000) |
| `PROJECT_DECOMMISSION_NUCLEAR_POWER_PLANT` | false | Removes nuke capability |

**File:** `Base\Assets\Gameplay\Data\Projects.xml` (lines 16-17, 34-37)

### WMD Modifiers & Effects
| ModifierType | EffectType | Purpose |
|-------------|-----------|---------|
| `MODIFIER_PLAYER_CREATE_WMD` | `EFFECT_ADJUST_PLAYER_WMD_COUNT` | Grant WMD capability |
| `MODIFIER_PLAYER_UNIT_ADJUST_WMD_RESISTANCE` | `EFFECT_ADJUST_UNIT_WMD_PROTECTION` | WMD resistance for units |
| `MODIFIER_PLAYER_ADJUST_WMD_MAINTENANCE_MODIFIER` | — | Reduce WMD maintenance cost |
| `MODIFIER_PLAYERS_ADJUST_WMD_STOCKPILE` | — | Adjust WMD stockpile cap |

### Global Parameters (WMD)
| Parameter | Value | Notes |
|-----------|-------|-------|
| `WAR_WEARINESS_PER_WMD_LAUNCHED` | 10 | War weariness from nuke launch |
| `MAYHEM_NUCLEAR_LAUNCH` | 5.0 | Mayhem score for nuke launch |

**File:** `Base\Assets\Gameplay\Data\GlobalParameters.xml` (lines 635, 386)

### WMD-Capable Units
| UnitType | Combat | Bombard | Range | WMDCapable |
|----------|--------|---------|-------|------------|
| `UNIT_BOMBER` | 85 | 110 | 10 | true |
| `UNIT_JET_BOMBER` | 90 | 120 | 15 | true |
| `UNIT_NUCLEAR_SUBMARINE` | 80 | 85 | 2 | true |

**File:** `Base\Assets\Gameplay\Data\Units.xml` (lines 830, 841, 836)

### Nuclear Assault Operation
- **Type:** `OP_NUCLEAR` (value=5)
- **Operation:** `Nuclear Assault` — targets enemy districts with nukes
- **Behavior tree:** 22 nodes in `BehaviorTrees.xml` lines 473-804
- **Limit:** 2 nuclear operations per player

**File:** `Base\Assets\Gameplay\Data\Operations.xml`, `BehaviorTrees.xml`

---

## 2. Plot Contamination / Fallout / Radiation

### Core Mechanic
| Parameter | Value | Notes |
|-----------|-------|-------|
| `PLOT_CONTAMINATION_DAMAGE_BASE` | 50 (base) / 20 (Black Death) | Damage per turn for units on contaminated plots |

Units standing on contaminated/fallout tiles take damage every turn. Tiles also cannot be worked/improved/built upon while contaminated.

### Fallout Unit Ability
- `FALLOUT_MOVE` — Fallout mutant movement ability
- `FALLOUT_RESISTANCE` — Reduced fallout damage
- `FALLOUT_SPEED` — Increased speed in fallout zones
- `SPREAD_FALLOUT_IMMUNE` — Cannot spread radiation

**File:** `DLC\CivRoyaleScenario\Data\CivRoyaleScenario_Civilizations.xml` (lines 35, 107, 194)

### Fallout Units (Civ Royale Scenario)
Mutant units with fallout abilities spawn after nuclear detonations in the Civ Royale scenario.

**File:** `DLC\CivRoyaleScenario\Data\CivRoyaleScenario_GameplayData.xml` (line 10: `PLOT_WATER_DAMAGE_BASE = 8`)

### Nuclear Accident Random Event
| Event Type | EffectOperatorType | Severity |
|-----------|-------------------|----------|
| `RANDOM_EVENT_NUCLEAR_ACCIDENT_MINOR` | `NUCLEAR_ACCIDENT` | Minor contamination |
| `RANDOM_EVENT_NUCLEAR_ACCIDENT_MAJOR` | `NUCLEAR_ACCIDENT` | Major contamination |
| `RANDOM_EVENT_NUCLEAR_ACCIDENT_CATASTROPHIC` | `NUCLEAR_ACCIDENT` | Catastrophic contamination |

**File:** `DLC\Expansion2\Data\Expansion2_RandomEvents.xml` (lines 30-32)

---

## 3. Combat Damage Parameters

### Base Combat Values
| Parameter | Value | Notes |
|-----------|-------|-------|
| `COMBAT_BASE_DAMAGE` | 24 | Base damage per attack |
| `COMBAT_MINIMUM_DAMAGE` | 1 | Minimum possible damage |
| `COMBAT_MAX_EXTRA_DAMAGE` | 12 | Maximum bonus damage |
| `COMBAT_DAMAGE_MULTIPLIER_MINIMUM` | 0.25 | Minimum damage multiplier |
| `COMBAT_BASE_CAPTURE_STRENGTH_DIFFERENCE` | 20 | Strength diff needed to capture |

### Defense Damage Percentages
| Parameter | Value | Notes |
|-----------|-------|-------|
| `COMBAT_DEFENSE_DAMAGE_PERCENT_BOMBARD` | 100 | Bombard does full damage to defenses |
| `COMBAT_DEFENSE_DAMAGE_PERCENT_MELEE` | 15 | Melee does 15% to defenses |
| `COMBAT_DEFENSE_DAMAGE_PERCENT_RANGED` | 50 | Ranged does 50% to defenses |

### Wounded Units
| Parameter | Value | Notes |
|-----------|-------|-------|
| `COMBAT_WOUNDED_DAMAGE_MULTIPLIER` | 10 | Wounded units deal 10x damage (desperation) |
| `COMBAT_WOUNDED_DISTRICT_DAMAGE_MULTIPLIER` | 10 | Wounded units deal 10x district damage |

### City Combat
| Parameter | Value | Notes |
|-----------|-------|-------|
| `COMBAT_CITY_RANGED_DAMAGE_THRESHOLD` | 50 | Ranged damage threshold for cities |
| `COMBAT_DISTRICT_STRENGTH_REDUCTION` | 15 | District strength reduction per turn |

### Civilian Damage
| Parameter | Value | Notes |
|-----------|-------|-------|
| `COMBAT_MIN_CIVILIAN_DAMAGE_PERCENT` | 65 | Minimum civilian collateral damage |

**File:** `Base\Assets\Gameplay\Data\GlobalParameters.xml` (lines 130-225)

### Damage Modifiers (Effect/Modifier pairs)
| ModifierType | EffectType | Scope |
|-------------|-----------|-------|
| `MODIFIER_PLAYER_UNIT_ADJUST_DAMAGE` | `EFFECT_ADJUST_UNIT_DAMAGE` | Single unit |
| `MODIFIER_PLAYER_UNITS_ADJUST_DAMAGE` | `EFFECT_ADJUST_UNIT_DAMAGE` | All player units |
| `MODIFIER_WORLD_UNITS_ADJUST_DAMAGE` | `EFFECT_ADJUST_UNIT_DAMAGE` | All world units |
| `MODIFIER_PLAYER_UNIT_ADJUST_NO_REDUCTION_DAMAGE` | `EFFECT_ADJUST_UNIT_NO_REDUCTION_DAMAGE` | No HP reduction penalty |
| `MODIFIER_PLAYER_UNITS_ADJUST_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER` | `EFFECT_ADJUST_UNIT_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER` | Strength scales with damage taken |

**File:** `Base\Assets\Gameplay\Data\Modifiers.xml` (lines 1575-1588, 1890-1893)

---

## 4. City Destruction / Capture / Razing

### City Capture Mechanics
| Parameter | Value | Notes |
|-----------|-------|-------|
| `CITY_CAPTURED_DAMAGE_PERCENTAGE` | 50 | City loses 50% HP on capture |
| `CITY_POPULATION_LOSS_TO_CONQUEST_PERCENTAGE` | 0.25 (25%) | Population loss on conquest |
| `COMBAT_KEEP_ALL_CITIES_ON_CAPTURE` | false | If true, all cities stay; if false, capital is lost |
| `COMBAT_RAZE_ANY_CITY` | false | Whether razing is enabled |
| `EXPERIENCE_CITY_CAPTURED` | 10 | XP for capturing a city |

### Razing Penalties
| Parameter | Value | Notes |
|-----------|-------|-------|
| `WARMONGER_RAZE_PENALTY_PERCENT` | 200 | Double warmonger penalty for razing |

**File:** `Base\Assets\Gameplay\Data\GlobalParameters.xml` (lines 74, 112, 178, 208, 284, 649)

### Leader Traits — Razing/Diplomatic Effects
| LeaderType/Trait | ModifierType | Effect |
|-----------------|-------------|--------|
| Caesar (`TRAIT_LEADER_CAESAR`) | `MODIFIER_PLAYER_CAPTURED_CITY_ATTACH_MODIFIER` | Captured cities get special treatment |
| Fall of Babylon (`TRAIT_LEADER_FALL_BABYLON`) | `MODIFIER_PLAYER_LOYALTY_ADJUST_MARTIAL_LAW_MODIFIER` | Martial law loyalty adjustment |
| Mother Russia (`TRAIT_CIVILIZATION_MOTHER_RUSSIA`) | `MODIFIER_PLAYER_ADJUST_RANDOM_EVENT_MODIFIED_DAMAGE_OPPOSING_PLAYER` | Opposing players take more disaster damage |

### Diplomatic Raze Penalties
- `STANDARD_DIPLOMATIC_RAZED_MY_CITY` — Other leaders get angry when you raze cities
- Five levels of raze penalty in Leaders.xml (lines 3135-3157)

**File:** `Base\Assets\Gameplay\Data\Leaders.xml` (lines 1012, 1352-1357, 3135-3157)

---

## 5. District/Building Destruction & Pillage

### District Hit Points
| DistrictType | HitPoints | CaptureRemovesBuildings | PlunderType | PlunderAmount |
|-------------|-----------|------------------------|-------------|---------------|
| `DISTRICT_CITY_CENTER` | 200 | true | NO_PLUNDER | 0 |
| `DISTRICT_ENCAMPMENT` | 100 | true | NO_PLUNDER | 0 |
| `DISTRICT_IKANDA` | 100 | true | NO_PLUNDER | 0 |
| `DISTRICT_OPPIDUM` | 100 | true | NO_PLUNDER | 0 |
| `DISTRICT_THANH` | 100 | true | NO_PLUNDER | 0 |
| All other districts | 0 | — | varies (Gold/Science/Faith/Culture/Heal) | 25-50 |

**File:** `Base\Assets\Gameplay\Data\Districts.xml` (lines 43-63)

### Pillage Modifiers
| ModifierType | EffectType | Notes |
|-------------|-----------|-------|
| `MODIFIER_PLAYER_ADJUST_DISTRICT_PILLAGE` | `EFFECT_ADJUST_UNIT_PILLAGE_DISTRICT_MODIFIER` | District pillage modifier |
| `MODIFIER_PLAYER_ADJUST_IMPROVEMENT_PILLAGE` | `EFFECT_ADJUST_UNIT_PILLAGE_IMPROVEMENT_MODIFIER` | Improvement pillage modifier |
| `MODIFIER_PLAYER_UNITS_ADJUST_PLUNDER_YIELDS` | `EFFECT_ADJUST_UNIT_PLUNDER_YIELDS` | Plunder yield from units |
| `MODIFIER_PLAYER_UNIT_ADJUST_PLUNDER_YIELDS` | `EFFECT_ADJUST_UNIT_PLUNDER_YIELDS` | Single unit plunder |
| `MODIFIER_PLAYER_ADJUST_ADDITIONAL_PILLAGING` | — | Additional pillaging capability |

### Pillage Global Parameters
| Parameter | Value | Notes |
|-----------|-------|-------|
| `PILLAGE_MOVEMENT_COST` | 3 | Movement cost on pillaged tiles |
| `PILLAGE_ADVANCED_MOVEMENT_COST` | 1 | Advanced pillager movement cost |
| `PILLAGE_BUILDING_REPAIR_PERCENT` | 25 | Building repair cost after pillage |
| `HARVEST_PILLAGED_DEGRADATION` | 30 | Degradation of pillaged improvements |

### Mayhem Scores (Destruction Tracking)
| Parameter | Value | Notes |
|-----------|-------|-------|
| `MAYHEM_BUILDING_PILLAGED` | 2.0 | Score for pillaging a building |
| `MAYHEM_DISTRICT_PILLAGED` | 1.5 | Score for pillaging a district |
| `MAYHEM_DISTRICT_DEATH` | 1.0 | Score for destroying a district |
| `MAYHEM_DISTRICT_DEATH_WITH_BARBARIANS` | 0.5 | Reduced score (barb kills) |
| `MAYHEM_IMPROVEMENT_PILLAGED` | 1.0 | Score for pillaging an improvement |
| `MAYHEM_CITY_DEATH` | 3.0 | Score for destroying a city |
| `MAYHEM_CITY_DEATH_WITH_BARBARIANS` | 2.0 | Reduced score (barb kills) |
| `MAYHEM_UNIT_COMBAT` | 1.0 | Score for unit combat |
| `MAYHEM_UNIT_DEATH` | 1.0 | Score for unit death |
| `MAYHEM_PLAYER_DESTROYED` | 3.0 | Score for destroying a player/civ |
| `MAYHEM_NUCLEAR_LAUNCH` | 5.0 | Score for nuclear launch |

**File:** `Base\Assets\Gameplay\Data\GlobalParameters.xml` (lines 366-400)

---

## 6. War Weariness & Warmongering

### War Weariness Parameters
| Parameter | Value | Notes |
|-----------|-------|-------|
| `WAR_WEARINESS_DECAY_PEACE_DECLARED` | 2000 | Decay rate when peace is declared |
| `WAR_WEARINESS_DECAY_TURN_AT_PEACE` | 200 | Daily decay at peace |
| `WAR_WEARINESS_DECAY_TURN_AT_WAR` | 50 | Daily decay during war |
| `WAR_WEARINESS_PER_COMBAT_IN_ALLIED_LANDS` | 1 | Weariness per combat in allied territory |
| `WAR_WEARINESS_PER_COMBAT_IN_FOREIGN_LANDS` | 2 | Weariness per combat in foreign territory |
| `WAR_WEARINESS_PER_UNIT_KILLED` | 3 | Weariness per unit killed |
| `WAR_WEARINESS_PER_WMD_LAUNCHED` | 10 | Weariness from WMD launch |
| `WAR_WEARINESS_POINTS_FOR_AMENITY_LOSS` | 400 | Points threshold for amenity loss |

### Warmongering Parameters
| Parameter | Value | Notes |
|-----------|-------|-------|
| `WARMONGER_BASE` | 16 | Base warmonger score |
| `WARMONGER_CITY_PERCENT_OF_DOW` | 50 | City conquest as % of declaration of war |
| `WARMONGER_FINAL_MAJOR_CITY_MULTIPLIER` | 200 | Multiplier for final major city |
| `WARMONGER_FINAL_MINOR_CITY_MULTIPLIER` | 100 | Multiplier for final minor city |
| `WARMONGER_LIBERATE_POINTS` | 32 | Points for liberating a city |
| `WARMONGER_RAZE_PENALTY_PERCENT` | 200 | Penalty multiplier for razing |
| `WARMONGER_REDUCTION_IF_AT_WAR` | 40 | Warmonger reduction if already at war |
| `WARMONGER_REDUCTION_IF_DENOUNCED` | 20 | Reduction if target denounced aggressor |

### War Weariness Modifiers
| ModifierType | EffectType | Scope |
|-------------|-----------|-------|
| `MODIFIER_PLAYER_ADJUST_WAR_WEARINESS` | `EFFECT_ADJUST_WAR_WEARINESS` | Adjust war weariness |
| `MODIFIER_PLAYER_ADJUST_MAX_WARMONGER_PERCENT` | — | Cap warmonger percentage |
| `MODIFIER_PLAYER_ADJUST_WARMONGER_MULTIPLIER` | `EFFECT_ADJUST_PLAYER_WARMONGER_MULTIPLIER` | Warmonger multiplier |
| `MODIFIER_PLAYER_DIPLOMACY_NEW_WARMONGER` | `EFFECT_ADJUST_PLAYER_NEW_WARMONGER` | New warmonger event |
| `MODIFIER_PLAYER_DIPLOMACY_THIRD_PARTY_WARMONGER` | — | Third-party warmonger |

### Governments with War Weariness Effects
| GovernmentType | ModifierType | Notes |
|---------------|-------------|-------|
| `GOVERNMENT_FASCISM` | `MODIFIER_PLAYER_ADJUST_WAR_WEARINESS` | Reduces war weariness |

**File:** `Base\Assets\Gameplay\Data\GlobalParameters.xml` (lines 617-655), `Modifiers.xml` (lines 84-85)

---

## 7. Bombardment & Siege Mechanics

### Bombard Units
| UnitType | Combat | Bombard | Range | Notes |
|----------|--------|---------|-------|-------|
| `UNIT_TREBUCHET` | — | 45 | 2 | Medieval siege |
| `UNIT_CATAPULT` | — | 35 | 2 | Classical siege |
| `UNIT_BOMBARD` | — | 55 | 2 | Renaissance |
| `UNIT_ARTILLERY` | 60 | 80 | 2 | Industrial age |
| `UNIT_ROCKET_ARTILLERY` | 70 | 100 | 3 | Modern |

### Bombard Abilities
| UnitAbilityType | Tag/Class | Notes |
|----------------|----------|-------|
| `ABILITY_BOMBARD_ATTACK_UNIT_DEBUFF` | CLASS_SIEGE | Debuffs units hit by bombard |
| `ABILITY_RANGED_ATTACK_DISTRICT_DEBUFF` | CLASS_RANGED | Debuffs district defenses |
| `ABILITY_AIR_FIGHTER_ATTACK_DISTRICT_DEBUFF` | CLASS_AIR_FIGHTER | Air fighter district debuff |
| `ABILITY_AIR_BOMBER_ATTACK_UNIT_DEBUFF` | CLASS_AIR_BOMBER | Bomber unit debuff |

### City Defense Parameters
| Parameter | Value | Notes |
|-----------|-------|-------|
| `COMBAT_BOMBARD_VS_UNIT_STRENGTH_MODIFIER` | 17 | Bombard vs unit strength |
| `COMBAT_RANGED_VS_DISTRICT_STRENGTH_MODIFIER` | 17 | Ranged vs district strength |
| `UNIT_MAX_DIRECT_LOYALTY_DAMAGE` | 30 | Max loyalty damage per unit attack |

### City Defense Modifiers
| ModifierType | EffectType | Notes |
|-------------|-----------|-------|
| `MODIFIER_PLAYER_CITIES_ADJUST_INNER_DEFENSE` | — | Inner defense strength |
| `MODIFIER_PLAYER_CITIES_ADJUST_OUTER_DEFENSE` | — | Outer defense strength |
| `MODIFIER_PLAYER_CITIES_ADJUST_RANGED_STRIKE` | — | City ranged strike capability |
| `MODIFIER_CITY_ADJUST_SIEGE_PROTECTION` | `EFFECT_ADJUST_CITY_SIEGE_PROTECTION` | Siege protection |
| `MODIFIER_CITY_ADJUST_AIR_DEFENSE_BONUS` | — | Air defense bonus |

### Wall Attack/Defense Abilities
| UnitAbilityType | Notes |
|----------------|-------|
| `ABILITY_ENABLE_WALL_ATTACK` | Allows attacking city walls (Battering Ram) |
| `ABILITY_BYPASS_WALLS` | Ignores wall defenses (Siege Tower) |

**File:** `Base\Assets\Gameplay\Data\Units.xml` (lines 789-847), `UnitAbilities.xml` (lines 102-105, 124-125, 428-431)

---

## 8. Unit Death / Kill Effects

### Kill Bonuses
| Parameter | Value | Notes |
|-----------|-------|-------|
| `EXPERIENCE_KILL_BONUS` | 2 | XP for killing a unit |
| `MAYHEM_UNIT_COMBAT` | 1.0 | Mayhem score for combat |
| `MAYHEM_UNIT_DEATH` | 1.0 | Mayhem score for death |

### Death-Related Modifiers
| ModifierType | EffectType | Notes |
|-------------|-----------|-------|
| `MODIFIER_PLAYER_UNIT_ADJUST_GREAT_PEOPLE_POINTS_PER_KILL` | `EFFECT_ADJUST_GREAT_PEOPLE_POINTS_PER_KILL` | GP points on kill |
| `MODIFIER_PLAYER_UNIT_ADJUST_RELIC_UPON_DEATH` | `EFFECT_ADJUST_UNIT_RELIC_UPON_DEATH` | Relic dropped on death |
| `MODIFIER_PLAYER_ADJUST_PLAYER_ERA_SCORE_PER_ARMY_KILLED` | — | Era score per army killed |
| `MODIFIER_PLAYER_ADJUST_PLAYER_ERA_SCORE_PER_CORPS_KILLED` | — | Era score per corps killed |
| `MODIFIER_PLAYER_ADJUST_PLAYER_ERA_SCORE_PER_NON_BARBARIAN_UNIT_KILLED_BY_GDR` | — | GDR kill score |
| `MODIFIER_PLAYER_ADJUST_PLAYER_ERA_SCORE_PER_NON_BARBARIAN_NAVAL_UNIT_KILLED` | — | Naval unit kill score |
| `MODIFIER_PLAYER_ADJUST_UNITS_GREAT_PEOPLE_POINTS_PER_KILL_BY_DEFEATED_STRENGTH` | `EFFECT_ADJUST_GREAT_PEOPLE_POINTS_PER_KILL_BY_DEFEATED_STRENGTH` | GP points by defeated strength |

### Unit Capture Mechanics
| ModifierType | EffectType | Notes |
|-------------|-----------|-------|
| `MODIFIER_UNIT_ADJUST_COMBAT_CAPTURE` | `EFFECT_ADJUST_UNIT_COMBAT_CAPTURE` | Ability to capture units in combat |
| `MODIFIER_PLAYER_UNIT_ADJUST_CITY_ON_CAPTURE` | `EFFECT_ADJUST_CITY_RELIGION_ON_CAPTURE` | Religion spread on city capture |
| `MODIFIER_PLAYER_CAPTURED_CITY_ATTACH_MODIFIER` | — | Attached modifiers for captured cities |

### Unit Capture Abilities
| UnitAbilityType | Tag/Class | Notes |
|----------------|----------|-------|
| `ABILITY_PRIZE_SHIPS` | CLASS_CAPTURE_SHIPS | Capture ships on kill |
| `ABILITY_CAPTIVE_WORKERS` | CLASS_CAPTURE_WORKER | Capture workers on kill |

### Retreat Mechanics
| ModifierType | Notes |
|-------------|-------|
| `MODIFIER_UNIT_ADJUST_FORCE_RETREAT` | Force enemy units to retreat |

**File:** `Base\Assets\Gameplay\Data\GlobalParameters.xml` (lines 292-306, 396-398), `Modifiers.xml` (lines 254, 281, 1765-1767)

---

## 9. Loyalty / Unrest / Rebellion Mechanics

### Loyalty Damage
| Parameter | Value | Notes |
|-----------|-------|-------|
| `UNIT_MAX_DIRECT_LOYALTY_DAMAGE` | 30 | Max loyalty damage a unit can deal per turn |

### Loyalty Modifiers
| ModifierType | EffectType | Notes |
|-------------|-----------|-------|
| `MODIFIER_PLAYER_ADJUST_POST_COMBAT_LOYALTY` | — | Post-combat loyalty adjustment |
| `MODIFIER_PLAYER_ADJUST_POST_PILLAGE_LOYALTY` | — | Post-pillage loyalty loss in enemy cities |
| `MODIFIER_SINGLE_CITY_GRANT_LOYALTY` | — | Grant loyalty to a city |
| `MODIFIER_SINGLE_UNIT_ADJUST_POST_TOURISM_BOMB_LOYALTY` | — | Tourism bomb loyalty effect |
| `MODIFIER_PLAYER_LOYALTY_ADJUST_MARTIAL_LAW_MODIFIER` | — | Martial law loyalty adjustment |
| `MODIFIER_EMERGENCY_TARGET_CITY_GRANT_LOYALTY` | — | Emergency: grant loyalty to target city |

### Rebellion Parameters
| Parameter | Value | Notes |
|-----------|-------|-------|
| `REBELLION_CHANCE_PER_POINT` | 2.0 | Rebellion chance per unhappiness point |
| `REBELLION_COOLDOWN_TURNS` | 20 | Cooldown after rebellion |

### Loyalty Levels
City loyalty has multiple levels (from LoyaltyLevels table) that determine whether a city flips to another civilization.

**File:** `Base\Assets\Gameplay\Data\GlobalParameters.xml` (line 607), `Modifiers.xml` (lines 866-868, various loyalty entries)

---

## 10. Attrition & Environmental Damage

### Water Damage
| Parameter | Value | Notes |
|-----------|-------|-------|
| `PLOT_WATER_DAMAGE_BASE` | 0 (base), 8 (Civ Royale) | Base damage per turn for units on water |

### Terrain-Specific Damage
| Source | Effect | Notes |
|--------|--------|-------|
| Tundra tiles | `-5` fertility modifier | Reduced food production |

**File:** `Base\Assets\Gameplay\Data\GlobalParameters.xml` (lines 451, 599)

### Attrition from Terrain/Features
Units on certain terrain types (swamps, tundra, mountains adjacent) may suffer implicit attrition through reduced movement and healing.

---

## 11. Natural Disasters (Random Events)

### Flood Events
| Event Type | EffectOperatorType | Damage Scale |
|-----------|-------------------|-------------|
| `RANDOM_EVENT_FLOOD_MODERATE` | `FLOODPLAIN` | Moderate damage |
| `RANDOM_EVENT_FLOOD_MAJOR` | `FLOODPLAIN` | Major damage |
| `RANDOM_EVENT_FLOOD_1000_YEAR` | `FLOODPLAIN` | Catastrophic 1000-year flood |

### Volcano Events
| Event Type | EffectOperatorType | Severity |
|-----------|-------------------|----------|
| `RANDOM_EVENT_KILIMANJARO_GENTLE` | `VOLCANO` | Gentle eruption |
| `RANDOM_EVENT_KILIMANJARO_CATASTROPHIC` | `VOLCANO` | Catastrophic |
| `RANDOM_EVENT_VESUVIUS_MEGACOLOSSAL` | `VOLCANO` | Mega-colossal |
| `RANDOM_EVENT_VOLCANO_GENTLE` | `VOLCANO` | Gentle |
| `RANDOM_EVENT_VOLCANO_CATASTROPHIC` | `VOLCANO` | Catastrophic |
| `RANDOM_EVENT_VOLCANO_MEGACOLOSSAL` | `VOLCANO` | Mega-colossal |

### Storm Events
| Event Type | EffectOperatorType | Severity |
|-----------|-------------------|----------|
| `RANDOM_EVENT_BLIZZARD_SIGNIFICANT` | `STORM` | Significant blizzard |
| `RANDOM_EVENT_BLIZZARD_CRIPPLING` | `STORM` | Crippling blizzard |
| `RANDOM_EVENT_TORNADO_FAMILY` | — | Tornado family |
| `RANDOM_EVENT_TORNADO_OUTBREAK` | — | Tornado outbreak |
| `RANDOM_EVENT_HURRICANE_CAT_4` | `STORM` | Category 4 hurricane |
| `RANDOM_EVENT_HURRICANE_CAT_5` | `STORM` | Category 5 hurricane |

### Other Disasters
| Event Type | EffectOperatorType | Notes |
|-----------|-------------------|-------|
| `RANDOM_EVENT_DUST_STORM_GRADIENT` | — | Dust storm gradient |
| `RANDOM_EVENT_DUST_STORM_HABOOB` | — | Haboob (severe dust storm) |
| `RANDOM_EVENT_DROUGHT_MAJOR` | `DROUGHT` | Major drought |
| `RANDOM_EVENT_DROUGHT_EXTREME` | `DROUGHT` | Extreme drought |

### Sea Level Rise
| Event Type | EffectOperatorType | Notes |
|-----------|-------------------|-------|
| `RANDOM_EVENT_SEA_LEVEL_RISE1` through `Rise7` | `SEA_LEVEL` | Progressive sea level rise |
| Effects: IceLoss, FertilityRemovalChance, coastal flooding | — | 7 levels of severity |

### Disaster Damage Modifiers
| ModifierType | EffectType | Notes |
|-------------|-----------|-------|
| `MODIFIER_PLAYER_ADJUST_RANDOM_EVENT_MODIFIED_DAMAGE_OPPOSING_PLAYER` | `EFFECT_ADJUST_RANDOM_EVENT_MODIFIED_DAMAGE_OPPOSING_PLAYER` | Increase damage to opposing players |
| `MODIFIER_PLAYER_ADJUST_RANDOM_EVENT_NO_UNIT_DAMAGE` | `EFFECT_ADJUST_RANDOM_EVENT_NO_UNIT_DAMAGE` | Prevent unit damage from disasters |
| `MODIFIER_PLAYER_ADJUST_AVOID_RANDOM_EVENT` | — | Avoid random events entirely |
| `MODIFIER_SINGLE_CITY_ADJUST_YIELD_FOR_FLOOD` | `EFFECT_ADJUST_CITY_YIELD_PER_FLOOD` | Flood yield adjustment |

### Disaster Prevention Traits
| TraitType | ModifierType | Effect |
|-----------|-------------|--------|
| Various leader traits | `NoDamage=1` in ModifierArguments | Prevents damage from specific disasters |

**File:** `DLC\Expansion2\Data\Expansion2_RandomEvents.xml` (lines 13-71), `Expansion2_Modifiers.xml` (lines 66, 109-110, 197)

---

## 12. Plague / Disease Mechanics (Black Death Scenario)

### Plague Damage
| Parameter | Value | Notes |
|-----------|-------|-------|
| `PLOT_CONTAMINATION_DAMAGE_BASE` | 20 | Damage per turn for units on plague-stricken tiles |

### Plague Effects
- Units on plague-stricken tiles suffer **20 damage per turn**
- City centers have a chance to lose **1 population per turn**
- Tiles cannot be worked, improved, or built upon while plague-stricken
- Creates `FEATURE_PLAGUE_STRICKEN` tiles (contaminated terrain)

### Plague Units & Buildings
| Type | Notes |
|------|-------|
| `UNIT_PLAGUE_DOCTOR` | Unit that can treat/cleanse plague |
| `BUILDING_PLAGUE_HOSPITAL` | Building that reduces plague effects |

**File:** `DLC\BlackDeathScenario\Data\BlackDeathScenario_GameplayData.xml` (line 510), `Text/en_US/BlackDeathScenario_GameplayText.xml` (lines 391-397)

---

## 13. Deforestation Effects

### Deforestation Levels
| Level | Threshold | Appeal Change |
|-------|-----------|--------------|
| `DEFORESTATION_LIGHT` | 10% of tiles | -1 appeal |
| `DEFORESTATION_EXPECTED` | 25% of tiles | +1 appeal |
| `DEFORESTATION_HEAVY` | 40% of tiles | +3 appeal |
| `DEFORESTATION_EXTREME` | 100% of tiles | +5 appeal |

### Deforestation Effects
| EffectType | Threshold | Appeal Change | Notes |
|-----------|-----------|--------------|-------|
| `DEFORESTATIONEFFECT_REDUCED` | 0% | -20 | Severe reduction |
| `DEFORESTATIONEFFECT_UNCHANGED` | 100% | 0 | No change |
| `DEFORESTATIONEFFECT_SLIGHTINCREASE` | 200% | +10 | Slight increase |
| `DEFORESTATIONEFFECT_INCREASE` | 300% | +30 | Moderate increase |
| `DEFORESTATIONEFFECT_HUGEINCREASE` | 500% | +50 | Massive increase |

**File:** SQLite database tables `DeforestationLevels`, `DeforestationEffects`

---

## 14. Policies with Destruction/Warmongering Effects

### Warmongering Policies
| PolicyType | ModifierType | Effect |
|-----------|-------------|--------|
| `POLICY_RAID` | `MODIFIER_PLAYER_ADJUST_IMPROVEMENT_PILLAGE` | Enhanced improvement pillage |
| `POLICY_RAID` | `MODIFIER_PLAYER_ADJUST_DISTRICT_PILLAGE` | Enhanced district pillage |
| `POLICY_TOTAL_WAR` | `MODIFIER_PLAYER_ADJUST_DISTRICT_PILLAGE` | Maximum district pillage |
| `POLICY_TOTAL_WAR` | `MODIFIER_PLAYER_ADJUST_IMPROVEMENT_PILLAGE` | Maximum improvement pillage |
| `POLICY_TOTAL_WAR` | `MODIFIER_PLAYER_UNITS_ADJUST_PLUNDER_YIELDS` | Enhanced plunder yields |
| `POLICY_LETTERS_OF_MARQUE` | `MODIFIER_PLAYER_UNITS_ADJUST_PLUNDER_YIELDS` | Naval plunder bonus |
| `POLICY_NATIONAL_IDENTITY` | `MODIFIER_PLAYER_UNITS_ADJUST_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER` | Strength scales with damage taken |

### Warfare Policies
| PolicyType | Notes |
|-----------|-------|
| `POLICY_LIGHTNING_WARFARE` | Enhanced mobility in war |
| `POLICY_CYBER_WARFARE` | Modern warfare capabilities |
| `POLICY_WARS_OF_RELIGION` | Religious combat bonuses |

**File:** SQLite database, PolicyModifiers table

---

## 15. Unit Abilities — Harmful/Aggressive

### Debuff Abilities
| UnitAbilityType | Target Class | Effect |
|----------------|-------------|--------|
| `ABILITY_BOMBARD_ATTACK_UNIT_DEBUFF` | CLASS_SIEGE | Debuffs units hit by bombard attacks |
| `ABILITY_RANGED_ATTACK_DISTRICT_DEBUFF` | CLASS_RANGED | Reduces district defense strength |
| `ABILITY_AIR_FIGHTER_ATTACK_DISTRICT_DEBUFF` | CLASS_AIR_FIGHTER | Fighter reduces district defenses |
| `ABILITY_AIR_BOMBER_ATTACK_UNIT_DEBUFF` | CLASS_AIR_BOMBER | Bomber debuffs target units |

### Capture Abilities
| UnitAbilityType | Tag/Class | Effect |
|----------------|----------|--------|
| `ABILITY_PRIZE_SHIPS` | CLASS_CAPTURE_SHIPS | Captures ships on kill |
| `ABILITY_CAPTIVE_WORKERS` | CLASS_CAPTURE_WORKER | Captures workers on kill |
| `ABILITY_GENGHIS_KHAN_CAVALRY_CAPTURE_CAVALRY` | — | Genghis Khan specific cavalry capture |

### Wall Attack Abilities
| UnitAbilityType | Tag/Class | Effect |
|----------------|----------|--------|
| `ABILITY_ENABLE_WALL_ATTACK` | CLASS_BATTERING_RAM | Allows attacking city walls |
| `ABILITY_ENABLE_WALL_ATTACK_PROMOTION_CLASS` | — | Promotion-based wall attack |
| `ABILITY_ENABLE_WALL_ATTACK_SAME_RELIGION` | — | Same religion wall attack |
| `ABILITY_BYPASS_WALLS` | CLASS_SIEGE_TOWER | Ignores wall defenses |

### Retreat Ability
| UnitAbilityType | Effect |
|----------------|--------|
| Various (via `MODIFIER_UNIT_ADJUST_FORCE_RETREAT`) | Forces enemy units to retreat |

**File:** `Base\Assets\Gameplay\Data\UnitAbilities.xml` (lines 102-105, 124-125, 176-177, 428-431)

---

## 16. Power / Resource Destruction

### Resource Consumption
| Yield | Notes |
|-------|-------|
| Strategic resources can be consumed by units/buildings | Units with strategic resource costs disappear when depleted |
| Luxury resources provide happiness/amenities | Removing them causes unrest |

### Gold Negative Balance Effects
| Threshold | Effect |
|-----------|--------|
| `GOLD_NEGATIVE_BALANCE_AMENITY_LOSS_LINE` | 0 — Lose amenities at negative balance |
| `GOLD_NEGATIVE_BALANCE_DISBAND_UNIT_LINE` | -10 — Units disbanded at severe deficit |
| `GOLD_NEGATIVE_BALANCE_SUBSEQUENT_AMENITY_LOSS` | -10 | Subsequent amenity losses |
| `GOLD_NEGATIVE_BALANCE_SUBSEQUENT_DISBAND_UNIT` | -10 | Subsequent unit disbandments |

**File:** `Base\Assets\Gameplay\Data\GlobalParameters.xml` (lines 324-330)

---

## 17. Tourism Bomb / Cultural Destruction

### Tourism Bomb Abilities
| ModifierType | Effect | Notes |
|-------------|--------|-------|
| `MODIFIER_SINGLE_UNIT_ADJUST_POST_TOURISM_BOMB_LOYALTY` | — | Loyalty damage from tourism bomb |
| `MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT` | — | Tourism bomb district effect |
| `MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_RANGE` | — | Range of tourism bomb |
| `MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_NATIONAL_PARK` | — | Bonus vs national parks |
| `MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_NATIVE_WONDER` | — | Bonus vs natural wonders |
| `MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_ADDITIONAL_YIELD` | — | Additional yield from bomb |
| `MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_CONVERT_CITY` | — | Converts cities via tourism |
| `MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_IMPROVEMENT` | — | Tourism bomb improvements |

### Tourism Reduction Policies
| ModifierType | Notes |
|-------------|-------|
| `MODIFIER_PLAYER_ADJUST_OVERALL_TOURISM_REDUCTION` | Overall tourism reduction |
| `MODIFIER_PLAYER_ADJUST_RELIGIOUS_TOURISM_REDUCTION` | Religious tourism reduction |

**File:** SQLite database, ModifierStrings table (tourism bomb entries)

---

## 18. Barriers / Wall Mechanics

### Wall Attack/Defense
| ModifierType | Effect | Notes |
|-------------|--------|-------|
| `MODIFIER_PLAYER_UNIT_ADJUST_ENABLE_WALL_ATTACK` | — | Enable wall attack capability |
| `MODIFIER_PLAYER_UNIT_ADJUST_BYPASS_WALLS` | — | Bypass wall defenses |
| `MODIFIER_CITY_ADJUST_SIEGE_PROTECTION` | `EFFECT_ADJUST_CITY_SIEGE_PROTECTION` | City siege protection |

### Wall Attack Abilities (repeat for completeness)
- `ABILITY_ENABLE_WALL_ATTACK` — Enable wall attack
- `ABILITY_BYPASS_WALLS` — Bypass walls
- `ABILITY_ENABLE_WALL_ATTACK_PROMOTION_CLASS` — Promotion variant
- `ABILITY_ENABLE_WALL_ATTACK_SAME_RELIGION` — Same religion variant

**File:** `UnitAbilities.xml` lines 18-19, 124-125

---

## 19. Emergency System Destruction

### Emergency Triggers
| Trigger | Description |
|---------|-------------|
| `EMERGENCY_TRIGGER_PLAYER_LOSES_POP_TO_RANDOM_EVENT` | Player loses population to disaster |
| Combat-based triggers for military emergencies | Kill-score tracking (lines 137-146) |

### Emergency Modifiers
| ModifierType | EffectType | Notes |
|-------------|-----------|-------|
| `MODIFIER_EMERGENCY_CITIES_KILL_ALL_EMERGENCY_TARGET_SPIES` | — | Kill all spies in emergency target city |
| `MODIFIER_EMERGENCY_PLAYERS_ADJUST_WAR_WEARINESS` | — | Adjust war weariness for emergencies |
| `MODIFIER_EMERGENCY_COMBATS_ADJUST_DEFENDER_STRENGTH` | — | Adjust defender strength |
| `MODIFIER_EMERGENCY_COMBATS_ADJUST_ATTACKER_STRENGTH` | — | Adjust attacker strength |
| `MODIFIER_EMERGENCY_UNITS_ADJUST_MOVEMENT` | — | Restrict enemy movement |
| `MODIFIER_EMERGENCY_UNITS_ADJUST_HEALING` | — | Reduce enemy healing |
| `MODIFIER_EMERGENCY_UNITS_ADJUST_SPYING_EFFICIENCY` | — | Reduce enemy spying |
| `MODIFIER_EMERGENCY_TRADE_ROUTES_ADJUST_YIELDS` | — | Adjust trade route yields |
| `MODIFIER_EMERGENCY_TARGET_CITY_GRANT_LOYALTY` | — | Grant loyalty to targeted city |

### Emergency Rewards/Punishments
- `EmergencyRewards` table — Bonuses for participating in emergencies
- `EmergencyBuffs` table — Buffs applied during emergencies
- `EmergencyScoreSources` table — Score tracking for emergency justification

**File:** `DLC\Expansion2\Data\Expansion2_Emergencies.xml`, SQLite database tables

---

## 20. Giant Death Robot (GDR)

### GDR Stats
| UnitType | Combat | RangedCombat | Range | AntiAirCombat |
|----------|--------|-------------|-------|--------------|
| `UNIT_GIANT_DEATH_ROBOT` | 130 | 120 | 3 | 90 |

### GDR Kill Scoring
| ModifierType | EffectType | Notes |
|-------------|-----------|-------|
| `MODIFIER_PLAYER_ADJUST_PLAYER_ERA_SCORE_PER_NON_BARBARIAN_UNIT_KILLED_BY_GDR` | `EFFECT_ADJUST_PLAYER_ERA_SCORE_PER_NON_BARBARIAN_UNIT_KILLED_BY_GDR` | Era score for GDR kills |

**File:** `DLC\Expansion2\Data\Expansion2_Units.xml` (line 11)

---

## 21. Spy Operations — Destructive

### Spy Operations
Spies can perform destructive operations including:
- **Sabotage** — Damage buildings/districts
- **Incite Rebellion** — Cause city unrest/rebellion
- **Scandal** — Diplomatic damage
- **Steal Technology** — Set back enemy research
- **Assassination** — Kill units/great people
- **Destroy Units** — Eliminate military units

### Spy-Related Modifiers
| ModifierType | Notes |
|-------------|-------|
| `MODIFIER_PLAYER_UNIT_ADJUST_SPY_OPERATION_CHANCE` | Spy operation success rate |
| `MODIFIER_PLAYER_UNIT_ADJUST_SPY_ESTABLISH_TIME` | Time to establish spy network |
| `MODIFIER_PLAYER_UNIT_ADJUST_SPY_OPERATION_TIME` | Operation duration |

**File:** SQLite database, UnitAbilities table (spy abilities)

---

## 22. Barbarian Destruction

### Mayhem Scores (Barbarian-specific)
| Parameter | Value | Notes |
|-----------|-------|-------|
| `MAYHEM_CITY_DEATH_WITH_BARBARIANS` | 2.0 | City death by barbarians |
| `MAYHEM_DISTRICT_DEATH_WITH_BARBARIANS` | 0.5 | District death by barbarians |
| `MAYHEM_UNIT_COMBAT_WITH_BARBARIANS` | 0.5 | Unit combat with barbarians |
| `MAYHEM_UNIT_DEATH_WITH_BARBARIANS` | 0.5 | Unit death by barbarians |

### Barbarian Mechanics
- `BarbarianAttackForces` — Attack wave compositions
- `BarbarianTribeForces` — Tribe unit compositions
- `BarbarianTribes` — Different tribe types with varying strength

**File:** SQLite database, Barbarian* tables

---

## 23. Unit Promotions — Damage-Related

### Key Combat Promotions
| PromotionType | Effect |
|--------------|--------|
| `PROMOTION_BOMBARDMENT` | Bonus vs district defenses |
| Various defensive promotions | `ReductionPercent` arguments for damage reduction |
| `PROMOTION_REINFORCED_HULL` | Bonus vs ranged attacks (naval) |

### Flanking & Support Bonuses
| Parameter | Value | Notes |
|-----------|-------|-------|
| `COMBAT_FLANKING_BONUS_MODIFIER` | 2 | Flanking bonus |
| `COMBAT_SUPPORT_BONUS_MODIFIER` | 2 | Combat support bonus |

**File:** `Base\Assets\Gameplay\Data\UnitPromotions.xml`, GlobalParameters.xml

---

## 24. Garrison / Fortification Mechanics

### Fortification Parameters
| Parameter | Value | Notes |
|-----------|-------|-------|
| `FORTIFY_BONUS_PER_TURN` | 3 | Defense bonus per turn fortifying |
| `FORTIFY_TURN_MAX` | 2 | Turns to max fortification |
| `COMBAT_GARRISON_MILITIA_MODIFIER` | 10 | Garrison militia defense bonus |

### Amphibious Penalties
| Parameter | Value | Notes |
|-----------|-------|-------|
| `COMBAT_AMPHIBIOUS_ATTACK_PENALTY` | -10 | Penalty for amphibious assault |

**File:** `Base\Assets\Gameplay\Data\GlobalParameters.xml` (lines 312-314, 156, 122)

---

## 25. Religious Combat / Conversion as Harm

### Religion Combat
| Parameter | Value | Notes |
|-----------|-------|-------|
| `RELIGION_SPREAD_RANGE_UNIT_CAPTURE` | 6 | Range for religious capture |
| `RELIGION_SPREAD_UNIT_CAPTURE` | 125 | Strength needed to convert via religion |

### Religious Combat Modifiers
| ModifierType | EffectType | Notes |
|-------------|-----------|-------|
| `MODIFIER_PLAYER_RELIGION_ADJUST_COMBAT_LOSS` | — | Adjust religious combat losses |
| `MODIFIER_PLAYER_RELIGION_ADJUST_RELIGIOUS_SPREAD_STRENGTH` | — | Religious spread strength |

### Religious Restrictions
| UnitAbilityType | Notes |
|----------------|-------|
| `ABILITY_RELIGIOUS_CANNOT_ATTACK` | Missionaries and other religious units cannot attack |

**File:** `Base\Assets\Gameplay\Data\GlobalParameters.xml` (lines 493, 501), `UnitAbilities.xml` (line 25)

---

## 26. Occupation / Martial Law

### Occupation Penalties
| ModifierType | Notes |
|-------------|-------|
| `MODIFIER_PLAYER_ADJUST_NO_OCCUPATION_PENALTIES` | Negates occupation penalties |
| `MODIFIER_PLAYER_LOYALTY_ADJUST_MARTIAL_LAW_MODIFIER` | Martial law loyalty effects |

### Leader Traits with Occupation Effects
| TraitType | ModifierType | Effect |
|-----------|-------------|--------|
| `TRAIT_LEADER_FALL_BABYLON` | `MODIFIER_PLAYER_LOYALTY_ADJUST_MARTIAL_LAW_MODIFIER` | Martial law in conquered cities |
| `TRAIT_LEADER_MAJOR_CIV` | `MODIFIER_PLAYER_LOYALTY_ADJUST_MARTIAL_LAW_MODIFIER` | Major civ martial law |

**File:** SQLite database, TraitModifiers table

---

## 27. Complete List of Destructive Modifier Types

All modifier types from the database that have destructive/harmful effects:

| ModifierType | Category |
|-------------|----------|
| `MODIFIER_PLAYER_ADJUST_WAR_WEARINESS` | War weariness |
| `MODIFIER_PLAYER_ADJUST_MAX_WARMONGER_PERCENT` | Warmongering |
| `MODIFIER_PLAYER_ADJUST_WARMONGER_MULTIPLIER` | Warmongering |
| `MODIFIER_PLAYER_DIPLOMACY_NEW_WARMONGER` | Diplomatic penalty |
| `MODIFIER_PLAYER_DIPLOMACY_THIRD_PARTY_WARMONGER` | Diplomatic penalty |
| `MODIFIER_PLAYER_CAPTURED_CITY_ATTACH_MODIFIER` | City capture |
| `MODIFIER_PLAYER_UNIT_ADJUST_DAMAGE` | Unit damage |
| `MODIFIER_PLAYER_UNITS_ADJUST_DAMAGE` | All units damage |
| `MODIFIER_WORLD_UNITS_ADJUST_DAMAGE` | All world units damage |
| `MODIFIER_PLAYER_UNIT_ADJUST_NO_REDUCTION_DAMAGE` | No HP reduction |
| `MODIFIER_PLAYER_UNITS_ADJUST_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER` | Strength scaling |
| `MODIFIER_PLAYER_UNIT_ADJUST_GREAT_PEOPLE_POINTS_PER_KILL` | Kill rewards |
| `MODIFIER_PLAYER_UNIT_ADJUST_RELIC_UPON_DEATH` | Death drops |
| `MODIFIER_PLAYER_ADJUST_DISTRICT_PILLAGE` | District pillage |
| `MODIFIER_PLAYER_ADJUST_IMPROVEMENT_PILLAGE` | Improvement pillage |
| `MODIFIER_PLAYER_UNITS_ADJUST_PLUNDER_YIELDS` | Plunder yields |
| `MODIFIER_PLAYER_UNIT_ADJUST_PLUNDER_YIELDS` | Single unit plunder |
| `MODIFIER_PLAYER_ADJUST_ADDITIONAL_PILLAGING` | Extra pillaging |
| `MODIFIER_PLAYER_ADJUST_POST_COMBAT_LOYALTY` | Post-combat loyalty |
| `MODIFIER_PLAYER_ADJUST_POST_PILLAGE_LOYALTY` | Post-pillage loyalty |
| `MODIFIER_SINGLE_CITY_GRANT_LOYALTY` | Grant loyalty |
| `MODIFIER_SINGLE_UNIT_ADJUST_POST_TOURISM_BOMB_LOYALTY` | Tourism bomb loyalty |
| `MODIFIER_PLAYER_LOYALTY_ADJUST_MARTIAL_LAW_MODIFIER` | Martial law |
| `MODIFIER_PLAYER_ADJUST_RANDOM_EVENT_MODIFIED_DAMAGE_OPPOSING_PLAYER` | Disaster damage boost |
| `MODIFIER_PLAYER_ADJUST_RANDOM_EVENT_NO_UNIT_DAMAGE` | Disaster prevention |
| `MODIFIER_PLAYER_ADJUST_AVOID_RANDOM_EVENT` | Avoid disasters |
| `MODIFIER_SINGLE_CITY_ADJUST_YIELD_FOR_FLOOD` | Flood effects |
| `MODIFIER_GOVERNOR_ADJUST_PREVENET_STRUCTURAL_DAMAGE` | Structural damage prevention |
| `MODIFIER_EMERGENCY_CITIES_KILL_ALL_EMERGENCY_TARGET_SPIES` | Spy elimination |
| `MODIFIER_EMERGENCY_PLAYERS_ADJUST_WAR_WEARINESS` | Emergency war weariness |
| `MODIFIER_EMERGENCY_TARGET_CITY_GRANT_LOYALTY` | Emergency loyalty |
| `MODIFIER_CITY_ADJUST_SIEGE_PROTECTION` | City siege defense |
| `MODIFIER_CITY_ADJUST_AIR_DEFENSE_BONUS` | Air defense |
| `MODIFIER_PLAYER_UNIT_ADJUST_FORCE_RETREAT` | Force retreat |
| `MODIFIER_PLAYER_UNIT_ADJUST_COMBAT_CAPTURE` | Unit capture |
| `MODIFIER_PLAYER_UNIT_ADJUST_CITY_ON_CAPTURE` | City capture effects |
| `MODIFIER_UNIT_ADJUST_COMBAT_UNIT_CAPTURE` | Combat unit capture |
| `MODIFIER_PLAYER_ADJUST_JOINTWAR_PLUNDER` | Joint war plunder |
| `MODIFIER_PLAYER_CITIES_ADJUST_RANGED_STRIKE` | City ranged strike |
| `MODIFIER_PLAYER_CITIES_ADJUST_INNER_DEFENSE` | Inner defense |
| `MODIFIER_PLAYER_CITIES_ADJUST_OUTER_DEFENSE` | Outer defense |

---

## 28. Complete List of Destructive Effect Types (GameEffects)

All effect types from the GameEffects table with destructive/harmful effects:

| EffectType | Category |
|-----------|----------|
| `EFFECT_ADJUST_UNIT_DAMAGE` | Unit damage |
| `EFFECT_ADJUST_UNIT_NO_REDUCTION_DAMAGE` | No HP reduction |
| `EFFECT_ADJUST_UNIT_STRENGTH_REDUCTION_FOR_DAMAGE_MODIFIER` | Strength scaling |
| `EFFECT_ADJUST_UNIT_WATER_DAMAGE_PROTECTION` | Water resistance |
| `EFFECT_ADJUST_UNIT_WMD_PROTECTION` | WMD resistance |
| `EFFECT_ADJUST_PLAYER_WARMONGER_MULTIPLIER` | Warmongering |
| `EFFECT_ADJUST_PLAYER_NEW_WARMONGER` | New warmonger |
| `EFFECT_ADJUST_WAR_WEARINESS` | War weariness |
| `EFFECT_ADJUST_UNIT_COMBAT_CAPTURE` | Unit capture |
| `EFFECT_ADJUST_CITY_RELIGION_ON_CAPTURE` | City capture religion |
| `EFFECT_ADJUST_UNIT_PLUNDER_YIELDS` | Plunder yields |
| `EFFECT_ADJUST_UNIT_PILLAGE_DISTRICT_MODIFIER` | District pillage |
| `EFFECT_ADJUST_UNIT_PILLAGE_IMPROVEMENT_MODIFIER` | Improvement pillage |
| `EFFECT_ADJUST_GREAT_PEOPLE_POINTS_PER_KILL` | GP points on kill |
| `EFFECT_ADJUST_GREAT_PEOPLE_POINTS_PER_KILL_BY_DEFEATED_STRENGTH` | GP by defeated strength |
| `EFFECT_ADJUST_UNIT_RELIC_UPON_DEATH` | Relic drops |
| `EFFECT_ADJUST_PLAYER_JOINTWAR_PLUNDER` | Joint war plunder |
| `EFFECT_ADJUST_RANDOM_EVENT_MODIFIED_DAMAGE_OPPOSING_PLAYER` | Disaster damage boost |
| `EFFECT_ADJUST_RANDOM_EVENT_NO_UNIT_DAMAGE` | Disaster prevention |
| `EFFECT_ADJUST_CITY_YIELD_PER_FLOOD` | Flood yields |
| `EFFECT_ADJUST_PREVENT_STRUCTURAL_DAMAGE` | Structural damage prevention |
| `EFFECT_ADJUST_PLAYER_ERA_SCORE_PER_ARMY_KILLED` | Era score - army kills |
| `EFFECT_ADJUST_PLAYER_ERA_SCORE_PER_CORPS_KILLED` | Era score - corps kills |
| `EFFECT_ADJUST_PLAYER_ERA_SCORE_PER_NON_BARBARIAN_UNIT_KILLED_BY_GDR` | Era score - GDR kills |
| `EFFECT_ADJUST_PLAYER_ERA_SCORE_PER_NON_BARBARIAN_NAVAL_UNIT_KILLED` | Era score - naval kills |
| `EFFECT_ADJUST_CITY_SIEGE_PROTECTION` | Siege protection |
| `EFFECT_ADJUST_UNIT_TRADE_ROUTE_PLUNDER_IMMUNITY` | Plunder immunity |
| `EFFECT_ADJUST_UNIT_FAITH_ON_DISTRICT_PLUNDER` | Faith from district pillage |
| `EFFECT_ADJUST_UNIT_FAITH_ON_IMPROVEMENT_PLUNDER` | Faith from improvement pillage |
| `EFFECT_ADJUST_PLAYER_ANYONE_PLUNDER_FAVOR` | Plunder favor |

---

## 29. Complete List of Harmful Unit Abilities

All unit abilities that can be harmful or aggressive:

| UnitAbilityType | Target Class | Effect |
|----------------|-------------|--------|
| `ABILITY_ENABLE_WALL_ATTACK` | CLASS_BATTERING_RAM | Attack city walls |
| `ABILITY_ENABLE_WALL_ATTACK_PROMOTION_CLASS` | — | Promotion-based wall attack |
| `ABILITY_ENABLE_WALL_ATTACK_SAME_RELIGION` | — | Same-religion wall attack |
| `ABILITY_BYPASS_WALLS` | CLASS_SIEGE_TOWER | Ignore wall defenses |
| `ABILITY_BOMBARD_ATTACK_UNIT_DEBUFF` | CLASS_SIEGE | Debuff units hit by bombard |
| `ABILITY_RANGED_ATTACK_DISTRICT_DEBUFF` | CLASS_RANGED | Reduce district defense |
| `ABILITY_AIR_FIGHTER_ATTACK_DISTRICT_DEBUFF` | CLASS_AIR_FIGHTER | Fighter reduces district defenses |
| `ABILITY_AIR_BOMBER_ATTACK_UNIT_DEBUFF` | CLASS_AIR_BOMBER | Bomber debuffs units |
| `ABILITY_PRIZE_SHIPS` | CLASS_CAPTURE_SHIPS | Capture ships on kill |
| `ABILITY_CAPTIVE_WORKERS` | CLASS_CAPTURE_WORKER | Capture workers on kill |
| `ABILITY_RELIGIOUS_CANNOT_ATTACK` | CLASS_MISSIONARY | Religious units cannot attack |
| `ABILITY_FASCISM_ATTACK_BUFF` | Multiple classes | Fascism attack buff |
| `ABILITY_GENGHIS_KHAN_CAVALRY_CAPTURE_CAVALRY` | — | Genghis Khan cavalry capture |
| `ABILITY_GREAT_TURKISH_BOMBARD` | — | Great Turkish Bombard ability |
| `ABILITY_SCOUT_CANNOT_ATTACK` | CLASS_SCOUT | Scouts cannot attack |

---

## 30. Complete List of Disaster Random Events

All disaster random events from Expansion2:

| Event Type | EffectOperatorType | Severity Levels |
|-----------|-------------------|-----------------|
| Floods | `FLOODPLAIN` | Moderate, Major, 1000-Year |
| Kilimanjaro Volcano | `VOLCANO` | Gentle, Catastrophic |
| Vesuvius Volcano | `VOLCANO` | Mega-colossal |
| Generic Volcanoes | `VOLCANO` | Gentle, Catastrophic, Mega-colossal |
| Blizzards | `STORM` | Significant, Crippling |
| Dust Storms | — | Gradient, Haboob |
| Tornadoes | — | Family, Outbreak |
| Hurricanes | `STORM` | Cat 4, Cat 5 |
| Nuclear Accidents | `NUCLEAR_ACCIDENT` | Minor, Major, Catastrophic |
| Droughts | `DROUGHT` | Major, Extreme |
| Sea Level Rise | `SEA_LEVEL` | Rise1 through Rise7 (7 levels) |

---

## 31. Key Reference File Locations

### Base Game XML Files
| File Path | Content |
|-----------|---------|
| `Base\Assets\Gameplay\Data\WMDs.xml` | WMD definitions (blast radius, fallout) |
| `Base\Assets\Gameplay\Data\GlobalParameters.xml` | All combat/damage/pillage parameters |
| `Base\Assets\Gameplay\Data\Modifiers.xml` | All modifier definitions and their effects |
| `Base\Assets\Gameplay\Data\UnitAbilities.xml` | All unit abilities including harmful ones |
| `Base\Assets\Gameplay\Data\UnitPromotions.xml` | Combat promotions and damage modifiers |
| `Base\Assets\Gameplay\Data\Units.xml` | Unit stats (combat, bombard, WMD capability) |
| `Base\Assets\Gameplay\Data\Districts.xml` | District HP, plunder properties |
| `Base\Assets\Gameplay\Data\Buildings.xml` | Building definitions |
| `Base\Assets\Gameplay\Data\Policies.xml` | Warmongering policies |
| `Base\Assets\Gameplay\Data\Governments.xml` | Government modifiers (Fascism war weariness) |
| `Base\Assets\Gameplay\Data\Leaders.xml` | Leader traits with razing/warmongering effects |
| `Base\Assets\Gameplay\Data\Notifications.xml` | Death/destruction notification messages |
| `Base\Assets\Gameplay\Data\Operations.xml` | Nuclear assault operations |
| `Base\Assets\Gameplay\Data\BehaviorTrees.xml` | AI nuclear assault behavior |
| `Base\Assets\Gameplay\Data\Projects.xml` | WMD projects (Manhattan, Operation Ivy) |
| `Base\Assets\Gameplay\Data\Civics.xml` | Nuclear Program civic |

### DLC Files
| File Path | Content |
|-----------|---------|
| `DLC\Expansion2\Data\Expansion2_RandomEvents.xml` | All natural disaster events |
| `DLC\Expansion2\Data\Expansion2_Modifiers.xml` | Disaster damage modifiers |
| `DLC\Expansion2\Data\Expansion2_Leaders.xml` | Hurricane/volcano leader traits |
| `DLC\Expansion2\Data\Expansion2_Units.xml` | Giant Death Robot |
| `DLC\Expansion1\Data\Expansion1_Modifiers.xml` | Pillage loyalty, WMD maintenance |
| `DLC\BlackDeathScenario\Data\BlackDeathScenario_GameplayData.xml` | Plague mechanics |
| `DLC\CivRoyaleScenario\Data\CivRoyaleScenario_GameplayData.xml` | Fallout water damage |
| `DLC\CivRoyaleScenario\Data\CivRoyaleScenario_Civilizations.xml` | Mutant fallout abilities |

### SQLite Database
| Table | Content |
|-------|---------|
| `GameEffects` | All effect types (EFFECT_*) |
| `Modifiers` | All modifier definitions |
| `ModifierArguments` | Modifier parameter values |
| `ModifierStrings` | Modifier descriptions |
| `BuildingModifiers` | Building-to-modifier links |
| `DistrictModifiers` | District-to-modifier links |
| `PolicyModifiers` | Policy-to-modifier links |
| `GovernmentModifiers` | Government-to-modifier links |
| `TraitModifiers` | Trait-to-modifier links |
| `LeaderTraits` | Leader-to-trait links |
| `UnitAbilityModifiers` | Unit ability modifiers |
| `UnitPromotionModifiers` | Promotion modifiers |
| `DeforestationEffects` | Deforestation damage levels |
| `DeforestationLevels` | Deforestation thresholds |
| `Resources` | Resource definitions |
| `Notifications` | Notification messages |
| `LoyaltyLevels` | City loyalty levels |

---

## 32. Implementation Notes for Mods

### How to Apply Damage Effects
1. **Unit Damage:** Use `MODIFIER_PLAYER_UNIT_ADJUST_DAMAGE` with `EFFECT_ADJUST_UNIT_DAMAGE`, set `Amount` in ModifierArguments
2. **City Damage:** Modify city HP through combat or custom modifiers targeting district hit points
3. **Population Loss:** No direct "population damage" modifier exists — implement via CustomGameplayScripts (Lua) or by triggering events that reduce population
4. **Tile Contamination:** Use the existing `PLOT_CONTAMINATION_DAMAGE_BASE` parameter or create custom contamination features
5. **WMD Effects:** Reference `WMD_NUCLEAR_DEVICE` and `WMD_THERMONUCLEAR_DEVICE` definitions for blast radius and fallout duration

### Key Argument Names in ModifierArguments
| Name | Type | Used By |
|------|------|---------|
| `Amount` | INTEGER/FLOAT | Most damage modifiers |
| `NoDamage` | INTEGER (0/1) | Disaster prevention |
| `Protected` | — | Protection flags |

### Creating Custom Destructive Effects
- SQL `INSERT OR REPLACE` into the appropriate tables
- Use existing ModifierTypes and EffectTypes as templates
- Reference the SQLite database schema for column names
- XML files on disk show the original definitions — use them as patterns

### Lua Hooks Available (from modding docs)
- `Events.WMDDetonated` — Triggered when WMD is used
- `Events.UnitDestroyed` — Unit death events
- `Events.CityCaptured` — City capture events
- `Events.PlayerRevolt` — Rebellion events
- Custom Lua scripts can iterate over units/cities and apply damage directly
