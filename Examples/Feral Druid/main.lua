game_api = require("lib")
spells = require("spells")
talents = require("talents")
auras = require("auras")
settings = require("settings")
functions = require("common_functions")
cLists = require("common_lists")
state = {}


function OnInit()
    settings.createSettings()
    print("Meow!")
end


function getCombatUnitsCount()
    local units = game_api.getHostileUnits()
    local combatUnits = {}
    local insert = table.insert

    for _, unit in ipairs(units) do
        if game_api.distanceToUnit(unit) <= 10 and
            game_api.unitHealthPercent(unit) > 0 and
            functions.isInCombatOrHasNpcId(unit,cLists.npcIdList)  and not functions.ignoreUnit(unit) and not functions.hasImmunity(unit) then
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
        game_api.unitHealthPercent(unit) > 0  and not functions.ignoreUnit(unit) and not functions.hasImmunity(unit) then
            insert(combatUnits, unit)
        end
    end
    return combatUnits
end

function last2Cast()
    local spellHistory = game_api.spellCastHistory()
    local filteredHistory = {}
    for i = 1, #spellHistory do
        if spellHistory[i] ~= 69369 then
            table.insert(filteredHistory, spellHistory[i])
        end
    end
    
    if #filteredHistory >= 2 and (filteredHistory[1] == 5221 or filteredHistory[2] == 5221) then
        return true
    else
        return false
    end
end


function lastCountCast(count, spell)
    local spellHistory = game_api.spellCastHistory()
    local filteredHistory = {}
    for i = 1, #spellHistory do
        if spellHistory[i] ~= 69369 then
            table.insert(filteredHistory, spellHistory[i])
        end
    end
    
    local targetSpellId = 1822
    local numChecks = math.min(#filteredHistory, count) -- Check the last 5 elements or fewer if history is shorter
    
    for i = 1, numChecks do
        if filteredHistory[i] == targetSpellId then
            return true
        end
    end

    return false
end


function StateUpdate()
    functions.RefreshFunctionsState();

    state.currentPlayer = game_api.getCurrentPlayer()
    state.currentEnergy = game_api.getPower(2)
    state.currentEnergyPercent = functions.convertPowerToPercentage(2)
    state.currentComboPoints = functions.convertPowerToPercentage(3) / 10 / 2
    state.currentTarget = game_api.getCurrentUnitTarget()
    state.unitTarget = game_api.unitTarget(state.currentTarget)
    state.PlayerIsInCombat = game_api.unitInCombat(game_api.getCurrentPlayer())
    state.currentTargetHpPercent = game_api.unitHealthPercent(state.currentTarget)
    state.playerHealth = game_api.unitHealthPercent(state.currentPlayer)
    state.getUnits = getCombatUnits()
    state.getPartyUnits = game_api.getPartyUnits()
    state.currentTargetHealth = game_api.unitHealth(state.currentTarget)
    state.currentTargetHealthMax = game_api.unitMaxHealth(state.currentTarget)
    state.brutalSlashCount = game_api.getChargeCountOnCooldown(spells.brutalSlash)
    state.TargetCheck = state.currentTarget ~= 00 and functions.isInCombatOrHasNpcId(state.currentTarget, cLists.npcIdList) and (game_api.currentPlayerDistanceFromTarget() <=9 or game_api.unitNpcID(state.currentTarget)== 44566)  and game_api.isFacing(state.currentTarget) and game_api.isTargetHostile(true) and game_api.unitHealthPercent(state.currentTarget) > 0 
    state.bloodTalonsCount = game_api.unitAuraStackCount(state.currentPlayer,auras.bloodTalons,true)
    state.iris = game_api.unitHasAura(state.currentTarget,auras.focusingIris,false)
    state.bloodTalons = game_api.unitHasAura(state.currentPlayer,auras.bloodTalons,true)
    state.incarn = game_api.unitHasAura(state.currentPlayer,auras.incarnationGuardianOfAshamane,true)
    state.berserk = game_api.unitHasAura(state.currentPlayer,auras.berserk,true)
    state.isRaid = game_api.getPartySize() >= 6
    state.unitsInRange = getCombatUnitsCount()   
    state.last2Cast = last2Cast()
    state.barkskin = game_api.currentPlayerHasAura(auras.barkskin, true)
    state.survivalInstincts = game_api.currentPlayerHasAura(auras.survivalInstincts, true)
    state.prowl = game_api.unitHasAura(state.currentPlayer,auras.prowl,true)
    state.shadowmeld = game_api.unitHasAura(state.currentPlayer,auras.shadowmeld,true)
    state.incarnProwl = game_api.unitHasAura(state.currentPlayer,auras.incarnProwl,true)
    state.castedProwl = state.castedProwl or false
    state.playerLevel = game_api.unitLevel(state.currentPlayer)
    if game_api.hasTalent(talents.lunarInspiration) then
        state.moonfireCount = 0
        for _, unit in ipairs(state.getUnits) do
            if functions.IsInRange(40, unit) then
                if game_api.unitHasAura(unit,auras.moonfire_debuff,true) then
                    state.moonfireCount =  state.moonfireCount + 1
                end
            end
        end
    end
end




function Defensive()
    local noCurrentDefensiveAuras = not state.barkskin and not state.survivalInstincts 
    if game_api.getToggle(settings.proactiveDefensives) then
        if noCurrentDefensiveAuras then
            for debuff, _ in pairs(cLists.harmFulDebuff) do
                if game_api.currentPlayerHasAura(debuff, false) then
                    if functions.CanCast(spells.survivalInstincts) then
                        print("Using Surival Instincts Proactively")
                        game_api.castSpell(spells.survivalInstincts)
                        return true
                    end
                    if functions.CanCast(spells.natures_vigil) then
                        print("Using Nature's Vigil Proactively")
                        game_api.castSpell(spells.natures_vigil)
                        return true
                    end
                    if functions.CanCast(spells.barkskin) then
                        print("Using Bark Skin Proactively")
                        game_api.castSpell(spells.barkskin)
                        return true
                    end
                end
            end
            for _, unit in ipairs(state.getUnits) do
                -- Check if the unit is hostile and within range
                if (game_api.unitIsCasting(unit) or game_api.unitIsChanneling(unit)) and game_api.isUnitHostile(unit, false) and game_api.distanceToUnit(unit) < 40 then
                    local spellId = game_api.unitCastingSpellID(unit) 
                    local channelId = game_api.unitChannelingSpellID(unit)
                    local castPercentage = game_api.unitCastPercentage(unit) or game_api.unitChannelPercentage(unit)
                    if castPercentage >= 30 and cLists.aoeIncoming[spellId] or cLists.aoeIncoming[channelId] then
                        if functions.CanCast(spells.natures_vigil) then
                            print("Using Nature's Vigil Proactively AOE")
                            game_api.castSpell(spells.natures_vigil)
                            return true
                        end
                        if functions.CanCast(spells.survivalInstincts) then
                            print("Using Surival Instincts Proactively AOE")
                            game_api.castSpell(spells.survivalInstincts)
                            return true
                        end
                        if functions.CanCast(spells.barkskin) then
                            print("Using Bark Skin Proactively AOE")
                            game_api.castSpell(spells.barkskin)
                            return true
                        end
                    end
                end
            end
        end
    end
    if functions.CanCast(spells.renewal) then
        if state.playerHealth <= game_api.getSetting(settings.renewal) then
            print("Casting Renewal due to Health")
            game_api.castSpell(spells.renewal)
            return true
        end
    end
    if functions.CanCast(spells.survivalInstincts) and noCurrentDefensiveAuras and functions.timeToDieGroup() >= 5 then
        if not game_api.currentPlayerHasAura(auras.survivalInstincts,true) and state.playerHealth <= game_api.getSetting(settings.survivalInstincts) then
            print("Casting Survival Instincts due to Health")
            game_api.castSpell(spells.survivalInstincts)
            return true
        end
    end
    if functions.CanCast(spells.barkskin) and noCurrentDefensiveAuras  and functions.timeToDieGroup() >= 5  then
        if not game_api.currentPlayerHasAura(auras.barkskin,true) and state.playerHealth <= game_api.getSetting(settings.barkskin) then
            print("Casting Barkskin due to Health")
            game_api.castSpell(spells.barkskin)
                    return true
        end
    end
    if functions.CanCast(spells.natures_vigil)  and functions.timeToDieGroup() >= 5  then
        if state.playerHealth <= game_api.getSetting(settings.natures_vigil) then
            print("Casting Nature's Vigil due to Health")
            game_api.castSpell(spells.natures_vigil)
            return true
        end
    end
    if functions.CanCast(spells.regrowth) and game_api.unitHasAura(state.currentPlayer,auras.predatorySwiftness,true) then
        if state.playerHealth <= game_api.getSetting(settings.regrowth) then
            print("Casting Regrowth due to Health")
            game_api.castSpellOnTarget(spells.regrowth,state.currentPlayer)
            return true
        end
    end
    if functions.CanCast(spells.regrowth) and game_api.unitHasAura(state.currentPlayer,auras.predatorySwiftness,true)  then
        for _, units in ipairs(state.getPartyUnits) do
            if game_api.unitHealthPercent(units) <= game_api.getSetting(settings.groupRegrowth) and game_api.unitHealthPercent(units) > 0 and game_api.distanceToUnit(units) <= 40 then
                print("Using Regrowth on Friendly")
                game_api.castSpellOnTarget(spells.regrowth, units)
            end
        end
    end 
    return false
end


function cooldowns()
    if functions.CanCast(spells.catForm) then
        if not game_api.unitHasAura(state.currentPlayer, auras.catForm, true) then
            print("Casting Bear Form")
            game_api.castSpell(spells.catForm)
            return true
        end
    end  
    if functions.CanCast(spells.incarn) and game_api.getCooldownRemainingTime(spells.berserk) == 0 then
        print("Casting Incarn")
        game_api.castSpell(spells.incarn)
        return true
    end
    if functions.CanCast(spells.berserk) and game_api.getCooldownRemainingTime(spells.incarn) == 0   then
        if game_api.hasTalent(talents.convoke) and ((functions.timeToDieGroup() * 1000) >= game_api.getCooldownRemainingTime(spells.convoke) or (game_api.getSetting(settings.alignCD) and (functions.CanCast(spells.feralFrenzy) and (state.currentComboPoints < 4)) and game_api.getCooldownRemainingTime(spells.convoke) < 10000)) then
            print("Casting Berserk")
            game_api.castSpell(spells.berserk)
            return true
        end
    end

    if functions.CanCast(spells.convoke) then
        if game_api.unitHasAura(state.currentPlayer, auras.tigersFury, true) then
            if state.currentComboPoints <= 4 and game_api.currentPlayerHasAura(auras.twoSet, true) and game_api.currentPlayerHasAura(auras.smolderingFrenzy, true) then
                print("Casting Convoke with Smoldering Frenzy")
                game_api.castSpell(spells.convoke)
                return true
            else
                if state.currentComboPoints <= 2 and not game_api.currentPlayerHasAura(auras.twoSet, true) then
                    print("Casting Convoke")
                    game_api.castSpell(spells.convoke)
                    return true
                end
            end
        end
    end
    
    return false
end


function spenderAOE()
    if functions.CanCast(spells.catForm) then
        if not game_api.unitHasAura(state.currentPlayer, auras.catForm, true) then
            print("Casting Bear Form")
            game_api.castSpell(spells.catForm)
            return true
        end
    end  
    if functions.CanCast(spells.ferociousBite) then
        if game_api.unitHasAura(state.currentPlayer,auras.apexPredator,true) then
            print("Casting Ferocious Bite - Apex Predator Proc")
            game_api.castSpellOnTarget(spells.ferociousBite,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.primalWrath) and game_api.hasTalent(talents.rampentFerocity) then
        if state.currentComboPoints == 5  and (game_api.currentPlayerHasAura(auras.berserk,true) or game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true)) and functions.isInPandemicRemainingTime(state.currentTarget,auras.rip_debuff) then
            print("Casting Primal Wrath Full Combo")
            game_api.castSpell(spells.primalWrath)
            return true
        end
    end
    if functions.CanCast(spells.primalWrath)  and game_api.hasTalent(talents.rampentFerocity)   then
        if state.currentComboPoints >= 4 and not game_api.currentPlayerHasAura(auras.berserk,true) and not game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true) and functions.isInPandemicRemainingTime(state.currentTarget,auras.rip_debuff)   then
            print("Casting Primal Wrath - No Berserk")
            game_api.castSpell(spells.primalWrath)
            return true
        end
    end
    if functions.CanCast(spells.ferociousBite)  and game_api.hasTalent(talents.rampentFerocity)  then
        if state.currentComboPoints == 5  and (game_api.currentPlayerHasAura(auras.berserk,true) or game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true))  then
            print("Casting Ferocious Bite - Full Combo")
            game_api.castSpell(spells.ferociousBite)
            return true
        end
    end
    if functions.CanCast(spells.ferociousBite)  and game_api.hasTalent(talents.rampentFerocity)    then
        if state.currentComboPoints >= 4 and not game_api.currentPlayerHasAura(auras.berserk,true) and not game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true) then
            print("Casting Primal Wrath - No Berserk")
            game_api.castSpell(spells.ferociousBite)
            return true
        end
    end
    if functions.CanCast(spells.primalWrath) then
        if state.currentComboPoints == 5  and (game_api.currentPlayerHasAura(auras.berserk,true) or game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true)) then
            print("Casting Primal Wrath Full Combo")
            game_api.castSpell(spells.primalWrath)
            return true
        end
    end
    if functions.CanCast(spells.primalWrath) then
        if state.currentComboPoints >= 4 and not game_api.currentPlayerHasAura(auras.berserk,true) and not game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true) then
            print("Casting Primal Wrath - No Berserk")
            game_api.castSpell(spells.primalWrath)
            return true
        end
    end
    if functions.CanCast(spells.ferociousBite) then
        if state.currentComboPoints == 5  and (game_api.currentPlayerHasAura(auras.berserk,true) or game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true))  then
            print("Casting Ferocious Bite - Full Combo")
            game_api.castSpell(spells.ferociousBite)
            return true
        end
    end
    if functions.CanCast(spells.ferociousBite) then
        if state.currentComboPoints >= 4 and not game_api.currentPlayerHasAura(auras.berserk,true) and not game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true) then
            print("Casting Primal Wrath - No Berserk")
            game_api.castSpell(spells.ferociousBite)
            return true
        end
    end
    return false
end

function builderAOE()
    if functions.CanCast(spells.catForm) then
        if not game_api.unitHasAura(state.currentPlayer, auras.catForm, true) then
            print("Casting Bear Form")
            game_api.castSpell(spells.catForm)
            return true
        end
    end  
  
    --feral frenzy
    if functions.CanCast(spells.adaptiveSwarm)    then
        if (not game_api.unitHasAura(state.currentTarget,auras.adaptiveSwarm,true) or  game_api.unitAuraRemainingTime(state.currentPlayer,auras.adaptiveSwarm,true) < 2000) and game_api.unitAuraStackCount(state.currentTarget,auras.adaptiveSwarm,true) < 3 and functions.timeToDie() >= game_api.getSetting(settings.timeToDie) then
            print("Casting Adaptive Swarm")
            game_api.castSpellOnTarget(spells.adaptiveSwarm,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.adaptiveSwarm)    then
        if not game_api.hasTalent(talents.unbridledSwarm) or state.unitsInRange == 1 then
            print("Casting Adaptive Swarm, Single Target")
            game_api.castSpellOnTarget(spells.adaptiveSwarm,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.adaptiveSwarm)    then
        if game_api.unitAuraStackCount(state.currentTarget,auras.adaptiveSwarm,true) < 3 and game_api.hasTalent(talents.unbridledSwarm) and state.unitsInRange > 1 and functions.timeToDie() > game_api.getSetting(settings.timeToDie) then
            print("Casting Adaptive Swarm")
            game_api.castSpellOnTarget(spells.adaptiveSwarm,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.shadowmeld) and (game_api.currentPlayerHasAura(auras.smolderingFrenzy,true) or not game_api.currentPlayerHasAura(auras.twoSet,true)) and game_api.currentPlayerHasAura(auras.tigersFury,true) and not game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true) and state.currentComboPoints < 4  and (not game_api.unitHasAura(state.currentTarget, auras.rake_debuff,true) or game_api.unitAuraRemainingTime(state.currentTarget,auras.rake_debuff,true) <= 6000) and not game_api.currentPlayerIsMoving() then
        print("Casting Shadowmeld")
        game_api.castSpell(spells.shadowmeld)
        return true
    end

    if functions.CanCast(spells.prowl) and (game_api.currentPlayerHasAura(auras.smolderingFrenzy,true) or not game_api.currentPlayerHasAura(auras.twoSet,true)) and not state.castedProwl and game_api.currentPlayerHasAura(auras.tigersFury,true) and state.currentComboPoints < 4  and (not game_api.unitHasAura(state.currentTarget, auras.rake_debuff,true) or game_api.unitAuraRemainingTime(state.currentTarget,auras.rake_debuff,true) <= 6000) and game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true) then
        print("Casting Prowl - Incarn")
        state.castedProwl = true
        game_api.castSpell(spells.prowl)
        return true
    end

    if functions.CanCast(spells.tigersFury)  then
        if state.currentEnergyPercent < 50 or not game_api.unitHasAura(state.currentPlayer,auras.tigersFury,true) then
            print("Casting Tigers Fury")
            game_api.castSpell(spells.tigersFury)
            return true
        end
    end
    if game_api.getToggle(settings.miniCooldowns) and functions.CanCast(spells.feralFrenzy)   then
        if functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie)  and (state.currentComboPoints <= 2 or ((state.berserk or state.incarn) and state.currentComboPoints <=3)) then
            print("Casting Feral Frenzy")
            game_api.castSpellOnTarget(spells.feralFrenzy,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.ferociousBite)     then
        if game_api.unitHasAura(state.currentPlayer, auras.apexPredator,true) then
            print("Casting Ferocious Bite - Apex Predator Buff")
            game_api.castSpellOnTarget(spells.ferociousBite,state.currentTarget)
            return true
        end
    end
    if game_api.canCastCharge(spells.brutalSlash,3) and state.brutalSlashCount <= 1 and state.currentEnergy > 25  then
        if game_api.unitHasAura(state.currentPlayer,auras.tigersFury,true) or game_api.getCooldownRemainingTime(spells.tigersFury) > 10 then
            print("Casting Brutal Slash Dump - Tiger's Fury")
            game_api.castSpell(spells.brutalSlash)
            return true
        end
    end  
    if functions.CanCast(spells.thrash) and (not game_api.unitHasAura(state.currentTarget,auras.thrash_debuff,true) and functions.isInPandemicRemainingTime(state.currentTarget,auras.thrash_debuff)) and state.unitsInRange > 4 and (state.currentEnergy > 40  or game_api.unitHasAura(state.currentPlayer,auras.clearcast_buff, true)) then
        print("Casting Thrash - No Debuff")
        game_api.castSpell(spells.thrash)
        return true
    end

    if functions.CanCast(spells.rake) and state.currentEnergy > 35   then
        if game_api.hasTalent(talents.doubleClawedRake) then
            for _, unit in ipairs(state.getUnits) do
                if functions.isInCombatOrHasNpcId(unit, cLists.npcIdList) and game_api.isUnitHostile(unit, true) and
                    game_api.isFacing(unit) and game_api.distanceToUnit(unit) < 6 and
                    (not game_api.unitHasAura(unit, auras.rake_debuff,true) and functions.isInPandemicRemainingTime(state.currentTarget,auras.rake_debuff)) and game_api.unitHealth(unit) > 0 then
                        print("Casting Rake - Double Clawed - Spread")
                        game_api.castSpellOnTarget(spells.rake,unit)
                    return true
                end
            end
        end
    end

    if functions.CanCast(spells.rake) and state.currentEnergy > 35     then
        if game_api.unitHasAura(state.currentPlayer, auras.suddenAmbush,true) then
            print("Casting Rake - Sudden Ambush Proc")
            game_api.castSpellOnTarget(spells.rake,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.thrash) and state.currentEnergy > 40     then
        if (not game_api.unitHasAura(state.currentTarget,auras.thrash_debuff,true) and functions.isInPandemicRemainingTime(state.currentTarget,auras.thrash_debuff)) then
            print("Casting Thrash - Apply Debuff")
            game_api.castSpell(spells.thrash)
            return true
        end
    end
    if game_api.canCastCharge(spells.brutalSlash,3) and state.currentEnergy > 25     then
        if game_api.unitHasAura(state.currentPlayer,auras.tigersFury,true) or game_api.getCooldownRemainingTime(spells.tigersFury) > 10 then
            print("Casting Brutal Slash Dump - Tiger's Fury")
            game_api.castSpell(spells.brutalSlash)
            return true
        end
    end  
    if game_api.hasTalent(talents.lunarInspiration) and state.moonfireCount < 4 and functions.CanCast(spells.moonfire) and state.currentEnergy > 30 then
        for _, unit in ipairs(state.getUnits) do
            if functions.IsInRange(15, unit) and game_api.isUnitHostile(unit, false) and game_api.unitHealthPercent(unit) > 0 and functions.isInCombatOrHasNpcId(unit, cLists.npcIdList) and game_api.isFacing(unit) then
                if not game_api.unitHasAura(unit,auras.moonfire_debuff,true) then
                    print("Spread Moonfire")
                    game_api.castSpellOnTarget(spells.moonfire, unit)
                    return true
                end
            end 
        end
    end
    if game_api.canCastCharge(spells.brutalSlash,3) and state.currentEnergy > 25     then
        if state.brutalSlashCount == 0 then
            print("Casting Brutal Slash 3 Charges")
            game_api.castSpell(spells.brutalSlash)
            return true
        end
    end
    if functions.CanCast(spells.rake) and state.currentEnergy > 35   then
        if state.bloodTalonsCount <= 1 then
            print("Casting Rake - Blood Talons")
            game_api.castSpellOnTarget(spells.rake,state.currentTarget)
            return true
        end
    end
    
    if functions.CanCast(spells.thrash) and state.unitsInRange > 4 and (state.currentEnergy > 40  or game_api.unitHasAura(state.currentPlayer,auras.clearcast_buff, true))     then
        print("Casting Thrash")
        game_api.castSpell(spells.thrash)
        return true
    end
    if functions.CanCast(spells.shred) and state.unitsInRange <= 4 and (state.currentEnergy > 40  or game_api.unitHasAura(state.currentPlayer,auras.clearcast_buff, true))    then
        print("Casting Shred - Generate Combos")
        game_api.castSpellOnTarget(spells.shred,state.currentTarget)
        return true
    end
    return false
end





function spenderST()
    if functions.CanCast(spells.catForm) then
        if not game_api.unitHasAura(state.currentPlayer, auras.catForm, true) then
            print("Casting Bear Form")
            game_api.castSpell(spells.catForm)
            return true
        end
    end  
 
    if functions.CanCast(spells.ferociousBite) then
        if game_api.unitHasAura(state.currentPlayer,auras.apexPredator,true) then
            print("Casting Ferocious Bite - Apex Predator Proc")
            game_api.castSpellOnTarget(spells.ferociousBite,state.currentTarget)
            return true
        end
    end
    if game_api.getToggle(settings.miniCooldowns) and functions.CanCast(spells.feralFrenzy)   then
        if functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) and (state.currentComboPoints <= 3 or ((state.berserk or state.incarn) and state.currentComboPoints <=3)) then
            print("Casting Feral Frenzy")
            game_api.castSpellOnTarget(spells.feralFrenzy,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.rip) then
        if state.currentComboPoints == 5 and castRipIfMorePowerful(state.currentTarget) then
            print("Casting Bigger Rip")
            return true
        end
    end
    if functions.CanCast(spells.rip) then
        if state.currentComboPoints == 5 and game_api.currentPlayerHasAura(auras.bloodTalons,true) and not game_api.unitHasAura(state.currentTarget,auras.rip_debuff,true) and game_api.unitHasAura(state.currentPlayer,auras.tigersFury,true) then
            print("Casting Rip Full Combo - Blood Talons")
            game_api.castSpellOnTarget(spells.rip,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.rip) then
        if state.currentComboPoints >= 4 and not game_api.unitHasAura(state.currentTarget,auras.rip_debuff,true) and not game_api.hasTalent(talents.bloodTalons) and (game_api.unitHasAura(state.currentPlayer,auras.tigersFury,true) or game_api.getCooldownRemainingTime(spells.tigersFury) > 10000 or game_api.currentPlayerHasAura(auras.berserk,true) or game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true)) then
            print("Casting Rip Full Combo - No Blood Talons")
            game_api.castSpellOnTarget(spells.rip,state.currentTarget)
            return true
        end
    end

    if functions.CanCast(spells.ferociousBite) then
        if state.currentComboPoints == 5 and (game_api.currentPlayerHasAura(auras.berserk,true) or game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true)) then
            print("Casting Ferocious Bite - Berserk")
            game_api.castSpellOnTarget(spells.ferociousBite,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.ferociousBite) then
        if state.currentComboPoints >= 4 and not game_api.currentPlayerHasAura(auras.berserk,true) and not game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true) then
            print("Casting Ferocious Bite")
            game_api.castSpellOnTarget(spells.ferociousBite,state.currentTarget)
            return true
        end
    end
    return false
end


function builderSTNew()
    if functions.CanCast(spells.catForm) then
        if not game_api.unitHasAura(state.currentPlayer, auras.catForm, true) then
            print("Casting Bear Form")
            game_api.castSpell(spells.catForm)
            return true
        end
    end  
    if functions.CanCast(spells.adaptiveSwarm) then
        if (not game_api.unitHasAura(state.currentTarget,auras.adaptiveSwarm,true) or  game_api.unitAuraRemainingTime(state.currentPlayer,auras.adaptiveSwarm,true) < 2000) and game_api.unitAuraStackCount(state.currentTarget,auras.adaptiveSwarm,true) < 3 and functions.timeToDie() >= game_api.getSetting(settings.timeToDie) then
            print("Casting Adaptive Swarm")
            game_api.castSpellOnTarget(spells.adaptiveSwarm,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.adaptiveSwarm) then
        if not game_api.hasTalent(talents.unbridledSwarm) or state.unitsInRange == 1 then
            print("Casting Adaptive Swarm, Single Target")
            game_api.castSpellOnTarget(spells.adaptiveSwarm,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.adaptiveSwarm)    then
        if game_api.unitAuraStackCount(state.currentTarget,auras.adaptiveSwarm,true) < 3 and game_api.hasTalent(talents.unbridledSwarm) and state.unitsInRange > 1 and functions.timeToDie() > game_api.getSetting(settings.timeToDie) then
            print("Casting Adaptive Swarm")
            game_api.castSpellOnTarget(spells.adaptiveSwarm,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.shadowmeld) and (game_api.currentPlayerHasAura(auras.smolderingFrenzy,true) or not game_api.currentPlayerHasAura(auras.twoSet,true)) and game_api.currentPlayerHasAura(auras.tigersFury,true) and not game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true) and state.currentComboPoints <= 4  and (not game_api.unitHasAura(state.currentTarget, auras.rake_debuff,true) or functions.isInPandemicRemainingTime(state.currentTarget,auras.rake_debuff)) and not game_api.currentPlayerIsMoving() then
        print("Casting Shadowmeld")
        game_api.castSpell(spells.shadowmeld)
        return true
    end
    if functions.CanCast(spells.prowl) and (game_api.currentPlayerHasAura(auras.smolderingFrenzy,true) or not game_api.currentPlayerHasAura(auras.twoSet,true)) and not state.castedProwl and game_api.currentPlayerHasAura(auras.tigersFury,true) and state.currentComboPoints <= 4  and (not game_api.unitHasAura(state.currentTarget, auras.rake_debuff,true) or functions.isInPandemicRemainingTime(state.currentTarget,auras.rake_debuff)) and game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true) then
        print("Casting Prowl - Incarn")
        state.castedProwl = true
        game_api.castSpell(spells.prowl)
        return true
    end
    if functions.CanCast(spells.tigersFury)  then
        if state.currentEnergyPercent < 60 or not game_api.unitHasAura(state.currentPlayer,auras.tigersFury,true) then
            print("Casting Tigers Fury")
            game_api.castSpell(spells.tigersFury)
            return true
        end
    end
    if game_api.getToggle(settings.miniCooldowns) and functions.CanCast(spells.feralFrenzy)   then
        if functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) and (state.currentComboPoints <= 3 or ((state.berserk or state.incarn) and state.currentComboPoints <=3)) then
            print("Casting Feral Frenzy")
            game_api.castSpellOnTarget(spells.feralFrenzy,state.currentTarget)
            return true
        end
    end

    if functions.CanCast(spells.ferociousBite) and game_api.unitHasAura(state.currentPlayer,auras.bloodTalons,true)   then
        if game_api.unitHasAura(state.currentPlayer,auras.apexPredator,true) then
            print("Casting Ferocious Bite - Apex Predator Proc")
            game_api.castSpellOnTarget(spells.ferociousBite,state.currentTarget)
            return true
        end
    end 
    if game_api.canCastCharge(spells.brutalSlash,3) and state.currentEnergy > 25 then
        if state.brutalSlashCount == 0 then
            print("Casting Brutal Slash 3 Charges")
            game_api.castSpell(spells.brutalSlash)
            return true
        end
    end
    if functions.CanCast(spells.rake) and state.currentEnergy > 35   then
        if functions.replaceSpell(state.currentTarget,auras.rake_debuff) and castRakeIfMorePowerful(state.currentTarget) then
            state.lastRakePowerScale = calculatePowerScale()
            print("Casting Big Dick Rake")
            return true
        end
    end

    if functions.CanCast(spells.rake) and state.currentEnergy > 35   then
        if (not game_api.unitHasAura(state.currentTarget, auras.rake_debuff,true) or functions.isInPandemicRemainingTime(state.currentTarget,auras.rake_debuff)) and functions.timeToDie() >= game_api.getSetting(settings.timeToDie) then
            print("Casting Rake - Debuff Application")
            state.lastRakePowerScale = calculatePowerScale()
            game_api.castSpellOnTarget(spells.rake,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.moonfire) and state.currentEnergy > 30 and game_api.hasTalent(talents.lunarInspiration) then
        if functions.IsInRange(15, state.currentTarget) then
            if not game_api.unitHasAura(state.currentTarget,auras.moonfire_debuff,true) then
                print("Cast Moonfire")
                game_api.castSpellOnTarget(spells.moonfire, state.currentTarget)
                return true
            end
        end 
    end
    if functions.CanCast(spells.shred) and (game_api.unitHasAura(state.currentPlayer,auras.clearcast_buff, true))  then
        if game_api.unitHasAura(state.currentTarget,auras.thrash_debuff,true) or not functions.isInPandemicRemainingTime(state.currentTarget,auras.thrash_debuff) then
            print("Casting Shred - ClearCast")
            game_api.castSpellOnTarget(spells.shred,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.shred) and state.currentEnergy > 40   then
        if game_api.currentPlayerHasAura(auras.suddenAmbush,true) then
            print("Casting Shred - Sudden Ambush")
            game_api.castSpellOnTarget(spells.shred,state.currentTarget)
            return true
        end
    end
    if functions.CanCast(spells.thrash) and (state.currentEnergy > 40  or game_api.unitHasAura(state.currentPlayer,auras.clearcast_buff, true))     then
        if (not game_api.unitHasAura(state.currentTarget,auras.thrash_debuff,true) or functions.isInPandemicRemainingTime(state.currentTarget,auras.thrash_debuff)) then
            print("Casting Thrash to get Thrash Debuff")
            game_api.castSpell(spells.thrash)
            return true
        end
    end
    if game_api.canCastCharge(spells.brutalSlash,3) and state.currentEnergy > 25 then
        if state.brutalSlashCount == 1 then
            print("Casting Brutal Slash 2 Charges")
            game_api.castSpell(spells.brutalSlash)
            return true
        end
    end
    if game_api.canCastCharge(spells.brutalSlash,3) and not wasSpecificComboAbilityCastRecently(spells.brutalSlash) and state.currentEnergy > 25 then
        print("Casting Brutal Slash - No Talons Logic")
        game_api.castSpell(spells.brutalSlash)
        return true
    end
    if functions.CanCast(spells.shred) and not wasSpecificComboAbilityCastRecently(spells.shred) then
        print("Casting Shred - No Talons Logic")
        game_api.castSpellOnTarget(spells.shred,state.currentTarget)
        return true
    end
    if functions.CanCast(spells.thrash) and not wasSpecificComboAbilityCastRecently(spells.thrash) then
        print("Casting Thrash - No Talons Logic")
        game_api.castSpell(spells.thrash)
        return true
    end
    if functions.CanCast(spells.rake) and not game_api.currentPlayerHasAura(auras.bloodTalons,true) and state.currentEnergy > 40 and not wasSpecificComboAbilityCastRecently(spells.rake) then
        print("Casting Rake - No Talons Logic")
        game_api.castSpellOnTarget(spells.rake,state.currentTarget)
        return true
    end

    if game_api.canCastCharge(spells.brutalSlash,3) and state.currentEnergy > 25 then
        print("Casting Brutal Slash")
        game_api.castSpell(spells.brutalSlash)
        return true
    end
    if functions.CanCast(spells.shred) then
        print("Casting Shred - High Energy")
        game_api.castSpellOnTarget(spells.shred,state.currentTarget)
        return true
    end
    return false
end


function wasSpecificComboAbilityCastRecently(spellIDToCheck)
    local lastCasts = game_api.spellCastHistory()

    for i = 1, math.min(#lastCasts, 6) do  
        local castSpellID = lastCasts[i]
        if castSpellID == spellIDToCheck then
            return true
        end
    end

    return false
end



function OOC()
    if functions.CanCast(spells.markofthewild) then
        local UnitMissingAura = functions.PartyUnitMissingAura(auras.markofthewild_buff)
        if UnitMissingAura  then
            print("Casting MotW, unit missing buff")
            game_api.castSpellOnTarget(spells.markofthewild,state.currentPlayer)
            return true
        end
    end
    
    if game_api.isTargetHostile(true) and game_api.unitHealthPercent(state.currentTarget) > 0  then
        if game_api.currentPlayerDistanceFromTarget() <= 18 then
            if functions.CanCast(spells.catForm) then
                if not game_api.unitHasAura(state.currentPlayer, auras.catForm, true) then
                    print("Casting Cat Form")
                    game_api.castSpell(spells.catForm)
                    return true
                end
            end
            if functions.CanCast(spells.prowl) and game_api.isFacing(state.currentTarget) then
                if not state.prowl then
                    print("Casting Prowl")
                    game_api.castSpell(spells.prowl)
                    return true
                end
            end   
            if functions.CanCast(spells.tigersFury)  then
                if not game_api.unitHasAura(state.currentPlayer,auras.tigersFury,true) and game_api.currentPlayerDistanceFromTarget() <=10 then
                    print("Casting Tigers Fury")
                    game_api.castSpell(spells.tigersFury)
                    return true
                end
            end
            if functions.CanCast(spells.rake) and game_api.currentPlayerDistanceFromTarget() <=9 and game_api.isFacing(state.currentTarget) then
                if state.prowl or  state.shadowmeld or state.incarnProwl then
                    print("Casting Rake from Stealth")
                    state.lastRakePowerScale = calculatePowerScale()
                    game_api.castSpellOnTarget(spells.rake,state.currentTarget)
                    return true
                end
            end     
        end
    end
    return false
end



function Interrupt()
    if not game_api.getToggle(settings.interrupts) then
        return false
    end
    if functions.CanCast(spells.catForm) then
        if not game_api.unitHasAura(state.currentPlayer, auras.catForm, true) then
            print("Casting Cat Form")
            game_api.castSpell(spells.catForm)
            return true
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

        local spellId = game_api.unitCastingSpellID(unit) 
        local channelId = game_api.unitChannelingSpellID(unit)
        local stunPercent = settings.stunPercent 
        local interruptPercent = settings.interruptPercent
        if unitCasting then
            local isStun = cLists.priorityStunList[spellId] or cLists.priorityStunList[channelId]
            local isKick = cLists.priorityKickList[spellId] or cLists.priorityKickList[channelId] 
            if isKick and functions.CanCast(spells.skullBash) and game_api.distanceToUnit(unit) <= 13 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(interruptPercent) then
                print("Casting Skull Bash on " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpellOnTarget(spells.skullBash, unit)
                return true
            end
            if state.playerLevel >= game_api.unitLevel(unit) and not game_api.unitIsBoss(unit) and  (isStun or (game_api.getSetting(settings.useStun) and isKick)) and functions.CanCast(spells.mightyBash) and game_api.distanceToUnit(unit) <= 6 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(stunPercent) then
                print("Casting Mighty Bash " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpellOnTarget(spells.mightyBash, state.currentTarget)
                return true
            end
            if state.playerLevel >= game_api.unitLevel(unit) and not game_api.unitIsBoss(unit) and  (isStun or (game_api.getSetting(settings.useStun) and isKick)) and functions.CanCast(spells.incapacitatingRoar) and game_api.distanceToUnit(unit) <= 8 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(stunPercent) then
                print("Casting Incap Roar on " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpell(spells.incapacitatingRoar)
                return true
            end
        end
        if unitCasting and game_api.getSetting(settings.kickEverything) then
            if functions.CanCast(spells.skullBash) and game_api.distanceToUnit(unit) <= 13 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(interruptPercent) then
                print("Casting Skull Bash on " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpellOnTarget(spells.skullBash, unit)
                return true
            end
            if state.playerLevel >= game_api.unitLevel(unit) and not game_api.unitIsBoss(unit) and game_api.getSetting(settings.useStun) and functions.CanCast(spells.mightyBash) and game_api.distanceToUnit(unit) <= 6 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(stunPercent) then
                print("Casting Mighty Bash " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpellOnTarget(spells.mightyBash, state.currentTarget)
                return true
            end
            if state.playerLevel >= game_api.unitLevel(unit) and not game_api.unitIsBoss(unit) and game_api.getSetting(settings.useStun) and functions.CanCast(spells.incapacitatingRoar) and game_api.distanceToUnit(unit) <= 8 and game_api.isFacing(unit) and castPercentage >= game_api.getSetting(stunPercent) then
                print("Casting Incap Roar on " .. (game_api.unitIsCasting(unit) and "Casting" or "Channeling") .. " Unit")
                game_api.castSpell(spells.incapacitatingRoar)
                return true
            end
        end
    end
    return false
end




--[[function Affix(SpellForAfflicted, SpellForIncorperal, range)
    state.afflictedUnits = game_api.getUnitsByNpcId(204773)
    if (#state.afflictedUnits > 0) and (game_api.canCast(SpellForAfflicted)) then
        for _, unit in ipairs(state.afflictedUnits) do
            if (game_api.distanceToUnit(unit) < range) and (game_api.unitIsCasting(unit) or game_api.unitIsChanneling(unit)) then
                if game_api.canCast(SpellForAfflicted) then
                    game_api.castSpellOnTarget(SpellForAfflicted, unit)
                    return true
                end
            end
        end
    end

    state.incorporealUnits = game_api.getUnitsByNpcId(204560)
    if (#state.incorporealUnits > 0) and game_api.canCast(SpellForIncorperal) then
        for _, unit in ipairs(state.incorporealUnits) do
            if (game_api.distanceToUnit(unit) < range) and (game_api.unitIsCasting(unit) or game_api.unitIsChanneling(unit)) then
                if game_api.canCast(SpellForIncorperal) then
                    game_api.castSpellOnTarget(SpellForIncorperal, unit)
                    return true
                end
            end
        end
    end
    return false
end]]


function brez()
    -- Check if the battle resurrection toggle is on and if Rebirth can be cast.
    if not game_api.getToggle(settings.targetBrez) or not functions.CanCast(spells.rebirth) then
        return false
    end

    -- Check if the current target is a dead party member.
    local target = state.currentTarget
    if game_api.unitHealthPercent(target) == 0 then
        for _, unit in ipairs(state.getPartyUnits) do
            if unit == target then
                print("Casting Raise Ally on Dead Teammate - Target")
                game_api.castSpellOnTarget(spells.rebirth, target)
                return true
            end
        end
    end

    return false
end

function innervate()
    if not game_api.getSetting(settings.innervateToggle) or not functions.CanCast(spells.innervate) then
        return false
    end
    local healer = game_api.getPartyUnitsByRole("HEAL")
    if game_api.hasTalent(talents.innervate) and (#healer > 0) and functions.timeToDieGroup() >= 10 then
        for _, healerUnit in ipairs(healer) do
            if game_api.distanceToUnit(healerUnit) < 40 then
                for _, unit in ipairs(state.getUnits) do
                    if (game_api.unitIsCasting(unit) or game_api.unitIsChanneling(unit)) and game_api.isUnitHostile(unit, false) and game_api.distanceToUnit(unit) < 30 then
                        local spellId = (game_api.unitCastingSpellID(unit) and game_api.unitCastingSpellID(unit) ~= 0) or (game_api.unitChannelingSpellID(unit))
                        if cLists.aoeIncoming[spellId] and spellId ~= 0 then
                            print("Casting Innervate on Healer for AOE Incoming")
                            game_api.castSpellOnTarget(spells.innervate, healerUnit)
                            return true
                        end
                    end
                end
                local actualPower = game_api.getUnitPower(healerUnit, 0)
                local maxPower = game_api.getUnitMaxPower(healerUnit, 0)
                local powerPercentage = (actualPower / maxPower) * 100
                if powerPercentage <= game_api.getSetting(settings.innervate) then
                    print("Casting Innervate on Healer for Mana Threshold")
                    game_api.castSpellOnTarget(spells.innervate, healerUnit)
                    return true
                end
            end
        end
    end
    return false
end




function soothe()
    if not functions.CanCast(spells.soothe) then return false end
    for _, unit in ipairs(state.getUnits) do
        if game_api.isFacing(unit) and functions.IsInRange(30, unit) then
            for auraId, _ in pairs(cLists.soothe) do
                if game_api.unitHasAura(unit, auraId, false) then
                    print("Soothing Enemy")
                    game_api.castSpellOnTarget(spells.soothe, unit)
                    return true
                end
            end
        end
    end
    return false
end

function calculatePowerScale()
    local powerScale = 1  -- Base power scale

    -- Check for Stealth, Shadowmeld, or Incarnation buffs
    if state.prowl or state.shadowmeld or state.incarnProwl then
        powerScale = powerScale + 1
    end

    -- Check for Sudden Ambush or Smoldering Frenzy buffs
    if game_api.currentPlayerHasAura(auras.suddenAmbush, true) or state.prowl or state.shadowmeld or state.incarnProwl then
        powerScale = powerScale + 1.6
    end
    if game_api.currentPlayerHasAura(auras.smolderingFrenzy, true) then
        powerScale = powerScale + 1.2
    end
    if state.incarn or state.berserk then
        powerScale = powerScale + 1.5
    end
    -- Check for Tiger's Fury buff
    if game_api.currentPlayerHasAura(auras.tigersFury, true) then
        powerScale = powerScale + 1.15
    end

    return powerScale
end

state.lastRakePowerScale = state.lastRakePowerScale 

function castRakeIfMorePowerful(target)
    local currentPowerScale = calculatePowerScale()

    -- Compare current power scale with the last one for this target
    if currentPowerScale > (state.lastRakePowerScale or 0) then
        state.lastRakePowerScale = currentPowerScale
        game_api.castSpellOnTarget(spells.rake, target)
        return true
    end

    return false
end

function calculateRipPowerScale()
    local powerScale = 1  -- Base power scale

    if game_api.currentPlayerHasAura(auras.smolderingFrenzy, true) then
        powerScale = powerScale + 1.2
    end

    -- Check for Tiger's Fury buff
    if game_api.currentPlayerHasAura(auras.tigersFury, true) then
        powerScale = powerScale + 1.15
    end

    return powerScale
end

state.lastRipPowerScale = state.lastRipPowerScale 

function castRipIfMorePowerful(target)
    local currentPowerScale = calculateRipPowerScale()
    if (currentPowerScale > (state.lastRipPowerScale or 0)) or functions.isInPandemicRemainingTime(state.currentTarget,auras.rip_debuff) then
        state.lastRipPowerScale = currentPowerScale
        game_api.castSpellOnTarget(spells.rip, target)
        return true
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




function OnUpdate()
    if game_api.getToggle(settings.Pause) then return end
    if not game_api.isSpec(137011) then
        print("User is not in Putty Cat spec, waiting..")
        return true
    end
    StateUpdate()

    if game_api.currentPlayerIsCasting() or game_api.currentPlayerIsMounted() or game_api.currentPlayerIsChanneling() or game_api.isAOECursor() then
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
    if not game_api.currentPlayerHasAura(auras.incarnationGuardianOfAshamane,true) then
        state.castedProwl = false
    end

    if state.PlayerIsInCombat then
        if Defensive() then
            return true
        end
        if brez() then
            return true
        end
        if not state.isRaid and soothe() then
            return true
        end
        if not state.isRaid and Interrupt() then
            return true
        end
        if innervate() then
            return true
        end
        if functions.useRacialCommon() then
            return true
        end
        if state.TargetCheck then
            if functions.useConsume(auras.incarnationGuardianOfAshamane, auras.berserk, false) then
                return true
            end
            if functions.dpsTrinket(auras.incarnationGuardianOfAshamane,auras.berserk) then
                return true
            end
            if functions.CanCast(spells.rake) then
                if state.prowl or  state.shadowmeld or state.incarnProwl then
                    print("Casting Rake from Stealth")
                    state.lastRakePowerScale = calculatePowerScale()
                    game_api.castSpellOnTarget(spells.rake,state.currentTarget)
                    return true
                end
            end    
            if game_api.getToggle(settings.cooldowns)  and functions.timeToDieGroup() >= game_api.getSetting(settings.timeToDie) then
                if cooldowns() then
                    return true
                end
            end
            if state.currentComboPoints >= 4 and state.unitsInRange >= 3  and not state.iris then
                if spenderAOE() then
                    return true
                end
            end
            if state.unitsInRange >= 3 and not state.iris then
                if builderAOE() then
                    return true
                end
            end
            if state.currentComboPoints >= 4 and state.unitsInRange <=2 and (state.bloodTalons or state.berserk or state.incarn) then
                if spenderST() then
                    return true
                end
            end
            if builderSTNew() then
                return true
            end
        end
    end
    if not game_api.unitInCombat(state.currentPlayer)  then
        if OOC()then
            return true
        end
    end
    return false
end 