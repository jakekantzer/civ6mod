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
UPDATE Projects SET Cost=Cost*0.7 WHERE SpaceRace=1

-- Spies can be bought with gold
UPDATE Units SET PurchaseYield='YIELD_GOLD' WHERE UnitType = 'UNIT_SPY';