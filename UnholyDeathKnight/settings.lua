local settings = {}
game_api = require("lib")
CooldownUsage = { "Logic",  "With Cooldowns Toggle",  "Not Used",  "With Cooldowns and Logic Setting" }

--Toogles

settings.Cooldown = "Cooldown"
settings.Pause = "Pause"
settings.Healonly = "Heal Only"
settings.Dispel = "Dispel"
settings.OOC = "Out of Combat Healing"
settings.EchoSpread = "Echo Spread"
settings.VerdantEmbrace = "Verdant Embrace"
settings.HoldStatis = "Hold for Stasis"
settings.Kick = "Interrupt"


settings.CooldownText = "Use with Logic Settings, With Cooldowns Toggle Enabled, With Cooldowns Toggle and Logic Settings, or not used at all."
settings.PartyText = "Number of Units in M+ for it to be used."
settings.RaidText = "Number of Units in Raid for it to be used"
settings.LifePercentText = "Life Percent of a unit for it to be used"
settings.DefenseLifePercent = "Your life percent for it to be used"
settings.LifePercentAoEText = "Life Percent Average for it to be used, special note : If special logic applies, that will also be taken into consideration"
settings.tankHealthToIgnore = "Tank Health to Ignore"

settings.DreamBreath = "Dream Breath"
settings.DreamFlight = "Dream Flight"
settings.EmeraldBlossom = "Emerald Blossom"
settings.Rewind = "Rewind"
settings.Spiritbloom = "Spiritbloom"
settings.Stasis = "Stasis"
settings.StasisMax = "Stasis Max"
settings.TemporalAnomaly = "Temportal Anomaly"
settings.TiptheScales = "Tip the Scales"
settings.ObsidianScales = "Obsidian Scales"
settings.RenewingBlaze = "Renewing Blaze"
settings.LivingFlameAVG = "Living Flame AVG For Leaping Flames"

settings.Recall = "Auto Recall"

settings.autoRetarget = "Auto Retarget:"
settings.autoRetargetDesc = "Will Retarget in combat if Target is Dead or Dont have one"

settings.LivingFlame = "Living Flame"
settings.Echo = "Echo"
settings.Reversion = "Reversion"
settings.ReversionTank = "Reversion on Tank"
settings.Timedilation = "Time Dilation"
settings.TimedilationTank = "Time Dilation on Tank"
settings.VerdantEmbrace = "Verdant Embrace"
settings.Disintegrate = "Disintegrate"
settings.FirebreathEmpower = "Fire Breath Empowered"
settings.SpiritbloomEmpower = "Spririt Bloom Empowered"
settings.DreamBreathEmpower = "DreamBreath Empowered"
settings.TrinketHP = "Trinket Average Life Percent"
settings.UseTrinket = "Use Trinkets"
settings.UseTrinket1 = "Use Trinket 1"
settings.UseTrinket2 = "Use Trinket 2"
settings.AutoHealNPC = "Auto Heal NPCs"

function settings.createSettings()
    --Toggles
    game_api.createToggle(settings.Pause, "Pause toggle",false,0);
    game_api.createToggle(settings.Cooldown, "Cooldown toggle",true,0);
    game_api.createToggle(settings.Healonly, "Heal Only toggle",true,0);
    game_api.createToggle(settings.Dispel, "Dispel toggle",true,0);
    game_api.createToggle(settings.OOC, "Out of Combat toggle",true,0);
    game_api.createToggle(settings.EchoSpread, "Echo Spread toggle",true,0);
    game_api.createToggle(settings.VerdantEmbrace, "Verdant Embrace toggle",true,0);
    game_api.createToggle(settings.HoldStatis, "Hold for Stasis toggle",true,0);
    game_api.createToggle(settings.Kick, "Interrupt toggle",false,0);

-- AOE SEttings

game_api.createSetting(settings.TrinketHP, "Avg Life Percent for either Trinkets to be used", 75, {0, 100})
game_api.createSetting(settings.UseTrinket, settings.CooldownText, CooldownUsage[1], CooldownUsage)
game_api.createSetting(settings.UseTrinket1, "Would you like the rotation use Trinket 1 if its usable and if settings are met", true, {})
game_api.createSetting(settings.UseTrinket2, "Would you like the rotation use Trinket 1 if its usable and if settings are met", true, {})


game_api.createSetting(settings.DreamBreath, settings.LifePercentAoEText, 85, {0, 100})
game_api.createSetting(settings.DreamFlight, settings.LifePercentAoEText, 35, {0, 100})
game_api.createSetting(settings.EmeraldBlossom, settings.LifePercentAoEText, 85, {0, 100})
game_api.createSetting(settings.Rewind, settings.LifePercentAoEText, 45, {0, 100})
game_api.createSetting(settings.Spiritbloom, settings.LifePercentAoEText, 75, {0, 100})
game_api.createSetting(settings.Stasis, settings.LifePercentAoEText, 45, {0, 100})
game_api.createSetting(settings.StasisMax, settings.LifePercentAoEText, 45, {0, 100})
game_api.createSetting(settings.TemporalAnomaly, settings.LifePercentAoEText, 85, {0, 100})
game_api.createSetting(settings.TiptheScales, settings.LifePercentAoEText, 65, {0, 100})
game_api.createSetting(settings.LivingFlameAVG, settings.LifePercentAoEText, 65, {0, 100})

-- Healing

game_api.createSetting(settings.Echo, settings.LifePercentText, 85, {0, 100})
game_api.createSetting(settings.Reversion, settings.LifePercentText, 75, {0, 100})
game_api.createSetting(settings.ReversionTank, settings.LifePercentText, 90, {0, 100})
game_api.createSetting(settings.Timedilation, settings.LifePercentText, 75, {0, 100})
game_api.createSetting(settings.TimedilationTank, settings.LifePercentText, 85, {0, 100})
game_api.createSetting(settings.VerdantEmbrace, settings.LifePercentText, 65, {0, 100})
game_api.createSetting(settings.LivingFlame, settings.LifePercentText, 45, {0, 100})

-- Empowered

game_api.createSetting(settings.FirebreathEmpower, " Which Rank to Recast? ", 0, {1, 4})
game_api.createSetting(settings.SpiritbloomEmpower, " Which Rank to Recast? ", 1, {1, 4})
game_api.createSetting(settings.DreamBreathEmpower, " Which Rank to Recast?", 0, {1, 4})

-- Others

game_api.createSetting(settings.Recall, "Would you like to Auto Recall?", false, {})

-- Defense
game_api.createSetting(settings.ObsidianScales, settings.DefenseLifePercent, 55, {0, 100})
game_api.createSetting(settings.RenewingBlaze, settings.DefenseLifePercent, 35, {0, 100})

-- Auto Target Settings
game_api.createSetting(settings.tankHealthToIgnore, "Percent if above targeting logic will ignore tank", 70, {0, 100})
game_api.createSetting(settings.AutoHealNPC, "Would you like to Auto Heal NPC Targets? (Only when the lowest player unit is above 45 %)", false, {})

game_api.createSetting(settings.autoRetarget, settings.autoRetargetDesc, true, {})

end

return settings