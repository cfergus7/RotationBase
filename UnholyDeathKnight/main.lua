game_api = require("lib")
spells = require ("spells")
talents = require ("talents")
auras = require ("auras")
settings = require ("settings")
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
local BloodlustAuras = {
    2825,    -- Shaman: Bloodlust (Horde)
    32182,   -- Shaman: Heroism (Alliance)
    80353,   -- Mage: Time Warp
    90355,   -- Hunter: Ancient Hysteria
    160452,  -- Hunter: Netherwinds
    264667,  -- Hunter: Primal Rage
    390386,  -- Evoker: Fury of the Aspects
    -- Drums
    35475,   -- Drums of War (Cata)
    35476,   -- Drums of Battle (Cata)
    146555,  -- Drums of Rage (MoP)
    178207,  -- Drums of Fury (WoD)
    230935,  -- Drums of the Mountain (Legion)
    256740,  -- Drums of the Maelstrom (BfA)
    309658,  -- Drums of Deathly Ferocity (SL)
    381301,  -- Feral Hide Drums (DF)
}
function PlayerHasAnyAuraUp(spellIDs)
    for _, id in ipairs(spellIDs) do
        if game_api.currentPlayerHasAura(id, false)  then
            return true
        end
    end
    return false
end

function getCombatUnits()
    local units = game_api.getHostileUnits()
    local combatUnits = {}
    local insert = table.insert

    for _, unit in ipairs(units) do
        if API.isInCombatOrHasNpcId(unit, cLists.npcIdList) and
        game_api.unitHealthPercent(unit) > 0 and game_api.isFacing(unit) and (game_api.currentPlayerDistanceFromTarget() <= 40 or game_api.unitNpcID(state.currentTarget)== 44566) and game_api.unitNpcID(unit) ~= 125977 and game_api.unitNpcID(unit) ~= 100991  and game_api.unitNpcID(unit) ~= 174773  then
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

                if isKick and API.CanCast(spells.Counterspell) and game_api.distanceToUnit(unit) <= 30 and
                    game_api.isFacing(unit) and castPercentage >= math.random(25, 75) then
                    API.Debug(
                        "Casting Counterspell on " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") ..
                            " Unit")
                    game_api.castSpellOnTarget(spells.Counterspell, unit)
                    return true
                end
                if ((isKick and game_api.isOnCooldown(spells.Counterspell)) or isStun) and
                    API.CanCast(spells.DragonsBreath) and game_api.distanceToUnit(unit) <= 11 and
                    game_api.isFacing(unit) and castPercentage >= math.random(25, 75) then
                    API.Debug("Casting DragonsBreath on " ..
                                  (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                    game_api.castSpell(spells.DragonsBreath)
                    return true
                end
                if game_api.isOnCooldown(spells.DragonsBreath) then
                    if ((isKick and game_api.isOnCooldown(spells.Counterspell)) or isStun) and
                        API.CanCast(spells.BlastWave) and game_api.distanceToUnit(unit) <= 7 and game_api.isFacing(unit) and
                        castPercentage >= math.random(25, 75) then
                        API.Debug("Casting DragonsBreath on " ..
                                      (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                        game_api.castSpell(spells.BlastWave)
                        return true
                    end
                end
            end
        end
    end
    return false
end

function Defense()
 --Applied later
end

function UnitWithHighestHealth()
    local highestHealthUnit = nil
    local highestEffectiveHealth = 0 -- Initialize with 0 for comparison
    for _, unit in ipairs(state.getUnits) do
        if game_api.isFacing(unit) and game_api.distanceToUnit(unit) <= 40 and game_api.isUnitHostile(unit,true) and API.isInCombatOrHasNpcId(unit,cLists.npcIdList) then
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

function  StateUpdate()
    API.RefreshFunctionsState();
    state.currentPower = game_api.getPower(0) /5 --runes
    state.currentMaxPower = game_api.getMaxPower(0) /5 --runes
    state.currentTarget = game_api.getCurrentUnitTarget()
    state.currentTargetHpPercent = game_api.unitHealthPercent(state.currentTarget)
    state.currentPlayer = game_api.getCurrentPlayer()
    state.currentHpPercent = game_api.unitHealthPercent(state.currentPlayer)
    state.playerHealth = game_api.unitHealthPercent(state.currentPlayer)


    state.TargetCheck = game_api.unitInCombat(state.currentPlayer) and state.currentTarget ~= 00 and functions.isInCombatOrHasNpcId(state.currentTarget, cLists.npcIdList) and (game_api.currentPlayerDistanceFromTarget() <=6 or  game_api.unitNpcID(state.currentTarget)== 44566) and game_api.isFacing(state.currentTarget) and game_api.isTargetHostile(true) and game_api.unitHealthPercent(state.currentTarget) > 0     state.getUnits = game_api.getUnits()
    state.PlayerIsInCombat = game_api.unitInCombat(state.currentPlayer)
    state.HostileUnits = getCombatUnits()
    state.HostileUnitCount = API.CountUnitsInRange(40, state.HostileUnits)


    state.afflictedUnits = game_api.getUnitsByNpcId(204773)
    state.incorporealUnits = game_api.getUnitsByNpcId(204560)
    
    state.CurrentCastID = game_api.unitCastingSpellID(state.currentPlayer) 
    state.Pets = game_api.getUnitsByNpcId(26125)
    state.Garg = game_api.getUnitsByNpcId(27829)
    state.Magus = game_api.getUnitsByNpcId(163366)
    state.CurrentRunicPower = game_api.getPower(1)/10
    state.CurrentRunesAvailable = game_api.getRuneCount()

    state.DeathAndDecaySpellID = game_api.hasTalentEntry(talents.DefileEntryID) and spells.Defile or spells.DeathAndDecay
    state.DnDCanCast = not game_api.isOnCooldown(state.DeathAndDecaySpellID)
    state.ScourgeOrClaw = game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and spells.ClawingShadows or spells.ScourgeStrike
    state.ScourgeOrClawCanCast = not game_api.isOnCooldown(state.ScourgeOrClaw)

    
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


local AutoAoE, SoulReaperLogic, DeathCoilLogicSuddenDoom, ClawingShadowsLogicRottenTouch, DeathCoilLogicDeathRot, OutbreakLogic, DeathCoilLogicSummonGargoyle, ScourgeStrikeLogic, DeathandDecayLogic, FesteringStrikeLogic, ClawingShadowsLogicFestering, DefileLogic

function hasPet()
    local Pets = state.Pets
    for _, Pet in pairs(Pets) do
        if game_api.unitOwner(Pet) == state.currentPlayer and game_api.distanceToUnit(Pet) <= 40 then
            if game_api.unitHealthPercent(Pet) == 0 then
                return false
            end
        end
    end
    return true
end
function hasPetGarg()
    local Pets = state.Garg
    for _, Pet in pairs(Pets) do
        if game_api.unitOwner(Pet) == state.currentPlayer and game_api.distanceToUnit(Pet) <= 40 then
            if game_api.unitHealthPercent(Pet) == 0 then
                return false
            end
        end
    end
    return true
end
function hasPetMagus()
    local Pets = state.Magus
    for _, Pet in pairs(Pets) do
        if game_api.unitOwner(Pet) == state.currentPlayer and game_api.distanceToUnit(Pet) <= 40 then
            if game_api.unitHealthPercent(Pet) == 0 then
                return false
            end
        end
    end
    return true
end

function DPS()

    SoulReaperLogic = state.currentTargetHpPercent < 35
    DeathCoilLogicSuddenDoom = API.PlayerHasBuff(auras.SuddenDoom) or state.CurrentRunicPower >= 80
    ClawingShadowsLogicRottenTouch = API.PlayerHasBuff(auras.RottenTouch) and API.PlayerHasBuff(auras.FesteringWound) > 0
    DeathCoilLogicDeathRot = game_api.currentPlayerAuraRemainingTime(auras.DeathRot, true) <= 1250 or game_api.unitAuraStackCount(state.currentPlayer, auras.DeathRot, true) < 10
    OutbreakLogic = TimeToReachHealth(34) < 5
    DeathCoilLogicSummonGargoyle = hasPet() or (state.CurrentRunesAvailable < 3)  -- not letting me use CurrentRunesAvailable and summon Pet 27829
    ScourgeStrikeLogic = API.PlayerHasBuff(auras.MagusoftheDead) and API.PlayerHasBuff(auras.FesteringWound) > 0
    DeathandDecayLogic = hasPet()-- pet check 27829
    FesteringStrikeLogic = API.PlayerHasBuff(auras.FesteringWound) < 3
    ClawingShadowsLogicFestering = API.PlayerHasBuff(auras.FesteringWound) > 3
    DefileLogic = API.PlayerHasBuff(auras.MagusoftheDead) and hasPet() -- and has pet 27829
    AutoAoE = game_api.getToggle(settings.AoE) and state.HostileUnitCount >= 3

    if state.PlayerIsInCombat and state.TargetCheck and (state.HostileUnitCount < 3 or not AutoAoE) then
        
        ------------- Cooldown priority ================
        if game_api.getToggle(settings.Cooldown) then

            if not hasPet() then
                if API.CanCast(spells.RaiseDead) then
                    game_api.castSpell(spells.RaiseDead)
                    API.Debug("RaiseDead Casted -- Cooldown Priority")
                    return true
                end
            end

            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if API.CanCast(spells.ArmyoftheDead)  then
                    game_api.castSpell(spells.ArmyoftheDead)
                    API.Debug("ArmyoftheDead Casted Spell -- Cooldown Priority")
                    return true
                end       
            end

            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if API.CanCast(spells.UnholyBlight) and game_api.isOnCooldown(spells.ArmyoftheDead) then
                    game_api.castSpell(spells.UnholyBlight)
                    API.Debug("Unholy Blight Casted Spell -- Cooldown Priority")
                    return true
                end                
            end

            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if state.DnDCanCast  then
                    game_api.castAOESpellOnSelf(state.DeathAndDecaySpellID)
                    API.Debug("DeathandDecay Casted Spell -- Cooldown Priority")
                    return true
                end         
            end

            if API.CanCast(spells.DarkTransformation) and game_api.isOnCooldown(spells.ArmyoftheDead) then
                game_api.castSpell(spells.DarkTransformation)
                API.Debug("DarkTransformation Casted Spell -- Cooldown Priority")
                return true
            end    

            if API.CanCast(spells.SummonGargoyle)  then
                game_api.castSpell(spells.SummonGargoyle)
                API.Debug("SummonGargoyle Casted Spell -- Cooldown Priority")
                return true
            end

            if API.CanCast(spells.DeathCoil) then
                game_api.castSpell(spells.DeathCoil)
                API.Debug(" Death Coil Casted Spell -- CoolDown Priority")
                return true
            end

            if API.CanCast(spells.DeathCoil) then
                game_api.castSpell(spells.DeathCoil)
                API.Debug(" Death Coil Casted Spell -- CoolDown Priority")
                return true
            end

            if API.CanCast(spells.DeathCoil) then
                game_api.castSpell(spells.DeathCoil)
                API.Debug(" Death Coil Casted Spell -- CoolDown Priority")
                return true
            end

            if API.CanCast(spells.UnholyAssault)  then
                game_api.castSpell(spells.UnholyAssault)
                API.Debug("UnholyAssault Casted Spell -- Cooldown Priority")
                return true
            end

            if API.CanCast(spells.EmpowerRuneWeapon)  then
                game_api.castSpell(spells.EmpowerRuneWeapon)
                API.Debug("EmpowerRuneWeapon Casted Spell -- Cooldown Priority")
                return true
            end

            -- Trinkets go here (I will help with that one) -- Freddy

            if API.CanCast(spells.Apocalypse)  then
                game_api.castSpell(spells.Apocalypse)
                API.Debug("Apocalypse Casted Spell -- Cooldown Priority")
                return true
            end
        end
                -- ST Coil Build

            if state.CurrentRunesAvailable > 9 then
                if API.CanCast(spells.SoulReaper) and SoulReaperLogic then
                    game_api.castSpell(spells.SoulReaper)
                    API.Debug("SoulReaper Casted Spell -- DPS Priority")
                    return true
                end
            end

            if API.CanCast(spells.DeathCoil)and DeathCoilLogicSuddenDoom then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority")
                return true
            end

            -- Clawing Shadows Needs Speical ID Check due to Talent (Replaces Scourge Strike)
            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and  state.ScourgeOrClawCanCast and ClawingShadowsLogicRottenTouch then
                    game_api.castSpell(spells.ClawingShadows)
                    API.Debug("ClawingShadows Casted Spell -- DPS Priority")
                    return true
                end
            end

            if API.CanCast(spells.DeathCoil) and DeathCoilLogicDeathRot then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority")
                return true
            end

            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if API.CanCast(spells.Outbreak) and OutbreakLogic then
                    game_api.castSpell(spells.Outbreak)
                    API.Debug("Outbreak Casted Spell -- DPS Priority")
                    return true
                end
            end

            if API.CanCast(spells.DeathCoil) and DeathCoilLogicSummonGargoyle then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority")
                return true
            end

            -- Scourge Strike Extra Needed due to Talent
            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if game_api.hasTalentEntry(talents.ScourgeStrikeEntryID) and state.ScourgeOrClawCanCast and ScourgeStrikeLogic then
                    game_api.castSpell(spells.ScourgeStrike)
                    API.Debug("ScourgeStrike Casted Spell -- DPS Priority")
                    return true
                end
            end

            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if state.DnDCanCast and DeathandDecayLogic then
                    game_api.castSpell(state.DeathAndDecaySpellID)
                    API.Debug("DeathandDecay Casted Spell -- DPS Priority")
                    return true
                end              
            end

            if state.CurrentRunesAvailable > 1 or state.CurrentRunicPower > 20 then
                if API.CanCast(spells.FesteringStrike) and FesteringStrikeLogic then
                    game_api.castSpell(spells.FesteringStrike)
                    API.Debug("FesteringStrike Casted Spell -- DPS Priority")
                    return true
                end     
            end

            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and state.ScourgeOrClawCanCast and ClawingShadowsLogicFestering then
                    game_api.castSpell(spells.ClawingShadows)
                    API.Debug("ClawingShadows Casted Spell -- DPS Priority")
                    return true
                end          
            end

            if API.CanCast(spells.DeathCoil) then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority")
                return true
            end

                -- Defile Start
            if not hasPet() then
                if API.CanCast(spells.RaiseDead) then
                    game_api.castSpell(spells.RaiseDead)
                    API.Debug("RaiseDead Casted -- DPS Priority")
                    return true
                end
            end

            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if API.CanCast(spells.SoulReaper) and SoulReaperLogic then
                    game_api.castSpell(spells.SoulReaper)
                    API.Debug("SoulReaper Casted Spell -- DPS Priority")
                    return true
                end              
            end

            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if game_api.hasTalentEntry(talents.DefileEntryID) and state.DnDCanCast and DefileLogic then
                    game_api.castSpell(spells.Defile)
                    API.Debug("Defile Casted Spell -- DPS Priority")
                    return true
                end               
            end

            if API.CanCast(spells.DeathCoil)and DeathCoilLogicSuddenDoom then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority")
                return true
            end

            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and state.ScourgeOrClawCanCast and ClawingShadowsLogicRottenTouch then
                    game_api.castSpell(spells.ClawingShadows)
                    API.Debug("ClawingShadows Casted Spell -- DPS Priority")
                    return true
                end                
            end

            if API.CanCast(spells.DeathCoil) and DeathCoilLogicDeathRot then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority")
                return true
            end

            if API.CanCast(spells.DeathCoil) and DeathCoilLogicSummonGargoyle then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority")
                return true
            end

            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if game_api.hasTalentEntry(talents.ScourgeStrikeEntryID) and state.ScourgeOrClawCanCast and ScourgeStrikeLogic then
                    game_api.castSpell(spells.ScourgeStrike)
                    API.Debug("ScourgeStrike Casted Spell -- DPS Priority")
                    return true
                end               
            end
            -- Festering Strike Talent Change
            if state.CurrentRunesAvailable > 1 or state.CurrentRunicPower > 20 then
                if API.CanCast(spells.FesteringStrike) and FesteringStrikeLogic then
                    game_api.castSpell(spells.FesteringStrike)
                    API.Debug("FesteringStrike Casted Spell -- DPS Priority")
                    return true
                end          
            end

            if state.CurrentRunesAvailable > 0 or state.CurrentRunicPower > 10 then
                if game_api.hasTalentEntry(talents.ClawingShadowsEntryID) and state.ScourgeOrClawCanCast and ClawingShadowsLogicFestering then
                    game_api.castSpell(spells.ClawingShadows)
                    API.Debug("ClawingShadows Casted Spell -- DPS Priority")
                    return true
                end               
            end

            if API.CanCast(spells.DeathCoil) then
                game_api.castSpell(spells.DeathCoil)
                API.Debug("DeathCoil Casted Spell -- DPS Priority")
                return true
            end
        end
end
    
--[[
    Run on eatch engine tick if game has focus and is not loading
]]
function OnUpdate()



    if game_api.getToggle("Pause") then
        return
    end

    if game_api.currentPlayerIsCasting() or game_api.currentPlayerIsMounted() or game_api.currentPlayerIsChanneling() or game_api.isAOECursor() then
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

end