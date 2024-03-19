local settings = {}
game_api = require("lib")

--Toogles
CooldownUsage = {"With Cooldown",  "On Cooldown",  "Not Used", }

settings.Cooldown = "Cooldown"
settings.Pause = "Pause"
settings.Kick = "Interrupt"
settings.AoE = "Auto AoE"

settings.CooldownText = "Use with Cooldowns, On Cooldown or not used at all."
settings.PartyText = "Number of Units in M+ for it to be used."
settings.RaidText = "Number of Units in Raid for it to be used"
settings.LifePercentText = "Life Percent of a unit for it to be used"
settings.DefenseLifePercent = "Your life percent for it to be used"
settings.LifePercentAoEText = "Life Percent of Units, matching the setting (Number), to be under before it to be used, special note : If special logic applies, that will also be taken into consideration"

settings.autoRetarget = "Auto Retarget:"
settings.autoRetargetDesc = "Will Retarget in combat if Target is Dead or Dont have one"

settings.potionOfPower = "Potion of Power Usage"
settings.potionOfPowerText = "How to use Potion of Power"
settings.healthPotionHP = "Potion - Healing"
settings.healthPotionHPText = "Health to Use Healing Potion"
settings.healthStoneHP = "Healthstone HP"
settings.healthStoneHPText = "Health to Use Health Stone"
settings.manaPotionMana = "Potion - Mana"
settings.manaPotionManaText = "Mana to Use Mana Potion"

settings.trinket1 = "Trinket 1 Usage"
settings.trinket1Text = "How to use 1st trinket (top slot)"
settings.trinket2 = "Trinket 2 Usage"
settings.trinket2Text = "How to use 2nd trinket (bottom slot)"
settings.defensiveTrinketHP = "Trinket - Defensive"
settings.defensiveTrinketHPText = "Health to Use Defensive Trinket"

function settings.createSettings()

    game_api.createToggle(settings.AoE, "Auto AoE toggle",true,0);
    game_api.createToggle(settings.Cooldown, "Cooldown toggle",true,0);
    game_api.createToggle(settings.Pause, "Pause toggle",false,0);
    game_api.createToggle(settings.Kick, "Interrupt Toggle",false,0);
    
    game_api.createSetting(settings.autoRetarget, settings.autoRetargetDesc, true, {})

    game_api.createSetting(settings.potionOfPower, settings.potionOfPower, "With Lust or Cooldowns", {"On Cooldown", "With Cooldown", "Dont Use", "With Lust", "With Lust or Cooldowns" })
    game_api.createSetting(settings.healthPotionHP, settings.healthPotionHPText, 50, { 0, 100 })
    game_api.createSetting(settings.manaPotionMana, settings.manaPotionManaText, 50, { 0, 100 })
    game_api.createSetting(settings.healthStoneHP, settings.healthStoneHPText, 50, { 0, 100 })

    game_api.createSetting(settings.trinket1, settings.trinket1Text, "Dont Use", {"On Cooldown", "With Cooldown", "Dont Use", "With Lust", "With Lust or Cooldowns", "Defensive" })
    game_api.createSetting(settings.trinket2, settings.trinket2Text, "Dont Use", {"On Cooldown", "With Cooldown", "Dont Use", "With Lust", "With Lust or Cooldowns", "Defensive" })
    game_api.createSetting(settings.defensiveTrinketHP, settings.defensiveTrinketHPText, 50, { 0, 100 })
end

return settings