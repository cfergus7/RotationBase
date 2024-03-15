local lists = {}

lists.PlayerCDs = {
    -- MAGE
    190319, -- Combustion
    12472,  -- Icy Veins
    12042,  -- Arcane Power

    -- DRUID
    194223, -- Celestial Alignment
    102560, -- Incarnation: Chosen of Elune

    -- WARRIOR
    316828, -- Recklessness

    -- WARLOCK
    266087, -- Infernal // Rainy Thingy
    265273, -- Tyrant with demonic buff

    -- ROGUE
    121471, -- Shadow Blades
    13750,  -- Adrenaline Rush

    -- PALADIN
    31884,  -- Avenging Wrath

    -- HUNTER
    288613, -- Trueshot
    266779, -- Coordinated Assault
    193530, -- Aspect of the Wild

    -- SHAMAN
    191634, -- Stormkeeper
    51533,  -- Feral Spirit

    -- DEMONHUNTER
    191427 -- Metamorphosis
}

lists.npcIdList = { [198594] = true, [81638] = true, [131009] = true, [133361] = true, [197833] = true, [125977] = true, [194643] = true, [127315] = true, [48416] = true}


lists.priorityKickList = {
    [278444] = true, [367503] = true, [411300] = true, [395427] = true, [385036] = true, [255824] = true, [372223] = true, [388862] = true, [257737] = true, [388863] = true,
    [369675] = true, [377389] = true, [426541] = true, [278961] = true, [164887] = true, [387974] = true, [199663] = true, [383385] = true, [415773] = true, [385046] = true,
    [256849] = true, [76820] = true, [369365] = true, [395694] = true, [374339] = true, [418200] = true, [410870] = true, [377402] = true, [387411] = true, [243369] = true,
    [384161] = true, [377341] = true, [385310] = true, [386012] = true, [392451] = true, [400165] = true, [378172] = true, [266036] = true, [413044] = true, [413427] = true,
    [383656] = true, [257397] = true, [390988] = true, [227913] = true, [267824] = true, [201298] = true, [429176] = true, [373395] = true, [193585] = true, [374544] = true,
    [384808] = true, [412922] = true, [200630] = true, [169839] = true, [255041] = true, [412924] = true, [373017] = true, [169840] = true, [384365] = true, [253544] = true,
    [396925] = true, [257784] = true, [387618] = true, [265346] = true, [264390] = true, [164965] = true, [252781] = true, [382712] = true, [264520] = true, [201399] = true,
    [374045] = true, [260879] = true, [377488] = true, [225562] = true, [412233] = true, [376725] = true, [388392] = true, [387564] = true, [372711] = true, [201837] = true,
    [396640] = true, [386546] = true, [264050] = true, [373872] = true, [200658] = true, [253583] = true, [382787] = true, [417481] = true, [388882] = true, [374563] = true,
    [265487] = true, [416256] = true, [369400] = true, [76813] = true, [266106] = true, [408805] = true, [265091] = true, [197797] = true, [263959] = true, [272183] = true,
    [204243] = true, [169825] = true, [396812] = true, [264024] = true, [387606] = true, [264407] = true, [382347] = true, [377500] = true, [389804] = true, [373803] = true,
    [225568] = true, [88170] = true, [200642] = true, [373804] = true, [88186] = true, [373932] = true, [265876] = true, [256060] = true, [413607] = true, [202108] = true,
    [196883] = true, [369823] = true, [278755] = true, [374699] = true, [265368] = true, [253517] = true, [253562] = true, [418202] = true, [411994] = true, [265433] = true,
    [415437] = true, [426783] = true, [377950] = true, [385029] = true, [412378] = true, [252923] = true, [369411] = true, [87779] = true, [415770] = true, [369603] = true,
    [260698] = true, [386024] = true, [367500] = true, [271174] = true, [201411] = true, [265089] = true, [86331] = true, [375602] = true, [164973] = true, [372538] = true,
    [415435] = true, [374706] = true, [165213] = true, [167385] = true, [250368] = true, [168082] = true, [427459] = true,
    [400180] = true, [413606] = true, [407891] = true, [250096] = true, [259572] = true, 
}

lists.priorityStunList = {
    [167385] = true, -- uber strike
    [253721] = true, -- Creates a barrier; mobs inside the barrier take 90% less damage
    [258653] = true, -- Creates a barrier; mobs inside the barrier take 90% less damage
    [268931] = true, -- Creates a barrier; mobs inside the barrier take 90% less damage
    [268202] = true, -- If not CC'd to stop it, it stuns and deals damage to the target
    [268203] = true, -- If not CC'd to stop it, it stuns and deals damage to the target
    [412012] = true, -- Stacking damage amplification on the target
    [412044] = true, -- Stacking damage amplification on the target
    [412200] = true, -- Massive frontal damage
    [412225] = true, -- Massive frontal damage
    [200291] = true, -- Does painful AOE damage if you let the cast go through
    [200325] = true, -- Does painful AOE damage if you let the cast go through
    [235823] = true, -- Does painful AOE damage if you let the cast go through
    [241064] = true, -- Does painful AOE damage if you let the cast go through
    [241065] = true, -- Does painful AOE damage if you let the cast go through
    [235824] = true, -- Does painful AOE damage if you let the cast go through
    [200345] = true, -- Very painful conal AOE at the target
    [200344] = true, -- Very painful conal AOE at the target
    [208068] = true, -- Very painful conal AOE at the target
    [200784] = true, -- Gains a huge buff
    [76516] = true,  -- Does a big targeted DoT if successful
    [200084] = true, -- soul blade
    [214001] = true, --ravens divineProtection
    [200913] = true, -- Indigestion
    [201139] = true, -- Brutal Assault
    [214003] = true,  -- Coup de Gace
    [225962] = true, -- Bloodthirsty leap
    [200343] = true, -- Arrow Barrage
    [172578] = true, -- Bounding Whirl
    [38166] = true, -- Enrage
    [413607] = true, -- Corroding Volley
    [400180] = true, -- Corroding Volley
    [413606] = true, -- Corroding Volley
    [412922] = true, -- Binding Grasp
    [415770] = true, -- Infinite bolt volley
    [412924] = true, 
    [407891] = true, 
    [204243] = true, 
    [201399] = true, 
    [200630] = true, 
    [200658] = true, 
    [225568] = true, 
    [256849] = true, 
    [253544] = true, 
    [253517] = true, 
    [252781] = true, 
    [253562] = true, 
    [255041] = true, 
    [250096] = true, 


}



lists.soothe = {
    [38166] = true,
    [257260] = true,
    [165213] = true,
    [255824] = true,
    [428291] = true,
    [426618] = true,
}


lists.uniqueIDs = {
    240443, 377405, 389179, 372682, 384161, 370766, 388777,
    374350, 377510, 397907, 415437, 404141, 403910, 374389,
    217851, 273226
}
lists.CurseList = {
    369365, -- Uldaman: Curse of Stone
    369366, -- Uldaman: Trapped in Stone
    369365, -- Brakenhide Hollow: Curse of Stone
    391762, -- Netlharus: Curse of Dragon hoard
    387615, -- Nokhud Offensive: Grasp of the Dead
    397911, -- Temple of the Jade Serpent: Touch of Ruin
    397936, -- Temple of the Jade Serpent: Touch of Ruin
    114803, -- Temple of the Jade Serpent: Throw Torch
    110125, -- Temple of the Jade Serpent: Shattered Resolve
    409465, -- Affix: Cursed Spirit
    265433  -- The Underrot: Withering Curse
}
lists.DiseaseList = {
    
    -- 69818, -- Uldaman: Diseased Bite
    377864, -- Brakenhide Hollow: Infectious Spit
    368081, -- Brakenhide Hollow: Withering
    373753, -- Brakenhide Hollow: Withering
    382805, -- Brakenhide Hollow: Necrotic Breath
    382808, -- Brakenhide Hollow: Withering Contagion
    391613, -- HoI: Creeping Mold
    156718, -- Shadowmoon Burial Grounds: Necrotic Burst
    153524, -- Shadowmoon Burial Grounds: Plague Spit
    387629, -- The Nokhud Offensive: Rotting Wind
    409472, -- Affix: Diseased Spirit
    258323, -- Freehold: Infected Wound
    257775, -- Freehold: Plague Step
    258321, -- Freehold: Filthy Blade
    278961, -- The Underrot: Decaying Mind
    273226, -- The Underrot: Decaying Spores
    250372, -- Atal'Dazar: Lingering Nausea
    201365, -- Darkheart Thicket: Darksoul Drain
    76363,  -- Throne of the Tides: Wave Of Corruption
    261440, -- Waycrest Manor: Virulent Pathogen
    264050  -- Waycrest Manor: Infected Thorn
}
lists.MagicList = {
    145206, -- Aqua Bomb
    376827, -- conductive-strike
    -- Uldaman
    375286, -- Searing Cannonfire
    369006, -- Burning Heat
    377405, -- Time Sink
    377510, -- Stolen Time
    -- Brakenhide Hollow
    381379, -- Decayed Senses
    373899, -- Decaying Roots
    373897, -- Decaying Roots ID 2
    -- Halls of Infusion
    383935, -- Spark Volley
    389443, -- Purifying Blast
    387359, -- Waterlogged
    374563, -- Dazzle
    391610, -- Binding Winds
    391634, -- Deep Chill
    374724, -- Molten Subduction
    -- Algeth'ar Academy
    391977, -- Oversurge
    388392, -- Monotnous Letcure
    -- Ruby Life Pools
    381513, -- Stormslam
    381514, -- Stormslam second ID
    392641, -- Rolling Thunder
    373869, -- Burning Touch
    392924, -- Shock Blast
    -- Neltharus
    372461, -- Imbued Magma
    384161, -- Mote of Combustion
    -- Azure Vault
    384978, -- Dragon Strike
    371352, -- Forbidden Knowledge
    377488, -- Icy Bindings
    386368, -- Poly
    386549, -- Waking Bane
    -- Temple of the Jade Serpent
    106823, -- Serpent Strike
    106113, -- Touch of Nothingness
    397878, -- Tainted Ripple
    114803, -- Throw Torch
    395859, -- Haunting Scream
    395872, -- Sleepy Soliloquy
    114826, -- Songbird Serenade
    -- Court of Stars
    207278, -- Arcane Lockdown
    207261, -- Resonant Slash
    208165, -- Withering Soul
    224333, -- Enveloping Winds
    212773, -- Subdue
    209516, -- Mana Fang
    209404, -- Seal Magic
    211470, -- Bewitch
    214688, -- Carrion Swarm
    214690, -- Cripple
    209413, -- Supress
    -- Halls of Valor
    215429, -- Thunderstrike
    -- The Nokhud Offensive
    386063, -- Frightful Roar
    376827, -- Conductive Strike
    386028, -- Thunder Clap
    386025, -- Tempest
    373395, -- Bloodcurdling Shout
    381530, -- Storm Shock
    -- Shadowmoon Burial Grounds
    152819, -- Shadow Word: Frailty
    -- Freehold
    257908, -- Oiled Blade
    256106, -- Azerite Poweder Shot
    -- The Underrot
    272180, -- Death Bolt
    266209, -- Wicked Frenzy
    272609, -- Maddening Gaze
    269301, -- Putrid Blood
    266265, -- Wicked Embrace
    -- Nelths Lair
    186576, -- Petrifying Cloud
    -- The Vortex Pinnacle
    87618,  -- Static Cling
    410873, -- Rushing Wind
    410997, -- Rushing Wind
    -- Dawn of Infinite
    416716, -- Sheared Lifespan
    415769, -- Chronoburst
    415436, -- Tainted Sands
    413544, -- Bloom
    400649, -- Spark of Tyr
    401667, -- Time Stasis
    407121, -- Immolate
    417030, -- Fireball
    412027, -- Chronal Burn
    255371, -- Atal'Dazar Terrifying Visage
    255041, -- Atal'Dazar Terrifying Screech
    255582, -- Atal'Dazar Molten Gold
    200084, -- Black Rook Hold Soul Blade
    194960, -- Black Rook Hold Soul Echoes
    225909, -- Black Rook Hold Soul Venom
    201902, -- Darkheart Thicket Scorching Shot
    416716, -- Dawn of the Infinite Sheared Lifespan
    417030, -- Dawn of the Infinite Fireball
    412027, -- Dawn of the Infinite Chronal Burn
    412378, -- Dawn of the Infinite Dizzying Sands
    407121, -- Dawn of the Infinite Immolate
    428084, -- Everbloom Glacial Fusion
    427863, -- Everbloom Frostbolt
    169840, -- Everbloom Frostbolt
    164965, -- Everbloom Choking Vines
    169839, -- Everbloom Pyroblast
    426849, -- Everbloom Cold Fusion
    75992,  -- Throne of the Tides Lightning Surge
    429048, -- Throne of the Tides Flame Shock
    428103, -- Throne of the Tides Frostbolt
    265881, -- Waycrest Manor Decaying Touch
    264378, -- Waycrest Manor Fragment Soul
    264390, -- Waycrest Manor Spellbind
    264407  -- Waycrest Manor Horrific Visage
}
lists.PoisonList = {
    -- Uldaman
    369419, -- Venomous Fangs
    -- Brakenhide
    385058, -- Withering Poison
    385039, -- Withering Poison
    -- Algeth'ar Academy
    389033, -- Lasher Toxin
    -- Freehold
    257436, -- Poisoning Strike
    -- Nelths Lair
    217851, -- Toxic Retch
    -- Affix
    409470, -- Poisoned Spirit

    252687, -- Atal'Dazar Venomfang Strike
    200684, -- Atal'Dazar Nightmare Toxin
    198904, -- Atal'Dazar Poison Spear
    165123, -- Everbloom Venom Burst
    169658, -- Everbloom Poisonous Claws
    427460, -- Everbloom Toxic Bloom
    76516,  -- Throne of the Tides Poisoned Spear
    264520  -- Waycrest Manor Severing Serpent
}

lists.RaidList = {
    -- Unshakeable Dread
    347286, -- Players with this debuff are feared. Prioritize dispelling melee players.
    -- Slothful Corruption
    350713, -- Magic debuff that reduces Haste and movement speed of affected players.
    -- Fragments of Destiny
    350542, -- Stacking debuff; monitor stacks.
    -- Frozen Binds
    357298, -- Magic debuff that roots players.
    -- Crushing Dread
    351117, -- Magic debuff in Phase 2.
    -- Gloom - Anduin Hope Debuff
    364031,
    -- Devouring Blood
    364522,
    -- Crushing Prism
    365297,
    -- Creation Spark
    369505,
    -- Leaping Flame
    389213,
    394917,
    -- Mythic Sark Dispel
    402051
}

lists.PlayerCDs2 = {
    -- Monk Cooldowns
    137639, -- Storm, Earth, and Fire
    152173, -- Serenity
    123904, -- Invoke Xuen, the White Tiger
    -- 325216 -- Bonedust Brew (not sure on this one)

    -- Paladin Cooldowns
    31884, -- Avenging Wrath

    -- Shaman Cooldowns
    191634, -- Stormkeeper
    --198067, -- Fire Elemental
    51533,  -- Feral Spirit

    -- Hunter Cooldowns
    288613, -- Trueshot
    19574,  -- Bestial Wrath

    -- Mage Cooldowns
    190319, -- Combustion
    365350, -- Arcane Surge
    12472,  -- Icy Veins

    -- Warrior Cooldowns
    107574, -- Avatar
    1719,   -- Recklessness

    -- Demon Hunter Cooldowns
    323639, -- The Hunt
    191427, -- Metamorphosis

    -- Priest Cooldowns
    194249, -- Voidform

    -- Evoker Cooldown
    375087, -- Dragonrage

    -- Death Knight Cooldowns
    51271,  -- Pillar of Frost
    315443, -- Abomination Limb
    317250, -- Summon Gargoyle
    207289, -- Unholy Assault

    -- Druid Cooldowns
    102543, -- Incarnation: Avatar of Ashamane
    106951, -- Berserk
    102560, -- Incarnation: Chosen of Elune
    194223, -- Celestial Alignment
    323764, -- Convoke the Spirits

    -- Warlock Cooldowns
    325640, -- Soul Rot
    205180, -- Summon Darkglare
    267217, -- Nether Portal
    265187, -- Summon Demonic Tyrant
    267171, -- Demonic Strength
    1122,   -- Summon Infernal

    -- Rogue Cooldowns
    360194, -- Deathmark
    328305, -- Sepsis
    13750,  -- Adrenaline Rush
    121471, -- Shadow Blades
}

lists.tankBusterMagic = {
    167385, -- uber strike
    405431, --fragments of time magic cast
    400641, -- dividing strike magic cast
    416139, -- temporal breath cast magic
    261438, -- wasting strike magic reflect diffuse
    266225, -- darkened lightning magic reflect cast
    204667, -- nightmare breath cast magic
    427510, -- noxious charge magic cast 
    413529, -- Untwist
    266036, -- Drain Essence
    265881, -- Decaying Touch
    265880, --Dread Mark
    264378, -- Fragment Soul
    428530, -- Murk Spew

}
lists.tankBustersPhysical = {
    167385,
    413013, -- chronoshear phy cast
    407159, -- blight reclamation phy cast
    414535, -- stone cracker barrage phy cast
    401248, -- titanic blow phy cast
    404916, -- sand blast phy cast
    410254, -- decapitate phy cast
    255579, -- gilded claws physical cast
    255434, -- serrated teeth phy cast
    249919, -- skewer phy cast
    260508, -- crush phy cast
    197418, -- vengeful shear phy cast
    198245, -- brutal haymaker phy cast
    198080, -- hateful charge
    198635, -- unerring shear debuff phy instant
    198376, -- primal rampage phy instant
    204611, -- crushing crip cast phy
    404916, -- sand blast
    413131, -- whirling dagger
    265371, -- Focused Strike
    265347, -- Peck
    265760, -- Thorned Barrage
    265337, -- Snout Smack
    256138, -- Feverent Strike
    273185, -- Shield Bash
    252687, -- Venomfang Strike
    255814, -- Rending Maul
    201902, -- Scorching Shot
    225732, -- Strike Down
    201139, -- Brutal Assault
    201176, -- Priceless Artifact
    169657, -- Poisonous Claw
    427245, -- Fungal Fist
    426741, -- Shellbreaker
    429021, -- Crush
    427670, -- Crushing Claw
    429021, --crush faceless watcher

}
lists.tankBustersCombined = {
    [167385] = true, -- uber strike dummy test
    [413013] = true, -- chronoshear phy cast
    [407159] = true, -- blight reclamation phy cast
    [414535] = true, -- stone cracker barrage phy cast
    [401248] = true, -- titanic blow phy cast
    [404916] = true, -- sand blast phy cast
    [410254] = true, -- decapitate phy cast
    [255579] = true, -- gilded claws physical cast
    [255434] = true, -- serrated teeth phy cast
    [249919] = true, -- skewer phy cast
    [260508] = true, -- crush phy cast
    [197418] = true, -- vengeful shear phy cast
    [198245] = true, -- brutal haymaker phy cast
    [198080] = true, -- hateful charge
    [198635] = true, -- unerring shear debuff phy instant
    [198376] = true, -- primal rampage phy instant
    [204611] = true, -- crushing crip cast phy
    [405431] = true, -- fragments of time magic cast
    [400641] = true, -- dividing strike magic cast
    [416139] = true, -- temporal breath cast magic
    [261438] = true, -- wasting strike magic reflect diffuse
    [266225] = true, -- darkened lightning magic reflect cast
    [204667] = true, -- nightmare breath cast magic
    [427510] = true, -- noxious charge magic cast 
    [413131] = true, -- whirling dagger
    [413529] = true, -- Untwist
    [265371] = true, -- Focused Strike
    [266036] = true, -- Drain Essence
    [265347] = true, -- Peck
    [265760] = true, -- Thorned Barrage
    [265337] = true, -- Snout Smack
    [265881] = true, -- Decaying Touch
    [256138] = true, -- Feverent Strike
    [273185] = true, -- Shield Bash
    [252687] = true, -- Venomfang Strike
    [255814] = true, -- Rending Maul
    [201902] = true, -- Scorching Shot
    [225732] = true, -- Strike Down
    [201139] = true, -- Brutal Assault1
    [201176] = true, -- Priceless Artifact
    [169657] = true, -- Poisonous Claw
    [427245] = true, -- Fungal Fist
    [426741] = true, -- Shellbreaker
    [429021] = true, -- Crush
    [427670] = true, -- Crushing Claw
    [428530] = true, -- Murk Spew
}

lists.tankBustersDebuff = {
    [255434] = true, -- serrated Teeth
    [412012] = true, -- Temposlice debuff
    [413544] = true, -- Bloom
    [412262] = true, -- Staticky Punch
    [419351] = true, -- Bonze Exhalation
    [256922] = true, -- Runic Blade
    [265880] = true, --Dread Mark
    [264378] = true, -- Fragment Soul
    [200642] = true, -- Despair
    [201361] = true, -- Darksoul Bite
    [225909] = true, -- Soul Venom
    [164886] = true, -- Dreadpetal Pollen
}
lists.PoisonDiseaseList = {
    [369419] = true, -- Venomous Fangs
    [385058] = true, -- Withering Poison
    [385039] = true, -- Withering Poison
    [389033] = true, -- Lasher Toxin
    [257436] = true, -- Poisoning Strike
    [217851] = true, -- Toxic Retch
    [409470] = true, -- Poisoned Spirit
    [252687] = true, -- Atal'Dazar Venomfang Strike
    [200684] = true, -- Atal'Dazar Nightmare Toxin
    [198904] = true, -- Atal'Dazar Poison Spear
    [165123] = true, -- Everbloom Venom Burst
    [169658] = true, -- Everbloom Poisonous Claws
    [427460] = true, -- Everbloom Toxic Bloom
    [76516] = true,  -- Throne of the Tides Poisoned Spear
    [264520] = true,  -- Waycrest Manor Severing Serpent
    [377864] = true, -- Brakenhide Hollow: Infectious Spit
    [368081] = true, -- Brakenhide Hollow: Withering
    [373753] = true, -- Brakenhide Hollow: Withering
    [382805] = true, -- Brakenhide Hollow: Necrotic Breath
    [382808] = true, -- Brakenhide Hollow: Withering Contagion
    [391613] = true, -- HoI: Creeping Mold
    [156718] = true, -- Shadowmoon Burial Grounds: Necrotic Burst
    [153524] = true, -- Shadowmoon Burial Grounds: Plague Spit
    [387629] = true, -- The Nokhud Offensive: Rotting Wind
    [409472] = true, -- Affix: Diseased Spirit
    [258323] = true, -- Freehold: Infected Wound
    [257775] = true, -- Freehold: Plague Step
    [258321] = true, -- Freehold: Filthy Blade
    [278961] = true, -- The Underrot: Decaying Mind
    [273226] = true, -- The Underrot: Decaying Spores
    [250372] = true, -- Atal'Dazar: Lingering Nausea
    [201365] = true, -- Darkheart Thicket: Darksoul Drain
    [76363] = true, -- Throne of the Tides: Wave Of Corruption
    [261440] = true, -- Waycrest Manor: Virulent Pathogen
    [264050] = true -- Waycrest Manor: Infected Thorn

}

lists.BleedList = {
    [225963] = true,
    [200182] = true,
    [196354] = true,
    [225484] = true,
    [196376] = true,
    [260741] = true,
    [426660] = true,
    [412505] = true,
    [255814] = true,
    [255434] = true,
    [264150] = true,
    [411700] = true,
    [411958] = true,
    [264556] = true
}

lists.BOPList = {
    [225963] = true,
    [200182] = true,
    [196354] = true,
    [225484] = true,
    [196376] = true,
    [260741] = true,
    [426660] = true,
    [412505] = true,
    [255814] = true,
    [255434] = true,
    [264150] = true,
    [411700] = true,
    [411958] = true,
    [264556] = true,
    [201733] = true, --stnging swarm
    [267907] = true,

}

    
lists.FreedomList = {
    [387359] = true,
    [377561] = true,
    [87618] = true,
    [369818] = true,
    [265377] = true,
    [408556] = true,
    [374724] = true,
    [385963] = true,
    [258875] = true,
    [391634] = true,
    [257483] = true,
    [199063] = true,
    [426500] = true,
    [164886] = true,
    [411994] = true,
    [204852] = true,
    [413606] = true,
    [169840] = true,
    [418200] = true,
    [408084] = true,
    [411644] = true,
    [254959] = true,
    [255041] = true,
    [252781] = true,
    [424498] = true
}


lists.tigersList = {
    387359,377561,87618,369818,265377,408556,374724,385963,258875,391634,257483,199063,426500,164886,411994, 204852, 413606, 169840,418200,408084,411644,254959,255041,252781
}






lists.deflectDebuff = {
    [421284] = true, -- Coiling Flames
    [429153] = true, -- Twisting Surge
    [425345] = true, -- Fyr'rath'sFlamen
}



lists.blockDebuff = {
    [414340] = true, -- Drenched Blades
    [419054] = true, -- Molten Venom
    [425492] = true, -- Infernal Maw
    [426519] = true, -- Weaver's Burden
    [252687] = true, -- Venomfang Strike
    [407406] = true, -- Corrosion
    [412012] = true, -- Temposlice Debuff
    [413544] = true, -- Bloom
    [412262] = true, -- Staticky Punch
    [419351] = true, -- Bonze Exhalation
    [256922] = true, -- Runic Blade
    [265880] = true, -- Dread Mark
    [264378] = true, -- Fragment Soul
    [200642] = true, -- Despair
    [201361] = true, -- Darksoul Bite
    [225909] = true, -- Soul Venom
    [164886] = true, -- Dreadpetal Pollen
}


lists.reflectAndBlock = {
    [202019] = true, -- Shadow Bolt Volley
    [196587] = true, -- Soul Burst
    [421986] = true, -- Tainted Bloom
    [422026] = true, -- Tortured Scream
    [414425] = true, -- Blistering Spear
    [422776] = true, -- Marked for Torment
    [418533] = true, -- Smashing Viscera
    [421674] = true, -- Burning Vertebrae
    [420934] = true, -- Flood of the Firelands
    [421671] = true, -- Serpent's Fury
    [421024] = true, -- Emerald Winds
    [420671] = true, -- Nox Blossom
    [421316] = true, -- Consuming Flame
    [427252] = true, -- Falling Embers
    [421323] = true, -- Searing Ash
    [420846] = true, -- Continuum
    [425039] = true, -- Threaded Blast
    [418423] = true, -- Verdant Matrix
    [420907] = true, -- Viridian Rain
    [421343] = true, -- Brand of Damnation
    [420236] = true, -- Falling Stars
    [417431] = true, -- Fyr'alath's Bite
    [200913] = true, -- Indigestion
    [427512] = true, -- Noxious Charge
    [169445] = true, -- Noxious Eruption
    [415770] = true, -- Infinite Bolt Volley
    [413529] = true, -- Untwist
    [419351] = true, -- Exhalation
    [167385] = true, -- Uber Strike
    [405431] = true, -- Fragments of Time Magic Cast
    [400641] = true, -- Dividing Strike Magic Cast
    [416139] = true, -- Temporal Breath Cast Magic
    [261438] = true, -- Wasting Strike Magic Reflect Diffuse
    [266225] = true, -- Darkened Lightning Magic Reflect Cast
    [204667] = true, -- Nightmare Breath Cast Magic
    [427510] = true, -- Noxious Charge Magic Cast
    [266036] = true, -- Drain Essence
    [265881] = true, -- Decaying Touch
    [265880] = true, -- Dread Mark
    [264378] = true, -- Fragment Soul
    [428530] = true, -- Murk Spew
    [370649] = true, [372275] = true, [372315] = true,
    [372394] = true, [376851] = true, [385812] = true,
    [375424] = true, [375653] = true, [374352] = true,
    [390942] = true, [387975] = true, 
    [388862] = true, [211401] = true, [211406] = true,
    [209036] = true, [373364] = true, [209413] = true,
    [211473] = true, [212784] = true, [191976] = true,
    [192288] = true, [198959] = true, [413590] = true,
    [416256] = true, [415435] = true, [415436] = true,
    [417030] = true, [411763] = true, [418202] = true,
    [413606] = true, [400165] = true, [421284] = true,
    [429153] = true, [425345] = true, [250096] = true,
    [253562] = true, [254959] = true, [252687] = true,
    [252923] = true, [199663] = true, [200248] = true,
    [200238] = true, [200185] = true, [201298] = true,
    [201411] = true, [200684] = true, [200642] = true,
    [200631] = true, [204243] = true, [201837] = true,
    [201361] = true, [168040] = true, [168092] = true,
    [427858] = true, [427863] = true, [427885] = true,
    [164886] = true, [164965] = true, [164973] = true,
    [169840] = true, [169839] = true, [169657] = true,
    [169658] = true, [428376] = true, [428103] = true,
    [428263] = true, [429048] = true, [429173] = true,
    [428889] = true, [428526] = true, [426783] = true,
    [429176] = true, [76820] = true, [303825] = true,
    [428542] = true, [426768] = true, [75992] = true,
    [260701] = true, [260700] = true, [260699] = true,
    [265372] = true,
    [278444] = true, [264153] = true, [263943] = true,
    [264105] = true, [264024] = true,
    [426541] = true, [267824] = true,
    [264556] = true, 
}



lists.reflectable = {

    [410351] = true, [397386] = true, [403699] = true, [403203] = true, [370649] = true, [372275] = true, [381315] = true, [391322] = true, [372315] = true, [372394] = true, 
    [376851] = true, [385812] = true, [375424] = true, [375653] = true, [250096] = true, [253562] = true, [254959] = true, [252687] = true, [252923] = true, [199663] = true, 
    [200248] = true, [200238] = true, [200185] = true, [201411] = true, [200684] = true, [200642] = true, [200631] = true, [200630] = true, [204243] = true, [201837] = true, 
    [201361] = true, [168040] = true, [168092] = true, [427885] = true, [427858] = true, [427863] = true, [164886] = true, [164885] = true, [164965] = true, [164973] = true, 
    [169840] = true, [169839] = true, [169657] = true, [169658] = true, [413590] = true, [415435] = true, [415436] = true, [411958] = true, [416254] = true, [412285] = true, 
    [417030] = true, [411763] = true, [418202] = true, [400165] = true, [413606] = true, [413607] = true, [400180] = true, [426783] = true, [429176] = true, [76820] = true, 
    [426731] = true, [428542] = true, [426768] = true, [75992] = true, [429048] = true, [429173] = true, [428889] = true, [428526] = true, [428263] = true, [428376] = true, 
    [428374] = true, [428103] = true, [260697] = true, [260701] = true, [260696] = true, [260700] = true, [260698] = true, [260699] = true, [261438] = true, [261439] = true, 
    [261440] = true, [268271] = true, [268278] = true, [266225] = true, [265372] = true, [264050] = true, [278444] = true, [278456] = true, 
    [264153] = true, [263943] = true, [264105] = true, [264054] = true, [265881] = true, [265880] = true, [426541] = true, [267824] = true, [264556] = true, [266036] = true, 
    [381694] = true, [373804] = true, [382474] = true, [378155] = true, [382249] = true, [382798] = true, [281420] = true, [258323] = true, [259092] = true, [257908] = true, 
    [389443] = true, [374389] = true, [386757] = true, [387571] = true, [387359] = true, [387504] = true, [395690] = true, [375950] = true, [385036] = true, [374706] = true, 
    [374020] = true, [385963] = true, [373424] = true, [382002] = true, [372538] = true, [383231] = true, [378818] = true, [384597] = true, [375251] = true, 
    [186269] = true, [200732] = true, [210150] = true, [198496] = true, [369417] = true, [369006] = true, [368996] = true, [369399] = true, [369419] = true, [369674] = true, 
    [369675] = true, [369823] = true, [377405] = true, [372718] = true, [260879] = true, [265084] = true, [259720] = true, [278961] = true, [266265] = true, 
    [272180] = true, [188196] = true, [410873] = true, [87762] = true, [87854] = true, [88959] = true, [410760] = true, [374352] = true, [390942] = true, 
    [387975] = true, [388862] = true, [211401] = true, [211406] = true, [209036] = true, [373364] = true, [209413] = true, [211473] = true, [212784] = true, [191976] = true, 
    [193668] = true, [192288] = true, [198959] = true, [198962] = true, [198595] = true, [373803] = true, [372808] = true, [372682] = true, [373693] = true, [371984] = true, 
    [372683] = true, [384194] = true, [385536] = true, [385310] = true, [373869] = true, [392576] = true, [162696] = true, [152853] = true, [398206] = true, [153524] = true, 
    [152814] = true, [152819] = true, [156776] = true, [156722] = true, [397801] = true, [114571] = true, [106823] = true, [107053] = true, [397914] = true, [397888] = true, 
    [114803] = true, [397931] = true, [397911] = true, [384978] = true, [371306] = true, [377503] = true, [389804] = true, [374789] = true, [384761] = true, [382670] = true, 
    [376827] = true, [376829] = true, [381530] = true, [396206] = true, [386012] = true, [387127] = true, [387125] = true, [387613] = true, [386026] = true, [360162] = true, 
    [361001] = true, [359778] = true, [359976] = true, [364030] = true, [365801] = true, [362885] = true, [363607] = true, [361513] = true, [360959] = true, [366234] = true, 
    [362383] = true, [360259] = true, [360618] = true, [364865] = true, [365041] = true, [361579] = true, [364073] = true, [360006] = true, [350803] = true, [348969] = true, 
    [350283] = true, [354231] = true, [350801] = true, [353603] = true, [353931] = true, [353398] = true, [352141] = true, [352650] = true, [358183] = true, [334852] = true, 
    [335114] = true, [328885] = true, [331573] = true, [342321] = true, [342320] = true, [330968] = true, [346800] = true, [346654] = true, [331634] = true, [326005] = true, 
    [326994] = true, [326851] = true, [165122] = true, [165152] = true, [173148] = true, [173149] = true, [173150] = true, [173480] = true, [173489] = true, [228252] = true, 
    [228389] = true, [241788] = true, [228277] = true, [241809] = true, [230161] = true, [230162] = true, [230050] = true, [229711] = true, [374743] = true, [229706] = true, 
    [227465] = true, [227285] = true, [228991] = true, [227641] = true, [227628] = true, [229083] = true, [298669] = true, [291878] = true, [293827] = true, [294855] = true, 
    [294860] = true, [299450] = true, [300764] = true, [300659] = true, [300211] = true, [294195] = true, [162422] = true, [162423] = true, [162407] = true, [161588] = true, 
    [164192] = true, [176032] = true, [176033] = true, [176039] = true, [166335] = true, [166336] = true, [166341] = true, [166340] = true, [176147] = true, [322736] = true, 
    [323166] = true, [320008] = true, [320230] = true, [325258] = true, [327646] = true, [332605] = true, [334076] = true, [332196] = true, [328707] = true, [333641] = true, 
    [332234] = true, [333711] = true, [323544] = true, [322977] = true, [323001] = true, [328322] = true, [323538] = true, [328791] = true, [338003] = true, [325700] = true, 
    [326829] = true, [325876] = true, [323057] = true, [322655] = true, [324923] = true, [322557] = true, [331718] = true, [325223] = true, [325418] = true, [322486] = true, 
    [324527] = true, [329110] = true, [325550] = true, [322491] = true, [328475] = true, [328002] = true, [328180] = true, [328094] = true, [334926] = true, [320512] = true, 
    [322554] = true, [328593] = true, [334660] = true, [326712] = true, [321249] = true, [326827] = true, [326837] = true, [326952] = true, [322169] = true, [321038] = true, 
    [324368] = true, [324662] = true, [324608] = true, [334053] = true, [322817] = true, [317661] = true, [323804] = true, [317959] = true, [328667] = true, [320788] = true, 
    [322274] = true, [334748] = true, [320462] = true, [320170] = true, [320171] = true, [333479] = true, [323347] = true, [345770] = true, [347632] = true, [347635] = true, 
    [358919] = true, [357196] = true, [355888] = true, [353836] = true, [355915] = true, [355930] = true, [356031] = true, [356324] = true, [355642] = true, [355641] = true, 
    [354297] = true, [356843] = true, [355225] = true, [320120] = true, [319669] = true, [324079] = true, [330784] = true, [330700] = true, [330703] = true, [345245] = true,
    [167385] = true 
}

        
lists.harmFulDebuff = {

    [267907] = true,
    [260741] = true,
    [263943] = true,
    [220855] = true,
    [196376] = true,
    [200238] = true,
    [197546] = true,
    [255575] = true,
    [250096] = true,
    [428542] = true,
    [426660] = true,
    [415554] = true, --choroburst
    [407406] = true, --
    [400681] = true, -- spark of tyr
    [413208] = true, -- sand buffeted
    [407120] = true, -- serrated axe
    [407205] = true,
    [413547] = true, -- bloom
}


lists.aoeIncoming = {

    427899, --firestorm EB
    169179, --EB last boss Stomp

}



return lists