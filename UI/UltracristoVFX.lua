-- ===========================================================================
--	Ultracristo Vinditador — Evil VFX
-- ===========================================================================

print("UltracristoVFX: Script loaded")

local ULTRACRISTO_BUILDING = GameInfo.Buildings["BUILDING_ULTRACRISTO_VINDITADOR"].Index
local MAX_PLAYERS = 63
local m_UltracristoLocations = {} -- {x, y}

-- ===========================================================================
function OnWonderCompleted(locX:number, locY:number, buildingIndex:number, playerIndex:number, cityId:number, iPercentComplete:number, pillaged:number)
	if buildingIndex == ULTRACRISTO_BUILDING then
		print(string.format("UltracristoVFX: Wonder completed at %d, %d", locX, locY))
		WorldView.PlayEffectAtXY("DISASTER_NUCLEAR_MELTDOWN", locX, locY)
		table.insert(m_UltracristoLocations, { x = locX, y = locY })
	end
end

-- ===========================================================================
function FindUltracristoWonders()
	m_UltracristoLocations = {}
	print(string.format("UltracristoVFX: Scanning %d players for wonder", MAX_PLAYERS))
	for iPlayer = 0, MAX_PLAYERS - 1 do
		local pPlayer = Players[iPlayer]
		if pPlayer and pPlayer:GetCities() then
			for _, pCity in pPlayer:GetCities():Members() do
				local pBuildings = pCity:GetBuildings()
				if pBuildings and pBuildings:HasBuilding(ULTRACRISTO_BUILDING) then
					print(string.format("UltracristoVFX: Found wonder at %d, %d (player %d)", pCity:GetX(), pCity:GetY(), iPlayer))
					table.insert(m_UltracristoLocations, { x = pCity:GetX(), y = pCity:GetY() })
				end
			end
		end
	end
	print(string.format("UltracristoVFX: Total wonders found: %d", #m_UltracristoLocations))
end

-- ===========================================================================
function OnPlayerTurnActivated(playerID:number, bIsFirstTime:boolean)
	if not bIsFirstTime then return end
	local localPlayer = Game.GetLocalPlayer()
	if localPlayer < 0 or playerID ~= localPlayer then return end

	print(string.format("UltracristoVFX: Turn start for player %d, cache size %d", localPlayer, #m_UltracristoLocations))

	if #m_UltracristoLocations == 0 then
		FindUltracristoWonders()
	end

	for i, loc in ipairs(m_UltracristoLocations) do
		print(string.format("UltracristoVFX: Playing meltdown at %d, %d", loc.x, loc.y))
		WorldView.PlayEffectAtXY("UNIT_SACRIFICE_UNIT", loc.x, loc.y)
	end
end

Events.WonderCompleted.Add(OnWonderCompleted)
Events.PlayerTurnActivated.Add(OnPlayerTurnActivated)
Events.LoadGameViewStateDone.Add(FindUltracristoWonders)

print("UltracristoVFX: Initialization complete")
