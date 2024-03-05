game_api : require("lib")
spells : require("spells")
talents : require("talents")
auras : require("auras")
settings : require("settings")
API : require("common_functions")
cLists : require("common_lists")
state = {}

--[[
    Create your variable and toggle here
]]
function OnInit()
    settings.createSettings()
    print("Sample rotation !")
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

    state.currentTarget = game_api.getCurrentUnitTarget()
    state.currentTargetHpPercent = game_api.unitHealthPercent(state.currentTarget)
    state.currentPlayer = game_api.getCurrentPlayer()
    state.currentHpPercent = game_api.unitHealthPercent(state.currentPlayer)
    state.playerHealth = game_api.unitHealthPercent(state.currentPlayer)
    state.TargetCheck = game_api.unitInCombat(state.currentPlayer) and state.currentTarget ~= 00 and functions.isInCombatOrHasNpcId(state.currentTarget, cLists.npcIdList) and (game_api.currentPlayerDistanceFromTarget() <=6 or  game_api.unitNpcID(state.currentTarget)== 44566) and game_api.isFacing(state.currentTarget) and game_api.isTargetHostile(true) and game_api.unitHealthPercent(state.currentTarget) > 0     state.getUnits = game_api.getUnits()
    state.PlayerIsInCombat = game_api.unitInCombat(state.currentPlayer)
    state.HostileUnits = getCombatUnits()
    state.HostileUnitCount = API.CountUnitsInRange(10, state.HostileUnits)
    state.afflictedUnits = game_api.getUnitsByNpcId(204773)
    state.incorporealUnits = game_api.getUnitsByNpcId(204560)
    state.CurrentCastID = game_api.unitCastingSpellID(state.currentPlayer)
    state.CurrentRunicPower = game_api.getPower(1)/10
    state.CurrentRunesAvailable = game_api.getRuneCount()
    if game_api.hasTalentEntry(96178) or game_api.hasTalentEntry(96229) then
        state.EmpowerRuneWeaponCharges = 1
    end
    if game_api.hasTalentEntry(96178) and game_api.hasTalentEntry(96229) then
        state.EmpowerRuneWeaponCharges = 2
    end


end

local AutoAoE, FrostStrikeLogic, BreathofSindragosaLogic, SoulReaperLogic, ObliterateLogic, HowlingBlastLogic, ObliterateLogic2, HornofWinterLogic, FrostStrikeLogicActiveBreathCheck

function DPS()

    AutoAoE = game_api.getToggle(settings.AoE) and state.HostileUnitCount >= 3
    FrostStrikeLogic = API.PlayerHasBuff(auras.IcyTalonsBuff) and API.PlayerHasBuff(auras.UnleashedFrenzy) and game_api.currentPlayerAuraRemainingTime(auras.IcyTalonsBuff, true) <= 1250 and game_api.currentPlayerAuraRemainingTime(auras.UnleashedFrenzy, true) <= 1250
    BreathofSindragosaLogic = state.CurrentRunicPower >= 60
    SoulReaperLogic = state.currentTargetHpPercent < 35 and state.CurrentRunicPower > 40
    ObliterateLogic = API.PlayerHasBuff(auras.KillingMachineBuff) or API.PlayerHasBuff(auras.PillarofFrostBuff)
    HowlingBlastLogic = API.PlayerHasBuff(auras.Ryme) and state.CurrentRunicPower >39
    ObliterateLogic2 = state.CurrentRunicPower <=100
    HornofWinterLogic = state.CurrentRunicPower <=95
    FrostStrikeLogicActiveBreathCheck = API.PlayerHasBuff(auras.BreathofSindragosa)

    --Opener Down the Road


    --Base Rotation BreathofSindragosa



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
            if API.CanCast(spells.DeathAndDecay) then
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


        --Base Rotation Obliteration

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
            if API.CanCast(spells.DeathAndDecay) then
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


            --Obliterate AoE

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



    if game_api.getToggle("Pause") then
        return
    end

    if game_api.currentPlayerIsCasting() or game_api.currentPlayerIsMounted() or game_api.currentPlayerIsChanneling() or game_api.isAOECursor() then
        return
    end


end