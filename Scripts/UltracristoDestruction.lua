local ULTRACRISTO_BUILDING = GameInfo.Buildings["BUILDING_ULTRACRISTO_VINDITADOR"].Index
local RANGE_POP = 5
local MAX_PLAYERS = 63

-- Track which game turn we last processed, so we only tick once per turn
local m_lastProcessedTurn = -1

function IsValidTarget(ultracristoOwnerID, targetPlayerID)
    if targetPlayerID == ultracristoOwnerID then
        return false
    end

    local pOwner = Players[ultracristoOwnerID]
    local pTarget = Players[targetPlayerID]
    if not pOwner or not pTarget then
        return false
    end

    if pOwner:GetTeam() == pTarget:GetTeam() then
        return false
    end

    local pDiplomacy = pOwner:GetDiplomacy()
    if pDiplomacy then
        if pDiplomacy:GetDeclaredFriendshipTurn(targetPlayerID) >= 0 then
            return false
        end
        if pDiplomacy:GetAllianceLevel(targetPlayerID) > 0 then
            return false
        end
    end

    -- Skip city-states where owner is suzerain
    if pTarget:IsMinorCiv() then
        local pInfluence = pTarget:GetInfluence()
        if pInfluence and pInfluence:GetSuzerain() == ultracristoOwnerID then
            return false
        end
    end

    return true
end

function DoUltracristoPopLoss(pUltracristoCity, ownerID)
    local locX = pUltracristoCity:GetX()
    local locY = pUltracristoCity:GetY()

    for iTarget = 0, MAX_PLAYERS - 1 do
        if IsValidTarget(ownerID, iTarget) then
            local pTarget = Players[iTarget]
            if pTarget and pTarget:IsAlive() then
                local pCities = pTarget:GetCities()
                if pCities then
                    for _, pEnemyCity in pCities:Members() do
                        local dist = Map.GetPlotDistance(locX, locY, pEnemyCity:GetX(), pEnemyCity:GetY())
                        if dist <= RANGE_POP then
                            local currentPop = pEnemyCity:GetPopulation()
                            if currentPop > 1 then
                                print(string.format("UltracristoDestruction: -1 pop in %s (player %d) at %d, %d (dist=%d)", pEnemyCity:GetName(), iTarget, pEnemyCity:GetX(), pEnemyCity:GetY(), dist))
                                pEnemyCity:ChangePopulation(-1)
                            else
                                print(string.format("UltracristoDestruction: %s already at min pop 1, skipping", pEnemyCity:GetName()))
                            end
                        end
                    end
                end
            end
        end
    end
end

function ApplyUltracristoEffects()
    for iPlayer = 0, MAX_PLAYERS - 1 do
        local pPlayer = Players[iPlayer]
        if pPlayer and pPlayer:IsAlive() and pPlayer:GetCities() then
            for _, pCity in pPlayer:GetCities():Members() do
                if pCity:GetBuildings():HasBuilding(ULTRACRISTO_BUILDING) then
                    DoUltracristoPopLoss(pCity, iPlayer)
                end
            end
        end
    end
end

function OnPlayerTurnActivated(playerID, isFirstTime)
    if not isFirstTime then return end

    local currentTurn = Game.GetCurrentGameTurn()
    if currentTurn == m_lastProcessedTurn then
        return
    end

    m_lastProcessedTurn = currentTurn
    print(string.format("UltracristoDestruction: Processing turn %d", currentTurn))
    ApplyUltracristoEffects()
end

function Initialize()
    print("UltracristoDestruction: Initializing (per-turn pop loss mode)")
    Events.PlayerTurnActivated.Add(OnPlayerTurnActivated)
    print("UltracristoDestruction: Setup complete")
end

Initialize()
