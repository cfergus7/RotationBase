local settings = {}
game_api = require("lib")

settings.enragedRegeneration = "Enraged Regen"
settings.enragedRegenerationDesc = "Health to use Enraged Regen"
settings.impendingVictory = "Impending Victory"
settings.impendingVictoryDesc = "Health to use Impending Victory"
settings.useStun = "Stun Logic"
settings.useStunDescription = "Toggle to Use Stuns for Interrupts"
settings.interrupts = "Interrupts"
settings.interruptsDescription = "Toggle use Interrupts"
settings.timeToDie = "Time To Die"
settings.timeToDieDesc = "Set Time to Die for Cooldown Usage"
-- Toggles
settings.autoEngage = "Auto Engage"
settings.autoEngageDesc = "Toggle to Auto Engage with Charge"
settings.interruptPercent = "Interrupt Percent"
settings.interruptPercentDesc = "Interrupt Percent"
settings.stunPercent = "Stun Percent"
settings.stunPercentDesc = "Stun Percent (Keep Low due to GCD)"
settings.kickEverything = "Kick Everything"
settings.kickEverythingDesc = "Kicks every Channeled and Casted Spell"
settings.autoRetarget = "Auto Retarget:"
settings.autoRetargetDesc = "Will Retarget in combat if Target is Dead or Dont have one"
settings.cooldowns = "Major CDs"
settings.cooldownsDescription = "Major CDs: Avatar, Recklessness, Thunderous Roar"
settings.cooldownsMinor = "Minor CDs"
settings.cooldownsMinorDescription = "Ravager, Spear of Bastion, Odyn's Fury"
settings.proactiveDefensives = "Proactive Defensives"
settings.proactiveDefensivesDesc = "Toggle to Auto Spell Reflect"
settings.Pause = "Pause"


--POTIONS
settings.potionOfPower = "Potion of Power Usage"
settings.potionOfPowerText = "How to use Potion of Power"
settings.healthPotionHP = "Potion - Healing"
settings.healthPotionHPText = "Health to Use Healing Potion"
settings.healthStoneHP = "Healthstone HP"
settings.healthStoneHPText = "Health to Use Health Stone"
settings.manaPotionMana = "Potion - Mana"
settings.manaPotionManaText = "Mana to Use Mana Potion"
settings.forceST = "Force ST"
settings.forceSTDesc = "Force ST Rotation"
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

    game_api.createSetting(settings.impendingVictory, settings.impendingVictoryDesc, 70, { 0, 100 })
    game_api.createSetting(settings.enragedRegeneration, settings.enragedRegenerationDesc, 50, { 0, 100 })
    game_api.createSetting(settings.interruptPercent, settings.interruptPercentDesc, 60, { 0, 100 })
    game_api.createSetting(settings.stunPercent, settings.stunPercentDesc, 40, { 0, 100 })
    game_api.createSetting(settings.timeToDie, settings.timeToDieDesc, 15, { 0, 100 })
    game_api.createSetting(settings.autoEngage, settings.autoEngageDesc, true, {})
    game_api.createSetting(settings.useStun, settings.useStunDescription, true, {})
    game_api.createSetting(settings.proactiveDefensives, settings.proactiveDefensivesDesc, true, {})
    game_api.createSetting(settings.kickEverything, settings.kickEverythingDesc, false, {})


    -- Toggles
    game_api.createToggle(settings.Pause, settings.Pause, false, 0)
    game_api.createToggle(settings.interrupts, settings.interruptsDescription, true, 0)
    game_api.createToggle(settings.cooldowns, settings.cooldownsDescription, true, 0)
    game_api.createToggle(settings.cooldownsMinor, settings.cooldownsMinorDescription, true, 0)
    game_api.createToggle(settings.forceST, settings.forceSTDesc, false, 0)

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
   game_api.createSetting(settings.racialsName, settings.racialsNameText, "None", { "None", "Fireblood","Shadowmeld",  "Blood fury", "Gift of the Naaru", "Berserking", "Stoneform", "Ancestral call", "Will to survive", "Escape artist", "War stomp"})
   game_api.createSetting(settings.racialsClass, settings.racialsClassText, "None", { "None", "Warrior", "Hunter", "Rogue", "Deathknight", "Priest", "Mage", "Warlock", "Shaman", "Monk", "Demon Hunter", "Paladin", "Druid"})




end

return settings
