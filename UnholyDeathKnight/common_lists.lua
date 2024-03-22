local common_lists = {}

common_lists.PlayerCDs = {
    -- MAGE
    190319, -- Combustion
    12472,  -- Icy Veins
    12042,  -- Arcane Power

    -- DRUID
    194223, -- Celestial Alignment
    102560, -- Incarnation: Chosen of Elune

    -- WARRIOR
    316828, -- Recklessness
    1719,   -- Recklessness

    -- WARLOCK
    266087, -- Infernal // Rainy Thingy
    265273, -- Tyrant with demonic buff

    -- ROGUE
    121471, -- Shadow Blades
    13750,  -- Adrenaline Rush

    -- PALADIN
    31884,  -- Avenging Wrath
    231895, -- Crusade

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

common_lists.npcIdList = {
    [198594] = true,
    [81638] = true,
    [131009] = true,
    [133361] = true,
    [125977] = true,
    [127315] = true,
    [48416] = true,
    [194648] = true,
    [31146] = true,
    [153292] = true,
    [114832] = true,
    [131989] = true,
    [196642] = true,
    [125828] = true,
    [197833] = true,
    [101008] = true,
    [153285] = true,
    [65310] = true,


}


common_lists.priorityKickList = {
    --Dragon Flight Season 3
    [278444] = true, -- Infest
    [367503] = true, -- Withering Burst
    [411300] = true, -- Fish Bolt Volley
    [395427] = true, -- Burning Roar
    [385036] = true, -- Wind Buffet
    [255824] = true, -- Fanatic's Rage
    [372223] = true, -- Mending Clay
    [388862] = true, -- Surge
    [257737] = true, -- Thundering Squall
    [388863] = true, -- Mana Void
    [369675] = true, -- Chain Lightning
    [377389] = true, -- Call of the Flock
    [426541] = true, -- Runic Bolt
    [278961] = true, -- Decaying Mind
    [164887] = true, -- Healing Waters
    [387974] = true, -- Arcane Missiles
    [199663] = true, -- Soul Blast
    [383385] = true, -- Rotting Surge
    [415773] = true, -- Temporal Detonation
    [385046] = true, -- Withering Poison
    [256849] = true, -- Dino Might
    [76820] = true,  -- Hex
    [369365] = true, -- Curse of Stone
    [395694] = true, -- Elemental Focus
    [374339] = true, -- Demoralizing Shout
    [418200] = true, -- Infinite Burn
    [410870] = true, -- Cyclone
    [377402] = true, -- Aqueous Barrier
    [387411] = true, -- Death Bolt Volley
    [243369] = true, -- Drain Life
    [384161] = true, -- Mote of Combustion
    [377341] = true, -- Tidal Divergence
    [385310] = true, -- Lightning Bolt
    [386012] = true, -- Stormbolt
    [392451] = true, -- Flashfire
    [400165] = true, -- Epoch Bolt
    [378172] = true, -- Molten Core
    [266036] = true, -- Drain Essence
    [413044] = true, -- Dark Echoes
    [413427] = true, -- Time Beam
    [383656] = true, -- Molten Army
    [257397] = true, -- Healing Balm
    [390988] = true, -- Water Bolt
    [227913] = true, -- Felfrenzy
    [267824] = true, -- Scar Soul
    [201298] = true, -- Bloodbolt
    [429176] = true, -- Aquablast
    [373395] = true, -- Bloodcurdling Shout
    [193585] = true, -- Bound
    [374544] = true, -- Burst of Decay
    [384808] = true, -- Guardian Wind
    [412922] = true, -- Binding Grasp
    [200630] = true, -- Unnerving Screech
    [169839] = true, -- Pyroblast
    [255041] = true, -- Terrifying Screech
    [412924] = true, -- Binding Grasp
    [373017] = true, -- Roaring Blaze
    [169840] = true, -- Frostbolt
    [384365] = true, -- Disruptive Shout
    [253544] = true, -- Bwonsamdi's Mantle
    [396925] = true, -- Lava Bolt
    [257784] = true, -- Frost Blast
    [387618] = true, -- Infuse
    [265346] = true, -- Pallid Glare
    [264390] = true, -- Spellbind
    [164965] = true, -- Choking Vines
    [252781] = true, -- Unstable Hex
    [382712] = true, -- Necrotic Breath
    [264520] = true, -- Severing Serpent
    [201399] = true, -- Dread Inferno
    [374045] = true, -- Expulse
    [260879] = true, -- Blood Bolt
    [377488] = true, -- Icy Bindings
    [225562] = true, -- Blood Metamorphosis
    [412233] = true, -- Rocket Bolt Volley
    [376725] = true, -- Storm Bolt
    [388392] = true, -- Monotonous Lecture
    [387564] = true, -- Mystic Vapors
    [372711] = true, -- Infuse Corruption
    [201837] = true, -- Shadow Bolt
    [396640] = true, -- Healing Touch
    [386546] = true, -- Waking Bane
    [264050] = true, -- Infected Thorn
    [373872] = true, -- Gushing Ooze
    [200658] = true, -- Star Shower
    [253583] = true, -- Fiery Enchant
    [382787] = true, -- Decay Claws
    [417481] = true, -- Displace Chronosequence
    [388882] = true, -- Inundate
    [374563] = true, -- Dazzle
    [265487] = true, -- Shadow Bolt Volley
    [416256] = true, -- Stonebolt
    [369400] = true, -- Earthen Ward
    [76813] = true,  -- Healing Wave
    [266106] = true, -- Sonic Screech
    [408805] = true, -- Destabilize
    [265091] = true, -- Gift of G'huun
    [197797] = true, -- Arcane Blitz
    [263959] = true, -- Soul Volley
    [272183] = true, -- Raise Dead
    [204243] = true, -- Tormenting Eye
    [169825] = true, -- Arcane Blast
    [396812] = true, -- Mystic Blast
    [264024] = true, -- Soul Bolt
    [387606] = true, -- Dominate
    [264407] = true, -- Horrific Visage
    [382347] = true, -- Witherbolt
    [377500] = true, -- Hasten
    [389804] = true, -- Heavy Tome
    [373803] = true, -- Cold Claws
    [225568] = true, -- Curse of Isolation
    [88170] = true,  -- Cloudburst
    [200642] = true, -- Despair
    [373804] = true, -- Touch of Decay
    [88186] = true,  -- Vapor Form
    [373932] = true, -- Illusionary Bolt
    [265876] = true, -- Ruinous Volley
    [256060] = true, -- Revitalizing Brew
    [413607] = true, -- Corroding Volley
    [202108] = true, -- Petrifying Totem
    [196883] = true, -- Spirit Blast
    [369823] = true, -- Spiked Carapace
    [278755] = true, -- Harrowing Despair
    [374699] = true, -- Cauterize
    [265368] = true, -- Spirited Defense
    [253517] = true, -- Mending Word
    [253562] = true, -- Wildfire
    [418202] = true, -- Temporal Blast
    [411994] = true, -- Chronomelt
    [265433] = true, -- Withering Curse
    [415437] = true, -- Enervate
    [426783] = true, -- Mind Flay
    [377950] = true, -- Greater Healing Rapids
    [385029] = true, -- Screech
    [412378] = true, -- Dizzying Sands
    [252923] = true, -- Venom Blast
    [369411] = true, -- Sonic Burst
    [87779] = true,  -- Greater Heal
    [415770] = true, -- Infinite Bolt Volley
    [369603] = true, -- Defensive Bulwark
    [260698] = true, -- Soul Bolt
    [386024] = true, -- Tempest
    [367500] = true, -- Hideous Cackle
    [271174] = true, -- Retch
    [201411] = true, -- Firebolt
    [265089] = true, -- Dark Reconstitution
    [86331] = true,  -- Lightning Bolt
    [375602] = true, -- Erratic Growth
    [164973] = true, -- Dancing Thorns
    [372538] = true, -- Melt
    [415435] = true, -- Infinite Bolt
    [374706] = true, -- Pyretic Burst
    [165213] = true, -- Enraged Growth
    [167385] = true, -- Uber Strike
    [250368] = true, -- Noxious Stench
    [168082] = true, -- Revitalize
    [427459] = true, -- Toxic Bloom
    [400180] = true, -- Corroding Volley
    [413606] = true, -- Corroding Volley
    [407891] = true, -- Healing Wave
    [259572] = true, -- Noxious Stench
    [426768] = true, -- Lightning Bolt
    [428103] = true, -- Frostbolt
    [426731] = true, -- Water Bolt
    [200248] = true, -- Arcane Blitz
    [428263] = true, -- Water Bolt
    [260699] = true, -- Soul Bolt
    [260700] = true, -- Ruinous Bolt
    [260701] = true, -- Bramble Bolt
    [268278] = true, -- Wracking Chord
    [426596] = true, -- Soul Bolt
    --[168092] = true, -- Water Bolt
    [266225] = true, -- darkened lightning

}



common_lists.ignoreUnits = {
    [125977] = true, -- reanimation-totem
    [100991] = true, -- strangling-roots
    [174773] = true, -- Spiteful
    [204773] = true, -- Afflicted
    [204560] = true, -- Incorp
    [206352] = true, -- Battlefield
    [203857] = true, -- Battlefield
    [203688] = true, -- Battlefield


}

common_lists.priorityStunList = {
    [167385] = true, -- Uber Strike
    [253721] = true, -- Bulwark of Juju
    [258653] = true, -- Bulwark of Juju
    [268931] = true, -- Bulwark of Juju
    [268202] = true, -- Death Lens
    [268203] = true, -- Death Lens
    [412012] = true, -- Temposlice
    [412044] = true, -- Temposlice
    [412200] = true, -- Electro-Juiced Gigablast
    [412225] = true, -- Electro-Juiced Gigablast
    [200291] = true, -- Knife Dance
    [200325] = true, -- Knife Dance
    [235823] = true, -- Knife Dance
    [241064] = true, -- Knife Dance
    [241065] = true, -- Knife Dance
    [235824] = true, -- Knife Dance
    [200345] = true, -- Arrow Barrage
    [200344] = true, -- Arrow Barrage
    [208068] = true, -- Arrow Barrage
    [200784] = true, -- &quot;Drink&quot; Ancient Potion
    [76516] = true,  -- Poisoned Spear
    [200084] = true, -- Soul Blade
    [214001] = true, -- Raven's Dive
    [200913] = true, -- Indigestion
    [201139] = true, -- Brutal Assault
    [214003] = true, -- Coup de Grace
    [225962] = true, -- Bloodthirsty Leap
    [200343] = true, -- Arrow Barrage
    [172578] = true, -- Bounding Whirl
    [38166] = true,  -- Enrage
    [413607] = true, -- Corroding Volley
    [400180] = true, -- Corroding Volley
    [413606] = true, -- Corroding Volley
    [412922] = true, -- Binding Grasp
    [415770] = true, -- Infinite Bolt Volley
    [412924] = true, -- Binding Grasp
    [407891] = true, -- Healing Wave
    [204243] = true, -- Tormenting Eye
    [201399] = true, -- Dread Inferno
    [200630] = true, -- Unnerving Screech
    [200658] = true, -- Star Shower
    [225568] = true, -- Curse of Isolation
    [256849] = true, -- Dino Might
    [253544] = true, -- Bwonsamdi's Mantle
    [253517] = true, -- Mending Word
    [252781] = true, -- Unstable Hex
    [253562] = true, -- Wildfire
    [255041] = true, -- Terrifying Screech
    --[250096] = true,


}

common_lists.shadowMeldTarget = {

    [411994] = true, -- Chronomelt
    [409266] = true, -- Extinction Blast
    [409268] = true, -- Extinction Blast
    [409261] = true, -- Extinction Blast
    --[406886] = true, -- Corrosive Infusion
    [408029] = true, -- Necrofrost
    [412922] = true, -- Binding Grasp
    [419511] = true, -- Temporal Link
    [419512] = true, -- Temporal Link
    [418009] = true, -- Serrated Arrows
    [407120] = true, -- Serrated Axe
    [263943] = true, -- Etch
    [266036] = true, -- Drain Essence
    [268202] = true, -- Death Lens
    [264694] = true, -- Rotten Expulsion
    [261439] = true, -- Virulent Pathogen
    [261440] = true, -- Virulent Pathogen
    [199663] = true, -- Soul Blast
    [200248] = true, -- Arcane Blitz
    [203163] = true, -- Sic Bats!
    [198833] = true, -- Shadow Bolt
    --[257407] = true, -- Pursuit
    [254959] = true, -- Soulburn
    [164965] = true, -- Choking Vines
    [169445] = true, -- Noxious Eruption
    [169930] = true, -- Lumbering Swipe
    [169929] = true, -- Lumbering Swipe
    [200642] = true, -- Despair
    [204243] = true, -- Tormenting Eye
    [201837] = true, -- Shadow Bolt
    [201902] = true, -- Scorching Shot
    [200238] = true, -- Feed on the Weak
    [200185] = true, -- Nightmare Bolt
    [200359] = true, -- Induced Paranoia
    [426768] = true, -- Lightning Bolt
    [426783] = true, -- Mind Flay
    [429176] = true, -- Aquablast
    [167385] = true, -- uber strike dummy test
    [250096] = true, -- Wracking Pain

}

common_lists.classSpecIDs = {

    [137015] = true, -- Beast Mastery Hunter
    [137016] = true, -- Marksmanship Hunter
    [137029] = true, -- Holy Paladin
    [137032] = true, -- Discipline Priest
    [137031] = true, -- Holy Priest
    [137017] = true, -- Survival Hunter
    [137010] = true, -- Guardian Druid
    [137037] = true, -- Assassination Rogue
    [137007] = true, -- Unholy Death Knight
    [137024] = true, -- Mistweaver Monk
    [137040] = true, -- Elemental Shaman
    [137033] = true, -- Shadow Priest
    [137025] = true, -- Windwalker Monk
    [137027] = true, -- Retribution Paladin
    [137036] = true, -- Outlaw Rogue
    [137050] = true, -- Fury Warrior
    [212612] = true, -- Havoc Demon Hunter
    [137019] = true, -- Fire Mage
    [137020] = true, -- Frost Mage
    [212613] = true, -- Vengeance Demon Hunter
    [137041] = true, -- Enhancement Shaman
    [137035] = true, -- Subtlety Rogue
    [137046] = true, -- Destruction Warlock
    [137011] = true, -- Feral Druid
    [137044] = true, -- Demonology Warlock
    [137013] = true, -- Balance Druid
    [137048] = true, -- Protection Warrior
    [137043] = true, -- Affliction Warlock
    [137028] = true, -- Protection Paladin
    [137012] = true, -- Restoration Druid
    [356809] = true, -- Devastation Evoker
    [356810] = true, -- Preservation Evoker
    [137023] = true, -- Brewmaster Monk
    [137039] = true, -- Restoration Shaman
    [396186] = true, -- Augmentation Evoker
    [137006] = true, -- Frost Death Knight
    [137049] = true, -- Arms Warrior
    [137008] = true, -- Blood Death Knight



}

common_lists.stoneForm = {
    [373735] = true, -- Dragon Strike
    [372570] = true, -- Bold Ambush
    [372224] = true, -- Dragonbone Axe
    [391762] = true, -- Curse of the Dragon Hoard
    [393444] = true, -- Gushing Wound
    [375416] = true, -- Bleeding
    [367521] = true, -- Bone Bolt
    [367481] = true, -- Bloody Bite
    [378020] = true, -- Gash Frenzy
    [369828] = true, -- Chomp
    [372718] = true, -- Earthen Shards
    [377732] = true, -- Jagged Bite
    [256363] = true, -- Ripper Punch
    --[413131] = true, -- Whirling Dagger
    [413136] = true, -- Whirling Dagger
    [260455] = true, -- Serrated Fangs
    [265533] = true, -- Blood Maw
    [265019] = true, -- Savage Cleave
    [193941] = true, -- Impaling Shard
    [200182] = true, -- Festering Rip
    [196376] = true, -- Grievous Tear
    [412285] = true, -- Stonebolt
    [418009] = true, -- Serrated Arrows
    [407120] = true, -- Serrated Axe
    [416258] = true, -- Stonebolt
    [407313] = true, -- Shrapnel
    [412505] = true, -- Rending Cleave
    [411700] = true, -- Slobbering Bite
    [260741] = true, -- Jagged Nettles
    [264556] = true, -- Tearing Strike
    [426660] = true, -- Razor Jaws
    [225963] = true, -- Bloodthirsty Leap
    [197546] = true, -- Brutal Glaive
    [255434] = true, -- Serrated Teeth
    [271178] = true, -- Ravaging Leap
    [225484] = true, -- Grievous Rip

}

common_lists.FreedomList = {
    [387359] = true, -- Waterlogged
    [377561] = true, -- Time Eruption
    [87618] = true,  -- Static Cling
    [369818] = true, -- Diseased Bite
    [265377] = true, -- Hooked Snare
    [408556] = true, -- Entangled
    [374724] = true, -- Molten Subduction
    [385963] = true, -- Frost Shock
    [258875] = true, -- Blackout Barrel
    [391634] = true, -- Deep Chill
    [257483] = true, -- Pile of Bones
    [199063] = true, -- Strangling Roots
    [426500] = true, -- Gnarled Roots
    [411994] = true, -- Chronomelt
    [204852] = true, -- Awakening Roots
    [413606] = true, -- Corroding Volley
    [169840] = true, -- Frostbolt
    [418200] = true, -- Infinite Burn
    [408084] = true, -- Necrofrost
    [411644] = true, -- Soggy Bonk
    [254959] = true, -- Soulburn
    [255041] = true, -- Terrifying Screech
    --[252781] = true, -- Unstable Hex
    [424498] = true, -- Mass Entanglement
    [401667] = true, -- Time Stasis

}


common_lists.tankBustersCombined = {
    [167385] = true, -- uber strike dummy test
    [413013] = true, -- chronoshear phy cast
    [407159] = true, -- blight reclamation phy cast
    --[414535] = true, -- stone cracker barrage phy cast
    [401248] = true, -- titanic blow phy cast
    [404916] = true, -- sand blast phy cast
    [410254] = true, -- decapitate phy cast
    [255579] = true, -- gilded claws physical cast
    [255434] = true, -- serrated teeth phy cast
    [249919] = true, -- skewer phy cast
    --[260508] = true, -- crush phy cast
    [197418] = true, -- vengeful shear phy cast
    [198245] = true, -- brutal haymaker phy cast
    --[198080] = true, -- hateful charge
    [198635] = true, -- unerring shear debuff phy instant
    [198376] = true, -- primal rampage phy instant
    --[204611] = true, -- crushing crip cast phy, using tankbusterdebuff instead
    --[405431] = true, -- fragments of time magic cast --- weak now
    [400641] = true, -- dividing strike magic cast
    [416139] = true, -- temporal breath cast magic
    [261438] = true, -- wasting strike magic reflect diffuse
    [266225] = true, -- darkened lightning magic reflect cast
    [427510] = true, -- noxious charge magic cast
    --[413131] = true, -- whirling dagger
    [413529] = true, -- Untwist
    --[265371] = true, -- Focused Strike
    [266036] = true, -- Drain Essence
    [265347] = true, -- Peck
    --[265760] = true, -- Thorned Barrage
    --[265337] = true, -- Snout Smack
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
    [427512] = true, -- Murk Spew
    [164357] = true, -- parched gasp
    [424352] = true, -- Dreadfire Barrage
    [423117] = true, -- cataclysm-jaws
    [421020] = true, -- agonizing-claws
    [418637] = true, -- furious-charge
    [427722] = true, -- weavers-burden
    [421343] = true, -- brand-of-damnation
    [425345] = true, -- fyralaths-flame
    [417431] = true, -- fyralaths-bite
    [429037] = true, -- Stormflurry Totem



}

common_lists.newTankLogic = {
    --[167385] = true, -- uber strike
    [421672] = true, -- serpents-fury
    --[421292] = true, -- constricting-thicket
    [420907] = true, -- viridian-rain
    [417455] = true, -- dream-rend
    [422026] = true, -- Tortured Scream
    [427899] = true, -- Firestorm EB
    [169179] = true, -- EB last boss Stomp
    --[204666] = true, -- Shattered Earth
    [266181] = true, -- Dread Essence
    --[260703] = true, -- Runic Mark
    [260773] = true, -- Dire Ritual
    [264734] = true, -- Consume Apocalyptic
    --[415770] = true, -- Infinite Bolt Volley
    --[413622] = true, -- Infinite Fury
    --[413607] = true, -- Corroding Volley
    --[417481] = true, -- Displace Chronosequence
    [411300] = true, -- Fish Bolt Volley
    --[409456] = true, -- Earth Surge
    --[414535] = true, -- Stonecracker
    --[407978] = true, -- Necrotic Winds
    [196587] = true, -- Soul Burst
    --[198073] = true, -- Earthshaking Stomp
    [202019] = true, -- Shadowbolt Volley
    --[264150] = true, -- Shattered
    [263959] = true, -- Soul Volley
    [265876] = true, -- Ruinous Volley
    --[259572] = true, -- Noxious Stench
    --[428868] = true, -- Putrid Roar
    --[427668] = true, -- Shockwave TOT
    --[416264] = true, -- Infinite Corruption
    [200050] = true, -- Apocalyptic Nightmare
    --[428374] = true, -- Focus Tempest
    [413023] = true, -- Ancient Radiance
    [200580] = true, -- Maddening Roar
    --[427223] = true, -- Cinderbolt Salve Timer
    [174921] = true, -- Noxious Eruption
    [177145] = true, -- Noxious Eruption
    --[76634] = true,  -- Swell
    --[419327] = true, -- Infinite Schism
    --[175973] = true, -- Colossal Blow
    [169445] = true, -- Nox erupt
    --[220855] = true, -- DHT Pushback

    [413013] = true, -- chronoshear phy cast
    [407159] = true, -- blight reclamation phy cast
    --[414535] = true, -- stone cracker barrage phy cast
    [401248] = true, -- titanic blow phy cast
    [404916] = true, -- sand blast phy cast
    [410254] = true, -- decapitate phy cast
    [255579] = true, -- gilded claws physical cast
    [255434] = true, -- serrated teeth phy cast
    [249919] = true, -- skewer phy cast
    --[260508] = true, -- crush phy cast
    [197418] = true, -- vengeful shear phy cast
    [198245] = true, -- brutal haymaker phy cast
    --[198080] = true, -- hateful charge
    [198635] = true, -- unerring shear debuff phy instant
    [198376] = true, -- primal rampage phy instant
    --[204611] = true, -- crushing crip cast phy, using tankbusterdebuff instead
    --[405431] = true, -- fragments of time magic cast --- weak now
    [400641] = true, -- dividing strike magic cast
    [416139] = true, -- temporal breath cast magic
    [261438] = true, -- wasting strike magic reflect diffuse
    --[266225] = true, -- darkened lightning magic reflect cast
    [427510] = true, -- noxious charge magic cast
    --[413131] = true, -- whirling dagger
    [413529] = true, -- Untwist
    --[265371] = true, -- Focused Strike
    --[266036] = true, -- Drain Essence
    --[265347] = true, -- Peck
    --[265760] = true, -- Thorned Barrage
    --[265337] = true, -- Snout Smack
    [265881] = true, -- Decaying Touch
    [256138] = true, -- Feverent Strike
    [273185] = true, -- Shield Bash
    --[252687] = true, -- Venomfang Strike
    --[255814] = true, -- Rending Maul
    ---[201902] = true, -- Scorching Shot
    [225732] = true, -- Strike Down
    [201139] = true, -- Brutal Assault1
    --[201176] = true, -- Priceless Artifact
    [169657] = true, -- Poisonous Claw
    ---[427245] = true, -- Fungal Fist
    [426741] = true, -- Shellbreaker
    [429021] = true, -- Crush
    [427670] = true, -- Crushing Claw
    [428530] = true, -- Murk Spew
    [427512] = true, -- Murk Spew
    [164357] = true, -- parched gasp
    [424352] = true, -- Dreadfire Barrage
    [423117] = true, -- cataclysm-jaws
    [421020] = true, -- agonizing-claws
    [418637] = true, -- furious-charge
    [427722] = true, -- weavers-burden
    [421343] = true, -- brand-of-damnation
    [425345] = true, -- fyralaths-flame
    [417431] = true, -- fyralaths-bite
    [429037] = true, -- Stormflurry Tote

}

common_lists.aoeIncoming = {
    [167385] = true, -- uber strike
    [421672] = true, -- serpents-fury
    [421292] = true, -- constricting-thicket
    [420907] = true, -- viridian-rain
    [417455] = true, -- dream-rend
    [422026] = true, -- Tortured Scream
    [427899] = true, -- Firestorm EB
    [169179] = true, -- EB last boss Stomp
    [204666] = true, -- Shattered Earth
    [266181] = true, -- Dread Essence
    [260703] = true, -- Runic Mark
    [260773] = true, -- Dire Ritual
    [264734] = true, -- Consume Apocalyptic
    [415770] = true, -- Infinite Bolt Volley
    [413622] = true, -- Infinite Fury
    [413607] = true, -- Corroding Volley
    [417481] = true, -- Displace Chronosequence
    [411300] = true, -- Fish Bolt Volley
    --[409456] = true, -- Earth Surge
    [414535] = true, -- Stonecracker
    [407978] = true, -- Necrotic Winds
    [196587] = true, -- Soul Burst
    [198073] = true, -- Earthshaking Stomp
    [202019] = true, -- Shadowbolt Volley
    --[264150] = true, -- Shattered
    [263959] = true, -- Soul Volley
    [265876] = true, -- Ruinous Volley
    [259572] = true, -- Noxious Stench
    [428868] = true, -- Putrid Roar
    [427668] = true, -- Shockwave TOT
    [416264] = true, -- Infinite Corruption
    [200050] = true, -- Apocalyptic Nightmare
    [428374] = true, -- Focus Tempest
    [413023] = true, -- Ancient Radiance
    [200580] = true, -- Maddening Roar
    [427223] = true, -- Cinderbolt Salve Timer
    [174921] = true, -- Noxious Eruption
    [177145] = true, -- Noxious Eruption
    [76634] = true,  -- Swell
    [419327] = true, -- Infinite Schism
    [175973] = true, -- Colossal Blow
    [169445] = true, -- Nox erupt
    [220855] = true, -- DHT Pushback
}

common_lists.aoeIncomingTank = {
    [167385] = true, -- uber strike
    [421672] = true, -- serpents-fury
    [421292] = true, -- constricting-thicket
    [420907] = true, -- viridian-rain
    [417455] = true, -- dream-rend
    [422026] = true, -- Tortured Scream
    [427899] = true, -- Firestorm EB
    [169179] = true, -- EB last boss Stomp
    [204666] = true, -- Shattered Earth
    [266181] = true, -- Dread Essence
    [260703] = true, -- Runic Mark
    [260773] = true, -- Dire Ritual
    [264734] = true, -- Consume Apocalyptic
    [415770] = true, -- Infinite Bolt Volley
    [413622] = true, -- Infinite Fury
    [413607] = true, -- Corroding Volley
    [417481] = true, -- Displace Chronosequence
    [411300] = true, -- Fish Bolt Volley
    --[409456] = true, -- Earth Surge
    --[414535] = true, -- Stonecracker
    [407978] = true, -- Necrotic Winds
    [196587] = true, -- Soul Burst
    --[198073] = true, -- Earthshaking Stomp
    [202019] = true, -- Shadowbolt Volley
    --[264150] = true, -- Shattered
    [263959] = true, -- Soul Volley
    [265876] = true, -- Ruinous Volley
    [259572] = true, -- Noxious Stench
    [428868] = true, -- Putrid Roar
    [427668] = true, -- Shockwave TOT
    [416264] = true, -- Infinite Corruption
    [200050] = true, -- Apocalyptic Nightmare
    [428374] = true, -- Focus Tempest
    [413023] = true, -- Ancient Radiance
    [200580] = true, -- Maddening Roar
    [427223] = true, -- Cinderbolt Salve Timer
    [174921] = true, -- Noxious Eruption
    [177145] = true, -- Noxious Eruption
    [76634] = true,  -- Swell
    [419327] = true, -- Infinite Schism
    [175973] = true, -- Colossal Blow
    [169445] = true, -- Nox erupt
    [220855] = true, -- DHT Pushback
}


common_lists.tankBustersDebuff = {
    [255434] = true, -- serrated Teeth
    [412012] = true, -- Temposlice debuff
    [413544] = true, -- Bloom
    [412262] = true, -- Staticky Punch
    [419351] = true, -- Bonze Exhalation
    [256922] = true, -- Runic Blade
    [264378] = true, -- Fragment Soul
    [200642] = true, -- Despair
    [201361] = true, -- Darksoul Bite
    [225909] = true, -- Soul Venom
    [427510] = true, -- noxious charge debuff
    [414340] = true, -- Drenched Blades
    [419054] = true, -- Molten Venom
    [425492] = true, -- Infernal Maw
    [426519] = true, -- Weaver's Burden
    [252687] = true, -- Venomfang Strike
    [407406] = true, -- Corrosion
    [265880] = true, -- Dread Mark
    [204645] = true, -- oakheart grip

}

common_lists.deflectDebuff = {
    [421284] = true, -- Coiling Flames
    [429153] = true, -- Twisting Surge
    [425345] = true, -- Fyr'rath'sFlamen
}



common_lists.blockDebuff = {
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


common_lists.reflectAndBlock = {
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
    -- [405431] = true, -- Fragments of Time Magic Cast
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
    [370649] = true, -- Lava Flow
    [372275] = true, -- Chain Lightning
    [372315] = true, -- Frost Spike
    [372394] = true, -- Lightning Bolt
    [376851] = true, -- Aerial Buffet
    [385812] = true, -- Aerial Slash
    [375424] = true, -- Raging Tempest
    [375653] = true, -- Static Jolt
    [374352] = true, -- Energy Bomb
    [390942] = true, -- Darting Sting
    [387975] = true, -- Arcane Missiles
    [388862] = true, -- Surge
    [211401] = true, -- Drifting Embers
    [211406] = true, -- Firebolt
    [209036] = true, -- Throw Torch
    [373364] = true, -- Vampiric Claws
    [209413] = true, -- Suppress
    [211473] = true, -- Shadow Slash
    [212784] = true, -- Eye Storm
    [191976] = true, -- Arcing Bolt
    [192288] = true, -- Searing Light
    [198959] = true, -- Etch
    [413590] = true, -- Noxious Ejection
    [416256] = true, -- Stonebolt
    [415435] = true, -- Infinite Bolt
    [415436] = true, -- Tainted Sands
    [417030] = true, -- Fireball
    [411763] = true, -- Infinite Blast
    [418202] = true, -- Temporal Blast
    [413606] = true, -- Corroding Volley
    [400165] = true, -- Epoch Bolt
    [421284] = true, -- Coiling Flames
    [429153] = true, -- Twisting Singe
    [425345] = true, -- Fyr'alath's Flame
    [250096] = true, -- Wracking Pain
    [253562] = true, -- Wildfire
    [254959] = true, -- Soulburn
    [252687] = true, -- Venomfang Strike
    [252923] = true, -- Venom Blast
    [199663] = true, -- Soul Blast
    [200248] = true, -- Arcane Blitz
    [200238] = true, -- Feed on the Weak
    [200185] = true, -- Nightmare Bolt
    [201298] = true, -- Bloodbolt
    [201411] = true, -- Firebolt
    [200684] = true, -- Nightmare Toxin
    [200642] = true, -- Despair
    [200631] = true, -- Unnerving Screech
    [204243] = true, -- Tormenting Eye
    [201837] = true, -- Shadow Bolt
    [201361] = true, -- Darksoul Bite
    [168040] = true, -- Nature's Wrath
    [168092] = true, -- Water Bolt
    [427858] = true, -- Fireball
    [427863] = true, -- Frostbolt
    [427885] = true, -- Arcane Blast
    [164886] = true, -- Dreadpetal Pollen
    [164965] = true, -- Choking Vines
    [164973] = true, -- Dancing Thorns
    [169840] = true, -- Frostbolt
    [169839] = true, -- Pyroblast
    [169657] = true, -- Poisonous Claws
    [169658] = true, -- Poisonous Claws
    [428376] = true, -- Focused Tempest
    [428103] = true, -- Frostbolt
    [428263] = true, -- Water Bolt
    [429048] = true, -- Flame Shock
    [429173] = true, -- Mind Rot
    [428889] = true, -- Foul Bolt
    [428526] = true, -- Ink Blast
    [426783] = true, -- Mind Flay
    [429176] = true, -- Aquablast
    [76820] = true,  -- Hex
    [303825] = true, -- Crushing Depths
    [428542] = true, -- Crushing Depths
    [426768] = true, -- Lightning Bolt
    [75992] = true,  -- Lightning Surge
    [260701] = true, -- Bramble Bolt
    [260700] = true, -- Ruinous Bolt
    [260699] = true, -- Soul Bolt
    [265372] = true, -- Shadow Cleave
    [278444] = true, -- Infest
    [264153] = true, -- Spit
    [263943] = true, -- Etch
    [264105] = true, -- Runic Mark
    [264024] = true, -- Soul Bolt
    [426541] = true, -- Runic Bolt
    [267824] = true, -- Scar Soul
    [264556] = true, -- Tearing Strike

}

common_lists.spellWardingAOE = {
    [416267] = true, --dragon after 2nd boss
    [417404] = true, --3rd boss corrosion
    [400641] = true, --Dividing Strike
    [409128] = true, --wild thrash
    [200580] = true, --Maddening Roar
    [199389] = true, --Earthshaking Roar
    [427899] = true, -- Firestorm EB
    [76634] = true,  -- Swell
    [167385] = true, --uber strike



}
common_lists.spellWardingDebuff = {
    [413547] = true, -- bloom
    --[263943] = true, -- etch
    [213611] = true, -- soul rend
    [200084] = true, -- soul blade
    [429263] = true, -- shock blast
    [409266] = true, --Extinction blast

}

common_lists.reflectable = {

    [410351] = true,
    [397386] = true,
    [403699] = true,
    [403203] = true,
    [370649] = true,
    [372275] = true,
    [381315] = true,
    [391322] = true,
    [372315] = true,
    [372394] = true,
    [376851] = true,
    [385812] = true,
    [375424] = true,
    [375653] = true,
    [250096] = true,
    [253562] = true,
    [254959] = true,
    [252687] = true,
    [252923] = true,
    [199663] = true,
    [200248] = true,
    [200238] = true,
    [200185] = true,
    [201411] = true,
    [200684] = true,
    [200642] = true,
    [200631] = true,
    [200630] = true,
    [204243] = true,
    [201837] = true,
    [201361] = true,
    [168040] = true,
    [168092] = true,
    [427885] = true,
    [427858] = true,
    [427863] = true,
    [164886] = true,
    [164885] = true,
    [164965] = true,
    [164973] = true,
    [169840] = true,
    [169839] = true,
    [169657] = true,
    [169658] = true,
    [413590] = true,
    [415435] = true,
    [415436] = true,
    [411958] = true,
    [416254] = true,
    [412285] = true,
    [417030] = true,
    [411763] = true,
    [418202] = true,
    [400165] = true,
    [413606] = true,
    [413607] = true,
    [400180] = true,
    [426783] = true,
    [429176] = true,
    [76820] = true,
    [426731] = true,
    [428542] = true,
    [426768] = true,
    [75992] = true,
    [429048] = true,
    [429173] = true,
    [428889] = true,
    [428526] = true,
    [428263] = true,
    [428376] = true,
    [428374] = true,
    [428103] = true,
    [260697] = true,
    [260701] = true,
    [260696] = true,
    [260700] = true,
    [260698] = true,
    [260699] = true,
    [261438] = true,
    [261439] = true,
    [261440] = true,
    [268271] = true,
    [268278] = true,
    [266225] = true,
    [265372] = true,
    [264050] = true,
    [278444] = true,
    [278456] = true,
    [264153] = true,
    [263943] = true,
    [264105] = true,
    [264054] = true,
    [265881] = true,
    [265880] = true,
    [426541] = true,
    [267824] = true,
    [264556] = true,
    [266036] = true,
    [381694] = true,
    [373804] = true,
    [382474] = true,
    [378155] = true,
    [382249] = true,
    [382798] = true,
    [281420] = true,
    [258323] = true,
    [259092] = true,
    [257908] = true,
    [389443] = true,
    [374389] = true,
    [386757] = true,
    [387571] = true,
    [387359] = true,
    [387504] = true,
    [395690] = true,
    [375950] = true,
    [385036] = true,
    [374706] = true,
    [374020] = true,
    [385963] = true,
    [373424] = true,
    [382002] = true,
    [372538] = true,
    [383231] = true,
    [378818] = true,
    [384597] = true,
    [375251] = true,
    [186269] = true,
    [200732] = true,
    [210150] = true,
    [198496] = true,
    [369417] = true,
    [369006] = true,
    [368996] = true,
    [369399] = true,
    [369419] = true,
    [369674] = true,
    [369675] = true,
    [369823] = true,
    [377405] = true,
    [372718] = true,
    [260879] = true,
    [265084] = true,
    [259720] = true,
    [278961] = true,
    [266265] = true,
    [272180] = true,
    [188196] = true,
    [410873] = true,
    [87762] = true,
    [87854] = true,
    [88959] = true,
    [410760] = true,
    [374352] = true,
    [390942] = true,
    [387975] = true,
    [388862] = true,
    [211401] = true,
    [211406] = true,
    [209036] = true,
    [373364] = true,
    [209413] = true,
    [211473] = true,
    [212784] = true,
    [191976] = true,
    [193668] = true,
    [192288] = true,
    [198959] = true,
    [198962] = true,
    [198595] = true,
    [373803] = true,
    [372808] = true,
    [372682] = true,
    [373693] = true,
    [371984] = true,
    [372683] = true,
    [384194] = true,
    [385536] = true,
    [385310] = true,
    [373869] = true,
    [392576] = true,
    [162696] = true,
    [152853] = true,
    [398206] = true,
    [153524] = true,
    [152814] = true,
    [152819] = true,
    [156776] = true,
    [156722] = true,
    [397801] = true,
    [114571] = true,
    [106823] = true,
    [107053] = true,
    [397914] = true,
    [397888] = true,
    [114803] = true,
    [397931] = true,
    [397911] = true,
    [384978] = true,
    [371306] = true,
    [377503] = true,
    [389804] = true,
    [374789] = true,
    [384761] = true,
    [382670] = true,
    [376827] = true,
    [376829] = true,
    [381530] = true,
    [396206] = true,
    [386012] = true,
    [387127] = true,
    [387125] = true,
    [387613] = true,
    [386026] = true,
    [360162] = true,
    [361001] = true,
    [359778] = true,
    [359976] = true,
    [364030] = true,
    [365801] = true,
    [362885] = true,
    [363607] = true,
    [361513] = true,
    [360959] = true,
    [366234] = true,
    [362383] = true,
    [360259] = true,
    [360618] = true,
    [364865] = true,
    [365041] = true,
    [361579] = true,
    [364073] = true,
    [360006] = true,
    [350803] = true,
    [348969] = true,
    [350283] = true,
    [354231] = true,
    [350801] = true,
    [353603] = true,
    [353931] = true,
    [353398] = true,
    [352141] = true,
    [352650] = true,
    [358183] = true,
    [334852] = true,
    [335114] = true,
    [328885] = true,
    [331573] = true,
    [342321] = true,
    [342320] = true,
    [330968] = true,
    [346800] = true,
    [346654] = true,
    [331634] = true,
    [326005] = true,
    [326994] = true,
    [326851] = true,
    [165122] = true,
    [165152] = true,
    [173148] = true,
    [173149] = true,
    [173150] = true,
    [173480] = true,
    [173489] = true,
    [228252] = true,
    [228389] = true,
    [241788] = true,
    [228277] = true,
    [241809] = true,
    [230161] = true,
    [230162] = true,
    [230050] = true,
    [229711] = true,
    [374743] = true,
    [229706] = true,
    [227465] = true,
    [227285] = true,
    [228991] = true,
    [227641] = true,
    [227628] = true,
    [229083] = true,
    [298669] = true,
    [291878] = true,
    [293827] = true,
    [294855] = true,
    [294860] = true,
    [299450] = true,
    [300764] = true,
    [300659] = true,
    [300211] = true,
    [294195] = true,
    [162422] = true,
    [162423] = true,
    [162407] = true,
    [161588] = true,
    [164192] = true,
    [176032] = true,
    [176033] = true,
    [176039] = true,
    [166335] = true,
    [166336] = true,
    [166341] = true,
    [166340] = true,
    [176147] = true,
    [322736] = true,
    [323166] = true,
    [320008] = true,
    [320230] = true,
    [325258] = true,
    [327646] = true,
    [332605] = true,
    [334076] = true,
    [332196] = true,
    [328707] = true,
    [333641] = true,
    [332234] = true,
    [333711] = true,
    [323544] = true,
    [322977] = true,
    [323001] = true,
    [328322] = true,
    [323538] = true,
    [328791] = true,
    [338003] = true,
    [325700] = true,
    [326829] = true,
    [325876] = true,
    [323057] = true,
    [322655] = true,
    [324923] = true,
    [322557] = true,
    [331718] = true,
    [325223] = true,
    [325418] = true,
    [322486] = true,
    [324527] = true,
    [329110] = true,
    [325550] = true,
    [322491] = true,
    [328475] = true,
    [328002] = true,
    [328180] = true,
    [328094] = true,
    [334926] = true,
    [320512] = true,
    [322554] = true,
    [328593] = true,
    [334660] = true,
    [326712] = true,
    [321249] = true,
    [326827] = true,
    [326837] = true,
    [326952] = true,
    [322169] = true,
    [321038] = true,
    [324368] = true,
    [324662] = true,
    [324608] = true,
    [334053] = true,
    [322817] = true,
    [317661] = true,
    [323804] = true,
    [317959] = true,
    [328667] = true,
    [320788] = true,
    [322274] = true,
    [334748] = true,
    [320462] = true,
    [320170] = true,
    [320171] = true,
    [333479] = true,
    [323347] = true,
    [345770] = true,
    [347632] = true,
    [347635] = true,
    [358919] = true,
    [357196] = true,
    [355888] = true,
    [353836] = true,
    [355915] = true,
    [355930] = true,
    [356031] = true,
    [356324] = true,
    [355642] = true,
    [355641] = true,
    [354297] = true,
    [356843] = true,
    [355225] = true,
    [320120] = true,
    [319669] = true,
    [324079] = true,
    [330784] = true,
    [330700] = true,
    [330703] = true,
    [345245] = true,
    [167385] = true


}


common_lists.Personals = {
    [48707] = true,  -- Anti-Magic Shell
    [48792] = true,  -- Icebound Fortitude
    [198589] = true, -- Blur
    [187827] = true, -- Metamorphosis
    [102342] = true, -- Ironbark
    [61336] = true,  -- Survival Instincts
    [363916] = true, -- Obsidian Scales
    [186265] = true, -- Aspect of the Turtle
    [264735] = true, -- Survival of the Fittest
    [45438] = true,  -- Ice Block
    [342245] = true, -- Alter Time
    [116849] = true, -- Life Cocoon
    [122783] = true, -- Diffuse Magic
    [122278] = true, -- Dampen Harm
    [642] = true,    -- Divine Shield
    [498] = true,    -- Divine Protection
    [47788] = true,  -- Guardian Spirit
    [33206] = true,  -- Pain Suppression
    [47585] = true,  -- Dispersion
    [31224] = true,  -- Cloak of Shadows
    [108271] = true, -- Astral Shift
    [104773] = true, -- Unending Resolve
    [108416] = true, -- Dark Pact
    [118038] = true, -- Die by the Sword
    [6940] = true,   -- Blessing of Sacrifice
}

common_lists.TankDefs = {
    [194679] = true, -- Rune Tap
    [48792] = true,  -- Icebound Fortitude
    [55233] = true,  -- Vampiric Blood
    [187827] = true, -- Metamorphosis
    [61336] = true,  -- Survival Instincts
    [22812] = true,  -- Barkskin
    [122278] = true, -- Dampen Harm
    [122783] = true, -- Diffuse Magic
    [642] = true,    -- Divine Shield
    [228049] = true, -- Guardian of the Forgotten Queen
    [204018] = true, -- Blessing of Spellwarding
    [31850] = true,  -- Ardent Defender
    [86659] = true,  -- Guardian of Ancient Kings
    [871] = true,    -- Shield Wall
    [392966] = true, -- Spell Block
    [23920] = true,  -- Spell Reflection
    [322507] = true, -- Celestial Brew
    [115203] = true, -- Fortifying Brew
}

common_lists.harmFulDebuff = {
    [414425] = true, -- Blistering Spear
    [424579] = true, -- Suppressive Ember
    [421656] = true, -- Cauterizing Wound
    [421326] = true, -- Flash Fire
    [420856] = true, -- Poisonous Javelin
    [421284] = true, -- Coiling Flames
    [417806] = true, -- Burning Presence
    [267907] = true, -- Soul Thorns
    [260741] = true, -- Jagged Nettles
    [263943] = true, -- Etch
    [220855] = true, -- Down Draft
    [196376] = true, -- Grievous Tear
    [200238] = true, -- Feed on the Weak
    [197546] = true, -- Brutal Glaive
    [255575] = true, -- Transfusion
    [250096] = true, -- Wracking Pain
    [428542] = true, -- Crushing Depths
    [426660] = true, -- Razor Jaws
    [415554] = true, -- Chronoburst
    [407406] = true, -- Corrosion
    [400681] = true, -- Spark of Tyr
    [413208] = true, -- Sand Buffeted
    [407120] = true, -- Serrated Axe
    [407205] = true, -- Volatile Mortar
    [413547] = true, -- Bloom
    [200684] = true, -- Nightmare Toxin
    [204645] = true, -- Crushing Grip
    [255835] = true, -- Transfusion

    --[409266] = true, --Extinction blast


}

common_lists.SacList = {
    [414425] = true, -- Blistering Spear
    [424579] = true, -- Suppressive Ember
    [421656] = true, -- Cauterizing Wound
    [421326] = true, -- Flash Fire
    [420856] = true, -- Poisonous Javelin
    [421284] = true, -- Coiling Flames
    [417806] = true, -- Burning Presence
    [267907] = true, -- Soul Thorns
    [260741] = true, -- Jagged Nettles
    [263943] = true, -- Etch
    [220855] = true, -- Down Draft
    [196376] = true, -- Grievous Tear
    [200238] = true, -- Feed on the Weak
    [197546] = true, -- Brutal Glaive
    [255575] = true, -- Transfusion
    [428542] = true, -- Crushing Depths
    [426660] = true, -- Razor Jaws
    [415554] = true, -- Chronoburst
    [400681] = true, -- Spark of Tyr
    [413208] = true, -- Sand Buffeted
    [407120] = true, -- Serrated Axe
    [407205] = true, -- Volatile Mortar
    [413547] = true, -- bloom
    [200684] = true, -- nightmare toxin
    [204645] = true, -- oakheart grip
    [255835] = true, -- transfusion
    [198079] = true, -- hateful gaze
    --[409266] = true, --Extinction blast
    [196587] = true, -- Soul Burst
    [201733] = true, --stnging swarm
    --[250096] = true, --wracking pain

    [196354] = true, --grievous leap
    [225484] = true, -- grievous rip


}


common_lists.healingPotions = {
    [207041] = true, -- Potion of Withering Dreams
    [207023] = true, -- Dreamwalker's Healing Potion
    [207022] = true, -- Dreamwalker's Healing Potion
    [207021] = true, -- Dreamwalker's Healing Potion
    [191380] = true, -- Refreshing Healing Potion
    [191379] = true, -- Refreshing Healing Potion
    [191378] = true, -- Refreshing Healing Potion
}

common_lists.powerPotions = {
    [191914] = true, -- Fleeting Elemental Potion of Ultimate Power
    [191913] = true, -- Fleeting Elemental Potion of Ultimate Power
    [191912] = true, -- Fleeting Elemental Potion of Ultimate Power
    [191383] = true, -- Elemental Potion of Ultimate Power
    [191381] = true, -- Elemental Potion of Ultimate Power
    [191382] = true, -- Elemental Potion of Ultimate Power
    [191906] = true, -- Fleeting Elemental Potion of Power
    [191905] = true, -- Fleeting Elemental Potion of Power
    [191907] = true, -- Fleeting Elemental Potion of Power
    [191387] = true, -- Elemental Potion of Power
    [191389] = true, -- Elemental Potion of Power
    [191388] = true, -- Elemental Potion of Power


}
common_lists.manaPotions = {
    [191386] = true, -- Aerated Mana Potion
    [191384] = true, -- Aerated Mana Potion
    [191385] = true, -- Aerated Mana Potion

}


common_lists.immunity = {

    [350158] = true, -- Annhylde's Bright Aegis
    [350857] = true, -- Banshee Shroud
    [359033] = true, -- Forge's Flames
    [355790] = true, -- Eternal Torment
    [336499] = true, -- Guessing Game
    [323149] = true, -- Embrace Darkness
    [326629] = true, -- Noxious Fog
    [351086] = true, -- Power Overwhelming
    [347097] = true, -- Security Shield
    [164426] = true, -- Reckless Provocation
    [227338] = true, -- Riderless
    [232156] = true, -- Spectral Service
    [229489] = true, -- Royalty
    [369031] = true, -- Sacred Barrier
    [330959] = true, -- Danse Macabre
    [346694] = true, -- Unyielding Shield
    [328921] = true, -- Blood Shroud
    [329808] = true, -- Hardened Stone Form
    [329636] = true, -- Hardened Stone Form
    [367573] = true, -- Genesis Bulwark
    [362505] = true, -- Domination's Grasp
    [84589] = true,  -- Deflecting Winds
    [376724] = true, -- Crackling Shield
    [383840] = true, -- Ablative Barrier
    [388084] = true, -- Glacial Shield
    [117665] = true, -- Bounds of Reality
    [113309] = true, -- Ultimate Power
    [379256] = true, -- Seal Empowerment
    [374779] = true, -- Primal Barrier
    [388431] = true, -- Ruinous Shroud
    [396734] = true, -- Storm Shroud
    [410654] = true, -- Void Empowerment
    [403284] = true, -- Void Empowerment
    [410631] = true, -- Void Empowerment
    [335141] = true, -- Dark Shroud
    [373233] = true, -- Reconfiguration Emitter
    [406730] = true, -- Crucible Instability
    [75683] = true,  -- High Tide
}


common_lists.BOPList = {
    [225963] = true, -- bloodthirsty leap
    [200182] = true, -- festering rip
    [196354] = true, --grievous leap
    [225484] = true, -- grievous rip
    [196376] = true, --grievous tear
    [260741] = true, -- jagged nettles
    [426660] = true, -- razor jaws
    [412505] = true, --rending cleave
    [255814] = true, --rending maul
    [255434] = true, --serrated-teeth
    [264150] = true, --shatter
    [411700] = true, --slobbering-bite
    [411958] = true, --stonebolt
    [264556] = true, --tearing-strike
    [201733] = true, --stnging swarm
    [267907] = true, --soul-thorns
    [260551] = true, -- soul thorns
    [257407] = true, -- pursuit
    --[198079] = true, -- hateful gaze
    [426659] = true, --razor jaws
}

common_lists.purge = {

    [412012] = true, -- Temposlice
    [265368] = true, -- Spirited Defense
    [256922] = true, -- Runic Blade
    [256849] = true, -- Dino Might
    [197797] = true, -- Arcane Blitz


}


common_lists.soothe = {
    [38166] = true,  -- Enrage
    [197797] = true, -- Arcane Blitz
    [257260] = true, -- Enrage
    [165213] = true, -- Enraged Growth
    [255824] = true, -- Fanatic's Rage
    [428291] = true, -- Slithering Assault
    [228318] = true, -- Enrage
    [8599] = true,   -- Enrage
    [167385] = true, -- Uber Strike
    [412012] = true, -- Temposlice
    [412695] = true, -- Relentless Hunger
    [412699] = true, -- Relentless Hunger
    [265368] = true, -- Spirited Defense
    [256922] = true, -- Runic Blade
    [256849] = true, -- Dino Might
    [200248] = true, -- Arcane Blitz
    [426618] = true, -- Slithering Assault
}

common_lists.tankBusterMagic = {
    [167385] = true, -- uber strike
    --[405431] = true, -- fragments of time magic cast
    [400641] = true, -- dividing strike magic cast
    [416139] = true, -- temporal breath cast magic
    [261438] = true, -- wasting strike magic reflect diffuse
    [266225] = true, -- darkened lightning magic reflect cast
    [204667] = true, -- nightmare breath cast magic
    [427510] = true, -- noxious charge magic cast
    [413529] = true, -- Untwist
    [266036] = true, -- Drain Essence
    [265881] = true, -- Decaying Touch
    [265880] = true, -- Dread Mark
    [264378] = true, -- Fragment Soul
    [428530] = true, -- Murk Spew
    [258151] = true, -- Crushing grip??
    [164357] = true, -- parched grasp
    [427512] = true, -- noxious charge
}


common_lists.PoisonDiseaseList = {
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
    [264520] = true, -- Waycrest Manor Severing Serpent
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
    --[250372] = true, -- Atal'Dazar: Lingering Nausea
    [201365] = true, -- Darkheart Thicket: Darksoul Drain
    [76363] = true,  -- Throne of the Tides: Wave Of Corruption
    --[261440] = true, -- Waycrest Manor: Virulent Pathogen
    [264050] = true, -- Waycrest Manor: Infected Thorn


}

common_lists.BleedList2 = {
    [393444] = true, -- Gushing Wound
    [367521] = true, -- Bone Bolt
    [372566] = true, -- Bold Ambush
    [372570] = true, -- Bold Ambush
    [367481] = true, -- Bloody Bite
    [378020] = true, -- Gash Frenzy
    [372718] = true, -- Earthen Shards
    [255814] = true, -- Atal'Dazar - Rending Maul
    [225963] = true, -- Black Rook Hold - Bloodthirsty Leap
    [197546] = true, -- Black Rook Hold - Brutal Glaive
    [196376] = true, -- Darkheart Thicket - Grievous Tear
    [225484] = true, -- Darkheart Thicket - Grievous Rip
    [412285] = true, -- DOTI: Lower - Stonebolt
    [418009] = true, -- DOTI: Upper - Serrated Arrows
    [407120] = true, -- DOTI: Upper - Serrated Axe
    [416258] = true, -- DOTI: Upper - Stonebolt
    [407313] = true, -- DOTI: Upper - Shrapnel
    [412505] = true, -- DOTI: Upper - Rending Cleave
    [411700] = true, -- DOTI: Upper - Slobbering Bite
    [271178] = true, -- Waycrest Manor - Ravaging Leap
    [260741] = true, -- Waycrest Manor - Jagged Nettles
    [264556] = true, -- Waycrest Manor - Tearing Strike

}


common_lists.aoeIncomingWarriorPhysical = {
    [167385] = true, -- uber strike
    [169179] = true, -- EB last boss Stomp
    [204666] = true, -- Shattered Earth
    [409456] = true, -- Earth Surge
    [414535] = true, -- Stonecracker
    [198073] = true, -- Earthshaking Stomp
    [428868] = true, -- Putrid Roar
    [200580] = true, -- Maddening Roar

}

common_lists.aoeIncomingWarriorMagic = {

    [427899] = true, -- Firestorm EB
    [266181] = true, -- Dread Essence
    [260703] = true, -- Runic Mark
    [260773] = true, -- Dire Ritual
    [264734] = true, -- Consume Apocalyptic
    [415770] = true, -- Infinite Bolt Volley
    [413622] = true, -- Infinite Fury
    [413607] = true, -- Corroding Volley
    [417481] = true, -- Displace Chronosequence
    [411300] = true, -- Fish Bolt Volley
    [196587] = true, -- Soul Burst
    [202019] = true, -- Shadowbolt Volley
    --[264150] = true, -- Shattered
    [263959] = true, -- Soul Volley
    [265876] = true, -- Ruinous Volley
    [259572] = true, -- Noxious Stench
    [416264] = true, -- Infinite Corruption
    [200050] = true, -- Apocalyptic Nightmare
    [428374] = true, -- Focus Tempest
    [413023] = true, -- Ancient Radiance
    [427223] = true, -- Cinderbolt Salve Timer
    [174921] = true, -- Noxious Eruption
    [177145] = true, -- Noxious Eruption
    [76634] = true,  -- Swell
    [419327] = true, -- Infinite Schism
    [175973] = true  -- Colossal Blow
}

common_lists.uniqueIDs = {
    240443, 377405, 389179, 372682, 384161, 370766, 388777,
    374350, 377510, 397907, 415437, 404141, 403910, 374389,
    217851, 273226,
    225909, -- Soul Vemon
    261440, -- Virulent Pathogen
    264050, -- Waycrest Manor: Infected Thorn
    --255582, -- Molten Gold
    200182, -- Festering Rip
    412044, -- Temp Slice
    416716, -- Sheared Life
    415554, -- Chronoburst
    400681, -- spark of tyr
    429048, -- flameshock
}
common_lists.CurseList = {
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
    265433, -- The Underrot: Withering Curse
    -- Atal'Dazar
    --252781, -- Unstable Hex
    -- Darkheart Thicket
    201839, -- Curse Of Isolation
    -- DOTI: Upper
    413618, -- Timeless Curse
    -- Throne of the Tides
    76820,  -- Hex
    -- Waycrest Manor
    260703, -- Unstable Runic Mark
    264105, -- Runic Mark
    265880, -- Dread Mark
}
common_lists.DiseaseList = {
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
    --250372, -- Atal'Dazar: Lingering Nausea
    201365, -- Darkheart Thicket: Darksoul Drain
    76363,  -- Throne of the Tides: Wave Of Corruption
    --261440, -- Waycrest Manor: Virulent Pathogen
    264050, -- Waycrest Manor: Infected Thorn

}
common_lists.MagicList = {
    418200, -- infinite burn
    413606, -- corroding volley
    412131, -- orb of contemplation
    411644, -- soggy bonk
    400681, -- spark of tyr
    --411994, -- chrono melt
    415554, -- Chronoburst
    145206, -- Aqua Bomb
    376827, -- conductive-strike
    200642, -- Despair
    204246, -- Tormenting Fear
    164965,
    253562,
    200182, -- Festering Rip
    412044, -- Temposlice
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
    415769, -- Chronoburst
    413547, -- Bloom
    400649, -- Spark of Tyr
    401667, -- Time Stasis
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
    419517, -- Dawn of the INfinute ChonroSeal
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
    264407, -- Waycrest Manor Horrific Visage
    417807, -- Aflame
    200182,

}
common_lists.PoisonList = {
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
common_lists.RaidList = {
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

common_lists.LocalPlayerCDs = {
    -- Monk Cooldowns
    137639, -- Storm, Earth, and Fire
    152173, -- Serenity
    123904, -- Invoke Xuen, the White Tiger
    -- 325216 -- Bonedust Brew (not sure on this one)

    -- Paladin Cooldowns
    31884,  -- Avenging Wrath
    231895, -- Crusade

    -- Shaman Cooldowns
    191634, -- Stormkeeper
    --198067, -- Fire Elemental
    333957, -- Feral Spirit
    114050, -- Ascend
    114051, -- Ascend

    -- Hunter Cooldowns
    288613, -- Trueshot
    19574,  -- Bestial Wrath
    193530, -- Aspect of the Wild
    360952, -- Aspect of the Turtle

    -- Mage Cooldowns
    190319, -- Combustion
    365350, -- Arcane Surge
    12472,  -- Icy Veins
    12042,  -- AP

    -- Warrior Cooldowns
    107574, -- Avatar
    1719,   -- Recklessness

    -- Demon Hunter Cooldowns
    323639, -- The Hunt
    191427, -- Metamorphosis
    200166, -- Meta

    -- Priest Cooldowns
    194249, -- Voidform

    -- Evoker Cooldown
    375087, -- Dragonrage

    -- Death Knight Cooldowns
    51271,  -- Pillar of Frost
    315443, -- Abomination Limb
    317250, -- Summon Gargoyle
    207289, -- Unholy Assault
    47568,  -- Empower Rune Weapon
    49028,  -- Rune Weapon
    152279, -- Breathe

    -- Druid Cooldowns
    102543, -- Incarnation: Avatar of Ashamane
    106951, -- Berserk
    102560, -- Incarnation: Chosen of Elune
    194223, -- Celestial Alignment
    323764, -- Convoke the Spirits
    383410, -- Obs
    390414, -- Incan + Obs

    -- Warlock Cooldowns
    325640, -- Soul Rot
    205180, -- Summon Darkglare
    267217, -- Nether Portal
    265187, -- Summon Demonic Tyrant
    267171, -- Demonic Strength
    1122,   -- Summon Infernal
    265273, -- Demonic Power

    -- Rogue Cooldowns
    360194, -- Deathmark
    328305, -- Sepsis
    13750,  -- Adrenaline Rush
    121471, -- Shadow Blades

    -- Evoker
    375087 -- Dragonrage
}

common_lists.BleedList = {
    393444, -- Gushing Wound
    367521, -- Bone Bolt
    372566, -- Bold Ambush
    372570, -- Bold Ambush
    367481, -- Bloody Bite
    378020, -- Gash Frenzy
    372718, -- Earthen Shards
    255814, -- Atal'Dazar - Rending Maul
    225963, -- Black Rook Hold - Bloodthirsty Leap
    197546, -- Black Rook Hold - Brutal Glaive
    196376, -- Darkheart Thicket - Grievous Tear
    225484, -- Darkheart Thicket - Grievous Rip
    412285, -- DOTI: Lower - Stonebolt
    418009, -- DOTI: Upper - Serrated Arrows
    407120, -- DOTI: Upper - Serrated Axe
    416258, -- DOTI: Upper - Stonebolt
    407313, -- DOTI: Upper - Shrapnel
    412505, -- DOTI: Upper - Rending Cleave
    411700, -- DOTI: Upper - Slobbering Bite
    271178, -- Waycrest Manor - Ravaging Leap
    260741, -- Waycrest Manor - Jagged Nettles
    264556, -- Waycrest Manor - Tearing Strike
    393444, -- Gushing Wound
}
common_lists.HeavyDmgList = {
    410873, -- Rushing Wind
    378208, -- Marked for Butchery
    378229  -- Marked for Butchery
}

common_lists.HoTList = { -- Not sure on the IDs for these (the actual AURA ID)
    139,                 -- Renew
    774,                 -- Rejuvenation
    8936,                -- Regrowth
    48438,               -- Wild Growth
    254419,              -- Riptide
    124682               -- Enveloping Mist
}
common_lists.shieldList = {
    17,    -- Word: Shield
    184662 -- Shield of Vengeance
}

common_lists.npcsToHeal = {
    "204449", -- Chromie
    "208459", -- Fiery tree (RAID)
    "208461", -- Scorching Roots (RAID)
    "207800"  -- Spirit of the Kaldorei (RAID)
}
common_lists.npcsToHealDictionary = {
    [204449] = true, -- Chromie
    [208459] = true, -- Fiery tree (RAID)
    [208461] = true, -- Scorching Roots (RAID)
    [207800] = true, -- Spirit of the Kaldorei (RAID)
    [194646] = true, -- Dummy
    [212590] = true, -- Treant Seedling
    [204773] = true, -- Afflicted

}

common_lists.PhysicalDmgList = {
    -- Atal'Dazar
    256882, -- Wild Trash
    -- Blackrook Hold
    200291, -- Knife Dance
}

common_lists.MagicalDmgList = {
    -- Atal'Dazar
    259572, -- Noxious Stench
    256577, -- Soulfeast
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
    76634,  -- Swell
    -- Waycrest Manor
    260702, -- Unstable Runic Mark
}


common_lists.dummies = {
    -- Misc/Unknown
    [79987]  = "Training Dummy",               -- Location Unknown
    [92169]  = "Raider's Training Dummy",      -- Tanking (Eastern Plaguelands)
    [96442]  = "Training Dummy",               -- Damage (Location Unknown)
    [109595] = "Training Dummy",               -- Location Unknown
    [113963] = "Raider's Training Dummy",      -- Damage (Location Unknown)
    [131985] = "Dungeoneer's Training Dummy",  -- Damage (Zuldazar)
    [131990] = "Raider's Training Dummy",      -- Tanking (Zuldazar)
    [132976] = "Training Dummy",               -- Morale Booster (Zuldazar)
    -- Level 1
    [17578]  = "Hellfire Training Dummy",      -- Lvl 1 (The Shattered Halls)
    [60197]  = "Training Dummy",               -- Lvl 1 (Scarlet Monastery)
    [64446]  = "Training Dummy",               -- Lvl 1 (Scarlet Monastery)
    [144077] = "Training Dummy",               -- Lvl 1 (Dazar'alor) - Morale Booster
    -- Level 3
    [44171]  = "Training Dummy",               -- Lvl 3 (New Tinkertown, Dun Morogh)
    [44389]  = "Training Dummy",               -- Lvl 3 (Coldridge Valley)
    [44848]  = "Training Dummy",               -- Lvl 3 (Camp Narache, Mulgore)
    [44548]  = "Training Dummy",               -- Lvl 3 (Elwynn Forest)
    [44614]  = "Training Dummy",               -- Lvl 3 (Teldrassil, Shadowglen)
    [44703]  = "Training Dummy",               -- Lvl 3 (Ammen Vale)
    [44794]  = "Training Dummy",               -- Lvl 3 (Dethknell, Tirisfal Glades)
    [44820]  = "Training Dummy",               -- Lvl 3 (Valley of Trials, Durotar)
    [44937]  = "Training Dummy",               -- Lvl 3 (Eversong Woods, Sunstrider Isle)
    [48304]  = "Training Dummy",               -- Lvl 3 (Kezan)
    -- Level 55
    [32541]  = "Initiate's Training Dummy",    -- Lvl 55 (Plaguelands: The Scarlet Enclave)
    [32545]  = "Initiate's Training Dummy",    -- Lvl 55 (Eastern Plaguelands)
    -- Level 60
    [32666]  = "Training Dummy",               -- Lvl 60 (Siege of Orgrimmar, Darnassus, Ironforge, ...)
    -- Level 65
    [32542]  = "Disciple's Training Dummy",    -- Lvl 65 (Eastern Plaguelands)
    -- Level 70
    [32667]  = "Training Dummy",               -- Lvl 70 (Orgrimmar, Darnassus, Silvermoon City, ...)
    -- Level 75
    [32543]  = "Veteran's Training Dummy",     -- Lvl 75 (Eastern Plaguelands)
    -- Level 80
    [31144]  = "Training Dummy",               -- Lvl 80 (Orgrimmar, Darnassus, Ironforge, ...)
    [32546]  = "Ebon Knight's Training Dummy", -- Lvl 80 (Eastern Plaguelands)
    -- Level 85
    [46647]  = "Training Dummy",               -- Lvl 85 (Orgrimmar, Stormwind City)
    -- Level 90
    [67127]  = "Training Dummy",               -- Lvl 90 (Vale of Eternal Blossoms)
    -- Level 95
    [79414]  = "Training Dummy",               -- Lvl 95 (Broken Shore, Talador)
    -- Level 100
    [87317]  = "Training Dummy",               -- Lvl 100 (Lunarfall, Frostwall) - Damage
    [87321]  = "Training Dummy",               -- Lvl 100 (Stormshield) - Healing
    [87760]  = "Training Dummy",               -- Lvl 100 (Frostwall) - Damage
    [88289]  = "Training Dummy",               -- Lvl 100 (Frostwall) - Healing
    [88316]  = "Training Dummy",               -- Lvl 100 (Lunarfall) - Healing
    [88835]  = "Training Dummy",               -- Lvl 100 (Warspear) - Healing
    [88906]  = "Combat Dummy",                 -- Lvl 100 (Nagrand)
    [88967]  = "Training Dummy",               -- Lvl 100 (Lunarfall, Frostwall)
    [89078]  = "Training Dummy",               -- Lvl 100 (Frostwall, Lunarfall)
    -- Levl 100 - 110
    [92164]  = "Training Dummy",               -- Lvl 100 - 110 (Dalaran) - Damage
    [92165]  = "Dungeoneer's Training Dummy",  -- Lvl 100 - 110 (Eastern Plaguelands) - Damage
    [92167]  = "Training Dummy",               -- Lvl 100 - 110 (The Maelstrom, Eastern Plaguelands, The Wandering Isle)
    [92168]  = "Dungeoneer's Training Dummy",  -- Lvl 100 - 110 (The Wandering Isles, Easter Plaguelands)
    [100440] = "Training Bag",                 -- Lvl 100 - 110 (The Wandering Isles)
    [100441] = "Dungeoneer's Training Bag",    -- Lvl 100 - 110 (The Wandering Isles)
    [102045] = "Rebellious Wrathguard",        -- Lvl 100 - 110 (Dreadscar Rift) - Dungeoneer
    [102048] = "Rebellious Felguard",          -- Lvl 100 - 110 (Dreadscar Rift)
    [102052] = "Rebellious Imp",               -- Lvl 100 - 110 (Dreadscar Rift) - AoE
    [103402] = "Lesser Bulwark Construct",     -- Lvl 100 - 110 (Hall of the Guardian)
    [103404] = "Bulwark Construct",            -- Lvl 100 - 110 (Hall of the Guardian) - Dungeoneer
    [107483] = "Lesser Sparring Partner",      -- Lvl 100 - 110 (Skyhold)
    [107555] = "Bound Void Wraith",            -- Lvl 100 - 110 (Netherlight Temple)
    [107557] = "Training Dummy",               -- Lvl 100 - 110 (Netherlight Temple) - Healing
    [108420] = "Training Dummy",               -- Lvl 100 - 110 (Stormwind City, Durotar)
    [111824] = "Training Dummy",               -- Lvl 100 - 110 (Azsuna)
    [113674] = "Imprisoned Centurion",         -- Lvl 100 - 110 (Mardum, the Shattered Abyss) - Dungeoneer
    [113676] = "Imprisoned Weaver",            -- Lvl 100 - 110 (Mardum, the Shattered Abyss)
    [113687] = "Imprisoned Imp",               -- Lvl 100 - 110 (Mardum, the Shattered Abyss) - Swarm
    [113858] = "Training Dummy",               -- Lvl 100 - 110 (Trueshot Lodge) - Damage
    [113859] = "Dungeoneer's Training Dummy",  -- Lvl 100 - 110 (Trueshot Lodge) - Damage
    [113862] = "Training Dummy",               -- Lvl 100 - 110 (Trueshot Lodge) - Damage
    [113863] = "Dungeoneer's Training Dummy",  -- Lvl 100 - 110 (Trueshot Lodge) - Damage
    [113871] = "Bombardier's Training Dummy",  -- Lvl 100 - 110 (Trueshot Lodge) - Damage
    [113966] = "Dungeoneer's Training Dummy",  -- Lvl 100 - 110 - Damage
    [113967] = "Training Dummy",               -- Lvl 100 - 110 (The Dreamgrove) - Healing
    [114832] = "PvP Training Dummy",           -- Lvl 100 - 110 (Stormwind City)
    [114840] = "PvP Training Dummy",           -- Lvl 100 - 110 (Orgrimmar)
    -- Level 102
    [87318]  = "Dungeoneer's Training Dummy",  -- Lvl 102 (Lunarfall) - Damage
    [87322]  = "Dungeoneer's Training Dummy",  -- Lvl 102 (Stormshield) - Tank
    [87761]  = "Dungeoneer's Training Dummy",  -- Lvl 102 (Frostwall) - Damage
    [88288]  = "Dungeoneer's Training Dummy",  -- Lvl 102 (Frostwall) - Tank
    [88314]  = "Dungeoneer's Training Dummy",  -- Lvl 102 (Lunarfall) - Tank
    [88836]  = "Dungeoneer's Training Dummy",  -- Lvl 102 (Warspear) - Tank
    [93828]  = "Training Dummy",               -- Lvl 102 (Hellfire Citadel)
    [97668]  = "Boxer's Trianing Dummy",       -- Lvl 102 (Highmountain)
    [98581]  = "Prepfoot Training Dummy",      -- Lvl 102 (Highmountain)
    -- Level 110 - 120
    [126781] = "Training Dummy",               -- Lvl 110 - 120 (Boralus) - Damage
    [131989] = "Training Dummy",               -- Lvl 110 - 120 (Boralus) - Damage
    [131994] = "Training Dummy",               -- Lvl 110 - 120 (Boralus) - Healing
    [144082] = "Training Dummy",               -- Lvl 110 - 120 (Dazar'alor) - PVP Damage
    [144085] = "Training Dummy",               -- Lvl 110 - 120 (Dazar'alor) - Damage
    [144081] = "Training Dummy",               -- Lvl 110 - 120 (Dazar'alor) - Damage
    [153285] = "Training Dummy",               -- Lvl 110 - 120 (Ogrimmar) - Damage
    [153292] = "Training Dummy",               -- Lvl 110 - 120 (Stormwind) - Damage
    -- Level 111 - 120
    [131997] = "Training Dummy",               -- Lvl 111 - 120 (Boralus, Zuldazar) - PVP Damage
    [131998] = "Training Dummy",               -- Lvl 111 - 120 (Boralus, Zuldazar) - PVP Healing
    -- Level 112 - 120
    [144074] = "Training Dummy",               -- Lvl 112 - 120 (Dazar'alor) - PVP Healing
    -- Level 112 - 122
    [131992] = "Dungeoneer's Training Dummy",  -- Lvl 112 - 122 (Boralus) - Tanking
    -- Level 113 - 120
    [132036] = "Training Dummy",               -- Lvl 113 - 120 (Boralus) - Healing
    -- Level 113 - 122
    [144078] = "Dungeoneer's Training Dummy",  -- Lvl 113 - 122 (Dazar'alor) - Tanking
    -- Level 114 - 120
    [144075] = "Training Dummy",               -- Lvl 114 - 120 (Dazar'alor) - Healing
    -- Level 60
    [174569] = "Training Dummy",               -- Lvl 60 (Ardenweald)
    [174570] = "Swarm Training Dummy",         -- Lvl 60 (Ardenweald)
    [174571] = "Cleave Training Dummy",        -- Lvl 60 (Ardenweald)
    [174487] = "Competent Veteran",            -- Lvl 60 (Location Unknown)
    [173942] = "Training Dummy",               -- Lvl 60 (Revendreth)
    [175456] = "Swarm Training Dummy",         -- Lvl 60 (Revendreth)
    [175455] = "Cleave Training Dummy",        -- Lvl 60 (Revendreth)
    -- Level 62
    [174484] = "Immovable Champion",           -- Lvl 62 (Location Unknown)
    [175449] = "Dungeoneer's Training Dummy",  -- Lvl 62 (Revendreth)
    [173957] = "Necrolord's Resolve",          -- Lvl 62 (Oribos)
    [173955] = "Pride's Resolve",              -- Lvl 62 (Oribos)
    [173954] = "Nature's Resolve",             -- Lvl 62 (Oribos)
    [173919] = "Valiant's Resolve",            -- Lvl 62 (Oribos)
    -- Level ??
    [24792]  = "Advanced Training Dummy",      -- Lvl ?? Boss (Location Unknown)
    [30527]  = "Training Dummy",               -- Lvl ?? Boss (Location Unknown)
    [31146]  = "Raider's Training Dummy",      -- Lvl ?? (Orgrimmar, Stormwind City, Ironforge, ...)
    [87320]  = "Raider's Training Dummy",      -- Lvl ?? (Lunarfall, Stormshield) - Damage
    [87329]  = "Raider's Training Dummy",      -- Lvl ?? (Stormshield) - Tank
    [87762]  = "Raider's Training Dummy",      -- Lvl ?? (Frostwall, Warspear) - Damage
    [88837]  = "Raider's Training Dummy",      -- Lvl ?? (Warspear) - Tank
    [92166]  = "Raider's Training Dummy",      -- Lvl ?? (The Maelstrom, Dalaran, Eastern Plaguelands, ...) - Damage
    [101956] = "Rebellious Fel Lord",          -- lvl ?? (Dreadscar Rift) - Raider
    [103397] = "Greater Bulwark Construct",    -- Lvl ?? (Hall of the Guardian) - Raider
    [107202] = "Reanimated Monstrosity",       -- Lvl ?? (Broken Shore) - Raider
    [107484] = "Greater Sparring Partner",     -- Lvl ?? (Skyhold)
    [107556] = "Bound Void Walker",            -- Lvl ?? (Netherlight Temple) - Raider
    [113636] = "Imprisoned Forgefiend",        -- Lvl ?? (Mardum, the Shattered Abyss) - Raider
    [113860] = "Raider's Training Dummy",      -- Lvl ?? (Trueshot Lodge) - Damage
    [113864] = "Raider's Training Dummy",      -- Lvl ?? (Trueshot Lodge) - Damage
    [70245]  = "Training Dummy",               -- Lvl ?? (Throne of Thunder)
    [113964] = "Raider's Training Dummy",      -- Lvl ?? (The Dreamgrove) - Tanking
    [131983] = "Raider's Training Dummy",      -- Lvl ?? (Boralus) - Damage
    [144086] = "Raider's Training Dummy",      -- Lvl ?? (Dazal'alor) - Damage
    [174565] = "Raider's Training Dummy",      -- Lvl ?? (Ardenweald)
    [174566] = "Dungeoneer's Tanking Dummy",   -- Lvl ?? (Ardenweald)
    [174567] = "Raider's Training Dummy",      -- Lvl ?? (Ardenweald)
    [174568] = "Dungeoneer's Tanking Dummy",   -- Lvl ?? (Ardenweald)
    [174491] = "Iron Tester",                  -- Lvl ?? (Location Unknown)
    [174488] = "Unbreakable Defender",         -- Lvl ?? (Location Unknown)
    -- [174489] = "Necromantic Guide", 		  -- Lvl ?? (Location Unknown)
    [174489] = "Raider's Training Dummy",      -- Lvl ?? (Revendreth)
    [175452] = "Raider's Training Dummy",      -- Lvl ?? (Location Unknown)
    [175451] = "Dungeoneer's Tanking Dummy",   -- Lvl ?? (Revendreth)
    [154580] = "Reinforced Guardian",          -- Elysian Hold
    [154583] = "Stalward Guardian",            -- Elysian Hold
    [154585] = "Valiant's Resolve",            -- Elysian Hold
    [154586] = "Stalward Phalanx",             -- Elysian Hold
    [154564] = "Valiant's Humility",           -- Elysian Hold
    [154567] = "Purity's Cleansing",           -- Elysian Hold
    [160325] = "Humility's Obedience",         -- Elysian Hold
    -- Dragonflight
    [194648] = "Training Dummy",               -- Valdrakken
    [194645] = "Training Dummy",               -- Valdrakken (Healing)
    [194649] = "Normal Tank Dummy",            -- Valdrakken
    [198594] = "Cleave Training Dummy",        -- Valdrakken
    --[197833] = "PvP Training Dummy",		  -- Valdrakken
    [197834] = "PvP Training Dummy",           -- Valdrakken (Healing)
    [194646] = "Cleave Training Dummy",        -- Valdrakken (Healing)
    --[194643] = "Dungeoneer's Training Dummy", -- Valdrakken
    --[194644] = "Dungeoneer's Training Dummy", -- Valdrakken (Tanking)
    --[189632] = "Animated Duelist", 			  -- Valdrakken (Raider's Training Dummy)
    --[189617] = "Boulderfist", 			      -- Valdrakken (Raider's Tanking Dummy)
}

return common_lists
