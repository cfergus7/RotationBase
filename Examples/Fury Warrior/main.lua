game_api = require("lib")
spells = require("spells")
talents = require("talents")
auras = require("auras")
settings = require("settings")
functions = require("common_functions")
cLists = require("common_lists")
state = {}

--[[
    Create your variable and toggle here
]]
function OnInit()
    settings.createSettings()
    print("Fury Warrior Zug Zug!")

end


function getCombatUnitsCount()
    local units = game_api.getHostileUnits()
    local combatUnits = {}
    local insert = table.insert

    for _, unit in ipairs(units) do
        if functions.IsInRange(10, unit) and
            game_api.unitHealthPercent(unit) > 0 and
            functions.isInCombatOrHasNpcId(unit,cLists.npcIdList) and not functions.ignoreUnit(unit) and not functions.hasImmunity(unit) then
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
        if functions.isInCombatOrHasNpcId(unit, cLists.npcIdList) and
        game_api.unitHealthPercent(unit) > 0 and not functions.ignoreUnit(unit) and not functions.hasImmunity(unit)  then
            insert(combatUnits, unit)
        end
    end
    return combatUnits
end


function StateUpdate()
    state.currentPower = game_api.getPower(0) /10 --rage
    state.currentPowerPercent = functions.convertPowerToPercentage(0) --rage

    state.currentMaxPower = game_api.getMaxPower(0) /10 --rage
    state.currentTarget = game_api.getCurrentUnitTarget()
    state.currentTargetHpPercent = game_api.unitHealthPercent(state.currentTarget)
    state.currentPlayer = game_api.getCurrentPlayer()
    state.currentHpPercent = game_api.unitHealthPercent(state.currentPlayer)
    state.playerHealth = game_api.unitHealthPercent(state.currentPlayer)
    state.getUnits = getCombatUnits()
    state.getPartyUnits = game_api.getPartyUnits()
    state.currentPlayerHealth = game_api.unitHealth(state.currentPlayer)
    state.currentTargetHealth = game_api.unitHealth(state.currentTarget)
    state.currentTargetHealthMax = game_api.unitMaxHealth(state.currentTarget)
    state.mouseoverUnit = game_api.getCurrentUnitMouseOver()
    state.unitTarget = game_api.unitTarget(state.currentTarget)
    state.spellReflect = game_api.currentPlayerHasAura(auras.spellReflect, true)
    if game_api.hasTalentEntry(112259) then -- improved raging blow
        state.ragingBlowCount = 2
    else
        state.ragingBlowCount = 1
    end
    state.TargetCheck = game_api.unitInCombat(state.currentPlayer) and state.currentTarget ~= 00 and functions.isInCombatOrHasNpcId(state.currentTarget, cLists.npcIdList) and (game_api.currentPlayerDistanceFromTarget() <=6 or  game_api.unitNpcID(state.currentTarget)== 44566) and game_api.isFacing(state.currentTarget) and game_api.isTargetHostile(true) and game_api.unitHealthPercent(state.currentTarget) > 0 
    state.iris = game_api.unitHasAura(state.currentTarget,auras.focusingIris,false)
    state.unitsInRange = getCombatUnitsCount()
    state.isRaid = game_api.getPartySize() >= 6
    state.avatar = game_api.unitHasAura(state.currentPlayer,auras.avatar, true)
    state.playerLevel = game_api.unitLevel(state.currentPlayer)
    state.enrage = game_api.currentPlayerHasAura(auras.enrage, true)
    state.avatar = game_api.currentPlayerHasAura(auras.avatar, true)
    if game_api.getToggle(settings.forceST) then
        state.unitsInRange = 1
    end
    state.suddenDeath = game_api.unitHasAura(state.currentPlayer,auras.suddenDeath,true)
    state.bloodbathCD = game_api.getCooldownRemainingTime(spells.bloodBath)
    state.meatCleaver = game_api.currentPlayerHasAura(auras.meatCleaver,true)
    state.recklessness = game_api.currentPlayerHasAura(auras.recklessness,true)
    state.enragedRegen = game_api.currentPlayerHasAura(auras.enragedRegen,true) 
    state.rally = game_api.currentPlayerHasAura(auras.rally,true)
    state.nodefensives = not state.enragedRegen and not state.rally
    state.defensiveStance = game_api.currentPlayerHasAura(auras.defensiveStance,true)
    state.berserkerStance = game_api.currentPlayerHasAura(auras.berserkerStance,true)
    state.excuteCD = game_api.getCooldownRemainingTime(spells.execute2)
end



function proactiveDefensives()
    if not game_api.getSetting(settings.proactiveDefensives) then
        return false
    end
    for debuff, _ in pairs(cLists.harmFulDebuff) do
        if game_api.currentPlayerHasAura(debuff, false) then
            if functions.CanCast(spells.spellReflect) then
                print("Using Spell Reflect Proactively Debuff")
                game_api.castSpell(spells.spellReflect)
                return true
            end
        end
    end
    for _, unit in ipairs(state.getUnits) do
        if game_api.unitIsCasting(unit) and not game_api.unitIsChanneling(unit) then
            unitCasting = true
            castPercentage =game_api.unitCastPercentage(unit)
        end
        if game_api.unitIsChanneling(unit) then
            unitCasting = true
            castPercentage =game_api.unitChannelPercentage(unit)
        end
        if unitCasting then
            local spellId = game_api.unitCastingSpellID(unit) 
            local channelId = game_api.unitChannelingSpellID(unit)
            if functions.CanCast(spells.spellReflect) then
                if game_api.unitTarget(unit) == state.currentPlayer then
                    if cLists.reflectable[spellId] then
                        print("Using Spell Reflect Proactively")
                        game_api.castSpell(spells.spellReflect)
                        return true
                    end
                end
            end
            if state.nodefensives and cLists.aoeIncoming[spellId] or cLists.aoeIncoming[channelId] then
                if functions.CanCast(spells.rally) then
                    print("Using Rally Proactive AOE")
                    game_api.castSpell(spells.rally)
                    return true
                end
                if functions.CanCast(spells.enragedRegeneration) then
                    print("Using Enraged Regen Proactively AOE")
                    game_api.castSpell(spells.enragedRegeneration)
                    return true
                end
            end
            if cLists.aoeIncomingWarriorMagic[spellId] or cLists.aoeIncomingWarriorMagic[channelId] then
                if functions.CanCast(spells.spellReflect) then
                    print("Using Spell Reflect Proactively AOE")
                    game_api.castSpell(spells.spellReflect)
                    return true
                end
            end
        end
    end
    return false
end

local unitCastingStance = false

function stanceDance()
    -- Set unitCastingStance to false initially
    unitCastingStance = false
    
    for _, unit in ipairs(state.getUnits) do
        if game_api.unitIsCasting(unit) and not game_api.unitIsChanneling(unit) then
            unitCastingStance = true
            castPercentage = game_api.unitCastPercentage(unit)
        end
        if game_api.unitIsChanneling(unit) then
            unitCastingStance = true
            castPercentage = game_api.unitChannelPercentage(unit)
        end
    end
    if not unitCastingStance then
        
        if functions.CanCast(spells.berserkerStance) and not state.berserkerStance then
            print("Berserker Stance")
            game_api.castSpell(spells.berserkerStance)
        end
    end

    if unitCastingStance then
        for _, unit in ipairs(state.getUnits) do
            local spellId = game_api.unitCastingSpellID(unit) 
            local channelId = game_api.unitChannelingSpellID(unit)
            if state.nodefensives and (cLists.aoeIncoming[spellId] or cLists.aoeIncoming[channelId]) then
                if not state.defensiveStance and functions.CanCast(spells.defensiveStance) then
                    print("Defensive Stance")
                    game_api.castSpell(spells.defensiveStance) 
                end
            end
        end
    end

    return false
end












function canExecute()
    if ((state.currentTargetHpPercent < 35 and game_api.hasTalent(talents.massacre)) or state.currentTargetHpPercent < 20 or state.suddenDeath) and state.excuteCD <= 250 then
        return true
    end
    return false
end

function Defensive()

    proactiveDefensives()
    if functions.CanCast(spells.impendingVictory) and state.currentHpPercent <= game_api.getSetting(settings.impendingVictory) then
        if game_api.isTargetHostile(true) and game_api.unitHealthPercent(state.currentTarget) > 0 and functions.isInCombatOrHasNpcId(state.currentTarget, cLists.npcIdList) then
            if game_api.isFacing(state.currentTarget) and game_api.currentPlayerDistanceFromTarget() <= 5 then
                print("Using Impending Victory due to Health Threshold")
                game_api.castSpellOnTarget(spells.impendingVictory, state.currentTarget)
                return true
            end
        end
    end
    if functions.CanCast(spells.spellReflect) and not state.spellBlock then
        for auraId, _ in pairs(cLists.tankBustersDebuff) do
            if game_api.unitHasAura(state.currentPlayer,auraId,false) then
                print("Using Spell Reflect Debuff")
                game_api.castSpell(spells.spellReflect)
                return true
            end
        end
    end
    if functions.CanCast(spells.enragedRegeneration) and state.currentHpPercent <= game_api.getSetting(settings.enragedRegeneration) then
        print("Using Enraged Regneration due to Health Threshold")
        game_api.castSpell(spells.enragedRegeneration)
        return true
    end
    return false
end


function OOC()
    if game_api.getSetting(settings.autoEngage) then
        if game_api.isTargetHostile(true) and game_api.unitHealthPercent(state.currentTarget) > 0  then
            if game_api.currentPlayerDistanceFromTarget() <= 15 and game_api.currentPlayerDistanceFromTarget() > 6 then
                if functions.CanCast(spells.charge)  then
                    print("Using Charge for Engage")
                    game_api.castSpellOnTarget(spells.charge,state.currentTarget)
                    return true
                end
            end
        end
    end
    if functions.CanCast(spells.battleShout) then
        local UnitMissingAura = functions.PartyUnitMissingAura(auras.battleShout)
        if UnitMissingAura and not game_api.isUnitHostile(UnitMissingAura,true) then
            print("Using Battle Shout for Buff")
            game_api.castSpell(spells.battleShout)
            return true
        end
    end
    return false
end


function Interrupt()
    if not game_api.getToggle(settings.interrupts) or state.spellReflect then
        return false
    end
    for _, unit in ipairs(state.getUnits) do
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
        local stunPercent = settings.stunPercent 
        local interruptPercent = settings.interruptPercent
        if unitCasting and game_api.getSetting(settings.kickEverything) then
            if functions.CanCast(spells.pummel) and game_api.distanceToUnit(unit) <= 5 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(interruptPercent) then
                print("Casting Pummel on " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpellOnTarget(spells.pummel, unit)
                return true
            end
            if state.playerLevel >= game_api.unitLevel(unit) and not game_api.unitIsBoss(unit) and  game_api.getSetting(settings.useStun) and functions.CanCast(spells.shockwave) and game_api.distanceToUnit(unit) <= 8 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(stunPercent) then
                print("Casting Shockwave " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpell(spells.shockwave)
                return true
            end
            if state.playerLevel >= game_api.unitLevel(unit) and not game_api.unitIsBoss(unit) and game_api.getSetting(settings.useStun) and functions.CanCast(spells.stormBolt) and game_api.distanceToUnit(unit) <= 20 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(stunPercent) then
                print("Casting Storm Bolt on " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpellOnTarget(spells.stormBolt, unit)
                return true
            end
            if state.playerLevel >= game_api.unitLevel(unit) and not game_api.unitIsBoss(unit) and game_api.getSetting(settings.useStun) and functions.CanCast(spells.intimidatingShout) and game_api.distanceToUnit(unit) <= 8 and castPercentage >= game_api.getSetting(stunPercent) then
                print("Casting Intimidating Shout " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpell(spells.intimidatingShout)
                return true
            end
        end
        if unitCasting then
            local isStun = cLists.priorityStunList[spellId] or cLists.priorityStunList[channelId]
            local isKick = cLists.priorityKickList[spellId] or cLists.priorityKickList[channelId] 
            if isKick and functions.CanCast(spells.pummel) and game_api.distanceToUnit(unit) <= 5 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(interruptPercent) then
                print("Casting Pummel on " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpellOnTarget(spells.pummel, unit)
                return true
            end
            if state.playerLevel >= game_api.unitLevel(unit) and not game_api.unitIsBoss(unit) and  (isStun or (game_api.getSetting(settings.useStun) and isKick)) and functions.CanCast(spells.shockwave) and game_api.distanceToUnit(unit) <= 8 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(stunPercent) then
                print("Casting Shockwave " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpell(spells.shockwave)
                return true
            end
            if state.playerLevel >= game_api.unitLevel(unit) and not game_api.unitIsBoss(unit) and  (isStun or (game_api.getSetting(settings.useStun) and isKick)) and functions.CanCast(spells.stormBolt) and game_api.distanceToUnit(unit) <= 20 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(stunPercent) then
                print("Casting Storm Bolt on " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpellOnTarget(spells.stormBolt, unit)
                return true
            end
            if state.playerLevel >= game_api.unitLevel(unit) and not game_api.unitIsBoss(unit) and  (isStun or (game_api.getSetting(settings.useStun) and isKick)) and functions.CanCast(spells.intimidatingShout) and game_api.distanceToUnit(unit) <= 8 and castPercentage >= game_api.getSetting(stunPercent) then
                print("Casting Intimidating Shout " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpell(spells.intimidatingShout)
                return true
            end
        end
    end

    return false
end


function UnitWithHighestHealth()
    local highestHealthUnit = nil
    local highestEffectiveHealth = 0 -- Initialize with 0 for comparison
    for _, unit in ipairs(state.getUnits) do
        if game_api.isFacing(unit) and game_api.distanceToUnit(unit) <= 6 then
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



function dps()
    --actions+=/ravager,if=cooldown.recklessness.remains<3|buff.recklessness.up
    if game_api.getToggle(settings.cooldownsMinor) and functions.CanCast(spells.ravager) then
        if functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
            if not game_api.currentPlayerIsMoving() and game_api.distanceToUnit(state.currentTarget) < 5 then
                if game_api.getCooldownRemainingTime(spells.recklessness) < 3000 or state.recklessness then
                    print("Casting Ravager")
                    game_api.castAOESpellOnSelf(spells.ravager)
                    return true
                end
            end
        end
    end
    --actions+=/avatar,if=talent.titans_torment&buff.enrage.up&raid_event.adds.in>15&!buff.avatar.up&(!talent.odyns_fury|cooldown.odyns_fury.remains)|talent.berserkers_torment&buff.enrage.up&!buff.avatar.up&raid_event.adds.in>15|!talent.titans_torment&!talent.berserkers_torment&(buff.recklessness.up|target.time_to_die<20)
    if game_api.getToggle(settings.cooldowns) and functions.CanCast(spells.avatar) and functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
        if game_api.hasTalentEntry(talents.titansTorment) and state.enrage and not state.avatar and (not game_api.hasTalentEntry(talents.odynsfury) or game_api.isOnCooldown(spells.odynsFury)) or game_api.hasTalentEntry(talents.berserkersTorment) and state.enrage and not state.avatar or not game_api.hasTalentEntry(talents.titansTorment) and not game_api.hasTalentEntry(talents.berserkersTorment) and (state.recklessness) then
            print("Casting Avatar")
            game_api.castSpell(spells.avatar)
            return true
        end
    end
    --actions+=/recklessness,if=!raid_event.adds.exists&(talent.annihilator&cooldown.champions_spear.remains<1|cooldown.avatar.remains>40|!talent.avatar|target.time_to_die<12)
    if game_api.getToggle(settings.cooldowns) and functions.CanCast(spells.recklessness) and functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
        if game_api.hasTalentEntry(talents.annihilator) and game_api.getCooldownRemainingTime(spells.championsSpear) < 1000 or game_api.getCooldownRemainingTime(spells.avatar) > 40000 or not game_api.hasTalentEntry(talents.avatar) then
            print("Casting Recklessness")
            game_api.castSpell(spells.recklessness)
            return true
        end
    end
    --actions+=/recklessness,if=!raid_event.adds.exists&!talent.annihilator|target.time_to_die<12
    if game_api.getToggle(settings.cooldowns) and functions.CanCast(spells.recklessness) and functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
        if not game_api.hasTalentEntry(talents.annihilator) then
            print("Casting Recklessness")
            game_api.castSpell(spells.recklessness)
            return true
        end
    end
    --actions+=/champions_spear,if=buff.enrage.up&((buff.furious_bloodthirst.up&talent.titans_torment)|!talent.titans_torment|target.time_to_die<20|active_enemies>1|!set_bonus.tier31_2pc)&raid_event.adds.in>15
    if game_api.getToggle(settings.cooldowns) and functions.CanCast(spells.championsSpear) and functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
        if state.enrage and ((game_api.currentPlayerHasAura(auras.furiousBloodthirst,true) and game_api.hasTalentEntry(talents.titansTorment)) or not game_api.hasTalentEntry(talents.titansTorment) or state.unitsInRange > 1 or not game_api.currentPlayerHasAura(auras.tier31_2pc,true)) then
            print("Casting Champions Spear")
            game_api.castAOESpellOnSelf(spells.championsSpear)
            return true
        end
    end
    --actions+=/run_action_list,name=multi_target,strict=1,if=active_enemies>=2
    if state.unitsInRange >= 2 and not state.iris then
        if AOERotation() then
            return true
        end
    end
    --actions+=/run_action_list,name=single_target,strict=1,if=active_enemies=1

    if state.unitsInRange == 1 then
        if SingleTargetRotation() then
            return true
        end
    end
    return false
end


function AOERotation()


    --actions.multi_target+=/recklessness,if=raid_event.adds.in>15|active_enemies>1|target.time_to_die<12
    if game_api.getToggle(settings.cooldowns) and functions.CanCast(spells.recklessness) and functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
        print("Casting Recklessness")
        game_api.castSpell(spells.recklessness)
        return true
    end
    --actions.multi_target+=/odyns_fury,if=active_enemies>1&talent.titanic_rage&(!buff.meat_cleaver.up|buff.avatar.up|buff.recklessness.up)
    if game_api.getToggle(settings.cooldownsMinor) and functions.CanCast(spells.odynsFury) and functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
        if game_api.hasTalentEntry(talents.titanicRage) and (not state.meatCleaver or state.avatar or state.recklessness) then
            print("Casting Odyns Fury")
            game_api.castSpell(spells.odynsFury)
            return true
        end
    end
    --actions.multi_target+=/whirlwind,if=spell_targets.whirlwind>1&talent.improved_whirlwind&!buff.meat_cleaver.up|raid_event.adds.in<2&talent.improved_whirlwind&!buff.meat_cleaver.up
    if functions.CanCast(spells.whirlwind) then
        if game_api.hasTalentEntry(talents.improvedWhirlwind) and (not state.meatCleaver or game_api.hasTalentEntry(talents.improvedWhirlwind) and not state.meatCleaver) then
            print("Casting Whirlwind")
            game_api.castSpell(spells.whirlwind)
            return true
        end
    end
    --actions.multi_target+=/execute,if=buff.ashen_juggernaut.up&buff.ashen_juggernaut.remains<gcd
    if functions.CanCast(spells.execute) and canExecute() then
        if game_api.currentPlayerHasAura(auras.ashenJuggernaut,true) and game_api.currentPlayerAuraRemainingTime(auras.ashenJuggernaut,true) < 1400 then
            print("Casting Execute - AOE1")
            game_api.castSpellOnTarget(spells.execute,state.currentTarget)
            return true
        end
    end
    --actions.multi_target+=/thunderous_roar,if=buff.enrage.up&(buff.avatar.up|!talent.avatar&!talent.titans_torment)&(spell_targets.whirlwind>1|raid_event.adds.in>15)
    if game_api.getToggle(settings.cooldowns) and functions.CanCast(spells.thunderousRoar) and functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
        if state.enrage and (state.avatar or not game_api.hasTalentEntry(talents.avatar) and not game_api.hasTalentEntry(talents.titansTorment)) then
            print("Casting Thunderous Roar")
            game_api.castSpell(spells.thunderousRoar)
            return true
        end
    end
    --actions.multi_target+=/odyns_fury,if=active_enemies>1&buff.enrage.up&raid_event.adds.in>15
    if game_api.getToggle(settings.cooldownsMinor) and functions.CanCast(spells.odynsFury) and functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
        if state.enrage then
            print("Casting Odyns Fury")
            game_api.castSpell(spells.odynsFury)
            return true
        end
    end
    --actions.multi_target+=/bloodbath,if=set_bonus.tier30_4pc&action.bloodthirst.crit_pct_current>=95|set_bonus.tier31_4pc
    if functions.CanCast(spells.bloodBath) then
        if game_api.unitHasAura(state.currentPlayer,auras.tier30_4pc,true) and (4 > 3) or game_api.currentPlayerHasAura(auras.tier31_4pc,true)  then
            print("Casting Bloodbath - AOE1")
            game_api.castSpellOnTarget(spells.bloodBath, state.currentTarget)
            return true
        end
    end
    --actions.multi_target+=/bloodthirst,if=(set_bonus.tier30_4pc&action.bloodthirst.crit_pct_current>=95)|(!talent.reckless_abandon&buff.furious_bloodthirst.up&buff.enrage.up)
    if functions.CanCast(spells.bloodthirst) and state.bloodbathCD == 0 then
        if (game_api.currentPlayerHasAura(auras.tier30_4pc,true) and (4 > 3)) or (not game_api.hasTalentEntry(talents.recklessAbandon) and game_api.currentPlayerHasAura(auras.furiousBloodthirst,true) and state.enrage) then
            print("Casting Bloodthirst - AOE1 ")
            game_api.castSpellOnTarget(spells.bloodthirst, state.currentTarget)
            return true
        end
    end
    --actions.multi_target+=/crushing_blow,if=talent.wrath_and_fury&buff.enrage.up
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.crushingBlow, state.ragingBlowCount) and game_api.hasTalent(talents.wrathAndFury) and state.enrage  then
        print("Casting Crushing Blow - AOE 1")
        game_api.castSpellOnTarget(spells.crushingBlow, state.currentTarget)
        return true
    end
    --actions.multi_target+=/execute,if=buff.enrage.up
    if functions.CanCast(spells.execute) and canExecute() and state.enrage then
            print("Casting Execute - AOE 2")
            game_api.castSpellOnTarget(spells.execute,state.currentTarget)
            return true
    end
    --actions.multi_target+=/odyns_fury,if=buff.enrage.up&raid_event.adds.in>15
    if game_api.getToggle(settings.cooldownsMinor) and functions.CanCast(spells.odynsFury) and functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
        if state.enrage then
            print("Casting Odyns Fury")
            game_api.castSpell(spells.odynsFury)
            return true
        end
    end
    --actions.multi_target+=/rampage,if=buff.recklessness.up|buff.enrage.remains<gcd|(rage>110&talent.overwhelming_rage)|(rage>80&!talent.overwhelming_rage)
    if functions.CanCast(spells.rampage) and state.currentPower > 80  then
        if state.recklessness or game_api.currentPlayerAuraRemainingTime(auras.enrage,true) < 1400 or (state.currentPower > 110 and game_api.hasTalentEntry(talents.overwhelmingRage)) or (state.currentPower > 80 and not game_api.hasTalentEntry(talents.overwhelmingRage)) then
            print("Casting Rampage - AOE 1")
            game_api.castSpellOnTarget(spells.rampage, state.currentTarget)
            return true
        end
    end
    --actions.multi_target+=/execute,
    if functions.CanCast(spells.execute) and canExecute() then
        print("Casting Execute - AOE 3")
        game_api.castSpellOnTarget(spells.execute,state.currentTarget)
        return true
    end
    --actions.multi_target+=/bloodbath,if=buff.enrage.up&talent.reckless_abandon&!talent.wrath_and_fury
    if functions.CanCast(spells.bloodBath)  then
        if state.enrage and game_api.hasTalentEntry(talents.recklessAbandon) and not game_api.hasTalentEntry(talents.wrathAndFury) then
            print("Casting Bloodbath - AOE2")
            game_api.castSpellOnTarget(spells.bloodBath, state.currentTarget)
            return true
        end
    end
    --actions.multi_target+=/bloodthirst,if=buff.enrage.down|(talent.annihilator&!buff.recklessness.up)
    if functions.CanCast(spells.bloodthirst) and state.bloodbathCD == 0 then
        if  not state.enrage or (game_api.hasTalentEntry(talents.annihilator) and not state.recklessness) then
            print("Casting Bloodthirst - AOE 2 ")
            game_api.castSpellOnTarget(spells.bloodthirst, state.currentTarget)
            return true
        end
    end
    --actions.multi_target+=/onslaught,if=!talent.annihilator&buff.enrage.up|talent.tenderize
    if functions.CanCast(spells.onslaught) then
        if not game_api.hasTalentEntry(talents.annihilator) and state.enrage or game_api.hasTalentEntry(talents.tenderize) then
            print("Casting Onslaught - Enrage - Tenderize")
            game_api.castSpellOnTarget(spells.onslaught, state.currentTarget)
            return true
        end
    end
    --actions.multi_target+=/raging_blow,if=charges>1&talent.wrath_and_fury
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.ragingBlow, state.ragingBlowCount) and game_api.getChargeCountOnCooldown(spells.ragingBlow) == 0 and game_api.hasTalentEntry(talents.wrathAndFury) then
        print("Casting Raging Blow - AOE 1")
        game_api.castSpellOnTarget(spells.ragingBlow, state.currentTarget)
        return true
    end
    --actions.multi_target+=/crushing_blow,if=charges>1&talent.wrath_and_fury
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.crushingBlow, state.ragingBlowCount) and game_api.getChargeCountOnCooldown(spells.ragingBlow) == 0 and game_api.hasTalentEntry(talents.wrathAndFury)  then
        print("Casting Crushing Blow - AOE 2")
        game_api.castSpellOnTarget(spells.crushingBlow, state.currentTarget)
        return true
    end
    --actions.multi_target+=/bloodbath,if=buff.enrage.down|!talent.wrath_and_fury
    if functions.CanCast(spells.bloodBath)  then
        if not state.enrage or not game_api.hasTalentEntry(talents.wrathAndFury) then
            print("Casting Bloodbath - AOE 3")
            game_api.castSpellOnTarget(spells.bloodBath, state.currentTarget)
            return true
        end
    end
    --actions.multi_target+=/crushing_blow,if=buff.enrage.up&talent.reckless_abandon
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.crushingBlow, state.ragingBlowCount) and state.enrage and game_api.hasTalentEntry(talents.recklessAbandon)  then
        print("Casting Crushing Blow - AOE 3 ")
        game_api.castSpellOnTarget(spells.crushingBlow, state.currentTarget)
        return true
    end
    --actions.multi_target+=/bloodthirst,if=!talent.wrath_and_fury
    if functions.CanCast(spells.bloodthirst) and state.bloodbathCD == 0 then
        if (game_api.hasTalentEntry(talents.wrathAndFury)) then
            print("Casting Bloodthirst - AOE 3 ")
            game_api.castSpellOnTarget(spells.bloodthirst, state.currentTarget)
            return true
        end
    end
    --actions.multi_target+=/raging_blow,if=charges>=1
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.ragingBlow, state.ragingBlowCount) and game_api.getChargeCountOnCooldown(spells.ragingBlow) <= 1  then
        print("Casting Raging Blow - AOE 2")
        game_api.castSpellOnTarget(spells.ragingBlow, state.currentTarget)
        return true
    end
   -- actions.multi_target+=/rampage

    if functions.CanCast(spells.rampage) and state.currentPower > 80  then
        print("Casting Rampage - AOE 2")
        game_api.castSpellOnTarget(spells.rampage, state.currentTarget)
        return true
    end
    --actions.multi_target+=/slam,if=talent.annihilator
    if functions.CanCast(spells.slam) and state.bloodbathCD >= 300  and game_api.hasTalentEntry(talents.annihilator) then
        print("Casting Slam - Annihilator")
        game_api.castSpellOnTarget(spells.slam, state.currentTarget)
        return true
    end
    --actions.multi_target+=/bloodbath
    if functions.CanCast(spells.bloodBath)  then
        print("Casting Bloodbath - AOE 4")
        game_api.castSpellOnTarget(spells.bloodBath, state.currentTarget)
        return true
    end
    --actions.multi_target+=/raging_blow
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.ragingBlow, state.ragingBlowCount)  then
        print("Casting Raging Blow - AOE 3")
        game_api.castSpellOnTarget(spells.ragingBlow, state.currentTarget)
        return true
    end
    --actions.multi_target+=/crushing_blow
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.crushingBlow, state.ragingBlowCount) then
        print("Casting Crushing Blow - AOE 4")
        game_api.castSpellOnTarget(spells.crushingBlow, state.currentTarget)
        return true
    end
    --actions.multi_target+=/whirlwind
    if functions.CanCast(spells.whirlwind) and state.bloodbathCD >= 300 then
        print("Casting Whirlwind")
        game_api.castSpell(spells.whirlwind)
        return true
    end
    return false
end




function SingleTargetRotation()
    --actions.single_target+=/whirlwind,if=spell_targets.whirlwind>1&talent.improved_whirlwind&!buff.meat_cleaver.up|raid_event.adds.in<2&talent.improved_whirlwind&!buff.meat_cleaver.up
    if functions.CanCast(spells.whirlwind) and state.unitsInRange > 1 then
        if game_api.hasTalentEntry(talents.improvedWhirlwind) and not state.meatCleaver then
            print("Casting Whirlwind1")
            game_api.castSpell(spells.whirlwind)
            return true
        end
    end
    --actions.single_target+=/execute,if=buff.ashen_juggernaut.up&buff.ashen_juggernaut.remains<gcd
    if functions.CanCast(spells.execute) and canExecute() then
        if game_api.currentPlayerHasAura(auras.ashenJuggernaut,true) and game_api.currentPlayerAuraRemainingTime(auras.ashenJuggernaut,true) < 1400 then
            print("Casting Execute - ST1")
            game_api.castSpellOnTarget(spells.execute,state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/odyns_fury,if=(buff.enrage.up&(spell_targets.whirlwind>1|raid_event.adds.in>15)&(talent.dancing_blades&buff.dancing_blades.remains<5|!talent.dancing_blades))
    if game_api.getToggle(settings.cooldownsMinor) and functions.CanCast(spells.odynsFury) and functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
        if (state.enrage and (game_api.hasTalentEntry(talents.dancingBlades) and game_api.currentPlayerAuraRemainingTime(auras.dancingBlades,true) < 5000 or not game_api.hasTalentEntry(talents.dancingBlades))) then
            print("Casting Odyns Fury - ST")
            game_api.castSpell(spells.odynsFury)
            return true
        end
    end
    --actions.single_target+=/rampage,if=talent.anger_management&(buff.recklessness.up|buff.enrage.remains<gcd|rage.pct>85)
    if functions.CanCast(spells.rampage) and state.currentPower > 80  then
        if game_api.hasTalentEntry(talents.angerManagement) and (state.recklessness or game_api.currentPlayerAuraRemainingTime(auras.enrage,true) < 1400 or state.currentPowerPercent > 85)  then
            print("Casting Rampage - ST1")
            game_api.castSpellOnTarget(spells.rampage, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/bloodbath,if=set_bonus.tier30_4pc&action.bloodthirst.crit_pct_current>=95
    if functions.CanCast(spells.bloodBath) then
        if game_api.unitHasAura(state.currentPlayer,auras.tier30_4pc,true) and (4>3) then
            print("Casting Bloodbath - ST1")
            game_api.castSpellOnTarget(spells.bloodBath, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/bloodthirst,if=(set_bonus.tier30_4pc&action.bloodthirst.crit_pct_current>=95)|(!talent.reckless_abandon&buff.furious_bloodthirst.up&buff.enrage.up&(!dot.gushing_wound.remains|buff.champions_might.up))
    if functions.CanCast(spells.bloodthirst) and state.bloodbathCD == 0  then
        if (game_api.unitHasAura(state.currentPlayer,auras.tier30_4pc,true) and (4>3)) or (not game_api.hasTalentEntry(talents.recklessAbandon) and game_api.currentPlayerHasAura(auras.furiousBloodthirst,true) and state.enrage and (not game_api.unitHasAura(auras.gushingWounds,true) or game_api.currentPlayerHasAura(auras.championsMight,true))) then
            print("Casting Bloodthirst - ST1")
            game_api.castSpellOnTarget(spells.bloodthirst, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/bloodbath,if=set_bonus.tier31_2pc
    if functions.CanCast(spells.bloodBath) then
        if game_api.currentPlayerHasAura(auras.tier31_2pc,true) then
            print("Casting Bloodbath - ST2")
            game_api.castSpellOnTarget(spells.bloodBath, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/thunderous_roar,if=buff.enrage.up&(buff.avatar.up|!talent.avatar&!talent.titans_torment)&(spell_targets.whirlwind>1|raid_event.adds.in>15)
    if  game_api.getToggle(settings.cooldowns) and functions.CanCast(spells.thunderousRoar) then
        if functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
            if state.enrage and (state.avatar or not game_api.hasTalentEntry(talents.avatar) and not game_api.hasTalentEntry(talents.titansTorment)) then
                print("Using Thunderous Roar")
                game_api.castSpell(spells.thunderousRoar)
                return true
            end
        end
    end
    --actions.single_target+=/onslaught,if=buff.enrage.up|talent.tenderize
    if functions.CanCast(spells.onslaught) then
        if state.enrage or game_api.hasTalentEntry(talents.tenderize) then
            print("Casting Onslaught - Enrage - Tenderize")
            game_api.castSpellOnTarget(spells.onslaught, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/crushing_blow,if=talent.wrath_and_fury&buff.enrage.up&!buff.furious_bloodthirst.up
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.crushingBlow, state.ragingBlowCount) and game_api.getChargeCountOnCooldown(spells.ragingBlow) == 0 then
        if game_api.hasTalentEntry(talents.wrathAndFury) and state.enrage and not game_api.currentPlayerHasAura(auras.furiousBloodthirst,true) then
            print("Casting Crushing Blow - ST1")
            game_api.castSpellOnTarget(spells.crushingBlow, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/execute,if=buff.enrage.up&!buff.furious_bloodthirst.up&buff.ashen_juggernaut.up|buff.sudden_death.remains<=gcd&(target.health.pct>35&talent.massacre|target.health.pct>20)
    if functions.CanCast(spells.execute) and canExecute() then
        if state.enrage and not game_api.currentPlayerHasAura(auras.furiousBloodthirst,true) and game_api.currentPlayerHasAura(auras.ashenJuggernaut,true) or game_api.currentPlayerAuraRemainingTime(auras.suddenDeath,true) < 1400 then
            print("Casting Execute - ST2")
            game_api.castSpellOnTarget(spells.execute,state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/rampage,if=talent.reckless_abandon&(buff.recklessness.up|buff.enrage.remains<gcd|rage.pct>85)
    if functions.CanCast(spells.rampage) and state.currentPower > 80  then
        if game_api.hasTalentEntry(talents.recklessAbandon) and (state.recklessness or game_api.currentPlayerAuraRemainingTime(auras.enrage,true) < 1400 or state.currentPowerPercent > 85) then
            print("Casting Rampage - ST2")
            game_api.castSpellOnTarget(spells.rampage, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/execute,if=buff.enrage.up
    if functions.CanCast(spells.execute) and canExecute() then
        if state.enrage then
            print("Casting Execute - ST3")
            game_api.castSpellOnTarget(spells.execute,state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/rampage,if=talent.anger_management
    if functions.CanCast(spells.rampage) and state.currentPower > 80  then
        if game_api.hasTalentEntry(talents.angerManagement) then
            print("Casting Rampage - ST3")
            game_api.castSpellOnTarget(spells.rampage, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/execute
    if functions.CanCast(spells.execute) and canExecute() then
        print("Casting Execute - ST4")
        game_api.castSpellOnTarget(spells.execute,state.currentTarget)
        return true
    end
    --actions.single_target+=/bloodbath,if=buff.enrage.up&talent.reckless_abandon&!talent.wrath_and_fury
    if functions.CanCast(spells.bloodBath) then
        if state.enrage and game_api.hasTalentEntry(talents.recklessAbandon) and game_api.hasTalentEntry(talents.wrathAndFury) then
            print("Casting Bloodbath - ST3")
            game_api.castSpellOnTarget(spells.bloodBath, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/rampage,if=target.health.pct<35&talent.massacre.enabled
    if functions.CanCast(spells.rampage) and state.currentPower > 80  then
        if game_api.unitHealthPercent(state.currentTarget) < 35 and game_api.hasTalentEntry(talents.massacre) then
            print("Casting Rampage - ST4")
            game_api.castSpellOnTarget(spells.rampage, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/bloodthirst,if=(buff.enrage.down|(talent.annihilator&!buff.recklessness.up))&!buff.furious_bloodthirst.up
    if functions.CanCast(spells.bloodthirst) and state.bloodbathCD == 0  then
        if (not state.enrage or (game_api.hasTalentEntry(talents.annihilator) and not state.recklessness)) and not game_api.currentPlayerHasAura(auras.furiousBloodthirst,true) then
            print("Casting Bloodthirst - ST2")
            game_api.castSpellOnTarget(spells.bloodthirst, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/raging_blow,if=charges>1&talent.wrath_and_fury
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.ragingBlow, state.ragingBlowCount) and game_api.getChargeCountOnCooldown(spells.ragingBlow) == 0 and game_api.hasTalentEntry(talents.wrathAndFury) then
        print("Casting Raging Blow - ST1")
        game_api.castSpellOnTarget(spells.ragingBlow, state.currentTarget)
        return true
    end
    --actions.single_target+=/crushing_blow,if=charges>1&talent.wrath_and_fury&!buff.furious_bloodthirst.up
    if game_api.canCastCharge(spells.crushingBlow, state.ragingBlowCount) and game_api.getChargeCountOnCooldown(spells.ragingBlow) == 0 and game_api.hasTalentEntry(talents.wrathAndFury) and not game_api.currentPlayerHasAura(auras.furiousBloodthirst,true) then
        print("Casting Crushing Blow - ST2")
        game_api.castSpellOnTarget(spells.crushingBlow, state.currentTarget)
        return true
    end
    --actions.single_target+=/bloodbath,if=buff.enrage.down|!talent.wrath_and_fury
    if functions.CanCast(spells.bloodBath) then
        if not state.enrage or not game_api.hasTalentEntry(talents.wrathAndFury) then
            print("Casting Bloodbath - ST4")
            game_api.castSpellOnTarget(spells.bloodBath, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/crushing_blow,if=buff.enrage.up&talent.reckless_abandon&!buff.furious_bloodthirst.up
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.crushingBlow, state.ragingBlowCount) and game_api.getChargeCountOnCooldown(spells.ragingBlow) == 0 then
        if state.enrage and game_api.hasTalentEntry(talents.recklessAbandon) and not game_api.currentPlayerHasAura(auras.furiousBloodthirst,true) then
            print("Casting Crushing Blow - ST3")
            game_api.castSpellOnTarget(spells.crushingBlow, state.currentTarget)
            return true
        end
    end
    --actions.single_target+=/bloodthirst,if=!talent.wrath_and_fury&!buff.furious_bloodthirst.up
    if functions.CanCast(spells.bloodthirst) and state.bloodbathCD == 0  then
        if not game_api.hasTalentEntry(talents.wrathAndFury) and not game_api.currentPlayerHasAura(auras.furiousBloodthirst,true) then
            print("Casting Bloodthirst  - ST3")
            game_api.castSpellOnTarget(spells.bloodthirst, state.currentTarget)
            return true
        end
    end

    --actions.single_target+=/raging_blow,if=charges>1
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.ragingBlow, state.ragingBlowCount) and game_api.getChargeCountOnCooldown(spells.ragingBlow) < 1  then
        print("Casting Raging Blow  - ST2")
        game_api.castSpellOnTarget(spells.ragingBlow, state.currentTarget)
        return true
    end
   -- actions.multi_target+=/rampage

    if functions.CanCast(spells.rampage) and state.currentPower > 80  then
        print("Casting Rampage - ST5")
        game_api.castSpellOnTarget(spells.rampage, state.currentTarget)
        return true
    end
    --actions.multi_target+=/slam,if=talent.annihilator
    if functions.CanCast(spells.slam) and state.bloodbathCD >= 300 and game_api.hasTalentEntry(talents.annihilator) then
        print("Casting Slam - Annihilator")
        game_api.castSpellOnTarget(spells.slam, state.currentTarget)
        return true
    end
    --actions.multi_target+=/bloodbath
    if functions.CanCast(spells.bloodBath)  then
        print("Casting Bloodbath  - ST5")
        game_api.castSpellOnTarget(spells.bloodBath, state.currentTarget)
        return true
    end
    --actions.multi_target+=/raging_blow
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.ragingBlow, state.ragingBlowCount)  then
        print("Casting Raging Blow - ST3")
        game_api.castSpellOnTarget(spells.ragingBlow, state.currentTarget)
        return true
    end
    --actions.single_target+=/crushing_blow,if=!buff.furious_bloodthirst.up
    if not game_api.hasTalentEntry(112290) and game_api.canCastCharge(spells.crushingBlow, state.ragingBlowCount) and not game_api.currentPlayerHasAura(auras.furiousBloodthirst,true) then
        print("Casting Crushing Blow - ST4")
        game_api.castSpellOnTarget(spells.crushingBlow, state.currentTarget)
        return true
    end

    if functions.CanCast(spells.bloodthirst) and state.bloodbathCD == 0  then
        print("Casting Bloodthirst  - ST4")
        game_api.castSpellOnTarget(spells.bloodthirst, state.currentTarget)
        return true
    end
    --actions.multi_target+=/whirlwind
    if functions.CanCast(spells.whirlwind)  and state.bloodbathCD >= 300 then
        print("Casting Whirlwind2")
        game_api.castSpell(spells.whirlwind)
        return true
    end
    return false
end



function OnUpdate()
    if game_api.getToggle(settings.Pause) then return end
    if not game_api.isSpec(137050) then
        print("User is not in Fury Warrior spec, waiting..")
        return true
    end
    StateUpdate()
    if game_api.currentPlayerIsCasting() or game_api.currentPlayerIsMounted() or game_api.getCurrentPlayerChannelPercentage() <= 90 or game_api.isAOECursor() then
        return
    end
    if game_api.unitInCombat(state.currentPlayer) and game_api.getSetting(settings.autoRetarget) then
        if state.currentTarget == "00" or (game_api.unitHealthPercent(state.currentTarget) == 0 and state.currentTarget ~= "00") or not game_api.isFacing(state.currentTarget) then
            local newTarget = UnitWithHighestHealth()
            if newTarget then
                print("New Target")
                game_api.setTarget(newTarget)
            end
        end
    end
    if game_api.unitInCombat(state.currentPlayer) then
        if Defensive() then
            return true
        end
        if stanceDance() then
            return true
        end
        if Interrupt() then
            return true
        end
        if functions.useRacialCommon() then
            return true
        end
    end
    if game_api.unitInCombat(state.currentPlayer) and state.TargetCheck then
        if functions.useConsume(auras.avatar, false, false) then
            return true
        end
        if functions.dpsTrinket(auras.avatar,false) then
            return true
        end
        if functions.useRacialCommon() then
            return true
        end
        if dps() then
            return true
        end
    end
    if not game_api.unitInCombat(state.currentPlayer)  then
        if OOC()then
            return true
        end
    end
end



