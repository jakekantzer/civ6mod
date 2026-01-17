--  Increase Movement of Land units 
UPDATE Units SET BaseMoves=BaseMoves+1 WHERE FormationClass='FORMATION_CLASS_LAND_COMBAT';
--  Increase Movement of Settlers 
UPDATE Units SET BaseMoves=BaseMoves+1 WHERE UnitType='UNIT_SETTLER';
UPDATE Units SET BaseSightRange=BaseSightRange+1 WHERE UnitType='UNIT_SETTLER';
--  Increase Movement of Embarked units
UPDATE GlobalParameters SET Value=Value+1 WHERE Name='MOVEMENT_WHILE_EMBARKED_BASE';

-- Reduce cost of Spaceport
UPDATE Districts SET Cost=Cost*0.7 WHERE DistrictType='DISTRICT_SPACEPORT';
-- Reduce cost of space projects
UPDATE Projects SET Cost=Cost*0.7 WHERE SpaceRace=1;

-- Spies can be bought with gold
UPDATE Units SET PurchaseYield='YIELD_GOLD' WHERE UnitType = 'UNIT_SPY';

-- Make Cliffs of Dover a little better
UPDATE Features SET DoubleAdjacentTerrainYield=1 WHERE FeatureType = 'FEATURE_CLIFFS_DOVER';

-- Make Comet Lakes a little better
UPDATE Features SET DoubleAdjacentTerrainYield=1 WHERE FeatureType = 'FEATURE_COMET_LAKE';

-- Barbarian tweaks
UPDATE GlobalParameters SET Value=Value/2 WHERE Name = 'BARBARIAN_CLANS_BRIBE_COST_PER_CITY';
UPDATE GlobalParameters SET Value=Value*1.5 WHERE Name = 'BARBARIAN_CLANS_CIV_CONVERSION_INCREMENT_CHANCE';

UPDATE GlobalParameters SET Value=Value-5 WHERE Name = 'BARBARIAN_BOLDNESS_PER_KILL';
UPDATE GlobalParameters SET Value=Value+5 WHERE Name = 'BARBARIAN_BOLDNESS_PER_SCOUT_LOST';
UPDATE GlobalParameters SET Value=Value+5 WHERE Name = 'BARBARIAN_BOLDNESS_PER_UNIT_LOST';
UPDATE GlobalParameters SET Value=0 WHERE Name = 'BARBARIAN_BOLDNESS_PER_CAMP_ATTACK';

UPDATE GlobalParameters SET Value=Value+1 WHERE Name = 'BARBARIAN_CAMP_MINIMUM_DISTANCE_CITY';
UPDATE GlobalParameters SET Value=Value-1 WHERE Name = 'BARBARIAN_DEFENSE_ALL_UNITS';

UPDATE BarbarianTribes SET RaidingBoldness=RaidingBoldness+5 WHERE Name='LOC_BARBARIAN_CLAN_TYPE_NAVAL';
UPDATE BarbarianTribes SET CityAttackBoldness=CityAttackBoldness+5 WHERE Name='LOC_BARBARIAN_CLAN_TYPE_NAVAL';
UPDATE BarbarianTribes SET DefenderTag = 'CLASS_MELEE' WHERE DefenderTag = 'CLASS_ANTI_CAVALRY';