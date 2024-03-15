local settings = {}
game_api = require("lib")

settings.barkskin = "Barkskin"
settings.barkskinDesc = "Health to use Barkskin"
settings.renewal = "Renewal"
settings.renewalDesc = "Health to use Renewal"
settings.survivalInstincts = "Survival Instincts"
settings.survivalInstinctsDesc = "Health to use Survival Instincts"
settings.natures_vigil = "Nature's Vigil"
settings.natures_vigilDesc = "Health to use Nature's Vigil"
settings.regrowth = "Instant Regrowth"
settings.regrowthDesc = "Health to use Instant Regrowth"
settings.groupRegrowth = "Instant Regrowth - Group Heal"
settings.groupRegrowthDesc = "Health to use Instant Regrowth on Group"
settings.innervate = "Innervate Usage"
settings.innervateDesc = "Healer Mana Setting to use Innervate"
settings.innervateToggle = "Innervate Toggle"
settings.innervateToggleDesc = "Toggle for Innervate Usage"
settings.timeToDie = "Time To Die"
settings.timeToDieDesc = "Set Time To Die usage for Cooldowns"
settings.autoRetarget = "Auto Retarget:"
settings.autoRetargetDesc = "Will Retarget in combat if Target is Dead or Dont have one"
settings.kickEverything = "Kick Everything"
settings.kickEverythingDesc = "Kicks every Channeled and Casted Spell"
settings.useStun = "Stuns"
settings.useStunDesc = "Toggle to Use Stuns for Interrupts"
settings.interruptPercent = "Interrupt Percent"
settings.interruptPercentDesc = "Cast/Channel Percent to interrupt at"
settings.stunPercent = "Stun Percent"
settings.stunPercentDesc = "Stun Percent (Keep Low due to GCD)"
settings.proactiveDefensives = "Defensives Proactively"
settings.proactiveDefensivesDesc = "Toggle use Defensives Proactively: Barkskin, Survival Instincts, Nature's Vigil"
settings.engageOOC = "Engages OCC"
settings.engageOOCDesc = "Toggle Engages OCC Prowl/Rake"
settings.alignCD = "Align Cooldowns"
settings.alignCDDesc = "Toggle to Align Cooldowns - Convoke - Berserk"
-- Toggles
settings.Pause = "Pause"
settings.interrupts = "Interrupts"
settings.interruptsDesc = "Toggle use Interrupts"
settings.cooldowns = "Cooldowns"
settings.cooldownsDesc = "Toggle use Cooldowns: Convoke, Berserk/Incarn"
settings.Pause = "Pause"
settings.miniCooldowns = "Cooldowns Mini"
settings.miniCooldownsDesc = "Toggle use Mini Cooldowns: Feral Frenzy"
settings.targetBrez = "Battle Rez"
settings.targetBrezDesc = "Toggle to Target Unit for Brez"

--POTIONS
settings.potionOfPower = "Potion of Power Usage"
settings.potionOfPowerText = "How to use Potion of Power"
settings.healthPotionHP = "Potion - Healing"
settings.healthPotionHPText = "Health to Use Healing Potion"
settings.healthStoneHP = "Healthstone HP"
settings.healthStoneHPText = "Health to Use Health Stone"
settings.manaPotionMana = "Potion - Mana"
settings.manaPotionManaText = "Mana to Use Mana Potion"
--trinket
settings.trinket1 = "Trinket 1 Usage"
settings.trinket1Text = "How to use 1st trinket (top slot)"
settings.trinket2 = "Trinket 2 Usage"
settings.trinket2Text = "How to use 2nd trinket (bottom slot)"
settings.defensiveTrinketHP = "Trinket - Defensive"
settings.defensiveTrinketHPText = "Health to Use Defensive Trinket"
-- Racials
settings.useRacials = "Racials"
settings.useRacialsText = "Decide if you would like to use racials or not"
settings.racialsName = "Racials mode"
settings.racialsNameText = "Decide which racial to use"
settings.racialsClass = "Racials Class"
settings.racialsClassText = "Decide Which Racial Class to Use"

function settings.createSettings()
    game_api.createSetting(settings.kickEverything, settings.kickEverythingDesc, false, {})
    game_api.createSetting(settings.autoRetarget, settings.autoRetargetDesc, true, {})
    game_api.createSetting(settings.innervate, settings.innervateDesc, 60, {0, 100})

    game_api.createSetting(settings.interruptPercent, settings.interruptPercentDesc, 60, { 0, 100 })
    game_api.createSetting(settings.stunPercent, settings.stunPercentDesc, 40, { 0, 100 })
    game_api.createSetting(settings.timeToDie, settings.timeToDieDesc, 15, { 0, 100 })
    game_api.createSetting(settings.barkskin, settings.barkskinDesc, 65, { 0, 100 })
    game_api.createSetting(settings.renewal, settings.renewalDesc, 60, { 0, 100 })
    game_api.createSetting(settings.survivalInstincts, settings.survivalInstinctsDesc, 50, { 0, 100 })
    game_api.createSetting(settings.natures_vigil, settings.natures_vigilDesc, 75, { 0, 100 })
    game_api.createSetting(settings.regrowth, settings.regrowthDesc, 50, { 0, 100 })
    game_api.createSetting(settings.groupRegrowth, settings.groupRegrowthDesc, 30, { 0, 100 })
    game_api.createSetting(settings.innervateToggle, settings.innervateToggleDesc, true, {})
    game_api.createSetting(settings.autoRetarget, settings.autoRetargetDesc, true, {})
    game_api.createSetting(settings.useStun, settings.useStunDesc, true, {})
    game_api.createSetting(settings.proactiveDefensives, settings.proactiveDefensivesDesc, true, {})
    game_api.createSetting(settings.engageOOC, settings.engageOOCDesc, true, {})
    game_api.createSetting(settings.alignCD, settings.alignCDDesc, true, {})

    -- Toggles
    game_api.createToggle(settings.Pause, settings.Pause, false, 0)
    game_api.createToggle(settings.interrupts, settings.interruptsDesc, true, 0)
    game_api.createToggle(settings.cooldowns, settings.cooldownsDesc, true, 0)
    game_api.createToggle(settings.miniCooldowns, settings.miniCooldownsDesc, true, 0)
    game_api.createToggle(settings.targetBrez, settings.targetBrezDesc, true, 0)

    -- Potions
    game_api.createSetting(settings.potionOfPower, settings.potionOfPower, "Dont Use", {"On Cooldown", "With Cooldown", "Dont Use", "With Lust", "With Lust or Cooldowns" })
    game_api.createSetting(settings.healthPotionHP, settings.healthPotionHPText, 50, { 0, 100 })
    game_api.createSetting(settings.manaPotionMana, settings.manaPotionManaText, 50, { 0, 100 })
    game_api.createSetting(settings.healthStoneHP, settings.healthStoneHPText, 50, { 0, 100 })

    -- trinkets
    game_api.createSetting(settings.trinket1, settings.trinket1Text, "Dont Use", {"On Cooldown", "With Cooldown", "Dont Use", "With Lust", "With Lust or Cooldowns", "Defensive" })
    game_api.createSetting(settings.trinket2, settings.trinket2Text, "Dont Use", {"On Cooldown", "With Cooldown", "Dont Use", "With Lust", "With Lust or Cooldowns", "Defensive" })
    game_api.createSetting(settings.defensiveTrinketHP, settings.defensiveTrinketHPText, 50, { 0, 100 })
   -- racials
   game_api.createSetting(settings.useRacials, settings.useRacialsText, false, {})
   game_api.createSetting(settings.racialsName, settings.racialsNameText, "None", { "None", "Fireblood","Shadowmeld", "Blood fury", "Gift of the Naaru", "Berserking", "Stoneform", "Ancestral call", "Will to survive", "Escape artist", "War stomp"})
   game_api.createSetting(settings.racialsClass, settings.racialsClassText, "None", { "None", "Warrior", "Hunter", "Rogue", "Deathknight", "Priest", "Mage", "Warlock", "Shaman", "Monk", "Demon Hunter", "Paladin", "Druid"})


end

return settings
