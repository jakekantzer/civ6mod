-- ===========================================================================
--	Ultracristo Vinditador — Evil VFX on wonder completion
-- ===========================================================================

local ULTRACRISTO_BUILDING = GameInfo.Buildings["BUILDING_ULTRACRISTO_VINDITADOR"].Index

-- ===========================================================================
function OnWonderCompleted(locX:number, locY:number, buildingIndex:number, playerIndex:number, cityId:number, iPercentComplete:number, pillaged:number)
	if buildingIndex == ULTRACRISTO_BUILDING then
		WorldView.PlayEffectAtXY("DISASTER_NUCLEAR_MELTDOWN", locX, locY)
	end
end

Events.WonderCompleted.Add(OnWonderCompleted)
