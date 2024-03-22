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
    print("Unholy Death Knight Rise Up !")
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
                if API.IsInRange(range, unit) and game_api.unitHasAura(unit, auraID, true) then
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
function UnitWithoutAura(units, range, aura)
    local highestHealthUnit = nil
    local highestHealthPercent = 0 -- Start lower than any health percentage to catch the first unit above 0% health

    for _, unit in ipairs(units) do
        if API.IsInRange(range, unit) and game_api.unitHealthPercent(unit) > 0 and
            not game_api.unitHasAura(unit, aura, true) then
            local unitHealthPercent = game_api.unitHealthPercent(unit)
            if unitHealthPercent > highestHealthPercent then
                highestHealthPercent = unitHealthPercent
                highestHealthUnit = unit
            end
        end
    end

    return highestHealthUnit
end
function UnitWithAura(units, range, aura)
    local highestHealthUnit = nil
    local highestHealthPercent = 0 -- Start lower than any health percentage to catch the first unit above 0% health

    for _, unit in ipairs(units) do
        if API.IsInRange(range, unit) and game_api.unitHealthPercent(unit) > 0 and
            game_api.unitHasAura(unit, aura, true) then
            local unitHealthPercent = game_api.unitHealthPercent(unit)
            if unitHealthPercent > highestHealthPercent then
                highestHealthPercent = unitHealthPercent
                highestHealthUnit = unit
            end
        end
    end

    return highestHealthUnit
end
function FindUnitWithoutAura(units, range, auras)
    for _, unit in ipairs(units) do
        if API.IsInRange(range, unit) then
            local unitHasNoAuras = true
            for _, auraID in ipairs(auras) do
                if game_api.unitHasAura(unit, auraID, true) then
                    unitHasNoAuras = false
                    break -- This unit has one of the auras, stop checking and move to the next unit
                end
            end
            if unitHasNoAuras then
                return unit -- Found a unit without any of the specified auras
            end
        end
    end

    return nil -- If no unit found without the auras
end

function UnitWithLowestAuraStacks(units, range, auraID)
    local targetUnit = nil
    local lowestStacks = nil -- Use nil to indicate no stacks found yet

    for _, unit in ipairs(units) do
        if game_api.unitHealthPercent(unit) > 0 and game_api.distanceToUnit(unit) <= range then -- Check if unit is alive and within range
            if game_api.unitHasAura(unit, auraID, true) then
                local stacks = game_api.unitAuraStackCount(unit, auraID, true)
                if stacks and (not lowestStacks or stacks < lowestStacks) then
                    lowestStacks = stacks
                    targetUnit = unit
                end
            end
        end
    end
    return targetUnit
end

function UnitWithHighestAuraStacks(units, range, auraID)
    local targetUnit = nil
    local highestStacks = nil -- Use nil to indicate no stacks found yet

    for _, unit in ipairs(units) do
        if game_api.unitHealthPercent(unit) > 0 and game_api.distanceToUnit(unit) <= range then -- Check if the unit is alive and within range
            if game_api.unitHasAura(unit, auraID, true) then
                local stacks = game_api.unitAuraStackCount(unit, auraID, true)
                if stacks and (not highestStacks or stacks > highestStacks) then
                    highestStacks = stacks
                    targetUnit = unit
                end
            end
        end
    end

    return targetUnit
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

function AuraTracking(units, aura)
    local count = 0

    for _, unit in ipairs(units) do
        if API.IsInRange(40, unit) and game_api.unitHasAura(unit, aura, true) and game_api.unitHealthPercent(unit) > 0 then
            count = count + 1
        end
    end
    return count
end

function countSpellCasts(spellId, count)
    local spellHistory = game_api.spellCastHistory()
    local castCount = 0
    local numChecks = math.min(#spellHistory, count)

    for i = 1, numChecks do
        if spellHistory[i] == spellId then
            castCount = castCount + 1
        end
    end

    return castCount
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

function StateUpdate()
    API.RefreshFunctionsState();
    state.currentPower = game_api.getPower(0) / 5 -- runes
    state.currentMaxPower = game_api.getMaxPower(0) / 5 -- runes
    state.currentTarget = game_api.getCurrentUnitTarget()
    state.currentTargetHpPercent = game_api.unitHealthPercent(state.currentTarget)
    state.currentPlayer = game_api.getCurrentPlayer()
    state.currentHpPercent = API.UnitHealthPercentWeighted(state.currentPlayer)
    state.playerHealth = game_api.unitHealthPercent(state.currentPlayer)

    state.FesteringUnitRange = game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and 30 or 6
    state.TargetCheck = game_api.unitInCombat(state.currentPlayer) and state.currentTarget ~= 00 and
                            API.isInCombatOrHasNpcId(state.currentTarget, cLists.npcIdList) and
                            (game_api.currentPlayerDistanceFromTarget() <= 6 or game_api.unitNpcID(state.currentTarget) ==
                                44566) and game_api.isFacing(state.currentTarget) and game_api.isTargetHostile(true) and
                            game_api.unitHealthPercent(state.currentTarget) > 0
    state.getUnits = game_api.getUnits()
    state.PlayerIsInCombat = game_api.unitInCombat(state.currentPlayer)
    state.HostileUnits = getCombatUnits()
    state.HostileUnitCount = getCombatUnitsCount()
    state.VirulentPlaugeCount = AuraTracking(state.HostileUnits, auras.VirulentPlagueDebuff)
    state.LowestStackFesteringUnit = UnitWithLowestAuraStacks(state.HostileUnits, 6, auras.FesteringWound)
    state.HighestStackFesteringUnit = UnitWithHighestAuraStacks(state.HostileUnits, 6, auras.FesteringWound)
    state.FesteringTarget = UnitWithoutAura(state.HostileUnits, 6, auras.FesteringWound)
    state.FesteringWoundCount = AuraTracking(state.HostileUnits, auras.FesteringWound)
    state.FesteringUnitTarget = UnitWithAura(state.HostileUnits, state.FesteringUnitRange, auras.FesteringWound)
    state.afflictedUnits = game_api.getUnitsByNpcId(204773)
    state.incorporealUnits = game_api.getUnitsByNpcId(204560)

    state.CurrentCastID = game_api.unitCastingSpellID(state.currentPlayer)
    state.Pets = game_api.getUnitsByNpcId(26125)
    state.Garg = game_api.getUnitsByNpcId(27829)
    state.Magus = game_api.getUnitsByNpcId(163366)
    state.CurrentRunicPower = game_api.getPower(1) / 10
    state.CurrentMaxRunicPower = game_api.getMaxPower(1) / 10
    state.CurrentRunesAvailable = game_api.getRuneCount()

    state.DnDMaxCharges = game_api.hasTalentEntry(96184) and 2 or 1
    state.DeathAndDecaySpellID = game_api.hasTalentEntry(talents.DefileEntryID) and spells.Defile or
                                     spells.DeathAndDecay
    state.DnDCanCast = game_api.canCastCharge(state.DeathAndDecaySpellID, state.DnDMaxCharges)
    state.ScourgeOrClaw = game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and spells.ClawingShadows or
                              spells.ScourgeStrike
    state.ScourgeOrClawCanCast = API.CanCast(state.ScourgeOrClaw)
    state.DeathCoilCount = countSpellCasts(spells.DeathCoil, 5)
    state.getUnits = game_api.getUnits()
    state.OverallProactiveLogic = ProactiveLogic()
    state.MagicalProactive = API.ProactiveLogic(cLists.aoeIncomingWarriorMagic)
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
function hasPetWithDarkTransformation()
    local Pets = state.Pets
    for _, Pet in pairs(Pets) do
        if game_api.unitOwner(Pet) == state.currentPlayer and game_api.distanceToUnit(Pet) <= 40 and
            game_api.unitHasAura(Pet, auras.DarkTransformation, false) then
            if game_api.unitHealthPercent(Pet) > 0 then
                return true
            end
        end
    end
    return false
end
function hasPetGarg()
    local Pets = state.Garg
    for _, Pet in pairs(Pets) do
        if game_api.unitOwner(Pet) == state.currentPlayer and game_api.distanceToUnit(Pet) <= 40 then
            if game_api.unitHealthPercent(Pet) > 0 then
                return true
            end
        end
    end
    return false
end
function hasPetMagus()
    local Pets = state.Magus
    for _, Pet in pairs(Pets) do
        if game_api.unitOwner(Pet) == state.currentPlayer and game_api.distanceToUnit(Pet) <= 40 then
            if game_api.unitHealthPercent(Pet) > 0 then
                return true
            end
        end
    end
    return false
end

function TargetHasAura(aura)
    return game_api.unitHasAura(state.currentTarget, aura, true)
end

local AutoAoE, SoulReaperLogic, DeathCoilLogicSuddenDoom, ClawingShadowsLogicRottenTouch, DeathCoilLogicDeathRot,
    OutbreakLogic, DeathCoilLogicSummonGargoyle, ScourgeStrikeLogic, DeathandDecayLogic, FesteringStrikeLogic,
    ClawingShadowsLogicFestering, DefileLogic
local DeathCoilCheck, DeathCoilLogicInCooldowns
local DC1 = false
local DC2 = false
local DC3 = false

local deathCoilCounter = 0

-- Function to reset the counter at the start of the cooldown window
function ResetDeathCoilCounter()
    deathCoilCounter = 0
    API.Debug("Death Coil Counter Reset " .. tostring(deathCoilCounter))
end

function DPS()

    if state.PlayerIsInCombat and (state.HostileUnitCount < 3 or not AutoAoE) then
        ------------- Cooldown priority ================
        if game_api.getToggle(settings.Cooldown) then

            if not hasPet() then
                if API.CanCast(spells.RaiseDead) then
                    game_api.castSpell(spells.RaiseDead)
                    API.Debug("RaiseDead Casted -- Cooldown Priority -- No Pet")
                    return true
                end
            end

            if state.CurrentRunesAvailable > 0 then
                if API.CanCast(spells.ArmyoftheDead) then
                    game_api.castSpell(spells.ArmyoftheDead)
                    API.Debug("ArmyoftheDead Casted Spell -- Cooldown Priority 2")
                    ResetDeathCoilCounter()
                    return true
                end
            end

            if state.CurrentRunesAvailable > 0 then
                if API.CanCast(spells.UnholyBlight) and game_api.isOnCooldown(spells.ArmyoftheDead) then
                    game_api.castSpell(spells.UnholyBlight)
                    API.Debug("Unholy Blight Casted Spell -- Cooldown Priority 1")
                    return true
                end
            end

            if state.CurrentRunesAvailable > 0 then
                if state.DnDCanCast then
                    game_api.castAOESpellOnSelf(state.DeathAndDecaySpellID)
                    API.Debug("DeathandDecay Casted Spell -- Cooldown Priority 1")
                    return true
                end
            end

            if API.CanCast(spells.DarkTransformation) and game_api.isOnCooldown(spells.ArmyoftheDead) then
                game_api.castSpell(spells.DarkTransformation)
                API.Debug("DarkTransformation Casted Spell -- Cooldown Priority 1")
                ResetDeathCoilCounter()
                return true
            end

            if API.CanCast(spells.SummonGargoyle) then
                game_api.castSpell(spells.SummonGargoyle)
                API.Debug("SummonGargoyle Casted Spell -- Cooldown Priority 1")
                return true
            end

            if deathCoilCounter < 3 then
                if API.CanCast(spells.DeathCoil) and hasPetWithDarkTransformation() and
                    (game_api.isOnCooldown(spells.DarkTransformation) or
                        not game_api.hasTalent(talents.DarkTransformation)) and
                    (game_api.isOnCooldown(spells.SummonGargoyle) or not game_api.hasTalent(talents.SummonGargoyle)) and
                    DeathCoilCheck then

                    game_api.castSpell(spells.DeathCoil)
                    API.Debug("Death Coil Casted -- CoolDown Priority " .. tostring(deathCoilCounter + 1) .. " Cast")
                    deathCoilCounter = deathCoilCounter + 1
                    return true
                end
            end

            if API.CanCast(spells.UnholyAssault) and deathCoilCounter >= 2 then
                game_api.castSpell(spells.UnholyAssault)
                API.Debug("UnholyAssault Casted Spell -- Cooldown Priority 1")
                return true
            end

            if API.CanCast(spells.EmpowerRuneWeapon) and
                (game_api.isOnCooldown(spells.UnholyAssault) or not game_api.hasTalent(talents.UnholyAssault)) and
                state.CurrentRunicPower < 30 then
                game_api.castSpell(spells.EmpowerRuneWeapon)
                API.Debug("EmpowerRuneWeapon Casted Spell -- Cooldown Priority 1")
                return true
            end

            if API.CanCast(spells.Apocalypse) and (state.CurrentRunicPower <= 20 or deathCoilCounter >= 2) and
                TargetHasAura(auras.FesteringWound) then
                game_api.castSpell(spells.Apocalypse)
                API.Debug("Apocalypse Casted Spell -- Cooldown Priority 1")
                return true
            end
        end

        if game_api.isOnCooldown(spells.Apocalypse) or not game_api.getToggle(settings.Cooldown) or
            not game_api.hasTalent(talents.Apocalypse) then

            if state.CurrentRunesAvailable > 1 then
                if API.CanCast(spells.SoulReaper) and SoulReaperLogic then
                    game_api.castSpell(spells.SoulReaper)
                    API.Debug("SoulReaper Casted Spell -- DPS Priority")
                    return true
                end
            end

            if API.CanCast(spells.DeathCoil) and DeathCoilLogicSuddenDoom then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority - Sudden Doom")
                return true
            end

            if game_api.hasTalentEntry(talents.DefileEntryID) then
                if API.CanCast(state.DeathAndDecaySpellID) and (hasPetGarg() or hasPetMagus() or DeathandDecayLogic) then
                    game_api.castAOESpellOnSelf(state.DeathAndDecaySpellID)
                    API.Debug("Defile Casted - DPS Priority")
                    return true
                end
            end

            if API.CanCast(spells.AbominationLimb) and state.CurrentRunesAvailable < 3 then
                game_api.castSpell(spells.AbominationLimb)
                API.Debug("Abom Limb Casted - AoE")
                return true
            end

            if state.CurrentRunesAvailable > 0 then
                if game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and state.ScourgeOrClawCanCast and
                    ClawingShadowsLogicRottenTouch then
                    game_api.castSpell(spells.ClawingShadows)
                    API.Debug("Clawing Shadows -- Rotten Shadows Casted Spell -- DPS Priority")
                    return true
                end
            end

            if API.CanCast(spells.DeathCoil) and DeathCoilLogicDeathRot then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority - DeathRot")
                return true
            end

            if state.CurrentRunesAvailable > 0 then
                if API.CanCast(spells.Outbreak) and OutbreakLogic then
                    game_api.castSpell(spells.Outbreak)
                    API.Debug("Outbreak Casted Spell -- DPS Priority")
                    return true
                end
            end

            if API.CanCast(spells.DeathCoil) and DeathCoilLogicSummonGargoyle then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority - Gargoyle Placement")
                return true
            end

            if state.CurrentRunesAvailable > 0 then
                if game_api.hasTalentEntry(talents.ScourgeStrikeEntryID) and
                    not game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and state.ScourgeOrClawCanCast and
                    ScourgeStrikeLogic then
                    game_api.castSpell(spells.ScourgeStrike)
                    API.Debug("ScourgeStrike Casted Spell -- DPS Priority")
                    return true
                end
            end

            if state.CurrentRunesAvailable > 0 then
                if state.DnDCanCast and DeathandDecayLogic then
                    game_api.castSpell(state.DeathAndDecaySpellID)
                    API.Debug("DeathandDecay Casted Spell -- DPS Priority")
                    return true
                end
            end

            if state.CurrentRunesAvailable > 1 then
                if API.CanCast(spells.FesteringStrike) and FesteringStrikeLogic then
                    game_api.castSpell(spells.FesteringStrike)
                    API.Debug("FesteringStrike Casted Spell -- DPS Priority")
                    return true
                end
            end

            if state.CurrentRunesAvailable > 0 then
                if game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and state.ScourgeOrClawCanCast and
                    ClawingShadowsLogicFestering then
                    game_api.castSpell(spells.ClawingShadows)
                    API.Debug("ClawingShadows Casted Spell -- DPS Priority")
                    return true
                end
            end

            if state.CurrentRunesAvailable > 0 then
                if game_api.hasTalentEntry(talents.ScourgeStrikeEntryID) and
                    not game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and state.ScourgeOrClawCanCast and
                    ClawingShadowsLogicFestering then
                    game_api.castSpell(spells.ScourgeStrike)
                    API.Debug("ScourgeStrike Casted Spell -- DPS Priority")
                    return true
                end
            end

            if API.CanCast(spells.DeathCoil) and DeathCoilCheck then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority - Last Priority")
                return true
            end
        end
    end

    if AutoAoE and state.TargetCheck and state.PlayerIsInCombat then
        if not hasPet() then
            if API.CanCast(spells.RaiseDead) then
                game_api.castSpell(spells.RaiseDead)
                API.Debug("RaiseDead Casted -- AoE Priority")
                return true
            end
        end
        -- Wound AoE Build 
        if game_api.hasTalentEntry(talents.PestilenceEntryID) then
            if state.FesteringWoundCount >= 3 then
                if state.CurrentRunesAvailable > 0 then
                    if state.DnDCanCast then
                        game_api.castAOESpellOnSelf(state.DeathAndDecaySpellID)
                        API.Debug(
                            "DeathandDecay Casted Spell -- AoE - Ending Build Phase (Enough Festering Detected) - Beging Burst Phase")
                        return true
                    end
                end
            end
            if state.CurrentRunesAvailable > 0 then
                if game_api.hasTalentEntry(talents.ScourgeStrikeEntryID) and state.ScourgeOrClawCanCast and
                    game_api.hasTalentEntry(talents.PlagueBringerEntryID) and
                    (not API.PlayerHasBuff(auras.Plaugebringer) or API.PlayerHasBuff(auras.Plaugebringer) and
                        game_api.currentPlayerAuraRemainingTime(auras.Plaugebringer, true) <= 750) then
                    game_api.castSpell(spells.ScourgeStrike)
                    API.Debug("Scourge Strike - Apply Plaguebringer or Refresh - AoE")
                    return true
                end
            end
            if API.PlayerHasBuff(auras.DeathAndDecayBuff) then
                if state.FesteringWoundCount > 0 then
                    if state.CurrentRunesAvailable > 0 then
                        if game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and state.ScourgeOrClawCanCast then
                            game_api.castSpell(spells.ClawingShadows)
                            API.Debug("ClawingShadows Casted Spell -- AOE Priority - DnD Active - Number of Units With Festering Wound : " .. tostring(state.FesteringWoundCount))
                            return true
                        end
                    end
                    if state.CurrentRunesAvailable > 0 then
                        if game_api.hasTalentEntry(talents.ScourgeStrikeEntryID) and
                            not game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and state.ScourgeOrClawCanCast then
                            game_api.castSpell(spells.ScourgeStrike)
                            API.Debug("ScourgeStrike Casted Spell -- AoE Priority - DnD Active - Number of Units With Festering Wound : " .. tostring(state.FesteringWoundCount))
                            return true
                        end
                    end
                end

                if not TargetHasAura(auras.FesteringWound) and state.FesteringWoundCount > 0 then
                    if state.FesteringUnitTarget ~= nil then
                        if state.ScourgeOrClawCanCast then
                            game_api.castSpellOnTarget(state.ScourgeOrClaw, state.FesteringUnitTarget)
                            API.Debug("Scourge or Claw on Non-Target Unit to Pop Festering Wound - DnD Active - Number of Units With Festering Wound : " .. tostring(state.FesteringWoundCount))
                            return true
                        end
                    end
                end
                if state.HostileUnitCount > 7 then
                    if API.PlayerHasBuff(auras.SuddenDoom) and API.CanCast(spells.Epidemic) and
                        state.CurrentRunesAvailable > 0 then
                        game_api.castSpell(spells.Epidemic)
                        API.Debug("Epidemic Casted - AoE - In DnD With no Festering Wounds - DnD Active")
                        return true
                    end
                end

                if state.FesteringWoundCount == 0 then
                    if state.CurrentRunicPower >= 30 and API.CanCast(spells.Epidemic) and state.CurrentRunesAvailable <
                        2 and state.CurrentRunesAvailable > 0 then
                        game_api.castSpell(spells.Epidemic)
                        API.Debug("Epidemic Casted - AoE - In DnD With no Festering Wounds")
                        return true
                    end
                end
                if state.CurrentRunicPower >= 30 and API.CanCast(spells.Epidemic) and state.CurrentRunesAvailable > 0 then
                    game_api.castSpell(spells.Epidemic)
                    API.Debug("Epidemic Casted - AoE - In DnD")
                    return true
                end
                if state.ScourgeOrClawCanCast then
                    game_api.castSpell(state.ScourgeOrClaw)
                    API.Debug("Scourge Strike or Claw Filler - AoE - DnD")
                    return true
                end
            end
            if API.timeToDieGroup() >= 10 then
                if API.CanCast(spells.UnholyBlight) and state.CurrentRunesAvailable > 0 then
                    game_api.castSpell(spells.UnholyBlight)
                    API.Debug("Unholy Blight - TTD Greater than 10 Seconds - AoE")
                end
            end
            if game_api.isOnCooldown(spells.UnholyBlight) and not API.PlayerHasBuff(auras.UnholyBlight) then
                if state.VirulentPlaugeCount ~= state.HostileUnitCount then
                    if state.CurrentRunesAvailable > 0 and API.CanCast(spells.Outbreak) then
                        game_api.castSpell(spells.Outbreak)
                        API.Debug("Outbreak Casted - Unholy Blight on CD and no Buff")
                        return true
                    end
                end
            end
            if API.CanCast(spells.DarkTransformation) then
                game_api.castSpell(spells.DarkTransformation)
                API.Debug("Dark Transformation - AoE Check")
                return true
            end
            if hasPetWithDarkTransformation() then
                if API.CanCast(spells.EmpowerRuneWeapon) then
                    game_api.castSpell(spells.EmpowerRuneWeapon)
                    API.Debug("Empower Rune Weapon Casted - AoE ")
                    return true
                end
                if API.CanCast(spells.UnholyAssault) then
                    game_api.castSpell(spells.UnholyAssault)
                    API.Debug("UnholyAssault Casted Spell -- AoE")
                    return true
                end
            end
            if state.LowestStackFesteringUnit ~= nil then
                if API.CanCast(spells.Apocalypse) then
                    game_api.castSpellOnTarget(spells.Apocalypse, state.LowestStackFesteringUnit)
                    API.Debug("Apoc on Lowest Stack Count of Festering Wound")
                    return true
                end
            end
            if state.HighestStackFesteringUnit ~= nil then
                if API.CanCast(spells.VileContagion) then
                    game_api.castSpellOnTarget(spells.VileContagion, state.HighestStackFesteringUnit)
                    API.Debug("Vile Contagion - On Highest Festering Unit")
                    return true
                end
            end
            if state.CurrentRunesAvailable > 1 then
                if API.CanCast(spells.FesteringStrike) and FesteringStrikeLogic then
                    game_api.castSpell(spells.FesteringStrike)
                    API.Debug("FesteringStrike Casted Spell -- AoE Priority")
                    return true
                end
            end
            if state.FesteringTarget ~= nil then
                if API.CanCast(spells.FesteringStrike) and state.CurrentRunesAvailable >= 2 then
                    game_api.castSpellOnTarget(spells.FesteringStrike, state.FesteringTarget)
                    API.Debug("Festering Strike Spread")
                end
            end
            if (state.FesteringWoundCount == state.HostileUnitCount) or
                (API.PlayerHasBuff(auras.DeathAndDecayBuff) and
                    game_api.currentPlayerAuraRemainingTime(auras.DeathAndDecayBuff, true) <= 1000 or
                    not API.PlayerHasBuff(auras.DeathAndDecayBuff)) then
                if API.CanCast(state.DeathAndDecaySpellID) then
                    game_api.castSpell(state.DeathAndDecaySpellID)
                    API.Debug(
                        "Defile/DND Casted - Festering Count = Enemy Count OR DnD Buff about to be gone or is missing - Begin Burst Phase")
                    return true
                end
            end
            if API.CanCast(spells.AbominationLimb) then
                game_api.castSpell(spells.AbominationLimb)
                API.Debug("Abom Limb Casted - AoE")
                return true
            end
            if state.CurrentRunicPower >= 30 and API.CanCast(spells.Epidemic) and state.CurrentRunesAvailable < 2 and
                state.CurrentRunesAvailable > 0 then
                game_api.castSpell(spells.Epidemic)
                API.Debug("Epidemic Casted - AoE")
                return true
            end
        else
            -- Disease AoE Build
            if state.CurrentRunesAvailable > 0 then
                if game_api.hasTalentEntry(talents.ScourgeStrikeEntryID) and
                    not game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and state.ScourgeOrClawCanCast and
                    game_api.hasTalentEntry(talents.PlagueBringerEntryID) and
                    (not API.PlayerHasBuff(auras.Plaugebringer) or API.PlayerHasBuff(auras.Plaugebringer) and
                        game_api.currentPlayerAuraRemainingTime(auras.Plaugebringer, true) <= 750) then
                    game_api.castSpell(spells.ScourgeStrike)
                    API.Debug("Scourge Strike - Apply Plaguebringer or Refresh - AoE")
                    return true
                end
            end
            if API.timeToDieGroup() >= 10 then
                if API.CanCast(spells.UnholyBlight) and state.CurrentRunesAvailable > 0 then
                    game_api.castSpell(spells.UnholyBlight)
                    API.Debug("Unholy Blight - TTD Greater than 10 Seconds - AoE")
                end
            end
            if game_api.isOnCooldown(spells.UnholyBlight) and not API.PlayerHasBuff(auras.UnholyBlight) then
                if state.VirulentPlaugeCount ~= state.HostileUnitCount then
                    if state.CurrentRunesAvailable > 0 and API.CanCast(spells.Outbreak) then
                        game_api.castSpell(spells.Outbreak)
                        API.Debug("Outbreak Casted - Unholy Blight on CD and no Buff")
                        return true
                    end
                end
            end
            if API.CanCast(spells.DarkTransformation) then
                game_api.castSpell(spells.DarkTransformation)
                API.Debug("Dark Transformation - AoE Check")
                return true
            end
            if hasPetWithDarkTransformation() then
                if API.CanCast(spells.EmpowerRuneWeapon) then
                    game_api.castSpell(spells.EmpowerRuneWeapon)
                    API.Debug("Empower Rune Weapon Casted")
                    return true
                end
                if API.CanCast(spells.UnholyAssault) then
                    game_api.castSpell(spells.UnholyAssault)
                    API.Debug("Unholy Assualt Casted - AoE Check")
                    return true
                end
            end
            if state.HighestStackFesteringUnit ~= nil then
                if API.CanCast(spells.Apocalypse) then
                    game_api.castSpellOnTarget(spells.Apocalypse, state.HighestStackFesteringUnit)
                    API.Debug("Apoc Casted on Unit With Highest Festering Wound Stack")
                    return true
                end
            end
            if state.DnDCanCast and game_api.hasTalentEntry(talents.DefileEntryID) and
                (not API.PlayerHasBuff(auras.DefileBuff) or API.PlayerHasBuff(auras.DefileBuff) and
                    game_api.currentPlayerAuraRemainingTime(auras.DefileBuff) <= 1000) then
                game_api.castAOESpellOnSelf(spells.Defile)
                API.Debug("Defile Casted - Defile Buff Not Present or About to Fall Off")
                return true
            end
            if API.PlayerHasBuff(auras.SuddenDoom) or state.CurrentRunicPower >= 95 then
                if API.CanCast(spells.Epidemic) then
                    game_api.castSpell(spells.Epidemic)
                    API.Debug("Epidemic Casted - AoE - Sudden Doom or Close to Max Runic Power")
                    return true
                end
            end
            if state.FesteringWoundCount >= 1 and API.PlayerHasBuff(auras.DeathAndDecayBuff) then
                if state.ScourgeOrClawCanCast and not game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and
                    game_api.unitAuraStackCount(state.currentPlayer, auras.FesterMight, true) < 20 then
                    game_api.castSpell(state.ScourgeOrClaw)
                    API.Debug("Scourge Strike or Claw - Festermight < 20 and in DnD/Defile")
                    return true
                end
            end
            if API.CanCast(spells.AbominationLimb) then
                game_api.castSpell(spells.AbominationLimb)
                API.Debug("Abom Limb Casted - AoE")
                return true
            end
            if state.CurrentRunicPower >= 30 and API.CanCast(spells.Epidemic) and state.CurrentRunesAvailable < 2 and
                state.CurrentRunesAvailable > 0 then
                game_api.castSpell(spells.Epidemic)
                API.Debug("Epidemic Casted - AoE")
                return true
            end
            if state.CurrentRunesAvailable > 1 then
                if API.CanCast(spells.FesteringStrike) and FesteringStrikeLogic then
                    game_api.castSpell(spells.FesteringStrike)
                    API.Debug("FesteringStrike Casted Spell -- AoE Priority")
                    return true
                end
            end
            if state.FesteringTarget ~= nil then
                if API.CanCast(spells.FesteringStrike) and state.CurrentRunesAvailable >= 2 then
                    game_api.castSpellOnTarget(spells.FesteringStrike, state.FesteringTarget)
                    API.Debug("Festering Strike Spread")
                end
            end
            if state.ScourgeOrClawCanCast and state.CurrentRunesAvailable > 0 then
                game_api.castSpell(state.ScourgeOrClaw)
                API.Debug("Scourge Strike or Claw Filler")
                return true
            end
        end
    end

end

--[[
    Run on eatch engine tick if game has focus and is not loading
]]
function OnUpdate()

    StateUpdate()

    --  API.Debug("Rune Count " .. tostring(state.HostileUnitCount) .. " Can Cast Rune Spell " .. tostring(game_api.getToggle(settings.AoE) and state.HostileUnitCount >= 3))
    -- API.Debug("Death Coil Check" .. tostring(state.DeathCoilCount))

    if game_api.getToggle("Pause") then
        return
    end

    if not game_api.isSpec(137007) then
        API.Debug("Not in Unholy Spec")
        return true
    end

    SoulReaperLogic = state.currentTargetHpPercent < 35 or TimeToReachHealth(34) < 5
    DeathCoilLogicSuddenDoom = API.PlayerHasBuff(auras.SuddenDoom) or state.CurrentRunicPower >= 80
    ClawingShadowsLogicRottenTouch = game_api.hasTalentEntry(96313) and game_api.unitHasAura(state.currentTarget, auras.RottenTouch, true) and
                                         API.PlayerHasBuff(auras.FesteringWound) > 0
    DeathCoilLogicDeathRot = state.CurrentRunicPower >= 30 and game_api.hasTalentEntry(96292) and
                                 (TargetHasAura(auras.DeathRot) and
                                     (game_api.unitAuraElapsedTime(state.currentTarget, auras.DeathRot, true) <= 1250 or
                                         game_api.unitAuraStackCount(state.currentPlayer, auras.DeathRot, true) < 10) or
                                     not TargetHasAura(auras.DeathRot))
    OutbreakLogic = not game_api.unitHasAura(state.currentTarget, auras.VirulentPlagueDebuff, true)
    DeathCoilLogicSummonGargoyle = state.CurrentRunicPower >= 30 and (hasPetGarg() or (state.CurrentRunesAvailable < 3)) -- not letting me use CurrentRunesAvailable and summon Pet 27829
    ScourgeStrikeLogic = hasPetMagus() and TargetHasAura(auras.FesteringWound)
    DeathandDecayLogic = hasPetGarg() -- pet check 27829n
    FesteringStrikeLogic = TargetHasAura(auras.FesteringWound) and
                               game_api.unitAuraStackCount(state.currentTarget, auras.FesteringWound, true) <= 3 or
                               not TargetHasAura(auras.FesteringWound)
    ClawingShadowsLogicFestering = TargetHasAura(auras.FesteringWound) and
                                       game_api.unitAuraStackCount(state.currentTarget, auras.FesteringWound, true) > 3
    DefileLogic = hasPetMagus() and hasPetGarg() -- and has pet 27829
    AutoAoE = game_api.getToggle(settings.AoE) and state.HostileUnitCount >= 3
    DeathCoilCheck = state.CurrentRunicPower >= 30 or API.PlayerHasBuff(auras.SuddenDoom)
    DeathCoilLogicInCooldowns = state.DeathCoilCount < 3

    if game_api.currentPlayerIsCasting() or game_api.currentPlayerIsMounted() or game_api.currentPlayerIsChanneling() or
        game_api.isAOECursor() then
        return
    end

    if not state.PlayerIsInCombat then
        if not hasPet() then
            if API.CanCast(spells.RaiseDead) then
                game_api.castSpell(spells.RaiseDead)
                API.Debug("Raise Dead -- No Pet OOC")
                return true
            end
        end
    end

    if game_api.unitInCombat(state.currentPlayer) and game_api.getSetting(settings.autoRetarget) then
        if state.currentTarget == "00" or
            (game_api.unitHealthPercent(state.currentTarget) == 0 and state.currentTarget ~= "00") or
            not game_api.isFacing(state.currentTarget) or game_api.distanceToUnit(state.currentTarget) > 4.5 then
            local newTarget = UnitWithHighestHealth()
            if newTarget then
                print("New Target")
                game_api.setTarget(newTarget)
            end
        end
    end

    if state.TargetCheck then
        if Interrupt() then
            return true
        end
        if Defense() then
            return true
        end
        if API.dpsTrinket(auras.EmpowerRuneWeaponBuff, false) then
            return true
        end
        if API.useConsume(auras.EmpowerRuneWeaponBuff, false, false) then
            return true
        end
        if DPS() then
            return true
        end
    end

end
