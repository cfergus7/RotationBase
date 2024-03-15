game_api = require("lib")
spells = require("spells")
auras = require("auras")

local functions = {} -- The main table

function functions.countUnitsBelowHealthThreshold(threshold)
    local party = game_api.getPartyUnits()
    local count = 0

    for _, unit in ipairs(party) do
        if game_api.unitHealthPercent(unit) < threshold then
            count = count + 1
        end
    end

    return count
end

function functions.countUnitsWithAura(aura)
    local party = game_api.getPartyUnits()
    local count = 0

    for _, unit in ipairs(party) do
        if game_api.unitHasAura(unit, aura) then
            count = count + 1
        end
    end

    return count
end

function functions.getLowestHealthUnits()
    local partyUnits = game_api.getPartyUnits()
    local lowestHealthUnit = nil
    local secondLowestHealthUnit = nil
    local lowestHealthPercent = 101
    local secondLowestHealthPercent = 101

    for _, unit in ipairs(partyUnits) do
        if functions.IsInRange(40, unit) and game_api.unitHealthPercent(unit) > 0 then
            local currentHealthPercent = game_api.unitHealthPercent(unit)

            if currentHealthPercent < lowestHealthPercent then
                -- Update second lowest
                secondLowestHealthPercent = lowestHealthPercent
                secondLowestHealthUnit = lowestHealthUnit
                -- Update lowest
                lowestHealthPercent = currentHealthPercent
                lowestHealthUnit = unit
            elseif currentHealthPercent < secondLowestHealthPercent and unit ~= lowestHealthUnit then
                secondLowestHealthPercent = currentHealthPercent
                secondLowestHealthUnit = unit
            end
        end
    end

    -- Default to player if no unit is found
    if not lowestHealthUnit then
        lowestHealthUnit = game_api.getCurrentPlayer()
        lowestHealthPercent = game_api.unitHealthPercent(lowestHealthUnit)
    end
    if not secondLowestHealthUnit then
        secondLowestHealthUnit = lowestHealthUnit
        secondLowestHealthPercent = lowestHealthPercent
    end

    return lowestHealthUnit, secondLowestHealthUnit, lowestHealthPercent, secondLowestHealthPercent
end

function functions.getTarget()
    local enemyTarget = nil
    local targetHpPercent = nil
    if not game_api.unitInCombat(state.currentPlayer) then return end

    local currentTarget = game_api.getCurrentUnitTarget()
    if currentTarget and game_api.isTargetHostile(true) and functions.IsInRange(40, currentTarget) then
        enemyTarget = currentTarget
        targetHpPercent = game_api.unitHealthPercent(currentTarget)
    end

    return enemyTarget, targetHpPercent
end

function functions.CanCast(spell)

    return game_api.canCast(spell) and game_api.spellIsKnown(spell) and not game_api.isOnCooldown(spell)   
   
end
function functions.cooldownRemaining(spell)
    if game_api.spellIsKnown(spell) then
    return game_api.getCooldownRemainingTime(spell)
    end
end


function functions.UnitToDispelNoLogic(dispelTypes)
    local lowestHealthUnit = nil
    local lowestHealth = 101

    local partyUnits = game_api.getPartyUnits()
    for _, playerPartyUnit in ipairs(partyUnits) do
        for _, dispelType in ipairs(dispelTypes) do
            if dispelType then
                local debuffList = game_api.unitDebuffListWithDispelType(playerPartyUnit, dispelType)
                if #debuffList > 0 then
                    local unitHealth = game_api.unitHealthPercent(playerPartyUnit)
                    if (unitHealth > 0 and unitHealth < lowestHealth) and game_api.distanceToUnit(playerPartyUnit) <= 25 then
                        lowestHealth = unitHealth
                        lowestHealthUnit = playerPartyUnit
                    end
                end
            end
        end
    end
    return lowestHealthUnit
end



function functions.IsInRange(range, unit)
    return game_api.distanceToUnit(unit) <= range
end



function functions.RefreshParty()
    return game_api.getPartyUnits();
end

function functions.UnitHasAnyAura(unit, ids)
    local randomNumber = functions.randomBetween(250, 1250)
    for _, id in ipairs(ids) do
        if game_api.unitHasAura(unit, id, false) and game_api.unitAuraElapsedTime(unit, id, false) >= randomNumber then
            return true
        end
    end
    return false
end

function functions.UnitHasDebuff(unit, id)
    local randomNumber = functions.randomBetween(250, 1250)
    
    local unitDebuffs = game_api.unitDebuffList(unit)
    for _, debuff in ipairs(unitDebuffs) do
        if debuff == id or game_api.unitDebuffRemainingTime(unit, id) >= randomNumber then
            return true
        end
    end
    return false
end

function functions.randomBetween(min, max)
    local intMin = math.floor(min)
    local intMax = math.floor(max)
    return math.random(intMin, intMax)
end



function functions.convertPowerToPercentage(index)
    local maxValue = game_api.getMaxPower(index)
    local currentValue = game_api.getPower(index)

    if maxValue and maxValue > 0 then
        local percentageValue = (currentValue / maxValue) * 100
        return percentageValue
    else
        return 0
    end
end



local combatStartTime = nil
local isInCombat = false
local lastTarget = nil

function functions.timeToDie()
    local targetHealthMax = state.currentTargetHealthMax
    local targetHealthCurrent = state.currentTargetHealth
    local currentTarget = state.currentTarget

    if lastTarget ~= currentTarget then
        combatStartTime = game_api.currentTime()
        isInCombat = true
        lastTarget = currentTarget
    end

    if targetHealthCurrent > 0 then
        local currentTime = game_api.currentTime()

        if not isInCombat then
            combatStartTime = currentTime
            isInCombat = true
        end
        local elapsedTime = currentTime - combatStartTime
        local healthLost = targetHealthMax - targetHealthCurrent
        if healthLost > 0 then
            local timeToDie = (targetHealthCurrent / healthLost) * elapsedTime / 1000
            return timeToDie
        else
            return 0
        end
    else
        combatStartTime = nil
        isInCombat = false
        lastTarget = nil
        return 0
    end
end
--#region

function functions.isInCombatOrHasNpcId(unit, npcIdList)
    if game_api.unitInCombat(unit) then
        return true
    end

    local unitNpcId = game_api.unitNpcID(unit)
    if unitNpcId then
        if npcIdList[unitNpcId] then
            return true
        end
    end

    return false
end

local combatStartTimes = {}
function functions.timeToDieGroup()
    local units = game_api.getUnits()
    local unitsToEvaluate = {}
    local totalTTD = 0
    local unitCount = 0

    -- Clean up combatStartTimes for units no longer in combat or relevant
    for unit in pairs(combatStartTimes) do
        if not game_api.unitInCombat(unit) or not game_api.isUnitHostile(unit, true) or game_api.unitHealth(unit) <= 0 then
            combatStartTimes[unit] = nil
        end
    end

    for _, unit in ipairs(units) do
        if game_api.unitInCombat(unit) and functions.IsInRange(40, unit) and game_api.isUnitHostile(unit, true) and game_api.unitHealth(unit) > 0 then
            table.insert(unitsToEvaluate, unit)
        end
    end

    for _, unit in ipairs(unitsToEvaluate) do
        local targetHealthMax = game_api.unitMaxHealth(unit)
        local targetHealthCurrent = game_api.unitHealth(unit)

        if targetHealthCurrent > 0 and targetHealthMax > 0 then
            local currentTime = game_api.currentTime()

            local unitCombatStartTime = combatStartTimes[unit] or currentTime
            combatStartTimes[unit] = unitCombatStartTime

            local elapsedTime = currentTime - unitCombatStartTime
            local healthLost = targetHealthMax - targetHealthCurrent

            if healthLost > 0 then
                local timeToDie = (targetHealthCurrent / healthLost) * elapsedTime / 1000
                totalTTD = totalTTD + timeToDie
                unitCount = unitCount + 1
            end
        end
    end

    if unitCount > 0 then
        return totalTTD / unitCount -- return average TTD
    else
        return 0
    end
end

function functions.IsInRange(range, unit)
    return game_api.distanceBetweenUnits(game_api.getCurrentPlayer(), unit) <= range
end

function functions.randomBetween(min, max)
    local intMin = math.floor(min)
    local intMax = math.floor(max)
    return math.random(intMin, intMax)
end

function functions.PartyUnitMissingAura(auraID)
    local randomNumber = functions.randomBetween(500, 1250)
    for _, unit in ipairs(game_api.getPartyUnits()) do
        if not game_api.isUnitHostile(unit,false) and game_api.unitHealthPercent(unit) > 0 and functions.IsInRange(20, unit) then
            if not game_api.unitHasAura(unit, auraID, true) 
            or (game_api.unitHasAura(unit, auraID, true) 
            and (game_api.unitAuraRemainingTime(unit, auraID, true) <= randomNumber)) then
                return unit
            end
        end
    end
end

return functions
