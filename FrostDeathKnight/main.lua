game_api = require("lib")
spells = require("spells")
talents = require("talents")
auras = require("auras")
settings = require("settings")
API = require("common_functions")
cLists = require("common_lists")
state = {}

--[[
    Create your variable and toggle here
]]
function OnInit()
    settings.createSettings()
    print("Frost DK - Beta")
end

local BloodlustExhaustSpells = {57724, 57723, 80354, 264689, 390435}
local BloodlustAuras = {2825, -- Shaman: Bloodlust (Horde)
32182, -- Shaman: Heroism (Alliance)
80353, -- Mage: Time Warp
90355, -- Hunter: Ancient Hysteria
160452, -- Hunter: Netherwinds
264667, -- Hunter: Primal Rage
390386, -- Evoker: Fury of the Aspects
-- Drums
35475, -- Drums of War (Cata)
35476, -- Drums of Battle (Cata)
146555, -- Drums of Rage (MoP)
178207, -- Drums of Fury (WoD)
230935, -- Drums of the Mountain (Legion)
256740, -- Drums of the Maelstrom (BfA)
309658, -- Drums of Deathly Ferocity (SL)
381301 -- Feral Hide Drums (DF)
}
function PlayerHasAnyAuraUp(spellIDs)
    for _, id in ipairs(spellIDs) do
        if game_api.currentPlayerHasAura(id, false) then
            return true
        end
    end
    return false
end

function getCombatUnitsCount()
    local units = game_api.getHostileUnits()
    local combatUnits = {}
    local insert = table.insert

    for _, unit in ipairs(units) do
        if game_api.distanceBetweenUnits(state.currentTarget, unit) <= 10 and game_api.unitHealthPercent(unit) > 0 and
            API.isInCombatOrHasNpcId(unit, cLists.npcIdList) and not API.ignoreUnit(unit) and not API.hasImmunity(unit) then
            insert(combatUnits, unit)
        end
    end
    local numberOfUnits = #combatUnits
    return numberOfUnits
end

function getCombatUnits()
    local units = game_api.getHostileUnits()
    local combatUnits = {}
    local insert = table.insert
    for _, unit in ipairs(units) do
        if API.isInCombatOrHasNpcId(unit, cLists.npcIdList) and game_api.unitHealthPercent(unit) > 0 and
            game_api.distanceToUnit(unit) < 10 and game_api.isFacing(unit) and not API.ignoreUnit(unit) and
            not API.hasImmunity(unit) then
            insert(combatUnits, unit)
        end
    end
    return combatUnits
end

function UnitWithAura(units, range, auras)
    local lowestHealthUnit = nil
    local lowestHealthPercent = 101 -- Start higher than 100% to ensure the first unit below 100% health is caught

    for _, unit in ipairs(units) do
        local unitHealthPercent = game_api.unitHealthPercent(unit)
        if unitHealthPercent > 0 then
            for _, auraID in ipairs(auras) do
                if game_api.unitHasAura(unit, auraID, true) then
                    if unitHealthPercent < lowestHealthPercent then
                        lowestHealthPercent = unitHealthPercent
                        lowestHealthUnit = unit
                        break -- Found an aura on the unit, no need to check further auras
                    end
                end
            end
        end
    end

    return lowestHealthUnit
end

function Interrupt()
    if not game_api.getToggle(settings.Kick) then
        return false
    end

    for _, unit in ipairs(state.getUnits) do
        if game_api.isUnitHostile(unit, true) then
            if game_api.unitIsCasting(unit) and not game_api.unitIsChanneling(unit) then
                unitCasting = true
                castPercentage = game_api.unitCastPercentage(unit)
            end
            if game_api.unitIsChanneling(unit) then
                unitCasting = true
                castPercentage = game_api.unitChannelPercentage(unit)
            end

            local spellId = game_api.unitCastingSpellID(unit)
            local channelId = game_api.unitChannelingSpellID(unit)

            if unitCasting then
                local isStun = cLists.priorityStunList[spellId] or cLists.priorityStunList[channelId]
                local isKick = cLists.priorityKickList[spellId] or cLists.priorityKickList[channelId]

                if isKick and API.CanCast(spells.MindFreeze) and game_api.distanceToUnit(unit) <= 15 and
                    game_api.isFacing(unit) and castPercentage >= math.random(25, 75) then
                    API.Debug(
                        "Casting Mind Freeze on " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") ..
                            " Unit")
                    game_api.castSpellOnTarget(spells.MindFreeze, unit)
                    return true
                end
            end
        end
    end
    return false
end



function UnitWithHighestHealth()
    local highestHealthUnit = nil
    local highestEffectiveHealth = 0 -- Initialize with 0 for comparison
    for _, unit in ipairs(state.getUnits) do
        if game_api.isFacing(unit) and game_api.distanceToUnit(unit) <= 40 and game_api.isUnitHostile(unit, true) and
            API.isInCombatOrHasNpcId(unit, cLists.npcIdList) then
            local effectiveHealth = game_api.unitHealthPercent(unit)
            if effectiveHealth > highestEffectiveHealth then
                highestEffectiveHealth = effectiveHealth
                highestHealthUnit = unit
            end
        end
        if highestHealthUnit ~= nil then
            return highestHealthUnit
        end
    end
end

local AutoAoE, FrostStrikeLogic, BreathofSindragosaLogic, SoulReaperLogic, ObliterateLogic, HowlingBlastLogic,
    ObliterateLogic2, HornofWinterLogic, FrostStrikeLogicActiveBreathCheck
local STSetup, AddsLeft, RimeBuffs, RPBuffs, CDCheck, FrostscythePriority, ObliteratePooling, BreathPooling, PoolRunes,
    PoolRP, RWSetup

function StateUpdate()
    API.RefreshFunctionsState();

    state.currentTarget = game_api.getCurrentUnitTarget()
    state.currentTargetHpPercent = game_api.unitHealthPercent(state.currentTarget)
    state.currentPlayer = game_api.getCurrentPlayer()
    state.currentHpPercent = game_api.unitHealthPercent(state.currentPlayer)
    state.playerHealth = game_api.unitHealthPercent(state.currentPlayer)
    state.TargetCheck = game_api.unitInCombat(state.currentPlayer) and state.currentTarget ~= 00 and
                            API.isInCombatOrHasNpcId(state.currentTarget, cLists.npcIdList) and
                            (game_api.currentPlayerDistanceFromTarget() <= 6 or game_api.unitNpcID(state.currentTarget) ==
                                44566) and game_api.isFacing(state.currentTarget) and game_api.isTargetHostile(true) and
                            game_api.unitHealthPercent(state.currentTarget) > 0
    state.getUnits = game_api.getUnits()
    state.PlayerIsInCombat = game_api.unitInCombat(state.currentPlayer)
    state.HostileUnits = getCombatUnits()
    state.HostileUnitCount = getCombatUnitsCount()
    state.afflictedUnits = game_api.getUnitsByNpcId(204773)
    state.incorporealUnits = game_api.getUnitsByNpcId(204560)
    state.CurrentCastID = game_api.unitCastingSpellID(state.currentPlayer)
    state.CurrentRunicPower = game_api.getPower(1) / 10
    state.RunicPowerMax = game_api.getMaxPower(1) / 10
    state.RunicPowerDeficit = state.RunicPowerMax - state.CurrentRunicPower
    state.CurrentRunesAvailable = game_api.getRuneCount()
    state.currentTime = game_api.currentTime()
    state.Pets = game_api.getUnitsByNpcId(26125)
    state.HasTwoHander = game_api.isTwoHandWeapon()
    if game_api.hasTalentEntry(96178) or game_api.hasTalentEntry(96229) then
        state.EmpowerRuneWeaponCharges = 1
    end
    if game_api.hasTalentEntry(96178) and game_api.hasTalentEntry(96229) then
        state.EmpowerRuneWeaponCharges = 2
    end

    state.HasEmpowerTalented = game_api.hasTalentEntry(talents.EmpowerRuneWeaponClassEntryID) or
                                   game_api.hasTalentEntry(talents.EmpowerRuneWeaponSpecEntryID)

    state.ColdheartBuffStacks = game_api.unitAuraStackCount(state.currentPlayer, auras.ColdHeartBuff, true)
    state.OverallProactiveLogic = ProactiveLogic()
    state.MagicalProactive = API.ProactiveLogic(cLists.aoeIncomingWarriorMagic)

    AutoAoE = game_api.getToggle(settings.AoE) and state.HostileUnitCount >= 2
    FrostStrikeLogic = API.PlayerHasBuff(auras.IcyTalonsBuff) and API.PlayerHasBuff(auras.UnleashedFrenzy) and
                           game_api.currentPlayerAuraRemainingTime(auras.IcyTalonsBuff, true) <= 1250 and
                           game_api.currentPlayerAuraRemainingTime(auras.UnleashedFrenzy, true) <= 1250
    BreathofSindragosaLogic = state.CurrentRunicPower >= 60
    SoulReaperLogic = (TimeToReachHealth(35) < 5 or state.currentTargetHpPercent < 35) and state.CurrentRunesAvailable >
                          0
    ObliterateLogic = API.PlayerHasBuff(auras.KillingMachineBuff) or API.PlayerHasBuff(auras.PillarofFrostBuff)
    HowlingBlastLogic = API.PlayerHasBuff(auras.RimeBuff) and state.CurrentRunicPower > 39
    ObliterateLogic2 = state.CurrentRunicPower <= 100
    HornofWinterLogic = state.CurrentRunicPower <= 95
    FrostStrikeLogicActiveBreathCheck = API.PlayerHasBuff(auras.BreathofSindragosa)
    -- SimC Vars
    STSetup = state.HostileUnitCount == 1 or not AutoAoE
    AddsLeft = state.HostileUnitCount >= 2 and AutoAoE
    RimeBuffs = (API.PlayerHasBuff(auras.RimeBuff) and
                    (game_api.hasTalentEntry(talents.RageOfTheFrozenChampionEntryID) or
                        game_api.hasTalentEntry(talents.Avalanche) or game_api.hasTalentEntry(talents.IcebreakerEntryID)))
    RPBuffs = (game_api.hasTalentEntry(talents.UnleashedFrenzyEntryID) and
                  (game_api.unitAuraRemainingTime(state.currentPlayer, auras.UnleashedFrenzy, true) < 5500 or
                      game_api.unitAuraStackCount(state.currentPlayer, auras.UnleashedFrenzy, true) < 3 or
                      (game_api.hasTalentEntry(talents.IcyTalonsEntryID) and
                          (game_api.unitAuraRemainingTime(state.currentPlayer, auras.IcyTalonsBuff, true) < 5500 or
                              game_api.unitAuraStackCount(state.currentPlayer, auras.IcyTalonsBuff, true) < 3))))
    CDCheck = (game_api.hasTalentEntry(talents.PillarofFrostEntryID) and API.PlayerHasBuff(auras.PillarofFrostBuff) and
                  (game_api.hasTalentEntry(talents.ObliterationEntryID) and
                      game_api.unitAuraRemainingTime(state.currentPlayer, auras.PillarofFrostBuff, true) > 10000 or
                      not game_api.hasTalentEntry(talents.ObliterationEntryID)) or
                  not game_api.hasTalentEntry(talents.PillarofFrostEntryID) and
                  API.PlayerHasBuff(auras.EmpowerRuneWeaponBuff) or
                  not game_api.hasTalentEntry(talents.PillarofFrostEntryID) and not state.HasEmpowerTalented or
                  state.HostileUnitCount >= 2 and API.PlayerHasBuff(auras.PillarofFrostBuff))
    FrostscythePriority = (game_api.hasTalentEntry(talents.FrostscytheEntryID) and
                              (API.PlayerHasBuff(auras.KillingMachineBuff) or state.HostileUnitCount >= 3) and
                              (not game_api.hasTalentEntry(talents.ImprovedObliterateEntryID) or
                                  not game_api.hasTalentEntry(talents.CleavingStrikeEntryID) or
                                  game_api.hasTalentEntry(talents.CleavingStrikeEntryID) and
                                  (state.HostileUnitCount > 8 or not API.PlayerHasBuff(auras.DeathAndDecayBuff) and
                                      state.HostileUnitCount > 4)))

    if state.CurrentRunicPower < 35 and state.CurrentRunesAvailable < 2 and
        game_api.getCooldownRemainingTime(spells.PillarofFrost) < 10000 then
        ObliteratePooling = (((game_api.getCooldownRemainingTime(spells.PillarofFrost) + 1000) / 1400) /
                                ((state.CurrentRunesAvailable + 3) * (state.CurrentRunicPower + 5)) * 100)
    else
        ObliteratePooling = 3000
    end
    if state.RunicPowerDeficit > 10 and game_api.getCooldownRemainingTime(spells.BreathofSindragosa) < 10000 then
        BreathPooling = (((game_api.getCooldownRemainingTime(spells.BreathofSindragosa) + 1000) / 1400) /
                            ((state.CurrentRunesAvailable + 1) * (state.CurrentRunicPower + 20)) * 100)
    else
        BreathPooling = 3000
    end
    PoolRunes = (state.CurrentRunesAvailable < 4 and game_api.hasTalentEntry(talents.Obliteration) and
                    game_api.getCooldownRemainingTime(spells.PillarofFrost) < ObliteratePooling)
    PoolRP = (game_api.hasTalent(talents.BreathofSindragosa) and
                 game_api.getCooldownRemainingTime(spells.BreathofSindragosa) < BreathPooling or
                 game_api.hasTalentEntry(talents.ObliterationEntryID) and state.CurrentRunicPower < 35 and
                 game_api.getCooldownRemainingTime(spells.PillarofFrost) < ObliteratePooling)
    RWSetup = game_api.hasTalentEntry(talents.EverFrostEntryID) or
                  game_api.hasTalentEntry(talents.GatheringStormEntryID)
                  


end

function ProactiveLogic()
    for _, unit in ipairs(state.getUnits) do
        if game_api.isUnitHostile(unit, true) then
            if game_api.unitIsCasting(unit) and not game_api.unitIsChanneling(unit) then
                unitCasting = true
                castPercentage =game_api.unitCastPercentage(unit)
            end
            if game_api.unitIsChanneling(unit) then
                unitCasting = true
                castPercentage =game_api.unitChannelPercentage(unit)
            end
            local spellId = game_api.unitCastingSpellID(unit) 
            local channelId = game_api.unitChannelingSpellID(unit)
            if unitCasting then
                local IsCastingAoE = cLists.aoeIncoming[spellId] or cLists.aoeIncoming[channelId] 

                if IsCastingAoE and game_api.distanceToUnit(unit) <= 40 then
                    return true
                end
            end
        end
    end
    return false
end

function TargetHasAura(aura)
    return game_api.unitHasAura(state.currentTarget, aura, true)
end

function Defense()
    if state.TargetCheck then
        if API.CanCast(spells.DeathStrike) and state.CurrentRunicPower >= 35 and state.currentHpPercent <= game_api.getSetting(settings.DeathStrike) then
            game_api.castSpell(spells.DeathStrike)
            API.Debug("Deathstrike at Setting")
            return true
        end
    end
    if state.OverallProactiveLogic and (not state.MagicalProactive or game_api.isOnCooldown(spells.AntiMagicShell) and not API.PlayerHasBuff(auras.AntiMagicShell)) then
        if API.CanCast(spells.IceboundFortitude) and not API.PlayerHasBuff(auras.IceboundFortitudeBuff) then
            game_api.castSpell(spells.IceboundFortitude)
            API.Debug("Ice Bound Fortitude Casted for Proactive")
            return true
        end
        if game_api.isOnCooldown(spells.IceboundFortitude) and game_api.hasTalentEntry(talents.UnholyEnduranceEntryID) and API.CanCast(spells.Lichborne) and not API.PlayerHasBuff(auras.IceboundFortitudeBuff) then
            game_api.castSpell(spells.Lichborne)
            API.Debug("Lichborne Casted for Proactive - Has DR Talent")
            return true
        end
    end
    if state.MagicalProactive then
        if API.CanCast(spells.AntiMagicShell) then
            game_api.castSpell(spells.AntiMagicShell)
            API.Debug("Anti Magic Shell casted for Proactive")
            return true
        end
        if ((game_api.isOnCooldown(spells.AntiMagicShell) and not API.PlayerHasBuff(auras.AntiMagicShell)) or API.IsInRaid()) then
            if API.CanCast(spells.AnitMagicZone) and not game_api.currentPlayerIsMoving() then
                game_api.castAOESpellOnSelf(spells.AnitMagicZone)
                API.Debug("Anti Magic Zone Casted - Proactive")
                return true
            end
        end
    end
    if API.CanCast(spells.IceboundFortitude) and not API.PlayerHasBuff(auras.IceboundFortitudeBuff) then
        if state.currentHpPercent <= game_api.getSetting(settings.IceboundFort) then
            game_api.castSpell(spells.IceboundFortitude)
            API.Debug("Ice Bound Fortitude Casted for Setting")
            return true
        end
    end
    if game_api.isOnCooldown(spells.IceboundFortitude) and game_api.hasTalentEntry(talents.UnholyEnduranceEntryID) and API.CanCast(spells.Lichborne) and not API.PlayerHasBuff(auras.IceboundFortitudeBuff) then
        if state.currentHpPercent <= game_api.getSetting(settings.LichBorne) then
            game_api.castSpell(spells.Lichborne)
            API.Debug("Lichborne Casted for Setting")
            return true
        end
    end
end
function PlayerAuraRemains(aura)
    return game_api.unitAuraRemainingTime(state.currentPlayer, aura, true)
end

function PlayerAuraStacks(aura)
    return game_api.unitAuraStackCount(state.currentPlayer, aura, true)
end

local combatStartTime = nil
local isInCombat = nil
local lastTarget = nil

function TimeToReachHealth(targetHealthThreshold)
    local targetHealthMax = game_api.unitMaxHealth(state.currentTarget)
    local targetHealthCurrent = game_api.unitHealth(state.currentTarget)
    local currentTarget = game_api.getCurrentUnitTarget()

    -- Check if the target has changed and update combat start time if necessary
    if lastTarget ~= currentTarget then
        combatStartTime = game_api.currentTime()
        isInCombat = true
        lastTarget = currentTarget
    end

    -- If the target is still alive
    if targetHealthCurrent > 0 then
        local currentTime = game_api.currentTime()

        -- If not in combat, consider combat starting now
        if not isInCombat then
            combatStartTime = currentTime
            isInCombat = true
        end

        -- Calculate time to reach health threshold
        local elapsedTime = currentTime - combatStartTime
        if elapsedTime == 0 then
            return math.huge -- To indicate that it's currently impossible to determine the time
        end
        local healthLost = targetHealthMax - targetHealthCurrent
        if healthLost <= 0 then
            return math.huge -- Health is not being lost, or target is healing
        end
        local healthLostRate = healthLost / elapsedTime
        local healthToLose = targetHealthThreshold - targetHealthCurrent
        local timeToReachHealth = healthToLose / healthLostRate

        return timeToReachHealth
    else
        -- Reset when the target is dead
        combatStartTime = nil
        isInCombat = false
        lastTarget = nil
        return 0
    end
end
local combatStartTime = 0

function isInCombatForLessThan10Seconds()
    local inCombat = game_api.unitInCombat(state.currentPlayer)
    local currentTime = state.currentTime -- Current time in milliseconds

    if inCombat then
        if combatStartTime == 0 then
            -- Combat just started
            combatStartTime = currentTime
            return true
        else
            -- Check if combat has been going on for less than 4000 milliseconds (4 seconds)
            return (currentTime - combatStartTime) < 8000
        end
    elseif not API.isUnitDummy(state.currentTarget) then
        combatStartTime = 0
        return false
    end
end

function hasPet()
    local Pets = state.Pets
    for _, Pet in pairs(Pets) do
        if game_api.unitOwner(Pet) == state.currentPlayer and game_api.distanceToUnit(Pet) <= 40 then
            if game_api.unitHealthPercent(Pet) > 0 then
                return true
            end
        end
    end
    return false
end

-- actions+=/call_action_list,name=high_prio_actions
function HighPriorityActionsSimC()
    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        (not TargetHasAura(auras.FrostFeverDebuff) and state.HostileUnitCount >= 2 and
            ((not game_api.hasTalentEntry(talents.ObliterationEntryID) or
                game_api.hasTalentEntry(talents.ObliterationEntryID) and
                (game_api.isOnCooldown(spells.PillarofFrost) or API.PlayerHasBuff(auras.PillarofFrostBuff) and
                    not API.PlayerHasBuff(auras.KillingMachineBuff))))) then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - High Priority Action - SimC")
        return true
    end
    if API.CanCast(spells.GlacialAdvance) and state.CurrentRunicPower >= 30 and
        (state.HostileUnitCount >= 2 and RPBuffs and game_api.hasTalentEntry(talents.ObliterationEntryID) and
            game_api.hasTalent(talents.BreathofSindragosa) and not API.PlayerHasBuff(auras.PillarofFrostBuff) and
            not API.PlayerHasBuff(auras.BreathofSindragosa) and
            game_api.getCooldownRemainingTime(spells.BreathofSindragosa) > BreathPooling) then
        game_api.castSpell(spells.GlacialAdvance)
        API.Debug('Glacial Advance - Hight Priority Action - SimC')
        return true
    end
    if API.CanCast(spells.GlacialAdvance) and state.CurrentRunicPower >= 30 and
        (state.HostileUnitCount >= 2 and RPBuffs and game_api.hasTalent(talents.BreathofSindragosa) and
            not API.PlayerHasBuff(auras.BreathofSindragosa) and
            game_api.getCooldownRemainingTime(spells.BreathofSindragosa) > BreathPooling) then
        game_api.castSpell(spells.GlacialAdvance)
        API.Debug('Glacial Advance - Hight Priority Action - SimC #2')
        return true
    end
    if API.CanCast(spells.GlacialAdvance) and state.CurrentRunicPower >= 30 and
        (state.HostileUnitCount >= 2 and RPBuffs and not game_api.hasTalent(talents.BreathofSindragosa) and
            game_api.hasTalentEntry(talents.ObliterationEntryID) and not API.PlayerHasBuff(auras.PillarofFrostBuff)) then
        game_api.castSpell(spells.GlacialAdvance)
        API.Debug('Glacial Advance - Hight Priority Action - SimC #3')
        return true
    end
    if state.CurrentRunicPower >= 30 then
        if API.CanCast(spells.FrostStrike) and
            (state.HostileUnitCount == 1 and RPBuffs and game_api.hasTalentEntry(talents.ObliterationEntryID) and
                game_api.hasTalent(talents.BreathofSindragosa) and not API.PlayerHasBuff(auras.PillarofFrostBuff) and
                not API.PlayerHasBuff(auras.BreathofSindragosa) and
                game_api.getCooldownRemainingTime(spells.BreathofSindragosa) > BreathPooling) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("Frost Strike - High Priority Action - SimC #1")
            return true
        end
        if API.CanCast(spells.FrostStrike) and
            (state.HostileUnitCount == 1 and RPBuffs and game_api.hasTalent(talents.BreathofSindragosa) and
                not API.PlayerHasBuff(auras.BreathofSindragosa) and
                game_api.getCooldownRemainingTime(spells.BreathofSindragosa) > BreathPooling) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("Frost Strike - High Priority Action - SimC #2")
            return true
        end
        if API.CanCast(spells.FrostStrike) and
            (state.HostileUnitCount == 1 and RPBuffs and not game_api.hasTalent(talents.BreathofSindragosa) and
                game_api.hasTalentEntry(talents.ObliterationEntryID) and not API.PlayerHasBuff(auras.PillarofFrostBuff)) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("Frost Strike - High Priority Action - SimC #3")
            return true
        end
    end
    if API.CanCast(spells.RemorselessWinter) and (RWSetup or AddsLeft) and state.CurrentRunesAvailable > 0 then
        game_api.castSpell(spells.RemorselessWinter)
        API.Debug("Remoresless Winter - High Priority Action - SimC")
        return true
    end
end
-- actions+=/call_action_list,name=aoe,if=active_enemies>=2
function AoE()
    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        (API.PlayerHasBuff(auras.RimeBuff) or not TargetHasAura(auras.FrostFeverDebuff)) then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - AoE - SimC")
        return true
    end
    if API.CanCast(spells.GlacialAdvance) and state.CurrentRunicPower >= 30 and not PoolRP and RPBuffs then
        game_api.castSpell(spells.GlacialAdvance)
        API.Debug("Glaical Advance - AoE - SimC")
        return true
    end
    -- actions.aoe+=/frostscythe,if=!death_and_decay.ticking&equipped.fyralath_the_dreamrender&(cooldown.rage_of_fyralath_417131.remains<3|!dot.mark_of_fyralath.ticking)
    -- Need to Do this part
    if API.CanCast(spells.Obliterate) and state.CurrentRunesAvailable > 1 and
        API.PlayerHasBuff(auras.KillingMachineBuff) and game_api.hasTalentEntry(talents.CleavingStrikeEntryID) and
        API.PlayerHasBuff(auras.DeathAndDecayBuff) and not FrostscythePriority then
        game_api.castSpell(spells.Obliterate)
        API.Debug("Obliterate - AoE - SimC")
        return true
    end
    if API.CanCast(spells.GlacialAdvance) and state.CurrentRunicPower >= 30 and not PoolRP then
        game_api.castSpell(spells.GlacialAdvance)
        API.Debug("Glaical Advance - AoE - SimC #2")
        return true
    end
    if API.CanCast(spells.Frostscythe) and state.CurrentRunesAvailable > 0 and FrostscythePriority then
        game_api.castSpell(spells.Frostscythe)
        API.Debug("FrostScythe - AoE - SimC")
        return true
    end
    if API.CanCast(spells.Obliterate) and state.CurrentRunesAvailable > 1 and not FrostscythePriority then
        game_api.castSpell(spells.Obliterate)
        API.Debug("Obliterate - AoE - SimC #2")
        return true
    end
    if state.CurrentRunicPower >= 30 and API.CanCast(spells.FrostStrike) and not PoolRP and
        not game_api.hasTalentEntry(talents.GlacialAdvanceEntryID) then
        game_api.castSpell(spells.FrostStrike)
        API.Debug("Frost Strike - AoE - SimC")
        return true
    end
    if API.CanCast(spells.HornofWinter) and state.RunicPowerDeficit > 25 then
        game_api.castSpell(spells.HornofWinter)
        API.Debug("Horn of Winter - AoE - SimC")
        return true
    end

end

-- actions+=/run_action_list,name=breath,if=buff.breath_of_sindragosa.up&(!talent.obliteration|talent.obliteration&!buff.pillar_of_frost.up)
function BreatheActiveRotationSimC()
    -- actions.breath=howling_blast,if=variable.rime_buffs&runic_power>(45-((talent.rage_of_the_frozen_champion*8)+(5*buff.rune_of_hysteria.up)))
    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        API.PlayerHasBuff(auras.RimeBuff) and state.CurrentRunicPower >
        (45 - ((game_api.hasTalentEntry(talents.RageOfTheFrozenChampionEntryID) and 8 or 0) +
            (API.PlayerHasBuff(auras.RuneofHysteriaBuff) and 5 or 0))) then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - Breathe Rotation - SimC")
        return true
    end
    if API.CanCast(spells.HornofWinter) and state.CurrentRunesAvailable < 2 and state.RunicPowerDeficit >
        (25 + (API.PlayerHasBuff(auras.RuneofHysteriaBuff) and 5 or 0)) then
        game_api.castSpell(spells.HornofWinter)
        API.Debug("Horn of Winter - Breathe Rotation - SimC")
        return true
    end
    if API.CanCast(spells.Obliterate) and state.CurrentRunesAvailable > 1 and
        (API.PlayerHasBuff(auras.KillingMachineBuff) and not FrostscythePriority) then
        game_api.castSpell(spells.Obliterate)
        API.Debug("Obliterate - Breathe Rotation - SimC")
        return true
    end
    if API.CanCast(spells.Frostscythe) and state.CurrentRunesAvailable > 0 and FrostscythePriority and
        (API.PlayerHasBuff(auras.KillingMachineBuff) and state.CurrentRunicPower > 45) then
        game_api.castSpell(spells.Frostscythe)
        API.Debug("Frostsycthe - Breathe Rotation - SimC")
    end
    if API.CanCast(spells.Obliterate) and state.CurrentRunesAvailable > 1 and
        (state.RunicPowerDeficit > 40 or API.PlayerHasBuff(auras.PillarofFrostBuff)) then
        game_api.castSpell(spells.Obliterate)
        API.Debug("Obliterate - Breathe Rotation - SimC #2")
        return true
    end
    if API.CanCast(spells.RemorselessWinter) and state.CurrentRunesAvailable > 0 and state.CurrentRunicPower < 36 then
        game_api.castSpell(spells.RemorselessWinter)
        API.Debug("Remorseless Winter - Breathe Rotation - SimC")
        return true
    end
    if game_api.canCastCharge(spells.DeathAndDecay, 2) and state.CurrentRunesAvailable > 0 and
        (STSetup and game_api.hasTalent(talents.UnholyGround) and not API.PlayerHasBuff(auras.DeathAndDecayBuff) and
            state.RunicPowerDeficit >= 10 or state.CurrentRunicPower < 36) then
        game_api.castAOESpellOnSelf(spells.DeathAndDecay)
        API.Debug("Death and Deacy - Breathe Rotation - SimC")
        return true
    end
    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        state.CurrentRunicPower < 36 then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - Breathe Rotation - SimC #2")
        return true
    end
    if API.CanCast(spells.Obliterate) and state.CurrentRunesAvailable > 1 and state.RunicPowerDeficit > 25 then
        game_api.castSpell(spells.Obliterate)
        API.Debug("Obliterate - Breathe Rotation - SimC #3")
        return true
    end
    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        API.PlayerHasBuff(auras.RimeBuff) then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - Breathe Rotation - SimC #2")
        return true
    end

end
-- actions+=/run_action_list,name=breath_oblit,if=buff.breath_of_sindragosa.up&talent.obliteration&buff.pillar_of_frost.up
function BreathandObliterateActiveSimC()

    if API.CanCast(spells.Frostscythe) and state.CurrentRunesAvailable > 0 and FrostscythePriority and
        API.PlayerHasBuff(auras.KillingMachineBuff) then
        game_api.castSpell(spells.Frostscythe)
        API.Debug("Frostsycthe - Breathe and Obliterate Rotation - SimC")
    end
    if API.CanCast(spells.Obliterate) and state.CurrentRunesAvailable > 1 and
        API.PlayerHasBuff(auras.KillingMachineBuff) then
        game_api.castSpell(spells.Obliterate)
        API.Debug("Obliterate - Breathe and Obliterate Rotation - SimC")
    end
    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        API.PlayerHasBuff(auras.RimeBuff) then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - Breathe and Obliterate Rotation - SimC ")
        return true
    end
    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        not API.PlayerHasBuff(auras.KillingMachineBuff) then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - Breathe and Obliterate Rotation - SimC #2")
        return true
    end
    if API.CanCast(spells.HornofWinter) and state.RunicPowerDeficit > 25 then
        game_api.castSpell(spells.HornofWinter)
        API.Debug("Horn of Winter - Breathe and Obliterate Rotation - SimC")
        return true
    end

end

-- actions+=/call_action_list,name=cold_heart,if=talent.cold_heart&(!buff.killing_machine.up|talent.breath_of_sindragosa)&((debuff.razorice.stack=5|!death_knight.runeforge.razorice&!talent.glacial_advance&!talent.avalanche)|fight_remains<=gcd)
function ColdHeartRotation()

    if API.CanCast(spells.ChainsOfIce) and state.CurrentRunesAvailable > 0 then
        -- actions.cold_heart=chains_of_ice,if=fight_remains<gcd&(rune<2|!buff.killing_machine.up&(!variable.2h_check&buff.cold_heart.stack>=4|variable.2h_check&buff.cold_heart.stack>8)|buff.killing_machine.up&(!variable.2h_check&buff.cold_heart.stack>8|variable.2h_check&buff.cold_heart.stack>10))
        if (state.CurrentRunesAvailable < 2 or not API.PlayerHasBuff(auras.KillingMachineBuff) and
            (not state.HasTwoHander and state.ColdheartBuffStacks >= 4 or state.HasTwoHander and
                state.ColdheartBuffStacks > 8) or API.PlayerHasBuff(auras.KillingMachineBuff) and
            (not state.HasTwoHander and state.ColdheartBuffStacks > 8 or state.HasTwoHander and
                state.ColdheartBuffStacks > 10)) then
            game_api.castSpell(spells.ChainsOfIce)
            API.Debug("Chains of Ice - ColdHeart - SimC")
            return true
        end
        -- actions.cold_heart+=/chains_of_ice,if=!talent.obliteration&buff.pillar_of_frost.up&buff.cold_heart.stack>=10&(buff.pillar_of_frost.remains<gcd*(1+(talent.frostwyrms_fury&cooldown.frostwyrms_fury.ready))|buff.unholy_strength.up&buff.unholy_strength.remains<gcd)
        if (not game_api.hasTalentEntry(talents.Obliteration) and API.PlayerHasBuff(auras.PillarofFrostBuff) and
            state.ColdheartBuffStacks >= 10 and
            (game_api.unitAuraRemainingTime(state.currentPlayer, auras.PillarofFrostBuff, true) < 1400 or
                API.PlayerHasBuff(auras.UnholyStrengthBuff) and
                game_api.unitAuraRemainingTime(state.currentPlayer, auras.UnholyStrengthBuff, true) < 1400)) then
            game_api.castSpell(spells.ChainsOfIce)
            API.Debug("Chains of Ice - ColdHeart - SimC #2")
            return true
        end
        if (not game_api.hasTalentEntry(talents.ObliterationEntryID) and not API.PlayerHasBuff(auras.PillarofFrostBuff) and
            game_api.getCooldownRemainingTime(spells.PillarofFrost) > 15000 and
            (state.ColdheartBuffStacks >= 10 and API.PlayerHasBuff(auras.UnholyStrengthBuff) or
                state.ColdheartBuffStacks >= 13)) then
            game_api.castSpell(spells.ChainsOfIce)
            API.Debug("Chains of Ice - ColdHeart - SimC #3")
            return true
        end
        if (game_api.hasTalentEntry(talents.ObliterationEntryID) and not API.PlayerHasBuff(auras.PillarofFrostBuff) and
            (state.ColdheartBuffStacks >= 14 and (API.PlayerHasBuff(auras.UnholyStrengthBuff)) or
                state.ColdheartBuffStacks >= 19 or game_api.getCooldownRemainingTime(spells.PillarofFrost) < 3000 and
                state.ColdheartBuffStacks >= 14)) then
            game_api.castSpell(spells.ChainsOfIce)
            API.Debug("Chains of Ice - ColdHeart - SimC #5")
            return true
        end

    end

    -- chains_of_ice,if=!talent.obliteration&!death_knight.runeforge.fallen_crusader&buff.cold_heart.stack>=10&!buff.pillar_of_frost.up&cooldown.pillar_of_frost.remains_expected>20
end

function Cooldowns()

    if API.useConsume(auras.PillarofFrostBuff, auras.EmpowerRuneWeaponBuff, false) then
        return true
    end

    if game_api.canCastCharge(spells.EmpowerRuneWeapon, state.EmpowerRuneWeaponCharges) then
        if (game_api.hasTalentEntry(talents.ObliterationEntryID) and not API.PlayerHasBuff(auras.EmpowerRuneWeaponBuff) and
            state.CurrentRunesAvailable < 6 and
            ((game_api.getCooldownRemainingTime(spells.PillarofFrost) < 7000 and PlayerHasAnyAuraUp(BloodlustAuras)) or
                ((state.HostileUnitCount >= 2 or STSetup) and not game_api.isOnCooldown(spells.PillarofFrost))) or
            API.timeToDieGroup() >= 20) then
            game_api.castSpell(spells.EmpowerRuneWeapon)
            API.Debug("Empower Rune Weapon - Cooldowns - SimC")
            return true
        end
    end

    if (API.PlayerHasBuff(auras.BreathofSindragosa) and not API.PlayerHasBuff(auras.EmpowerRuneWeaponBuff) and
        ((isInCombatForLessThan10Seconds() and PlayerHasAnyAuraUp(BloodlustAuras)) or
            (state.CurrentRunicPower < 70 and state.CurrentRunesAvailable < 3 and
                (game_api.getCooldownRemainingTime(spells.BreathofSindragosa) > 30000)))) then
        game_api.castSpell(spells.EmpowerRuneWeapon)
        API.Debug("Empower Rune Weapon - Cooldowns - SimC #2")
        return true
    end
    if (not game_api.hasTalent(talents.BreathofSindragosa) and not game_api.hasTalentEntry(talents.ObliterationEntryID) and
        not API.PlayerHasBuff(auras.EmpowerRuneWeaponBuff) and state.CurrentRunesAvailable < 5 and
        (game_api.getCooldownRemainingTime(spells.PillarofFrost) < 7000 or API.PlayerHasBuff(auras.PillarofFrostBuff) or
            not game_api.hasTalentEntry(talents.PillarofFrostEntryID))) then
        game_api.castSpell(spells.EmpowerRuneWeapon)
        API.Debug("Empower Rune Weapon - Cooldowns - SimC #3")
        return true
    end
    if API.CanCast(spells.AbominationLimb) and
        (game_api.hasTalentEntry(talents.ObliterationEntryID) and not API.PlayerHasBuff(auras.PillarofFrostBuff) and
            game_api.getCooldownRemainingTime(spells.PillarofFrost) < 3000 and (AddsLeft or STSetup)) then
        game_api.castSpell(spells.AbominationLimb)
        API.Debug("Abom Limb - Cooldowns - SimC")
        return true
    end
    if API.CanCast(spells.AbominationLimb) and
        (game_api.hasTalent(talents.BreathofSindragosa) and (AddsLeft or STSetup)) then
        game_api.castSpell(spells.AbominationLimb)
        API.Debug("Abom Limb - Cooldowns - SimC #2")
        return true
    end
    if API.CanCast(spells.AbominationLimb) and
        (not game_api.hasTalent(talents.BreathofSindragosa) and not game_api.hasTalentEntry(talents.ObliterationEntryID) and
            (AddsLeft or STSetup)) then
        game_api.castSpell(spells.AbominationLimb)
        API.Debug("Abom Limb - Cooldowns - SimC #3")
        return true
    end
    if state.CurrentRunesAvailable > 0 then
        if API.CanCast(spells.ChillStreak) and
            (API.PlayerHasBuff(auras.T312P) and
                game_api.unitAuraRemainingTime(state.currentPlayer, auras.ChillingRageBuff, true) < 3000) then
            game_api.castSpell(spells.ChillStreak)
            API.Debug("Chill Streak - Cooldowns - SimC")
            return true
        end
        if API.CanCast(spells.ChillStreak) and (not API.PlayerHasBuff(auras.T312P) and state.HostileUnitCount >= 2 and
            (not API.PlayerHasBuff(auras.DeathAndDecayBuff) and game_api.hasTalentEntry(talents.CleavingStrikeEntryID) or
                not game_api.hasTalentEntry(talents.CleavingStrikeEntryID) or state.HostileUnitCount <= 5)) then
            game_api.castSpell(spells.ChillStreak)
            API.Debug("Chill Streak - Cooldowns - SimC #2")
            return true
        end
        if API.CanCast(spells.PillarofFrost) then
            if (game_api.hasTalentEntry(talents.ObliterationEntryID) and (AddsLeft or STSetup) and
                (API.PlayerHasBuff(auras.EmpowerRuneWeaponBuff) or
                    game_api.getCooldownRemainingTime(spells.EmpowerRuneWeapon) > 0)) then
                game_api.castSpell(spells.PillarofFrost)
                API.Debug("Pillar of Frost - Cooldowns - SimC")
                return true
            end
            if (game_api.hasTalent(talents.BreathofSindragosa) and (AddsLeft or STSetup) and
                (not game_api.hasTalentEntry(talents.IceCapEntryID) and
                    (state.CurrentRunicPower > 70 or game_api.getCooldownRemainingTime(spells.BreathofSindragosa) >
                        40000) or game_api.hasTalentEntry(talents.IceCapEntryID) and
                    (game_api.getCooldownRemainingTime(spells.BreathofSindragosa) > 5000 or
                        API.PlayerHasBuff(auras.BreathofSindragosa)))) then
                game_api.castSpell(spells.PillarofFrost)
                API.Debug("Pillar of Frost - Cooldowns - SimC #2")
                return true
            end
            if (game_api.hasTalentEntry(talents.IceCapEntryID) and
                not game_api.hasTalentEntry(talents.ObliterationEntryID) and
                not game_api.hasTalent(talents.BreathofSindragosa) and (AddsLeft or STSetup)) then
                game_api.castSpell(spells.PillarofFrost)
                API.Debug("Pillar of Frost - Cooldowns - SimC #3")
                return true
            end
        end
        if API.CanCast(spells.BreathofSindragosa) and (not API.PlayerHasBuff(auras.BreathofSindragosa) and
            (state.CurrentRunicPower > 50 and not game_api.isOnCooldown(spells.EmpowerRuneWeapon) or
                state.CurrentRunicPower > 60 and game_api.getCooldownRemainingTime(spells.EmpowerRuneWeapon) < 30000 or
                state.CurrentRunicPower > 80 and game_api.getCooldownRemainingTime(spells.EmpowerRuneWeapon) > 30000) and
            (AddsLeft or STSetup)) then
            game_api.castSpell(spells.BreathofSindragosa)
            API.Debug("Breath of Sindragosa - Cooldowns - SimC")
            return true
        end
        if API.CanCast(spells.FrostwyrmsFury) then
            if (state.HostileUnitCount == 1 and (game_api.hasTalentEntry(talents.PillarofFrostEntryID) and
                game_api.unitAuraRemainingTime(state.currentPlayer, auras.PillarofFrostBuff, true) < 2000 and
                API.PlayerHasBuff(auras.PillarofFrostBuff) and
                not game_api.hasTalentEntry(talents.ImprovedObliterateEntryID) or
                not game_api.hasTalentEntry(talents.PillarofFrostEntryID))) then
                game_api.castSpell(spells.FrostwyrmsFury)
                API.Debug("Frostwryms Fury - Cooldowns - SimC")
                return true
            end
            if (state.HostileUnitCount >= 2 and
                (game_api.hasTalentEntry(talents.PillarofFrostEntryID) and API.PlayerHasBuff(auras.PillarofFrostBuff))) then
                game_api.castSpell(spells.FrostwyrmsFury)
                API.Debug("Frostwryms Fury - Cooldowns - SimC - #2")
                return true
            end
            if (game_api.hasTalentEntry(talents.ObliterationEntryID) and
                (game_api.hasTalentEntry(talents.PillarofFrostEntryID) and API.PlayerHasBuff(auras.PillarofFrostBuff) and
                    not state.HasTwoHander or not API.PlayerHasBuff(auras.PillarofFrostBuff) and state.HasTwoHander and
                    game_api.isOnCooldown(spells.PillarofFrost) or
                    not game_api.hasTalentEntry(talents.PillarofFrostEntryID))) then
                game_api.castSpell(spells.FrostwyrmsFury)
                API.Debug("Frostwryms Fury - Cooldowns - SimC - #3")
                return true
            end
        end
        if not hasPet() then
            if API.CanCast(spells.RaiseDead) then
                game_api.castSpell(spells.RaiseDead)
                API.Debug("Raise Dead - Cooldowns - SimC")
                return true
            end
        end
        if API.CanCast(spells.SoulReaper) and SoulReaperLogic then
            game_api.castSpell(spells.SoulReaper)
            API.Debug("Soul Repear - Cooldowns - SimC")
            return true
        end
        if game_api.canCastCharge(spells.DeathAndDecay, 2) and state.CurrentRunesAvailable > 0 and
            (AddsLeft and not API.PlayerHasBuff(auras.DeathAndDecayBuff) or game_api.hasTalent(talents.UnholyGround) and
                not API.PlayerHasBuff(auras.DeathAndDecayBuff)) then
            game_api.castAOESpellOnSelf(spells.DeathAndDecay)
            API.Debug("Death and Decay - Cooldowns - SimC")
            return true
        end
    end
end

function ObliterationRotation()

    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        (PlayerAuraStacks(auras.KillingMachineBuff) < 2 and PlayerAuraRemains(auras.PillarofFrostBuff) < 1400 and
            API.PlayerHasBuff(auras.RimeBuff)) then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - Obliteration - SimC")
        return true
    end
    if API.CanCast(spells.FrostStrike) and state.CurrentRunicPower >= 30 and
        ((state.HostileUnitCount <= 1 or not game_api.hasTalentEntry(talents.GlacialAdvanceEntryID)) and
            PlayerAuraStacks(auras.KillingMachineBuff) < 2 and PlayerAuraRemains(auras.PillarofFrostBuff) < 1400 and
            not API.PlayerHasBuff(auras.DeathAndDecayBuff)) then
        game_api.castSpell(spells.FrostStrike)
        API.Debug("Frost Strike - Obliteration - SimC")
        return true
    end
    if API.CanCast(spells.GlacialAdvance) and state.CurrentRunicPower >= 30 and
        (PlayerAuraStacks(auras.KillingMachineBuff) < 2 and PlayerAuraRemains(auras.PillarofFrostBuff) < 1400 and
            not API.PlayerHasBuff(auras.DeathAndDecayBuff)) then
        game_api.castSpell(spells.GlacialAdvance)
        API.Debug("Glacial Advance - Obliteration - SimC")
        return true
    end
    if API.CanCast(spells.Frostscythe) and state.CurrentRunesAvailable > 0 and
        (API.PlayerHasBuff(auras.KillingMachineBuff) and
            (FrostscythePriority or state.HostileUnitCount > 3 and API.PlayerHasBuff(auras.DeathAndDecayBuff))) then
        game_api.castSpell(spells.Frostscythe)
        API.Debug("Frostscythe - Obliteration - SimC")
        return true
    end
    if API.CanCast(spells.Obliterate) and state.CurrentRunesAvailable > 1 and
        API.PlayerHasBuff(auras.KillingMachineBuff) and not FrostscythePriority then
        game_api.castSpell(spells.Obliterate)
        API.Debug("Obliterate - Obliteration - SimC")
        return true
    end
    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        (not API.PlayerHasBuff(auras.KillingMachineBuff) and
            (not TargetHasAura(auras.FrostFeverDebuff) or API.PlayerHasBuff(auras.RimeBuff) and not RPBuffs)) then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - Obliteration - SimC #2")
        return true
    end
    if API.CanCast(spells.GlacialAdvance) and state.CurrentRunicPower >= 30 and
        not API.PlayerHasBuff(auras.KillingMachineBuff) and (RPBuffs or state.CurrentRunesAvailable < 2) then
        game_api.castSpell(spells.GlacialAdvance)
        API.Debug("Glacical Advance - Obliteration - SimC #2")
        return true
    end
    if API.CanCast(spells.FrostStrike) and state.CurrentRunicPower >= 30 and
        (not API.PlayerHasBuff(auras.KillingMachineBuff) and
            (state.CurrentRunesAvailable < 2 or RPBuffs or state.HostileUnitCount == 1)) then
        game_api.castSpell(spells.FrostStrike)
        API.Debug("Frost Strike - Obliteration - SimC #2")
        return true
    end
    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        API.PlayerHasBuff(auras.RimeBuff) and not API.PlayerHasBuff(auras.KillingMachineBuff) then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - Obliteration - SimC #3")
        return true
    end
    if API.CanCast(spells.FrostStrike) and state.CurrentRunicPower >= 30 and
        (not API.PlayerHasBuff(auras.KillingMachineBuff) and not PoolRP and
            (not game_api.hasTalentEntry(talents.GlacialAdvanceEntryID) or state.HostileUnitCount == 1)) then
        game_api.castSpell(spells.FrostStrike)
        API.Debug("Frost Strike - Obliteration - SimC #3")
        return true
    end
    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        not API.PlayerHasBuff(auras.KillingMachineBuff) and state.CurrentRunicPower < 30 then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - Obliteration - SimC #4")
        return true
    end
    -- ArcaneTorrent
    if API.CanCast(spells.GlacialAdvance) and state.CurrentRunicPower >= 30 and not PoolRP and state.HostileUnitCount >=
        2 then
        game_api.castSpell(spells.GlacialAdvance)
        API.Debug("Glacical Advance - Obliteration - SimC #3")
        return true
    end
    if API.CanCast(spells.FrostStrike) and state.CurrentRunicPower >= 30 and
        (not PoolRP and (not game_api.hasTalentEntry(talents.GlacialAdvanceEntryID) or state.HostileUnitCount == 1)) then
        game_api.castSpell(spells.FrostStrike)
        API.Debug("Frost Strike - Obliteration - SimC #4")
        return true
    end
    if API.CanCast(spells.HowlingBlast) and API.PlayerHasBuff(auras.RimeBuff) then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - Obliteration - SimC #5")
        return true
    end
    if API.CanCast(spells.Obliterate) and state.CurrentRunesAvailable > 1 then
        game_api.castSpell(spells.Obliterate)
        API.Debug("Obliterate - Obliteration - SimC #2")
        return true
    end
end

function SingleTargetRotation()
    if not state.HasTwoHander then
        if API.CanCast(spells.FrostStrike) and state.CurrentRunicPower >= 30 and
            (PlayerAuraStacks(auras.KillingMachineBuff) < 2 and state.RunicPowerDeficit < 20) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("Frost Strike - ST - SimC")
            return true
        end
    end
    if API.CanCast(spells.Frostscythe) and state.CurrentRunesAvailable > 0 and
        API.PlayerHasBuff(auras.KillingMachineBuff) and FrostscythePriority then
        game_api.castSpell(spells.Frostscythe)
        API.Debug("Frostscythe - ST - SimC")
        return true
    end
    if API.CanCast(spells.Obliterate) and state.CurrentRunesAvailable > 1 and
        API.PlayerHasBuff(auras.KillingMachineBuff) then
        game_api.castSpell(spells.Obliterate)
        API.Debug("Obliterate - ST - SimC")
        return true
    end
    if API.CanCast(spells.HowlingBlast) and (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff)) and
        API.PlayerHasBuff(auras.RimeBuff) and game_api.getTalentEntryRank(talents.IcebreakerEntryID) == 2 then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - ST - SimC")
        return true
    end
    if API.CanCast(spells.HornofWinter) and (state.CurrentRunesAvailable < 4 and state.RunicPowerDeficit > 25 and
        game_api.hasTalentEntry(talents.ObliterationEntryID) and game_api.hasTalent(talents.BreathofSindragosa)) then
        game_api.castSpell(spells.HornofWinter)
        API.Debug("Horn of Winter - ST - SimC")
        return true
    end
    if API.CanCast(spells.FrostStrike) and state.CurrentRunicPower >= 30 and (not PoolRP and
        (RPBuffs or state.RunicPowerDeficit < 25 or
            game_api.unitAuraStackCount(state.currentTarget, auras.RazoriceDebuff, true) == 5 and
            game_api.hasTalentEntry(96231))) then
        game_api.castSpell(spells.FrostStrike)
        API.Debug("Frost Strike - ST - SimC #2")
        return true
    end
    if API.CanCast(spells.HowlingBlast) and
        (state.CurrentRunesAvailable > 0 or API.PlayerHasBuff(auras.RimeBuff) and RimeBuffs) then
        game_api.castSpell(spells.HowlingBlast)
        API.Debug("Howling Blast - ST - SimC #2")
        return true
    end
    if API.CanCast(spells.GlacialAdvance) and state.CurrentRunicPower >= 30 and not PoolRP then
        game_api.castSpell(spells.GlacialAdvance)
        API.Debug("Glaical Advance - ST - SimC")
        return true
    end
    if API.CanCast(spells.Obliterate) and state.CurrentRunesAvailable > 1 and not PoolRunes then
        game_api.castSpell(spells.Obliterate)
        API.Debug("Obliterate - ST - SimC #2")
        return true
    end
    if API.CanCast(spells.HornofWinter) and (state.CurrentRunesAvailable < 4 and state.RunicPowerDeficit > 25 and
        (not game_api.hasTalent(spells.BreathofSindragosa) or
            game_api.getCooldownRemainingTime(spells.BreathofSindragosa) > 45000)) then
        game_api.castSpell(spells.HornofWinter)
        API.Debug("Horn of Winter - ST - SimC #2")
        return true
    end
    -- Arcane ArcaneTorrent
    if API.CanCast(spells.FrostStrike) and state.CurrentRunicPower >= 30 and not PoolRP then
        game_api.castSpell(spells.FrostStrike)
        API.Debug("Frost Strike - ST - SimC #3")
        return true
    end
end

function DPS()

    -- Opener Down the Road

    -- Base Rotation BreathofSindragosa

    if state.PlayerIsInCombat and state.TargetCheck and (state.HostileUnitCount < 3 or not AutoAoE) then

        if API.CanCast(spells.FrostStrike) and FrostStrikeLogic and FrostStrikeLogicActiveBreathCheck then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("FrostStrikeCasted for DPS")
            return true
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.PillarofFrost) then
                game_api.castSpell(spells.PillarofFrost)
                API.Debug("PillarofFrost Casted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) and BreathofSindragosaLogic then
            if API.CanCast(spells.BreathofSindragosa) then
                game_api.castSpell(spells.BreathofSindragosa)
                API.Debug("BreathofSindragosa Casted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if game_api.canCastCharge(spells.EmpowerRuneWeapon, state.EmpowerRuneWeaponCharges) then
                game_api.castSpell(spells.EmpowerRuneWeapon)
                API.Debug("EmpowerRuneWeaponCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.RemorselessWinter) then
                game_api.castSpell(spells.RemorselessWinter)
                API.Debug("RemorselessWinterCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.ChillStreak) then
                game_api.castSpell(spells.ChillStreak)
                API.Debug("ChillStreakCasted for DPS")
                return true
            end
        end

        if API.CanCast(spells.SoulReaper) and SoulReaperLogic then
            game_api.castSpell(spells.SoulReaper)
            API.Debug("SoulReaper Casted for DPS")
            return true
        end

        if API.CanCast(spells.Obliterate) and ObliterateLogic then
            game_api.castSpell(spells.Obliterate)
            API.Debug("ObliterateCasted for DPS")
            return true
        end

        if API.CanCast(spells.HowlingBlast) and HowlingBlastLogic then
            game_api.castSpell(spells.HowlingBlast)
            API.Debug("HowlingBlastCasted for DPS")
            return true
        end

        if game_api.getToggle(settings.Cooldown) and ObliterateLogic2 then
            if API.CanCast(spells.Obliterate) then
                game_api.castSpell(spells.Obliterate)
                API.Debug("ObliterateCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) and HornofWinterLogic then
            if API.CanCast(spells.HornofWinter) then
                game_api.castSpell(spells.HornofWinter)
                API.Debug("HornofWinter Casted for DPS")
                return true
            end
        end

        if API.CanCast(spells.FrostStrike) and FrostStrikeLogicActiveBreathCheck then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("FrostStrikeCasted for DPS")
            return true
        end

        -- BreathofSindragosa AoE

        if API.CanCast(spells.FrostStrike) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("FrostStrikeCasted for DPS")
            return true
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.PillarofFrost) then
                game_api.castSpell(spells.PillarofFrost)
                API.Debug("PillarofFrost Casted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.BreathofSindragosa) then
                game_api.castSpell(spells.BreathofSindragosa)
                API.Debug("BreathofSindragosa Casted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.EmpowerRuneWeapon) then
                game_api.castSpell(spells.EmpowerRuneWeapon)
                API.Debug("EmpowerRuneWeaponCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.AbominationLimb) then
                game_api.castSpell(spells.AbominationLimb)
                API.Debug("AbominationLimb Casted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.RemorselessWinter) then
                game_api.castSpell(spells.RemorselessWinter)
                API.Debug("RemorselessWinterCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.ChillStreak) then
                game_api.castSpell(spells.ChillStreak)
                API.Debug("ChillStreakCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if game_api.canCastCharge(spells.DeathAndDecay, 2) then
                game_api.castSpell(spells.DeathAndDecay)
                API.Debug("DeathAndDecay Casted for DPS")
                return true
            end
        end

        if API.CanCast(spells.Obliterate) then
            game_api.castSpell(spells.Obliterate)
            API.Debug("ObliterateCasted for DPS")
            return true
        end

        if API.CanCast(spells.HowlingBlast) then
            game_api.castSpell(spells.HowlingBlast)
            API.Debug("HowlingBlastCasted for DPS")
            return true
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.Obliterate) then
                game_api.castSpell(spells.Obliterate)
                API.Debug("ObliterateCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.HornofWinter) then
                game_api.castSpell(spells.HornofWinter)
                API.Debug("HornofWinter Casted for DPS")
                return true
            end
        end

        if API.CanCast(spells.FrostStrike) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("FrostStrikeCasted for DPS")
            return true
        end

        -- Base Rotation Obliteration

        if API.CanCast(spells.FrostStrike) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("FrostStrikeCasted for DPS")
            return true
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.RemorselessWinter) then
                game_api.castSpell(spells.RemorselessWinter)
                API.Debug("RemorselessWinterCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.ChillStreak) then
                game_api.castSpell(spells.ChillStreak)
                API.Debug("ChillStreakCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.EmpowerRuneWeapon) then
                game_api.castSpell(spells.EmpowerRuneWeapon)
                API.Debug("EmpowerRuneWeaponCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.PillarofFrost) then
                game_api.castSpell(spells.PillarofFrost)
                API.Debug("PillarofFrost Casted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if game_api.canCastCharge(spells.DeathAndDecay, 2) then
                game_api.castSpell(spells.DeathAndDecay)
                API.Debug("DeathAndDecay Casted for DPS")
                return true
            end
        end

        if API.CanCast(spells.Obliterate) then
            game_api.castSpell(spells.Obliterate)
            API.Debug("ObliterateCasted for DPS")
            return true
        end

        if API.CanCast(spells.HowlingBlast) then
            game_api.castSpell(spells.HowlingBlast)
            API.Debug("HowlingBlastCasted for DPS")
            return true
        end

        if API.CanCast(spells.FrostStrike) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("FrostStrikeCasted for DPS")
            return true
        end

        if API.CanCast(spells.HowlingBlast) then
            game_api.castSpell(spells.HowlingBlast)
            API.Debug("HowlingBlastCasted for DPS")
            return true
        end

        if API.CanCast(spells.FrostStrike) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("FrostStrikeCasted for DPS")
            return true
        end

        if API.CanCast(spells.Obliterate) then
            game_api.castSpell(spells.Obliterate)
            API.Debug("ObliterateCasted for DPS")
            return true
        end

        -- Obliterate AoE

        if API.CanCast(spells.FrostStrike) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("FrostStrikeCasted for DPS")
            return true
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.AbominationLimb) then
                game_api.castSpell(spells.AbominationLimb)
                API.Debug("AbominationLimb Casted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.RemorselessWinter) then
                game_api.castSpell(spells.RemorselessWinter)
                API.Debug("RemorselessWinterCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.ChillStreak) then
                game_api.castSpell(spells.ChillStreak)
                API.Debug("ChillStreakCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.EmpowerRuneWeapon) then
                game_api.castSpell(spells.EmpowerRuneWeapon)
                API.Debug("EmpowerRuneWeaponCasted for DPS")
                return true
            end
        end

        if game_api.getToggle(settings.Cooldown) then
            if API.CanCast(spells.PillarofFrost) then
                game_api.castSpell(spells.PillarofFrost)
                API.Debug("PillarofFrost Casted for DPS")
                return true
            end
        end

        if API.CanCast(spells.Obliterate) then
            game_api.castSpell(spells.Obliterate)
            API.Debug("ObliterateCasted for DPS")
            return true
        end

        if API.CanCast(spells.HowlingBlast) then
            game_api.castSpell(spells.HowlingBlast)
            API.Debug("HowlingBlastCasted for DPS")
            return true
        end

        if API.CanCast(spells.FrostStrike) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("FrostStrikeCasted for DPS")
            return true
        end

        if API.CanCast(spells.HowlingBlast) then
            game_api.castSpell(spells.HowlingBlast)
            API.Debug("HowlingBlastCasted for DPS")
            return true
        end

        if API.CanCast(spells.FrostStrike) then
            game_api.castSpell(spells.FrostStrike)
            API.Debug("FrostStrikeCasted for DPS")
            return true
        end

        if API.CanCast(spells.Obliterate) then
            game_api.castSpell(spells.Obliterate)
            API.Debug("ObliterateCasted for DPS")
            return true
        end

        --------- Combat and DPS functions ----------------------        
    end
end

--[[
    Run on eatch engine tick if game has focus and is not loading
]]
function OnUpdate()

    if not game_api.isSpec(137006) then
        API.Debug("Not Frost DK Spec!!")
    end

    StateUpdate()
--API.Debug("Check ? " .. tostring(game_api.hasTalentEntry(96163)))
    if game_api.getToggle("Pause") then
        return
    end
    if game_api.currentPlayerIsCasting() or game_api.currentPlayerIsMounted() or game_api.currentPlayerIsChanneling() or
        game_api.isAOECursor() then
        return
    end

    if state.TargetCheck and state.PlayerIsInCombat then
        if Defense() then
            return true
        end
        --  actions+=/call_action_list,name=trinkets
        if API.dpsTrinket(auras.PillarofFrostBuff, auras.EmpowerRuneWeaponBuff) then
            return true
        end

        --  actions+=/call_action_list,name=high_prio_actions
        if HighPriorityActionsSimC() then
            return true
        end
        --  actions+=/call_action_list,name=cooldowns
        if game_api.getToggle(settings.Cooldown) then
            if Cooldowns() then
                return true
            end
        end
        --   actions+=/call_action_list,name=racials
        if API.useRacialCommon(auras.PillarofFrostBuff) then
            return true
        end
        --   actions+=/call_action_list,name=cold_heart,if=talent.cold_heart&(!buff.killing_machine.up|talent.breath_of_sindragosa)&((debuff.razorice.stack=5|!death_knight.runeforge.razorice&!talent.glacial_advance&!talent.avalanche)|fight_remains<=gcd)
        if game_api.hasTalentEntry(96163) then
            if (not API.PlayerHasBuff(auras.KillingMachineBuff) or game_api.hasTalent(talents.BreathofSindragosa)) and
                ((game_api.unitAuraRemainingTime(state.currentTarget, auras.RazoriceDebuff) == 5 or not settings.UseRazorIce and
                    not game_api.hasTalentEntry(talents.GlacialAdvanceEntryID) and not game_api.hasTalent(talents.Avalanche))) or
                API.timeToDieGroup() > 1.4 then
                if ColdHeartRotation() then
                    return true
                end
            end

        end

        --   actions+=/run_action_list,name=breath_oblit,if=buff.breath_of_sindragosa.up&talent.obliteration&buff.pillar_of_frost.up
        if API.PlayerHasBuff(auras.BreathofSindragosa) and game_api.hasTalentEntry(talents.ObliterationEntryID) and
            API.PlayerHasBuff(auras.PillarofFrostBuff) then
            if BreathandObliterateActiveSimC() then
                return true
            end
        end
        --   actions+=/run_action_list,name=breath,if=buff.breath_of_sindragosa.up&(!talent.obliteration|talent.obliteration&!buff.pillar_of_frost.up)
        if API.PlayerHasBuff(auras.BreathofSindragosa) and
            (not game_api.hasTalentEntry(talents.ObliterationEntryID) or
                game_api.hasTalentEntry(talents.ObliterationEntryID) and not API.PlayerHasBuff(auras.PillarofFrostBuff)) then
            if BreatheActiveRotationSimC() then
                return true
            end
        end
        --  actions+=/run_action_list,name=obliteration,if=talent.obliteration&buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up
        if game_api.hasTalentEntry(talents.ObliterationEntryID) and API.PlayerHasBuff(auras.PillarofFrostBuff) and
            not API.PlayerHasBuff(auras.BreathofSindragosa) then
            if ObliterationRotation() then
                return true
            end
        end
        --   actions+=/call_action_list,name=aoe,if=active_enemies>=2
        if AutoAoE then
            if AoE() then
            end
        end
        --   actions+=/call_action_list,name=single_target,if=active_enemies=1
        if not AutoAoE then
            if SingleTargetRotation() then
                return true
            end
        end
    end

end
