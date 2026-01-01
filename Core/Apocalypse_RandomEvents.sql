-- Allow random Comet Strikes and targeted Comet Strikes to happen at any time
-- Allow all disasters to happen at the Apocalypse stage
INSERT OR REPLACE INTO RandomEvent_Frequencies 
		(RandomEventType,	RealismSettingType,				OccurrencesPerGame)
SELECT	RandomEventType,	'REALISM_SETTING_APOCALYPSE',	OccurrencesPerGame
FROM RandomEvent_Frequencies 
WHERE RealismSettingType = 'REALISM_SETTING_MEGADISASTERS';

UPDATE RandomEvent_Frequencies 
SET OccurrencesPerGame = OccurrencesPerGame*2
WHERE RealismSettingType = 'REALISM_SETTING_APOCALYPSE' AND OccurrencesPerGame <> 1;

INSERT OR REPLACE INTO RandomEvent_Frequencies
		(RandomEventType,						RealismSettingType,					OccurrencesPerGame)
VALUES	('RANDOM_EVENT_COMET_STRIKE',			'REALISM_SETTING_MEGADISASTERS',	50),
		('RANDOM_EVENT_COMET_STRIKE',			'REALISM_SETTING_APOCALYPSE',		400),
		('RANDOM_EVENT_COMET_STRIKE_TARGETED',	'REALISM_SETTING_MEGADISASTERS',	25),
		('RANDOM_EVENT_COMET_STRIKE_TARGETED',	'REALISM_SETTING_APOCALYPSE',		200);