local settings = {}
game_api = require("lib")

--Toogles

settings.Cooldown = "Cooldown"
settings.Pause = "Pause"




function settings.createSettings()

    game_api.createToggle(settings.Cooldown, "Cooldown toggle",true,0);
    game_api.createToggle(settings.Pause, "Pause toggle",false,0);

    
end

return settings