game_api = require("lib")
spells = require("spells")
auras = require("auras")
cLists = require("common_lists")

local common_functions = {}

function common_functions.IsInGroup()
    return game_api.getPartySize() <= 5
end

function common_functions.IsInRaid()
    return game_api.getPartySize() > 5
end

function FollowerDungeonAddMobs()
    local party = game_api.getPartyUnits()
    local npcIds = { 209057, 209059, 209065, 214390 }

    for _, npcId in ipairs(npcIds) do
        local unitsWithID = game_api.getUnitsByNpcId(npcId)

        for _, unit in ipairs(unitsWithID) do
            table.insert(party, unit)
        end
    end
    return party
end

function common_functions.getParty()
    return FollowerDungeonAddMobs();
end

local party = common_functions.getParty()

local prevstring = nil

function common_functions.HealingTrinketLogic(UseTrinket1Setting, UseTrinket2Setting, TrinketAvgHP, UseSetting, TargetUnit)
    local Trinket1 = game_api.getTrinketID1()
    local Trinket2 = game_api.getTrinketID2()
    local TrinketAoELogic = common_functions.AverageGroupLife(40) <= game_api.getSetting(TrinketAvgHP)

    if game_api.getSetting(UseTrinket1Setting) then
        if game_api.canCastObject(Trinket1) and common_functions.UseCooldown(UseSetting, TrinketAoELogic) then
            if TargetUnit then
                game_api.castObjectOnPartyMember(Trinket1, TargetUnit)
            else
                game_api.castObject(Trinket1)
            end
            common_functions.Debug("Trinket 1 Casted")
            return true
        end
    end
    if game_api.getSetting(UseTrinket2Setting) then
        if game_api.canCastObject(Trinket2) and common_functions.UseCooldown(UseSetting, TrinketAoELogic) then
            if TargetUnit then
                game_api.castObjectOnPartyMember(Trinket2, TargetUnit)
            else
                game_api.castObject(Trinket2)
            end
            common_functions.Debug("Trinket 2 Casted")
            return true
        end
    end

    return false
end

function common_functions.Debug(string)
    if string ~= prevstring then
        print(string)
        prevstring = string
    end
end

function common_functions.BestNPCToHeal(range)
    local BestUnit = nil
    local LowestHealthPercent = 100 -- Start with the highest possible health percent

    for npcId, _ in pairs(cLists.npcsToHealDictionary) do
        local units = game_api.getUnitsByNpcId(npcId)
        for _, unit in ipairs(units) do
            local unitHealthPercent = game_api.unitHealthPercent(unit)
            if common_functions.IsInRange(range, unit) and unitHealthPercent > 0 and unitHealthPercent < LowestHealthPercent then
                BestUnit = unit
                LowestHealthPercent = unitHealthPercent
            end
        end
    end

    return BestUnit -- This will return nil if no suitable NPC is found, or the identifier of the best NPC to heal
end

function common_functions.CountNPCsBelowFullHealthInRange(range)
    local count = 0

    for npcId, _ in pairs(cLists.npcsToHealDictionary) do
        local units = game_api.getUnitsByNpcId(npcId)
        for _, unit in ipairs(units) do
            local unitHealthPercent = game_api.unitHealthPercent(unit)
            if unitHealthPercent > 0 and unitHealthPercent < 100 and common_functions.IsInRange(range, unit) then
                count = count + 1
            end
        end
    end

    return count
end

function common_functions.CountUnitsInRange(range, units)
    local count = 0
    range = nil and 40 or range

    for _, unit in ipairs(units) do
        local unitHealthPercent = game_api.unitHealthPercent(unit)
        if unitHealthPercent > 0 and unitHealthPercent < 100 and common_functions.IsInRange(range, unit) then
            count = count + 1
        end
    end

    return count
end

function common_functions.CountUnits(units)
    local count = 0

    for _, unit in ipairs(units) do
        local unitHealthPercent = game_api.unitHealthPercent(unit)
        if unitHealthPercent > 0 and unitHealthPercent <= 100 then
            count = count + 1
        end
    end

    return count
end

function common_functions.BufTrackingHealth(buff, health, range)
    local count = 0
    for _, unit in ipairs(party) do
        if game_api.unitHasAura(unit, buff, true) and game_api.unitHealthPercent(unit) <= health and game_api.unitHealthPercent(unit) > 0 and game_api.distanceBetweenUnits(game_api.getCurrentPlayer(), unit) <= range then
            count = count + 1
        end
    end
    return count
end

function common_functions.BuffTrackingNoRange(buff)
    local count = 0

    for _, unit in ipairs(party) do
        if game_api.unitHasAura(unit, buff, true) and game_api.unitHealthPercent(unit) > 0 then
            count = count + 1
        end
    end
    return count
end

function common_functions.AnyBuffTrackingNoRange(buff)
    local count = 0

    for _, unit in ipairs(party) do
        if game_api.unitHasAura(unit, buff, false) and game_api.unitHealthPercent(unit) > 0 then
            count = count + 1
        end
    end
    return count
end

function common_functions.BuffTracking(buff)
    local count = 0

    for _, unit in ipairs(party) do
        if common_functions.IsInRange(40, unit) and game_api.unitHasAura(unit, buff, true) and game_api.unitHealthPercent(unit) > 0 then
            count = count + 1
        end
    end
    return count
end

function common_functions.AoELogic(hasTalentCondition, talentRange, noTalentRange, isInRaidSetting, notInRaidSetting,
                                   healthThresholdSetting)
    -- Default values
    hasTalentCondition = hasTalentCondition or false
    talentRange = talentRange or 40
    noTalentRange = noTalentRange or 40

    -- Check if the player has the specified talent
    local AoERange = hasTalentCondition and talentRange or noTalentRange
    -- Get the appropriate setting based on whether the player is in a raid
    local AoESetting = common_functions.IsInRaid() and game_api.getSetting(isInRaidSetting) or
        game_api.getSetting(notInRaidSetting)
    -- Get the number of party units below a certain health percentage within the AoERange
    local AoESetup = game_api.getPartyUnitBelowHealthPercent(game_api.getSetting(healthThresholdSetting), AoERange)

    -- Check if the number of units in AoESetup is greater than or equal to the AoESetting
    local AoECondition = #AoESetup >= AoESetting
    -- Return true if all conditions are met, otherwise return false
    return AoECondition
end

function common_functions.UseCooldown(conditions, AoESetting)
    local UsageSetting = game_api.getSetting(conditions)
    AoESetting = AoESetting == nil and true or AoESetting -- Treat nil as true

    if UsageSetting == "Logic" then
        return AoESetting
    elseif UsageSetting == "With Cooldowns and Logic Setting" then
        return game_api.getToggle(settings.Cooldown) and AoESetting
    elseif UsageSetting == "With Cooldowns Toggle" then
        return game_api.getToggle(settings.Cooldown)
    else
        return false -- Explicitly return false if none of the conditions are met
    end
end

function common_functions.UnitHealthPercentWeighted(unit)
    local weight = common_functions.CustomWeightFunction:CalculatePartyUnitWeight(unit)
    local result = math.floor(game_api.unitHealthPercent(unit) * weight)

    return math.max(result, 1)
end

--[[function common_functions.UnitWithLowestEffectiveHealth(range)
    local lowestHealthUnit = nil
    local lowestEffectiveHealth = 101 -- Start higher than 100 to ensure we catch the first unit


    for _, unit in ipairs(party) do
        if common_functions.IsInRange(range, unit) and game_api.unitHealthPercent(unit) > 0 then
            local weight = common_functions.CustomWeightFunction:CalculatePartyUnitWeight(unit)
            local effectiveHealth = game_api.unitHealthPercent(unit) * weight

            if effectiveHealth < lowestEffectiveHealth then
                lowestEffectiveHealth = effectiveHealth
                lowestHealthUnit = unit
            end
        end
    end

    -- Check if lowestHealthUnit is still nil, indicating no units were found
    if lowestHealthUnit == nil then
        return game_api.getCurrentPlayer()
    else
        return lowestHealthUnit
    end
end]]

function common_functions.UnitWithLowestEffectiveHealth(range)
    local lowestHealthUnit = nil
    local lowestEffectiveHealth = 101 -- Start higher than 100 to ensure we catch the first unit
    local CurrentTarget = game_api.getCurrentUnitTarget()
    local unitBelowThresholdFound = false -- Track if any unit below 15% health is found
    local isCurrentTargetInParty = false -- Flag to check if CurrentTarget is in the party

    for _, unit in ipairs(party) do
        -- Check if CurrentTarget is in the party
        if unit == CurrentTarget then
            isCurrentTargetInParty = true
        end

        if common_functions.IsInRange(range, unit) and game_api.unitHealthPercent(unit) > 0 then
            local weight = common_functions.CustomWeightFunction:CalculatePartyUnitWeight(unit)
            local effectiveHealth = game_api.unitHealthPercent(unit) * weight

            -- Check if any unit's health is below 15%
            if game_api.unitHealthPercent(unit) < 15 then
                unitBelowThresholdFound = true
            end

            if effectiveHealth < lowestEffectiveHealth then
                lowestEffectiveHealth = effectiveHealth
                lowestHealthUnit = unit
            end
        end
    end

    -- Additional checks for CurrentTarget
    if not unitBelowThresholdFound and isCurrentTargetInParty and common_functions.IsInRange(range, CurrentTarget) and game_api.unitHealthPercent(CurrentTarget) > 0 then
        -- Default to CurrentTarget if it matches the criteria and no unit is below 15% health, ensuring it's also part of the party
        lowestHealthUnit = CurrentTarget
    end

    -- Check if lowestHealthUnit is still nil, indicating no units were found
    if lowestHealthUnit == nil then
        return game_api.getCurrentPlayer()
    else
        return lowestHealthUnit
    end
end

function common_functions.AverageGroupLife(range)
    local totalEffectiveHealth = 0
    local unitCount = 0

    for _, unit in ipairs(party) do
        if common_functions.IsInRange(range, unit) and game_api.unitHealthPercent(unit) > 0 then
            local weight = common_functions.CustomWeightFunction:CalculatePartyUnitWeight(unit)
            local effectiveHealth = game_api.unitHealthPercent(unit) * weight

            totalEffectiveHealth = totalEffectiveHealth + effectiveHealth
            unitCount = unitCount + 1
        end
    end

    if unitCount == 0 then
        -- Avoid division by zero if no units are found
        return 0
    else
        local averageEffectiveHealth = totalEffectiveHealth / unitCount
        return averageEffectiveHealth
    end
end


function common_functions.UnitWithLowestEffectiveHealthWithOutAura(range, aura)
    local lowestHealthUnit = nil
    local lowestEffectiveHealth = 101 -- Start higher than 100 to ensure we catch the first unit


    for _, unit in ipairs(party) do
        if common_functions.IsInRange(range, unit) and game_api.unitHealthPercent(unit) > 0 and not game_api.unitHasAura(unit, aura, true) then
            local weight = common_functions.CustomWeightFunction:CalculatePartyUnitWeight(unit)
            local effectiveHealth = game_api.unitHealthPercent(unit) * weight

            if effectiveHealth < lowestEffectiveHealth then
                lowestEffectiveHealth = effectiveHealth
                lowestHealthUnit = unit
            end
        end
    end
    return lowestHealthUnit
end

function common_functions.UnitWithLowestEffectiveHealthWithAura(range, aura)
    local lowestHealthUnit = nil
    local lowestEffectiveHealth = 101 -- Start higher than 100 to ensure we catch the first unit


    for _, unit in ipairs(party) do
        if common_functions.IsInRange(range, unit) and game_api.unitHealthPercent(unit) > 0 and game_api.unitHasAura(unit, aura, true) then
            local weight = common_functions.CustomWeightFunction:CalculatePartyUnitWeight(unit)
            local effectiveHealth = game_api.unitHealthPercent(unit) * weight

            if effectiveHealth < lowestEffectiveHealth then
                lowestEffectiveHealth = effectiveHealth
                lowestHealthUnit = unit
            end
        end
    end
    return lowestHealthUnit
end

function common_functions.CanCast(spell)
    return game_api.canCast(spell) and game_api.spellIsKnown(spell) and not game_api.isOnCooldown(spell)
end

function common_functions.BuffTrackingTL(buff, timeleft)
    timeleft = timeleft or 1000
    local count = 0


    for _, unit in ipairs(party) do
        if common_functions.IsInRange(40, unit) and game_api.unitHasAura(unit, buff, true) and game_api.unitHealthPercent(unit) > 0 and game_api.unitAuraRemainingTime(unit, buff, true) > timeleft then
            count = count + 1
        end
    end
    return count
end

function common_functions.isInPandemicRemainingTime(target, auraID)
    local valid = true
    if auraID ~= nil then
        if game_api.unitHasAura(target, auraID, true) then
            local globalTime = game_api.unitAuraEndTime(target, auraID, true) -
                game_api.unitAuraStartTime(target, auraID, true)
            local remainingTime = game_api.unitAuraRemainingTime(target, auraID, true)
            local remainingTimePercentage = ((remainingTime * 100) / globalTime)
            valid = remainingTimePercentage < 30
        end
    end
    return valid
end

common_functions.CustomWeightFunction = {}
function common_functions.CustomWeightFunction:CalculatePartyWeight() -- Get combined party weight
    local totalPartyWeight = 1
    local count = 0


    for _, unit in ipairs(party) do
        local unitWeight = common_functions.CustomWeightFunction:CalculatePartyUnitWeight(unit)
        totalPartyWeight = totalPartyWeight + unitWeight
        count = count + 1
    end

    return totalPartyWeight / count -- Divide it by count to get the average total party weight
end

function common_functions.CustomWeightFunction:CalculateEnemyWeight() -- Get combined enemy weights
    local totalEnemyWeight = 1
    local enemies = game_api.getUnits()
    local enemiesToWeight = {}
    local count = 0

    -- First we need to check which units we ACTUALLY want to weight
    for _, enemy in ipairs(enemies) do
        if game_api.isUnitHostile(enemy, true) and game_api.unitHealth(enemy) > 0 and game_api.unitInCombat(enemy) then
            table.insert(enemiesToWeight, enemy)
            count = count + 1
        end
    end

    -- We then loop through the enemiesToWeight table and calculate the weight for each unit
    for _, enemy in ipairs(enemiesToWeight) do
        local enemyWeight = common_functions.CustomWeightFunction:CalculatePartyUnitWeight(enemy)
        totalEnemyWeight = totalEnemyWeight + enemyWeight
    end

    return totalEnemyWeight / count -- Divide by count to get the average total enemy weight
end

local GashFrenzy = 378020
local TouchOfRuin = 397936
local JadeSerpentStrike = 106841
local EarthenShards = 372718
local ImpendingDoom = 397907
local DecayingStrike = 373917
local DecayingStrikeE = 373915
local ShadowflameEnergy = 410077
local Purgatory = 116888
local Ironbark = 102342
local Painsuppression = 33206
local GuardianSpirit = 47788
local BoS = 6940
local DivineShield = 642
local WrackingPain = 250096
local ChronoShear = 413013
local TemporalLink = 419511
local CrushingDepths = 428542
local soulthorns = 260551
local HeavyDmgDebuffs = {
    429048, -- FlameShock
    200238, -- FeedOnTheWeek
    204646, -- CrushingGrip
    204611, -- CrushingGrip2
    196376, -- GreviousTear
    201733, -- StingingSwarm
    197546, -- BrutalGlaive
    260511, -- SoulThorns
    260741, -- JaggedNettles
    263943, -- Etch
    416139, -- TemporalBreath
    409266, -- ExtictionBlast1
    409268, -- ExtictionBlast2
    409261, -- ExtictionBlast3
    414300, -- ExtictionBlast4
    407714, -- Corrosion1
    407713, -- Corrosion2
    407406, -- Corrosion3
    415769, -- Chronoburst
}
local ModerateDmgDebuffs = { 393444, 367521, 372566, 372570, 367481, 410873, 378208, 255558, 204243, 413427 }

local function unitHasDebuffFromList(debuffList, unit)
    for _, debuffId in ipairs(debuffList) do
        if game_api.unitHasAura(unit, debuffId, false) then
            return true
        end
    end
    return false
end
local function countAurasFromList(auraList, unit)
    local count = 0
    for _, debuffId in ipairs(auraList) do
        if game_api.unitHasAura(unit, debuffId, false) then
            count = count + 1
        end
    end
    return count
end

function common_functions.CustomWeightFunction:CalculatePartyUnitWeight(unit)
    local weight = 1
    local unitIsTank = game_api.unitIsRole(unit, "TANK")
    local unitClassDK = game_api.unitHasAura(unit, 137008, false)
    local unitClassDruid = game_api.unitHasAura(unit, 137010, false)

    -- Defining the debuffs as global for the sake of the example

    local PriorityDebuff = game_api.unitHasAura(unit, GashFrenzy, false) or
        game_api.unitHasAura(unit, EarthenShards, false) or game_api.unitHasAura(unit, ShadowflameEnergy, false) or
        game_api.unitHasAura(unit, WrackingPain, false) or game_api.unitHasAura(unit, ChronoShear, false) or
        game_api.unitHasAura(unit, TemporalLink, false) or game_api.unitHasAura(unit, CrushingDepths, false) or
        unitHasDebuffFromList(HeavyDmgDebuffs, unit)
    local hasAnyDebuff = game_api.unitHasAura(unit, TouchOfRuin, false) or
        game_api.unitHasAura(unit, ImpendingDoom, false) or game_api.unitHasAura(unit, JadeSerpentStrike, false) or game_api.unitHasAura(unit, soulthorns, false) or
        unitHasDebuffFromList(cLists.HeavyDmgList, unit) or unitHasDebuffFromList(cLists.BleedList, unit)
    local hasTankDebuff = game_api.unitHasAura(unit, JadeSerpentStrike, false) or
        game_api.unitHasAura(unit, DecayingStrike, false) or game_api.unitHasAura(unit, DecayingStrikeE, false)

    if PriorityDebuff or (unitIsTank and hasTankDebuff) then
        return 0.4
    elseif hasAnyDebuff then
        weight = weight * 0.75

        if unitIsTank then
            if not unitClassDK then
                local healthPercent = game_api.unitHealthPercent(unit)
                if healthPercent >= game_api.getSetting(settings.tankHealthToIgnore) then
                    weight = weight * 1.9
                else
                    weight = weight * 0.8
                end
            else
                local maxPower = game_api.getUnitMaxPower(unit, 0)
                local unitEnergyPercent = maxPower > 0 and (game_api.getUnitPower(unit, 0) / maxPower) * 100 or 0

                if unitEnergyPercent < 20 then
                    weight = weight * 0.4
                else
                    weight = weight * 1.2
                end
            end
        end
    end


    weight = weight * (game_api.unitHasAura(unit, Purgatory, false) and 0.2 or 1)

    -- Check if unit has any HoT from the HoTList and reduce weight if so
    local hasHoT = countAurasFromList(cLists.HoTList, unit)
    if hasHoT > 0 then
        local HoTModifier = 1
        if hasHoT > 2 then
            HoTModifier = HoTModifier * 1.1
        else
            HoTModifier = HoTModifier * 1.02
        end
        weight = weight * HoTModifier
    end

    -- Check if unit has any Shield from the shieldList and reduce weight if so
    local hasShield = countAurasFromList(cLists.shieldList, unit)
    if hasShield > 0 or game_api.unitAuraRemainingTime(unit, DivineShield, false) > 5 then
        local shieldModifier = 1
        shieldModifier = shieldModifier * 1.1
        weight = weight * shieldModifier
    end

    if weight > 0.30 then
        local buffModifier = 1
        if game_api.unitHasAura(unit, Ironbark, false) or game_api.unitHasAura(unit, BoS, false) or game_api.unitHasAura(unit, Painsuppression, false) then
            buffModifier = buffModifier * 1.1
        end
        if game_api.unitHasAura(unit, GuardianSpirit, false) then
            buffModifier = buffModifier * 1.3
        end
        weight = weight * buffModifier
    end
    local CurrentTarget = game_api.getCurrentUnitTarget()
    if game_api.unitInCombat(game_api.getCurrentPlayer()) then
        if unit == CurrentTarget and unit ~= game_api.getCurrentPlayer() then
            weight = .4
        end
    end
    return weight
end

function common_functions.PartyUnitToDispel(...)
    local dispelLists = {}


    for _, dispel in ipairs(...) do
        for _, debuffId in ipairs(dispel) do
            table.insert(dispelLists, debuffId)
        end
    end
    for _, partyMember in ipairs(party) do
        for _, debuffId in ipairs(dispelLists) do
            if game_api.unitHasAura(partyMember, debuffId, false) and not common_functions.UnitHasAnyAura(partyMember, cLists.uniqueIDs) then
                return partyMember
            end
        end
    end
end

function common_functions.AllUnitsAreGreaterDistanceApart(range)
    for i, unit1 in ipairs(party) do
        for j, unit2 in ipairs(party) do
            if i ~= j then       -- Ensure you're not comparing the unit to itself
                if game_api.distanceBetweenUnits(unit1, unit2) <= range then
                    return false -- Found two units within the range, not all are beyond
                end
            end
        end
    end
    return true -- No units within or equal to the range were found
end

-- Helper function to check if a table contains a specific value
local function containsAnyValues(tbl, values)
    for _, val in ipairs(values) do
        for _, v in ipairs(tbl) do
            if v == val then
                return true
            end
        end
    end
    return false
end

function common_functions.AllUnitsAreFarFromUnitWithAura(auraID, range)
    local unitWithAura = nil
    for _, unit in ipairs(party) do
        if game_api.unitHasAura(unit, auraID, false) then
            unitWithAura = unit
            break 
        end
    end

    if not unitWithAura then
        return false
    end

    for _, otherUnit in ipairs(party) do
        if otherUnit ~= unitWithAura then 
            if game_api.distanceBetweenUnits(otherUnit, unitWithAura) <= range then
                return false 
            end
        end
    end

    return true
end



function common_functions.UnitToDispel(DispelType, DispelType2, DispelType3, DispelType4)
    local lowestHealthUnit = nil
    local lowestHealth = 101 -- Set to a number higher than 100 to ensure we catch the first unit

    local dispelTypes = { DispelType, DispelType2, DispelType3, DispelType4 }

    local function shouldDispelUnit(unit)
        local uniqueIDs = cLists.uniqueIDs
        local combinedList = common_functions.getCombinedList(dispelTypes)

        local randomNumber = common_functions.randomBetween(250, 1250)
        -- Helper function to check if a unit has any of the auras from a given list
        local function unitHasAnyAura(unit, ids)
            for _, id in ipairs(ids) do
                if game_api.unitHasAura(unit, id, false) and game_api.unitAuraElapsedTime(unit, id, false) >= randomNumber then
                    common_functions.Debug("Unit Found With Dispelable ID" .. tostring(id))
                    return true
                end
            end
            return false
        end
        local desiredDispelTypes = { "MAGIC", "POISON", "CURSE", "DISEASE" }
        local hasDebuffOfDesiredType = false



        for _, dispelType in ipairs(desiredDispelTypes) do
            if game_api.unitDebuffListWithDispelType(unit, dispelType) then
                hasDebuffOfDesiredType = true
                break
            end
        end

        local genericDispelCheck = common_functions.IsInRange(40, unit) and not unitHasAnyAura(unit, uniqueIDs) and
            hasDebuffOfDesiredType and unitHasAnyAura(unit, combinedList)

        return (

            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 400681, false) and game_api.unitAuraElapsedTime(unit, 400681, false) > 1500) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 240443, false) and game_api.unitAuraStackCount(unit, 240443, false) >= 3 and game_api.unitAuraElapsedTime(unit, 240443, false) > 1500) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 377405, false) and game_api.unitAuraElapsedTime(unit, 377405, false) > 3000) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 389179, false) and common_functions.IsInRange(15, unit) and game_api.unitAuraElapsedTime(unit, 389179, false) > 3000) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 372682, false) and game_api.unitAuraStackCount(unit, 372682, false) > 5) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 384161, false) and common_functions.IsInRange(10, unit) and game_api.unitAuraElapsedTime(unit, 384161, false) > 2500) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 370766, false) and common_functions.IsInRange(15, unit) and game_api.unitAuraElapsedTime(unit, 370766, false) > 2500) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 388777, false) and game_api.unitAuraStackCount(unit, 388777, false) > 11) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 374350, false) and common_functions.IsInRange(15, unit) and game_api.unitAuraElapsedTime(unit, 374350, false) > 3000) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 377510, false) and game_api.unitAuraStackCount(unit, 377510, false) >= 3) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 397907, false) and game_api.unitAuraElapsedTime(unit, 397907, false) >= 1250) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and common_functions.AllUnitsAreFarFromUnitWithAura(415554, 10)) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and (game_api.unitHasAura(unit, 405696, false) or game_api.unitHasAura(unit, 404141, false)) and game_api.unitHasAura(unit, 403912, false)) or
            --(containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 255582, false) and game_api.unitIsRole(unit, "TANK")) or 
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 200182, false) and game_api.unitIsRole(unit, "TANK")) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 412044, false) and game_api.unitIsRole(unit, "TANK")) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 416716, false) and game_api.unitIsRole(unit, "TANK")) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 225909, false) and (game_api.unitAuraStackCount(unit, 225909, false) >= 12 and game_api.unitIsRole(unit, "DPS") or game_api.unitAuraStackCount(unit, 225909, false) >= 8 and game_api.unitIsRole(unit, "TANK"))) or
            (containsAnyValues(dispelTypes, { "POISON" }) and game_api.unitHasAura(unit, 374389, false) and game_api.unitAuraStackCount(unit, 374389, false) >= 4) or
            (containsAnyValues(dispelTypes, { "POISON" }) and game_api.unitHasAura(unit, 217851, false) and (game_api.unitIsRole(unit, "TANK") and game_api.unitAuraElapsedTime(unit, 217851, false) > 2000 or not game_api.unitIsRole("TANK"))) or
            (containsAnyValues(dispelTypes, { "DISEASE" }) and game_api.unitHasAura(unit, 273226, false) and game_api.unitAuraStackCount(unit, 273226, false) >= 2) or
            (containsAnyValues(dispelTypes, { "DISEASE" }) and game_api.unitHasAura(unit, 264050, false) and game_api.unitAuraStackCount(unit, 264050, false) >= 2) or
            (containsAnyValues(dispelTypes, { "DISEASE" }) and common_functions.AllUnitsAreFarFromUnitWithAura(261440, 4)) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and common_functions.AllUnitsAreFarFromUnitWithAura(429048, 10)) or
            
            genericDispelCheck
        )
    end

    for _, playerPartyUnit in ipairs(party) do
        if common_functions.IsInRange(40, playerPartyUnit) and shouldDispelUnit(playerPartyUnit) then
            local unitHealth = game_api.unitHealthPercent(playerPartyUnit)
            if unitHealth > 0 and unitHealth < lowestHealth then
                lowestHealth = unitHealth
                lowestHealthUnit = playerPartyUnit
            end
        end
    end

    return lowestHealthUnit
end





function common_functions.EvokerUnitToDispel(DispelType, DispelType2, DispelType3, DispelType4)
    local lowestHealthUnit = nil
    local lowestHealth = 101 -- Set to a number higher than 100 to ensure we catch the first unit

    local dispelTypes = { DispelType, DispelType2, DispelType3, DispelType4 }

    local function shouldDispelUnit(unit)
        local uniqueIDs = cLists.uniqueIDs
        local combinedList = common_functions.getCombinedList(dispelTypes)

        local randomNumber = common_functions.randomBetween(250, 1250)
        -- Helper function to check if a unit has any of the auras from a given list
        local function unitHasAnyAura(unit, ids)
            for _, id in ipairs(ids) do
                if game_api.unitHasAura(unit, id, false) and game_api.unitAuraElapsedTime(unit, id, false) >= randomNumber then
                    common_functions.Debug("Unit Found With Dispelable ID" .. tostring(id))
                    return true
                end
            end
            return false
        end
        local desiredDispelTypes = { "MAGIC", "POISON", "CURSE", "DISEASE" }
        local hasDebuffOfDesiredType = false



        for _, dispelType in ipairs(desiredDispelTypes) do
            if game_api.unitDebuffListWithDispelType(unit, dispelType) then
                hasDebuffOfDesiredType = true
                break
            end
        end

        local genericDispelCheck = common_functions.IsInRange(25, unit) and not unitHasAnyAura(unit, uniqueIDs) and
            hasDebuffOfDesiredType and unitHasAnyAura(unit, combinedList)

            return (

            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 400681, false) and game_api.unitAuraElapsedTime(unit, 400681, false) > 1500) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 240443, false) and game_api.unitAuraStackCount(unit, 240443, false) >= 3 and game_api.unitAuraElapsedTime(unit, 240443, false) > 1500) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 377405, false) and game_api.unitAuraElapsedTime(unit, 377405, false) > 3000) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 389179, false) and common_functions.IsInRange(15, unit) and game_api.unitAuraElapsedTime(unit, 389179, false) > 3000) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 372682, false) and game_api.unitAuraStackCount(unit, 372682, false) > 5) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 384161, false) and common_functions.IsInRange(10, unit) and game_api.unitAuraElapsedTime(unit, 384161, false) > 2500) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 370766, false) and common_functions.IsInRange(15, unit) and game_api.unitAuraElapsedTime(unit, 370766, false) > 2500) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 388777, false) and game_api.unitAuraStackCount(unit, 388777, false) > 11) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 374350, false) and common_functions.IsInRange(15, unit) and game_api.unitAuraElapsedTime(unit, 374350, false) > 3000) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 377510, false) and game_api.unitAuraStackCount(unit, 377510, false) >= 3) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 397907, false) and game_api.unitAuraElapsedTime(unit, 397907, false) >= 1250) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and common_functions.AllUnitsAreFarFromUnitWithAura(415554, 15)) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and (game_api.unitHasAura(unit, 405696, false) or game_api.unitHasAura(unit, 404141, false)) and game_api.unitHasAura(unit, 403912, false)) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 255582, false) and game_api.unitIsRole(unit, "TANK")) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 200182, false) and game_api.unitIsRole(unit, "TANK")) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 412044, false) and game_api.unitIsRole(unit, "TANK")) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 416716, false) and game_api.unitIsRole(unit, "TANK")) or
            (containsAnyValues(dispelTypes, { "MAGIC" }) and game_api.unitHasAura(unit, 225909, false) and (game_api.unitAuraStackCount(unit, 225909, false) >= 12 and game_api.unitIsRole(unit, "DPS") or game_api.unitAuraStackCount(unit, 225909, false) >= 8 and game_api.unitIsRole(unit, "TANK"))) or
            (containsAnyValues(dispelTypes, { "POISON" }) and game_api.unitHasAura(unit, 374389, false) and game_api.unitAuraStackCount(unit, 374389, false) >= 4) or
            (containsAnyValues(dispelTypes, { "POISON" }) and game_api.unitHasAura(unit, 217851, false) and (game_api.unitIsRole(unit, "TANK") and game_api.unitAuraElapsedTime(unit, 217851, false) > 2000 or not game_api.unitIsRole("TANK"))) or
            (containsAnyValues(dispelTypes, { "DISEASE" }) and game_api.unitHasAura(unit, 273226, false) and game_api.unitAuraStackCount(unit, 273226, false) >= 2) or
            (containsAnyValues(dispelTypes, { "DISEASE" }) and game_api.unitHasAura(unit, 264050, false) and game_api.unitAuraStackCount(unit, 264050, false) >= 2) or
            (containsAnyValues(dispelTypes, { "DISEASE" }) and common_functions.AllUnitsAreFarFromUnitWithAura(261440, 6)) or

            genericDispelCheck
        )
    end

    for _, playerPartyUnit in ipairs(party) do
        if common_functions.IsInRange(30, playerPartyUnit) and shouldDispelUnit(playerPartyUnit) then
            local unitHealth = game_api.unitHealthPercent(playerPartyUnit)
            if unitHealth > 0 and unitHealth < lowestHealth then
                lowestHealth = unitHealth
                lowestHealthUnit = playerPartyUnit
            end
        end
    end

    return lowestHealthUnit
end

function common_functions.LowestBleedUnit(range)
    local randomNumber = common_functions.randomBetween(250, 1250)
    local lowestHealth = 101     -- Initialize to a value higher than the maximum possible health percentage
    local lowestHealthUnit = nil -- Initialize to nil

    local function unitHasAnyAura(unit, ids)
        for _, id in ipairs(ids) do
            if game_api.unitHasAura(unit, id, false) and game_api.unitAuraElapsedTime(unit, id, false) >= randomNumber then
                return true
            end
        end
        return false
    end

    for _, playerPartyUnit in ipairs(party) do
        if common_functions.IsInRange(range, playerPartyUnit) and unitHasAnyAura(playerPartyUnit, cLists.BleedList) then
            local unitHealth = game_api.unitHealthPercent(playerPartyUnit)
            if unitHealth > 0 and unitHealth < lowestHealth then
                lowestHealth = unitHealth
                lowestHealthUnit = playerPartyUnit
            end
        end
    end

    return lowestHealthUnit
end

function common_functions.FreedomUnit(range)
    local randomNumber = common_functions.randomBetween(150, 1050)
    local lowestHealth = 101     -- Initialize to a value higher than the maximum possible health percentage
    local lowestHealthUnit = nil -- Initialize to nil

    local function unitHasAnyAura(unit, ids)
        for id, _ in pairs(ids) do
            if game_api.unitHasAura(unit, id, false) and game_api.unitAuraElapsedTime(unit, id, false) >= randomNumber then
                return true
            end
        end
        return false
    end


    for _, playerPartyUnit in ipairs(party) do
        if common_functions.IsInRange(range, playerPartyUnit) and (unitHasAnyAura(playerPartyUnit, cLists.FreedomList) or game_api.unitHasAura(playerPartyUnit, 164886, false) and game_api.unitAuraStackCount(playerPartyUnit, 164886, false) >= 6) then
            local unitHealth = game_api.unitHealthPercent(playerPartyUnit)
            if unitHealth > 0 and unitHealth < lowestHealth then
                lowestHealth = unitHealth
                lowestHealthUnit = playerPartyUnit
            end
        end
    end

    return lowestHealthUnit
end

function common_functions.BoPUnit(range)
    local randomNumber = common_functions.randomBetween(150, 1050)
    local lowestHealth = 101     -- Initialize to a value higher than the maximum possible health percentage
    local lowestHealthUnit = nil -- Initialize to nil

    local function unitHasAnyAura(unit, ids)
        for id, _ in pairs(ids) do
            if game_api.unitHasAura(unit, id, false) and game_api.unitAuraElapsedTime(unit, id, false) >= randomNumber then
                return true
            end
        end
        return false
    end

    for _, playerPartyUnit in ipairs(party) do
        local unitHealth = game_api.unitHealthPercent(playerPartyUnit)
        if common_functions.IsInRange(range, playerPartyUnit) and not game_api.unitHasAura(playerPartyUnit, auras.Forbearance, false) and (unitHasAnyAura(playerPartyUnit, cLists.BOPList) or unitHasAnyAura(playerPartyUnit, cLists.BleedList2)) and unitHealth <= 70 and unitHealth > 0 then
            if unitHealth < lowestHealth then
                lowestHealth = unitHealth
                lowestHealthUnit = playerPartyUnit
            end
        end
    end

    return lowestHealthUnit
end

function common_functions.UnitWithLowestHealthWithoutAura(buff, secondBuff)
    local lowestHealthUnit = nil
    local lowestHealth = 101 -- Set to a number higher than 100 to ensure we catch the first unit

    for _, unit in ipairs(party) do
        if common_functions.IsInRange(40, unit) and not game_api.unitHasAura(unit, buff, true)
            and (secondBuff ~= nil and not game_api.unitHasAura(unit, secondBuff, true))
            and game_api.unitHealthPercent(unit) > 0 then
            local unitHealth = game_api.unitHealthPercent(unit)
            if unitHealth < lowestHealth then
                lowestHealth = unitHealth
                lowestHealthUnit = unit
            end
        end
    end

    return lowestHealthUnit
end

function common_functions.countUnitsBelowHealthThreshold(threshold, range)
    local count = 0
    range = range or 40 -- Assign 40 if range is nil
    for _, unit in ipairs(party) do
        if game_api.unitHealthPercent(unit) < threshold and common_functions.IsInRange(range, unit) then
            count = count + 1
        end
    end

    return count
end

function common_functions.countUnitsWithAura(aura)
    local count = 0

    for _, unit in ipairs(party) do
        if game_api.unitHasAura(unit, aura, true) then
            count = count + 1
        end
    end

    return count
end

function common_functions.IsInRange(range, unit)
    return game_api.distanceBetweenUnits(game_api.getCurrentPlayer(), unit) <= range
end

function common_functions.IsTargetingNPC(target)
    local npcID = game_api.unitNpcID(target)
    if cLists.npcsToHealDictionary[npcID] then
        return true
    else
        return false
    end
end

function common_functions.RefreshFunctionsState()
    party = common_functions.getParty()

    local npcIds = { 208459, 208461, 207800 }

    for _, npcId in ipairs(npcIds) do
        local unitsWithID = game_api.getUnitsByNpcId(npcId)
        for _, unit in ipairs(unitsWithID) do
            table.insert(party, unit)
        end
    end
end

function common_functions.UnitHasAnyAura(unit, spellIDs)
    local randomNumber = common_functions.randomBetween(1250, 1800)
    for _, id in ipairs(spellIDs) do
        if game_api.unitHasAura(unit, id, true) and game_api.unitAuraElapsedTime(unit, id, true) >= randomNumber then
            return true
        end
    end
    return false
end

function common_functions.UnitHasAnyAuraUp(unit, spellIDs, source)
    for _, id in ipairs(spellIDs) do
        if game_api.unitHasAura(unit, id, source) then
            return true
        end
    end
    return false
end

function common_functions.UnitHasAllAuras(unit, spellIDs)
    local randomNumber = common_functions.randomBetween(1250, 1800)
    for _, id in ipairs(spellIDs) do
        if not game_api.unitHasAura(unit, id, true) or (game_api.unitHasAura(unit, id, true) and (game_api.unitAuraRemainingTime(unit, id, true) <= randomNumber)) then
            return false
        end
    end
    return true
end

function common_functions.PartyUnitHasAnyAuraInCombat(spellIDs)
    local randomNumber = common_functions.randomBetween(500, 1500)

    for _, unit in ipairs(party) do
        for _, id in ipairs(spellIDs) do
            if (game_api.unitHasAura(unit, id, false) and game_api.unitAuraElapsedTime(unit, id, false) >= randomNumber) and game_api.unitInCombat(unit) then
                return unit
            end
        end
    end
    return false
end

function common_functions.PartyUnitMissingAura(auraID)
    local randomNumber = common_functions.randomBetween(500, 1250)
    local partymembers = game_api.getPartyUnits()
    for _, unit in ipairs(partymembers) do
        if game_api.unitHealthPercent(unit) > 0 and common_functions.IsInRange(40, unit) then
            if not game_api.unitHasAura(unit, auraID, true) or (game_api.unitHasAura(unit, auraID, true) and (game_api.unitAuraRemainingTime(unit, auraID, true) <= randomNumber)) then
                return unit
            end
        end
    end
end

function common_functions.UnitMissingAura(unit, auraID)
    local randomNumber = common_functions.randomBetween(500, 1250)
    if game_api.unitHealthPercent(unit) > 0 and common_functions.IsInRange(40, unit) then
        if not game_api.unitHasAura(unit, auraID, true) or (game_api.unitHasAura(unit, auraID, true) and (game_api.unitAuraRemainingTime(unit, auraID, true) <= randomNumber)) then
            return unit
        end
    end
end

function common_functions.UnitHasDebuff(unit, id)
    local randomNumber = common_functions.randomBetween(1250, 1800)
    if (game_api.unitHasAura(unit, id, true)) and game_api.unitAuraRemainingTime(unit, id, true) >= randomNumber then
        return true
    end
    return false
end

function common_functions.randomBetween(min, max)
    local intMin = math.floor(min)
    local intMax = math.floor(max)
    return math.random(intMin, intMax)
end

function common_functions.getCombinedList(dispelTypes)
    local combinedList = {}
    local listMapping = {
        CURSE = cLists.CurseList,
        DISEASE = cLists.DiseaseList,
        MAGIC = cLists.MagicList,
        POISON = cLists.PoisonList
        -- Add other mappings as needed
    }

    local includeRaidList = false -- Flag to determine if RaidList should be included

    for _, dispelType in ipairs(dispelTypes) do
        if dispelType then -- Check if dispelType is not nil
            local list = listMapping[dispelType]
            if list then
                for _, id in ipairs(list) do
                    table.insert(combinedList, id)
                end

                -- Check if the dispelType is MAGIC and set the flag
                if dispelType == "MAGIC" then
                    includeRaidList = true
                end
            end
        end
    end

    -- Include the RaidList only if MAGIC type is mapped
    if includeRaidList then
        for _, id in ipairs(cLists.RaidList) do
            table.insert(combinedList, id)
        end
    end

    return combinedList
end

function common_functions.convertPowerToPercentage(index)
    local maxValue = game_api.getMaxPower(index)
    local currentValue = game_api.getPower(index)

    if maxValue and maxValue > 0 then
        local percentageValue = (currentValue / maxValue) * 100
        return percentageValue
    else
        return 0
    end
end

function common_functions.applyHumanizerPct(value, minVariation, maxVariation)
    if settings.humanizer then
        local variation = math.random(minVariation, maxVariation) -- 5% variation
        value = value + variation
        value = math.max(value, 1)                                -- Ensure it's at least 1%
        value = math.min(value, 99)                               -- Ensure it doesn't exceed 99%
    end
    return value
end

function common_functions.PartyCheckCount(raidCount, mplusCount)
    local checkcount
    if game_api.getPartySize() >= 6 then
        checkcount = raidCount
    else
        checkcount = mplusCount
    end
    return checkcount
end

function common_functions.useConsume(potionOfPowerAlign1, potionOfPowerAlign2,useManaPotion)
    --[[SETTINGS FOR POTION OF POWER TO USE
    -- Potions
    game_api.createSetting(settings.potionOfPower, settings.potionOfPower, "With Lust or Cooldowns", {"On Cooldown", "With Cooldown", "Dont Use", "With Lust", "With Lust or Cooldowns" })
    game_api.createSetting(settings.healthPotionHP, settings.healthPotionHPText, 50, { 0, 100 })
    game_api.createSetting(settings.manaPotionMana, settings.manaPotionManaText, 50, { 0, 100 })
    game_api.createSetting(settings.healthStoneHP, settings.healthStoneHPText, 50, { 0, 100 })

--POTIONS
settings.potionOfPower = "Potion of Power Usage"
settings.potionOfPowerText = "How to use Potion of Power"
settings.healthPotionHP = "Potion - Healing"
settings.healthPotionHPText = "Health to Use Healing Potion"
settings.healthStoneHP = "Healthstone HP"
settings.healthStoneHPText = "Health to Use Health Stone"
settings.manaPotionMana = "Potion - Mana"
settings.manaPotionManaText = "Mana to Use Mana Potion"

    --usage example
        if functions.useConsume(auras.PrimordialWaveBuff, false, false) then
            return true
        end
    if you want 2 auras to trigger on, maybe PI, you can use the 2nd index
    auras.Bloodlust = 2825
    auras.Bloodlust = 32182
]]
    local PotionMode = game_api.getSetting(settings.potionOfPower)
    local shouldUsePotionOfPower = (PotionMode == "On Cooldown") or 
                                   (PotionMode == "With Cooldown" and ((potionOfPowerAlign1 and game_api.currentPlayerHasAura(potionOfPowerAlign1, false)) or (potionOfPowerAlign2 and game_api.currentPlayerHasAura(potionOfPowerAlign2, false)))) or
                                    (PotionMode == "With Lust or Cooldowns" and ((potionOfPowerAlign1 and game_api.currentPlayerHasAura(potionOfPowerAlign1, false)) or (potionOfPowerAlign2 and game_api.currentPlayerHasAura(potionOfPowerAlign2, false)) or game_api.currentPlayerHasAura(390386,false) or game_api.currentPlayerHasAura(80353,false) or game_api.currentPlayerHasAura(2825,false) or game_api.currentPlayerHasAura(32182,false) or game_api.currentPlayerHasAura(264667,false))) or
                                    (PotionMode == "With Lust" and (game_api.currentPlayerHasAura(390386,false) or game_api.currentPlayerHasAura(80353,false) or game_api.currentPlayerHasAura(2825,false) or game_api.currentPlayerHasAura(32182,false) or game_api.currentPlayerHasAura(264667,false)))

    if shouldUsePotionOfPower then
        for potionID, _ in pairs(cLists.powerPotions) do
            if not game_api.objectIsOnCooldown(potionID) and game_api.canCastObject(potionID) then
                print("Using Power Potion:", potionID)
                game_api.castObject(potionID)
            end
        end
    end
    if game_api.unitHealthPercent(game_api.getCurrentPlayer()) < game_api.getSetting(settings.healthStoneHP) then
        if not game_api.objectIsOnCooldown(5512) and game_api.canCastObject(5512) then
            print("Using Healthstone")
            game_api.castObject(5512)
        end
    end
    if game_api.unitHealthPercent(game_api.getCurrentPlayer()) < game_api.getSetting(settings.healthPotionHP) then
        for potionID, _ in pairs(cLists.healingPotions) do
            if not game_api.objectIsOnCooldown(potionID) and game_api.canCastObject(potionID) then
                print("Using Healing Potion:", potionID)
                game_api.castObject(potionID)
            end
        end
    end
    if useManaPotion then
        if common_functions.convertPowerToPercentage(0) < game_api.getSetting(settings.manaPotionMana) then
            for potionID, _ in pairs(cLists.manaPotions) do
                if not game_api.objectIsOnCooldown(potionID) and game_api.canCastObject(potionID) then
                    print("Using Mana Potion:", potionID)
                    game_api.castObject(potionID)
                end
            end
        end
    end

    return false 
end

function common_functions.dpsTrinket(trinketAlignAura1, trinketAlignAura2)
    --[[SETTINGS FOR trinket usage
    -- trinkets
    game_api.createSetting(settings.trinket1, settings.trinket1Text, "With Lust or Cooldowns", {"On Cooldown", "With Cooldown", "Dont Use", "With Lust", "With Lust or Cooldowns", "Defensive" })
    game_api.createSetting(settings.trinket2, settings.trinket2Text, "With Lust or Cooldowns", {"On Cooldown", "With Cooldown", "Dont Use", "With Lust", "With Lust or Cooldowns", "Defensive" })
    game_api.createSetting(settings.defensiveTrinketHP, settings.defensiveTrinketHPText, 50, { 0, 100 })

--trinket
settings.trinket1 = "Trinket 1 Usage"
settings.trinket1Text = "How to use 1st trinket (top slot)"
settings.trinket2 = "Trinket 2 Usage"
settings.trinket2Text = "How to use 2nd trinket (bottom slot)"
settings.defensiveTrinketHP = "Trinket - Defensive"
settings.defensiveTrinketHPText = "Health to Use Defensive Trinket"


    --usage example
        if functions.dpsTrinket(auras.empowerRuneWeapon,false) then
            return true
        end
    if you want 2 auras to trigger on, maybe PI, you can use the 2nd index
    auras.Bloodlust = 2825
    auras.Bloodlust = 32182
]]

    local trinketMode1 = game_api.getSetting(settings.trinket1)
    local shouldUseTrinket1 = (trinketMode1 == "On Cooldown") or 
                                (trinketMode1 == "With Cooldown" and ((trinketAlignAura1 and game_api.currentPlayerHasAura(trinketAlignAura1, false)) or (trinketAlignAura2 and game_api.currentPlayerHasAura(trinketAlignAura2, false)))) or
                                (trinketMode1 == "With Lust or Cooldowns" and ((trinketAlignAura1 and game_api.currentPlayerHasAura(trinketAlignAura1, false)) or (trinketAlignAura2 and game_api.currentPlayerHasAura(trinketAlignAura2, false)) or game_api.currentPlayerHasAura(390386,false) or game_api.currentPlayerHasAura(80353,false) or game_api.currentPlayerHasAura(2825,false) or game_api.currentPlayerHasAura(32182,false) or game_api.currentPlayerHasAura(264667,false))) or
                                (trinketMode1 == "With Lust" and (game_api.currentPlayerHasAura(390386,false) or game_api.currentPlayerHasAura(80353,false) or game_api.currentPlayerHasAura(2825,false) or game_api.currentPlayerHasAura(32182,false) or game_api.currentPlayerHasAura(264667,false)))

    local trinketMode2 = game_api.getSetting(settings.trinket2)
    local shouldUseTrinket2 = (trinketMode2 == "On Cooldown") or 
                                (trinketMode2 == "With Cooldown" and ((trinketAlignAura1 and game_api.currentPlayerHasAura(trinketAlignAura1, false)) or (trinketAlignAura2 and game_api.currentPlayerHasAura(trinketAlignAura2, false)))) or
                                (trinketMode2 == "With Lust or Cooldowns" and ((trinketAlignAura1 and game_api.currentPlayerHasAura(trinketAlignAura1, false)) or (trinketAlignAura2 and game_api.currentPlayerHasAura(trinketAlignAura2, false)) or game_api.currentPlayerHasAura(390386,false) or game_api.currentPlayerHasAura(80353,false) or game_api.currentPlayerHasAura(2825,false) or game_api.currentPlayerHasAura(32182,false) or game_api.currentPlayerHasAura(264667,false))) or
                                (trinketMode2 == "With Lust" and (game_api.currentPlayerHasAura(390386,false) or game_api.currentPlayerHasAura(80353,false) or game_api.currentPlayerHasAura(2825,false) or game_api.currentPlayerHasAura(32182,false) or game_api.currentPlayerHasAura(264667,false)))

    if shouldUseTrinket1 then
        local trinket1 = game_api.getTrinketID1()
        if trinket1 ~= nil then
            if not game_api.objectIsOnCooldown(trinket1) and game_api.canCastObject(trinket1) then
                print("Using Trinket 1")
                game_api.castObjectOnTarget(trinket1, game_api.getCurrentUnitTarget())
            end
        end
    end
    if trinketMode1 == "Defensive" then
        local trinket1 = game_api.getTrinketID1()
        if trinket1 ~= nil then
            if game_api.unitHealthPercent(game_api.getCurrentPlayer()) <= game_api.getSetting(settings.defensiveTrinketHP) then
                if not game_api.objectIsOnCooldown(trinket1) and game_api.canCastObject(trinket1) then
                    print("Using Trinket 1 Defensive")
                    game_api.castObjectOnTarget(trinket1, game_api.getCurrentUnitTarget())
                end
            end
        end
    end

    if shouldUseTrinket2 then
        local trinket2 = game_api.getTrinketID2()
        if trinket2 ~= nil then
            if not game_api.objectIsOnCooldown(trinket2) and game_api.canCastObject(trinket2)  then
                print("Using Trinket 2")
                game_api.castObjectOnTarget(trinket2, game_api.getCurrentUnitTarget())
            end
        end
    end
    if trinketMode2 == "Defensive" then
        local trinket2 = game_api.getTrinketID2()
        if trinket2 ~= nil then
            if game_api.unitHealthPercent(game_api.getCurrentPlayer()) <= game_api.getSetting(settings.defensiveTrinketHP) then
                if not game_api.objectIsOnCooldown(trinket2) and game_api.canCastObject(trinket2) then
                    print("Using Trinket 2 Defensive")
                    print(game_api.getCurrentUnitTarget())
                    game_api.castObjectOnTarget(trinket2, game_api.getCurrentUnitTarget())
                end
            end
        end
    end
    return false
end

function common_functions.isUnitDummy(unit)
    local unitNpcID = game_api.unitNpcID(unit)
    
    for id, _ in pairs(cLists.dummies) do
        if unitNpcID == id then
            return true
        end
    end
    
    return false
end

function common_functions.hasImmunity(unit)
    for _, immunity in ipairs(cLists.immunity) do
        if game_api.unitHasAura(immunity, unit, false) then
            return true
        end
    end
    return false
end

function common_functions.ignoreUnit(unit)
    for _, ignoreID in ipairs(cLists.ignoreUnits) do
        if game_api.unitNpcID(unit) == ignoreID then
            return true
        end
    end
    return false
end

function common_functions.countEnemies()
    local units = game_api.getUnits()
    local count = 0
    for _, enemies in ipairs(units) do
        if game_api.isUnitHostile(enemies, true) and game_api.unitHealth(enemies) > 0 and game_api.unitInCombat(enemies) and common_functions.IsInRange(40, enemies) then
            count = count + 1
        end
    end
    return count
end

function common_functions.getEnemyUnits()
    local units = game_api.getUnits()
    local enemies = {}

    for _, enemy in ipairs(units) do
        if game_api.isUnitHostile(enemy, true) and game_api.unitHealth(enemy) > 0 and game_api.unitInCombat(enemy) and common_functions.IsInRange(40, enemy) then
            table.insert(enemies, enemy)
        end
    end

    return enemies
end

function common_functions.getCombatUnits()
    local units = game_api.getHostileUnits()
    local combatUnits = {}
    local insert = table.insert

    for _, unit in ipairs(units) do
        if game_api.unitHealthPercent(unit) > 0 and not common_functions.ignoreUnit(unit) and not common_functions.hasImmunity(unit) and
            game_api.isFacing(unit) and game_api.unitInCombat(unit) then
            insert(combatUnits, unit)
        end
    end

    return combatUnits
end

function common_functions.countUnitsAboveHealthThreshold(threshold)
    local count = 0

    for _, unit in ipairs(party) do
        if game_api.unitHealthPercent(unit) > threshold and common_functions.IsInRange(40, unit) then
            count = count + 1
        end
    end

    return count
end

function common_functions.LowestUnitWithAura(spellIDs)
    local lowestUnitWithAura = nil
    local lowestHealthPercent = 101
    local party = common_functions.getParty()
    for _, unit in ipairs(party) do
        for _, id in ipairs(spellIDs) do
            if (game_api.unitHasAura(unit, id, true) and game_api.distanceToUnit(unit) < 40 and (game_api.unitHealthPercent(unit) < lowestHealthPercent) and game_api.unitHealthPercent(unit) > 0) then
                lowestUnitWithAura = unit
                break
            end
        end
    end
    return lowestUnitWithAura
end

function common_functions.LowestUnitNotTank()
    local LowestUnitNotTank = nil
    local lowestHealthPercent = 101
    local party = common_functions.getParty()
    for _, unit in ipairs(party) do
        if (game_api.unitHealthPercent(unit) < lowestHealthPercent) and game_api.unitHealthPercent(unit) > 0 and not game_api.unitIsRole(unit, "TANK") then
            LowestUnitNotTank = unit
            break
        end
    end
end

-- Calculates the Time to Die for the current target
local combatStartTime = nil
local isInCombat = false
local lastTarget = nil
function common_functions.timeToDie()
    local targetHealthMax = game_api.unitMaxHealth(state.currentTarget)
    local targetHealthCurrent = game_api.unitHealth(state.currentTarget)
    local currentTarget = game_api.getCurrentUnitTarget()
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
        local timeToDie = (targetHealthCurrent / healthLost) * elapsedTime / 1000

        return timeToDie -- return when they die
    else
        combatStartTime = nil
        isInCombat = false
        lastTarget = nil
        return 0
    end
end

local combatStartTimes = {}
function common_functions.timeToDieGroup()
    local units = game_api.getHostileUnits()
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
        if common_functions.isInCombatOrHasNpcId(unit, cLists.npcIdList) and common_functions.IsInRange(40, unit) and game_api.unitHealth(unit) > 0 and game_api.unitNpcID(unit) ~= 174773 then
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

function common_functions.replaceSpell(target, auraID)
    local valid = true
    if auraID ~= nil then
        if game_api.unitHasAura(target, auraID, true) then
            local globalTime = game_api.unitAuraEndTime(target, auraID, true) -
                game_api.unitAuraStartTime(target, auraID, true)
            local remainingTime = game_api.unitAuraRemainingTime(target, auraID, true)
            local remainingTimePercentage = ((remainingTime * 100) / globalTime)
            valid = remainingTimePercentage < 80
        end
    end
    return valid
end

function common_functions.useRacial(aura)
    state.knownRacialSpell = nil
    if game_api.spellIsKnown(20572) then      --orc
        state.knownRacialSpell = 20572
    elseif game_api.spellIsKnown(26297) then  --troll
        state.knownRacialSpell = 26297
    elseif game_api.spellIsKnown(274738) then --other orc
        state.knownRacialSpell = 274738
    end
    if game_api.canCast(state.knownRacialSpell) then
        if game_api.currentPlayerHasAura(aura, true) or game_api.currentPlayerHasAura(10060, false) or game_api.currentPlayerHasAura(2825, false) or game_api.currentPlayerHasAura(32182, false) then
            print("Casting Racial")
            game_api.castSpell(state.knownRacialSpell)
        end
    end
end

function common_functions.timeToDieUnit(unit)
    local targetHealthMax = game_api.unitMaxHealth(unit)
    local targetHealthCurrent = game_api.unitHealth(unit)
    local currentTarget = game_api.getCurrentUnitTarget()

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

function common_functions.ProactiveLogic(List)
    local enemyUnits = game_api.getUnits()
    for _, enemy in ipairs(enemyUnits) do -- Some way to loop enemies
        for _, id in ipairs(List) do
            if game_api.unitCastingSpellID(enemy) == id then
                return true
            end
        end
    end
end

function common_functions.ProactiveLogicTable(List)
    local enemyUnits = game_api.getUnits()
    for _, enemy in ipairs(enemyUnits) do -- Some way to loop enemies
        for _, id in pairs(List) do
            if game_api.unitCastingSpellID(enemy) == id then
                return true
            end
        end
    end
end

function common_functions.BoSUnit(range)
    local lowestHealth = 101     -- Initialize to a value higher than the maximum possible health percentage
    local lowestHealthUnit = nil -- Initialize to nil

    local function unitHasAnyAura(unit, ids)
        for id, _ in pairs(ids) do
            if game_api.unitHasAura(unit, id, false) then
                return true
            end
        end
        return false
    end

    for _, playerPartyUnit in ipairs(party) do
        if common_functions.IsInRange(range, playerPartyUnit) and not unitHasAnyAura(playerPartyUnit, cLists.Personals) and game_api.unitHealthPercent(playerPartyUnit) > 0 and ((common_functions.ProactiveLogicTable(cLists.aoeIncoming)) or (game_api.unitIsRole(playerPartyUnit, "TANK") and common_functions.ProactiveLogicTable(cLists.tankBustersCombined)
                and ((game_api.unitHealthPercent(playerPartyUnit) <= 55 and not unitHasAnyAura(playerPartyUnit, cLists.TankDefs)) or game_api.unitHealthPercent(playerPartyUnit) <= 20))) then
            local unitHealth = game_api.unitHealthPercent(playerPartyUnit)
            if unitHealth > 0 and unitHealth < lowestHealth then
                lowestHealth = unitHealth
                lowestHealthUnit = playerPartyUnit
            end
        end
    end

    return lowestHealthUnit
end

function common_functions.BoSUnitTank(range)
    local lowestHealth = 101 -- Initialize to a value higher than the maximum possible health percentage
    local lowestHealthUnit = nil -- Initialize to nil

    local function unitHasAnyAura(unit, ids)
        for id, _ in pairs(ids) do
            if game_api.unitHasAura(unit, id, false) then
                return true
            end
        end
        return false
    end

    for _, playerPartyUnit in ipairs(party) do
        if functions.IsInRange(range, playerPartyUnit) and (not unitHasAnyAura(playerPartyUnit, cLists.Personals) or game_api.unitHealthPercent(playerPartyUnit) <= 40) and game_api.unitHealthPercent(playerPartyUnit) > 0 and (functions.ProactiveLogicTable(cLists.aoeIncoming))then
            local unitHealth = game_api.unitHealthPercent(playerPartyUnit)
            if unitHealth > 0 and unitHealth < lowestHealth then
                lowestHealth = unitHealth
                lowestHealthUnit = playerPartyUnit
            end
        end
    end
    return lowestHealthUnit
end

function common_functions.isInCombatOrHasNpcId(unit, npcIdList)
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

function common_functions.ironBarkUnit(range)
    local lowestHealth = 101     -- Initialize to a value higher than the maximum possible health percentage
    local lowestHealthUnit = nil -- Initialize to nil
    local function unitHasAnyAura(unit, ids)
        for id, _ in pairs(ids) do
            if game_api.unitHasAura(unit, id, false) then
                return true
            end
        end
        return false
    end

    for _, playerPartyUnit in ipairs(party) do
        if common_functions.IsInRange(range, playerPartyUnit) and not unitHasAnyAura(playerPartyUnit, cLists.Personals) and game_api.unitHealthPercent(playerPartyUnit) > 0 and ((common_functions.ProactiveLogicTable(cLists.aoeIncoming)) or (game_api.unitIsRole(playerPartyUnit, "TANK") and common_functions.ProactiveLogicTable(cLists.tankBustersCombined)
                and ((game_api.unitHealthPercent(playerPartyUnit) <= 65 and not unitHasAnyAura(playerPartyUnit, cLists.TankDefs)) or game_api.unitHealthPercent(playerPartyUnit) <= 40))) then
            local unitHealth = game_api.unitHealthPercent(playerPartyUnit)
            if unitHealth > 0 and unitHealth < lowestHealth then
                lowestHealth = unitHealth
                lowestHealthUnit = playerPartyUnit
            end
        end
    end
    return lowestHealthUnit
end

function common_functions.PlayerHasBuff(spell)
    return game_api.currentPlayerHasAura(spell, true)
end

-- HEAVILY NOT DONE YET! BUT A START OF COMMON RACIAL FUNCTION
-- You are free to help contribute to this also ;)

-- Settings lines:
-- settings.useRacials = "Use racilas"
-- settings.useRacialsText = "Decide if you would like to use racials or not"
-- settings.racialsMode = "Racials mode"
-- settings.racialsModeText = "Decide which racial to use"

-- game_api.createSetting(useRacials, useRacialsText, true, {})
-- game_api.createSetting(settings.racialsName, settings.racialsNameText, "none", { "none", "Fireblood", "Blood fury", "Gift of the Naaru", "Berserking", "Stoneform", "Ancestral call", "Will to survive", "Escape artist", "War stomp"})
-- game_api.createSetting(settings.racialsClass, settings.racialsClassText, "none", { "none", "Warrior", "Hunter", "Rogue", "Deathknight", "Priest", "Mage", "Warlock", "Shaman", "Monk", "Demon Hunter", "Paladin", "Druid"})
function common_functions.useRacialCommon()
    local racialName = game_api.getSetting(settings.racialsName)
    local racialClass = game_api.getSetting(settings.racialsClass)

    if racialName == "none" or racialClass == "none" then
        print("No racial selected or class selected, please select a racial and class in the settings.")
        return false
    end

    -- No idea if these IDs are correct, just took em off wowhead, but there are several versions for many of them, lol.
    local racialIDs = {
        Fireblood = 265221, -- All classes
        ["Blood fury"] = {
            [20572] = "Warrior, Hunter, Rogue, Deathknight",
            [33702] = "Priest, Mage, Warlock",
            [33697] = "Shaman, Monk"
        },
        Berserking = 26297, -- All classes
        Stoneform = 20594,
        ["Ancestral call"] = 274738,
        ["Will to survive"] = 59752, -- All classes
        ["Escape artist"] = 20589,   -- All classes
        ["War stomp"] = 20549,
        ["Arcane Torrent"] = {
            [28730] = "Mage, Warlock",
            [202719] = "Demon Hunter",
            [129597] = "Monk",
            [155145] = "Paladin",
            [25046] = "Rogue",
            [80483] = "Hunter",
            [232633] = "Priest",
            [50613] = "Deathknight",
            [69179] = "Warrior"
        },
        ["Will of the Forsaken"] = 7744, -- All classes
        Shadowmeld = 58984               -- All classes
    }
    local racialID
    -- Check if the racial ability is class-specific
    if type(racialIDs[racialName]) == "table" then
        -- It's class-specific, find the ID for the given class
        racialID = racialIDs[racialName][racialClass]
        if not racialID then
            print("Racial ability not available for class: " .. racialClass)
            return false
        end
    else
        -- It's not class-specific, use the ID directly
        racialID = racialIDs[racialName]
    end

    local racialLogic = {
        Fireblood = function()
            if common_functions.CanCast(racialID) and common_functions.UnitHasAnyAura(game_api.getCurrentPlayer(), common_functions.getCombinedList) then
                print("Using Fireblood to remove debuff(s)")
                game_api.castSpell(racialID)
            end
        end,
        ["Blood fury"] = function()
            if common_functions.CanCast(racialID) and common_functions.UnitHasAnyAura(game_api.getCurrentPlayer(), cLists.LocalPlayerCDs) then
                print("Using Blood fury")
                game_api.castSpell(racialID)
            end
        end,
        ["Gift of the Naaru"] = function()
            if common_functions.CanCast(racialID) then
                local UnitLowest = common_functions.UnitWithLowestEffectiveHealth(40)
                local UnitLowestLife = UnitLowest ~= nil and common_functions.UnitHealthPercentWeighted(UnitLowest) or
                    100

                if UnitLowestLife < 50 then
                    print("Using Gift of the Naaru")
                    game_api.castSpellOnPartyMember(racialID, UnitLowest)
                end
            end
        end,
        Berserking = function()
            if common_functions.CanCast(racialID) and common_functions.UnitHasAnyAura(game_api.getCurrentPlayer(), cLists.LocalPlayerCDs) then
                print("Using Berserking")
                game_api.castSpell(racialID)
            end
        end,
        Stoneform = function()
            if common_functions.CanCast(racialID) and common_functions.UnitHasAnyAura(game_api.getCurrentPlayer(), common_functions.getCombinedList) then
                print("Using Stoneform to remove debuff(s)")
                game_api.castSpell(racialID)
            end
        end,
        ["Ancestral call"] = function()
            if common_functions.CanCast(racialID) and common_functions.UnitHasAnyAura(game_api.getCurrentPlayer(), cLists.LocalPlayerCDs) then
                print("Using Ancestral call")
                game_api.castSpell(racialID)
            end
        end,
        ["Will to survive"] = function()
            if common_functions.CanCast(racialID) and common_functions.UnitHasAnyAura(game_api.getCurrentPlayer(), cLists.FreedomList) then
                print("Using Will to survive")
                game_api.castSpell(racialID)
            end
        end,
        ["Escape artist"] = function()
            if common_functions.CanCast(racialID) and common_functions.UnitHasAnyAura(game_api.getCurrentPlayer(), cLists.FreedomList) then
                print("Using Escape artist")
                game_api.castSpell(racialID)
            end
        end,
        ["War stomp"] = function()
            local units = game_api.getCombatUnits()
            local count = 0

            -- First, count how many units that are casting/channeling and are hostile and in combat
            for _, unit in ipairs(units) do
                if API.IsInRange(8, unit) and game_api.isUnitHostile(unit, true) and game_api.unitHealthPercent(unit) > 0 and common_functions.isInCombatOrHasNpcId(unit, cLists.npcIdList) and (game_api.unitIsCasting(unit) or game_api.unitIsChanneling(unit)) then
                    count = count + 1
                end
            end

            if count >= 2 and common_functions.CanCast(racialID) then
                print("Using War stomp")
                game_api.castSpell(racialID)
            end
        end
    }

    if racialID then
        local logicFunction = racialLogic[racialName]
        if logicFunction then
            logicFunction() -- Execute the racial logic
            return true
        else
            print("Unknown racial name: " .. racialName)
            return false
        end
    else
        print("Unknown or unavailable racial ability for class: ", racialClass)
    end
    return false
end

return common_functions
