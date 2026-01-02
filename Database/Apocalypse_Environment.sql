-- Increased blast radius
-- Allow random Comet Strikes and targeted Comet Strikes to happen at any time
-- Allow all disasters to happen at the Apocalypse stage
-- Increase odds of Comet Strikes at the Apocalypse stage
-- Increase odds of Meteor Showers
-- Double CO2 production of all resources and deforestation effects
-- Reduce CO2 diplomatic favor penalty to offset doubled CO2 production

UPDATE RandomEvents SET Hexes=Hexes+2 WHERE RandomEventType = 'RANDOM_EVENT_COMET_STRIKE';

INSERT OR REPLACE INTO RandomEvent_Frequencies 
        (RandomEventType,    RealismSettingType,                OccurrencesPerGame)
SELECT   RandomEventType,    'REALISM_SETTING_APOCALYPSE',      OccurrencesPerGame
FROM RandomEvent_Frequencies 
WHERE RealismSettingType = 'REALISM_SETTING_MEGADISASTERS';

UPDATE RandomEvent_Frequencies 
SET OccurrencesPerGame = OccurrencesPerGame*2
WHERE RealismSettingType = 'REALISM_SETTING_APOCALYPSE' AND OccurrencesPerGame <> 1;

INSERT OR REPLACE INTO RandomEvent_Frequencies
        (RandomEventType,                        RealismSettingType,                    OccurrencesPerGame)
VALUES  ('RANDOM_EVENT_COMET_STRIKE',            'REALISM_SETTING_MEGADISASTERS',    20),
        ('RANDOM_EVENT_COMET_STRIKE',            'REALISM_SETTING_APOCALYPSE',       400),
        ('RANDOM_EVENT_COMET_STRIKE_TARGETED',   'REALISM_SETTING_MEGADISASTERS',    10),
        ('RANDOM_EVENT_COMET_STRIKE_TARGETED',   'REALISM_SETTING_APOCALYPSE',       200),
        ('RANDOM_EVENT_METEOR_SHOWER',           'REALISM_SETTING_MEGADISASTERS',    30),
        ('RANDOM_EVENT_METEOR_SHOWER',           'REALISM_SETTING_APOCALYPSE',       30);

UPDATE Resource_Consumption
SET CO2perkWh = CO2perkWh*2
WHERE CO2perkWh > 0;

UPDATE DeforestationEffects
SET CO2PercentModifier = CO2PercentModifier*2
WHERE CO2PercentModifier > 0;

UPDATE GlobalParameters
SET Value = 6
WHERE Name = 'FAVOR_CO2_DIVISOR';