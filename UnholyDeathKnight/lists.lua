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
    31884, -- Avenging Wrath

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
    402051,
    -- Fyrakk Dispel
    417807
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

lists.BleedList = {
    393444, -- Gushing Wound
    367521, -- Bone Bolt
    372566, -- Bold Ambush
    372570, -- Bold Ambush
    367481, -- Bloody Bite
    378020, -- Gash Frenzy
    372718,  -- Earthen Shards
    255814, -- Atal'Dazar - Rending Maul
    225963,       -- Black Rook Hold - Bloodthirsty Leap
    197546,       -- Black Rook Hold - Brutal Glaive
    196376,       -- Darkheart Thicket - Grievous Tear
    225484,       -- Darkheart Thicket - Grievous Rip
    412285,       -- DOTI: Lower - Stonebolt
    418009,       -- DOTI: Upper - Serrated Arrows
    407120,       -- DOTI: Upper - Serrated Axe
    416258,       -- DOTI: Upper - Stonebolt
    407313,       -- DOTI: Upper - Shrapnel
    412505,       -- DOTI: Upper - Rending Cleave
    411700,       -- DOTI: Upper - Slobbering Bite
    271178,       -- Waycrest Manor - Ravaging Leap
    260741,       -- Waycrest Manor - Jagged Nettles
    264556,       -- Waycrest Manor - Tearing Strike
    393444,       -- Gushing Wound
}
lists.HeavyDmgList = {
    410873, -- Rushing Wind
    378208, -- Marked for Butchery
    378229  -- Marked for Butchery
}

lists.HoTList = { -- Not sure on the IDs for these (the actual AURA ID)
    139,          -- Renew
    774,          -- Rejuvenation
    8936,         -- Regrowth
    48438,        -- Wild Growth
    254419,       -- Riptide
    124682        -- Enveloping Mist
}
lists.shieldList = {
    17,    -- Word: Shield
    184662 -- Shield of Vengeance
}

lists.npcsToHeal = {
    "204449", -- Chromie
    "208459", -- Fiery tree (RAID)
    "208461", -- Scorching Roots (RAID)
    "207800"  -- Spirit of the Kaldorei (RAID)
}
lists.PhysicalDmgList = {
    -- Atal'Dazar
    256882, -- Wild Trash
    -- Blackrook Hold
    200291, -- Knife Dance   
    }

    lists.MagicalDmgList = {
    -- Atal'Dazar
    259572, -- Noxious Stench
    256577, -- Soulfeast
    259190, -- Soulrend
    255577, -- Transfusion
    -- Blackrook Hold
    202019, -- Shadowbolt Volley
    -- Darkheart Thicket
    204502, -- Apolocaltic Nightmare
    220855, -- Downdraft
    199389, -- Earthshaking Roar
    204666, -- Shattered Earth
    -- DOTI: Galakronds Fall
    414483, -- Cataclysmic Obliteration
    413622, -- Infinite Fury
    407978, -- Necrotic Winds
    -- DOTI: Murozonds Rise
    413606, -- Corroding Volley
    411952, -- Millenium Aid
    -- Everbloom 
    427223, -- Cinderbolt Salvo
    428951, -- Vibrant Flourish
    169445, -- Noxious Eruption
    -- Throne of Tides
    427668, -- Frestering Shockwave
    428868, -- Putrid Roar
    76634, -- Swell
    -- Waycrest Manor
    260702, -- Unstable Runic Mark
    }

return lists