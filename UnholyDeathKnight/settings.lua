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
function settings.createSettings()

    game_api.createToggle(settings.AoE, "Auto AoE toggle",true,0);
    game_api.createToggle(settings.Cooldown, "Cooldown toggle",true,0);
    game_api.createToggle(settings.Pause, "Pause toggle",false,0);
    game_api.createToggle(settings.Kick, "Interrupt Toggle",false,0);
    
    game_api.createSetting(settings.autoRetarget, settings.autoRetargetDesc, true, {})

end

return settings