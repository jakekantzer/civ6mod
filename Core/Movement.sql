--  Increase Movement of Land units 
UPDATE Units SET BaseMoves=BaseMoves+1 WHERE FormationClass='FORMATION_CLASS_LAND_COMBAT';
--  Increase Movement of Settlers 
UPDATE Units SET BaseMoves=BaseMoves+1 WHERE UnitType='UNIT_SETTLER';
UPDATE Units SET BaseSightRange=BaseSightRange+1 WHERE UnitType='UNIT_SETTLER';
--  Increase Movement of Embarked units
UPDATE GlobalParameters SET Value=Value+1 WHERE Name='MOVEMENT_WHILE_EMBARKED_BASE';