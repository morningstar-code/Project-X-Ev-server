custom_skins = {
    "ig_vanya",
    "bobby_brown",
    "a_f_y_tessa_cop",
    "ig_shevy",
    "ig_tony",
    "ig_sayeed_w",
    "ig_holden",
    "ig_mike",
    "mr_kebun",
    "a_m_m_taco",
    "a_m_m_mel",
    "a_f_y_tessa",
    "s_m_y_joker",
    "a_f_y_ellie",
    "a_f_y_ellie_talon",
    "shaggy",
    "ig_trafficwarden_m",
    "g_m_y_famfor_01_m",
    -- "francis_j_francer", -- removed, don't re-add
    "francis_small_francer",
    "g_m_m_chigoon_01_m",
    "g_m_m_chigoon_02_m",
    "ig_car3guy1_m",
    "a_m_y_skater_m",
    "ig_terry_m",
    "a_m_m_ktown_m",
    "a_m_y_stbla_m",
    "s_f_y_cop_02c",
    "u_m_y_coop",
    "a_m_o_eugene",
    "a_f_y_zelda",
    "a_m_y_erf",
    "g_m_m_buddha",
    "ig_buddha",
    "u_m_y_coop_cop",
    "a_m_y_leslie",
    "g_m_y_gary",
    "ig_rudi",
    "a_f_m_trish",
    "s_m_m_snow",
    "a_m_m_taco_kid",
    "s_m_m_jacob",
    "a_m_y_jacket",
    "ig_garrett",
    "a_f_y_windsong",
    "s_m_y_happy",
    "a_m_y_stiv",
    "ig_speedy",
    "u_m_y_coop_casual",
    "a_m_o_bill",
    "ramee",
    "p_e_d_ott",
    "a_f_y_ava",
    "a_f_y_brenda",
    "np_f_character_select",
    "np_m_character_select",
    "s_m_y_bovice",
    "ig_siz",
    "ig_jay_norris",
    "ig_huck",
    "np_nancy",
    "walter",
    "dougcanada",
    "s_m_y_joker",
    "a_m_m_bigd",
    "a_f_y_brenda_cop",
    "ig_mario",
    "ig_milton",
    "a_c_panther",
    "koil",
    "ig_nino",
    "ig_cesar",
    "ig_cornwood",
    "ig_bogg",
    "ig_petunia",
    "ig_avonB",
    "ig_eddieD",
    "dragon",
    "ig_bubba",
    "ig_sheila",
    "ig_ziggyf",
    "ig_taochen",
    "ig_tessa",
    "ig_juddrev",
    "ig_leslie",
    "k_abdul",
    "k_judd",
    "k_fatrandy",
    "ig_ken",
    "mando",
    "davidwonders",
    "marigold",
    "k_peanut",
    "ig_krit",
    "ig_yeager",
    "z_sprinkle",
    "a_m_o_bob_01",
    "u_m_y_paparazzi_02",
    "ig_crane",
    "ig_walt",
    "ig_marlo",
    "ig_martybanks",
    "ig_nottics",
    "ig_fourtee",
}

animal_skins = {
    "a_c_raccoon_01",
    "a_c_racoon_01",
    "a_c_cat_01",
    "a_c_chop",
    "a_c_husky",
    "a_c_retriever",
    "a_c_rottweiler",
    -- "a_c_chimp",
}

octopus_skins = {
  "ig_squid"
}


function TableConcat(t1,t2)
  local t3 = {}
  for k, v in pairs(t1) do
    t3[#t3 + 1] = v
  end
  for k, v in pairs(t2) do
    t3[#t3 + 1] = v
  end
  return t3
end


animal_and_octopus = TableConcat(animal_skins, octopus_skins)

-- we should change this so each steam id refers to its own table
-- but i don't know which skin goes to which steam id at this current time
-- so it references the entire table as an "allow" list
whitelisted_to_use_custom_skins = {
  ["STEAM_0:1:1405612"] = custom_skins,      --	8	Coop	Holliday
  ["STEAM_0:0:15944641"] = custom_skins,     --	40	Leslie	Ling
  ["STEAM_0:1:43743359"] = custom_skins,     --	41	Mr	Kebun
  ["STEAM_0:0:106408109"] = custom_skins,    --	44	Charles	Prince
  ["STEAM_0:1:118347710"] = custom_skins,    --	68	Gary	Adams
  ["STEAM_0:1:41999003"] = custom_skins,     --	80	Ramee	El-Rahman
  ["STEAM_0:1:26548926"] = custom_skins,     --	115	Lang	Buddha
  ["STEAM_0:0:37692185"] = custom_skins,     --	125	Sayeed	White
  ["STEAM_0:0:9821409"] = custom_skins,      --	251	Garrett	Jobless
  ["STEAM_0:0:145163"] = custom_skins,       --	351	Rudi	Rinsen
  ["STEAM_0:1:36904216"] = custom_skins,     --	801	Pete	Phillips
  ["STEAM_0:0:132977"] = custom_skins,       --	2604	Bobby	Goodman
  ["STEAM_0:1:61958622"] = custom_skins,     --	3282	Tony	Corleone
  ["STEAM_0:0:229360026"] = custom_skins,    --	3318	Bovice	Wilkinson
  ["STEAM_0:0:52910754"] = custom_skins,     --	3602	Griselda	Harth
  ["STEAM_0:1:17549569"] = custom_skins,     --	3615	Francis	Francer
  ["STEAM_0:0:170466016"] = custom_skins,    --	3631	Jacob L.	Harth
  ["STEAM_0:1:218994254"] = custom_skins,    --	3761	Georgina	Williams
  ["STEAM_0:1:41044200"] = custom_skins,     --	3894	Eugene	Zuckerburg
  ["STEAM_0:0:37692185"] = custom_skins,     --	4190	Arush Patell	Santana
  ["STEAM_0:1:99329757"] = custom_skins,     --	4371	Lil	Erf
  ["STEAM_0:0:30763052"] = custom_skins,     --	4423	Bill Ding
  ["STEAM_0:0:73167001"] = custom_skins,     --	4553	Brenda	Pancake
  ["STEAM_0:1:26895610"] = custom_skins,     --	4701	Trish	Baggs
  ["STEAM_0:1:85893692"] = custom_skins,     --	4909	Ellie	Dono
  ["STEAM_0:0:2575440"] = custom_skins,      --	5294	Happy	DKlown
  ["STEAM_0:1:59275922"] = custom_skins,     --	5348	Karen	Dahmer
  ["STEAM_0:1:27565322"] = custom_skins,     --	5761	Siz	Fulker
  ["STEAM_0:1:31504821"] = custom_skins,     --	5782	Outto-Tune	Tyrone
  ["STEAM_0:0:52910754"] = custom_skins,     --	6554	Yuri Mersion
  ["STEAM_0:1:10884711"] = custom_skins,     --	7690	Shevy	Augusto Santanna
  ["STEAM_0:1:495686416"] = custom_skins,    --	8626	Huckleberry	Guthrie
  ["STEAM_0:1:43425813"] = custom_skins,     --	9065	Wren	Draider
  ["STEAM_0:1:36904216"] = custom_skins,     --	9324	Unity	The Cat
  ["STEAM_0:0:48209028"] = custom_skins,     --	10437	Kermy	Fulker
  ["STEAM_0:1:94317144"] = custom_skins,     --	10962	Dale	Heartern
  ["STEAM_0:1:38740904"] = custom_skins,     --	11853	Gazpacho	Prince
  ["STEAM_0:0:19753846"] = custom_skins,     --	11854	Snow	Flake
  ["STEAM_0:0:19753846"] = custom_skins,     --	11855	Richard	Fritz
  ["STEAM_0:1:17716360"] = custom_skins,     --	12280	Mike	Block
  ["STEAM_0:0:2015744"] = custom_skins,      --	12961	Hunter	Shaw
  ["STEAM_0:0:87012400"] = custom_skins,     --	13888	Vanya	White
  ["STEAM_0:1:65960476"] = custom_skins,     --	14354	Holden Block
  ["STEAM_0:1:238928190"] = custom_skins,    -- 0 Nancy Ree
  ["STEAM_0:1:32559221"] = custom_skins,     -- Tessa Lamb
  ["STEAM_0:1:108409354"] = custom_skins,    -- Greenish
  ["STEAM_0:1:5487344"] = custom_skins,      -- Kyle
  ["STEAM_0:1:196496490"] = custom_skins,    -- YoinksOG
  ["STEAM_0:0:6213526"] = custom_skins,      -- ig_car3guy1_m
  ["STEAM_0:1:720857"] = custom_skins,       --	0	Dw Testing
  ["STEAM_0:0:19753846"] = custom_skins,     -- Tobii
  ["STEAM_0:0:15066931"] = custom_skins,     -- Spaceboy
  ["STEAM_0:0:29978577"] = custom_skins,     -- Wayward
  ["STEAM_0:0:2575440"] = custom_skins,      -- RevRoach
  ["STEAM_0:0:48209028"] = custom_skins,     -- Boba
  ["STEAM_0:0:106408109"] = custom_skins,    -- Taco
  ["STEAM_0:0:68525143"] = custom_skins,     -- Coolio
  ["STEAM_0:0:11467298"] = custom_skins,     -- Timmac
  ["STEAM_0:0:5941828"] = custom_skins,      -- Snow
  ["STEAM_0:1:21578862"] = custom_skins,     -- Mario
  ["STEAM_0:0:28572907"] = custom_skins,     -- Cesar
  ["STEAM_0:1:5566402"] = custom_skins,      -- Esfand
  ["STEAM_0:0:13253979"] = custom_skins,     -- Poke
  ["STEAM_0:1:115664530"] = custom_skins,    -- Poke2
  ["STEAM_0:1:29932896"] = custom_skins,     -- Nerdandi
  ["STEAM_0:0:267027"] = custom_skins,       -- Lirik
  ["STEAM_0:1:42324084"] = custom_skins,     -- ShortyGuy
  ["STEAM_0:0:132977"] = custom_skins,       -- IronMonkey
  ["STEAM_0:0:11885000"] = custom_skins,     -- Silent Sentry
  ["STEAM_0:0:52851928"] = custom_skins,     -- Elochai
  ["STEAM_0:1:15294848"] = custom_skins,     -- Abdul
  ["STEAM_0:1:1650151"] = custom_skins,      -- Judd
  ["STEAM_0:1:55573343"] = custom_skins,     -- Randy
  ["STEAM_0:1:47596855"] = custom_skins,     -- Pengwin
  ["STEAM_0:0:170466016"] = custom_skins,    -- Afro
  ["STEAM_0:1:69601532"] = custom_skins,     -- ????
  ["STEAM_0:0:170641433"] = custom_skins,     -- Client/Peanut
  ["STEAM_0:1:8992379"] = custom_skins,      -- Nikez
  ["STEAM_0:1:40804144"] = custom_skins,      -- Krit
  ["STEAM_0:0:42013790"] = custom_skins,      -- Vigor
  ["STEAM_0:1:51643092"] = custom_skins,      -- ????
  ["STEAM_0:1:1629306"] = custom_skins,       -- DENIS
  ["STEAM_0:1:38059404"] = custom_skins,       --
  ["STEAM_0:0:80663"] = custom_skins,          -- nathankb
  ["STEAM_0:1:147736853"] = custom_skins,      -- Hutch
  ["STEAM_0:0:101139046"] = custom_skins,      -- Shotz
  ["STEAM_0:1:81163841"] = custom_skins,      -- Yawger
  ["STEAM_0:1:107587841"] = custom_skins, 
  ["STEAM_0:1:512448873"] = custom_skins, 
  ["STEAM_0:0:22888171"] = custom_skins, 
  ["STEAM_0:1:30963041"] = custom_skins, 
  ["STEAM_0:1:94429473"] = custom_skins,
  ["STEAM_0:0:21272464"] = custom_skins,
  ["STEAM_0:0:17522452"] = custom_skins,
  ["STEAM_0:1:215530503"] = custom_skins,
  ["STEAM_0:0:35800122"] = custom_skins,

  ["STEAM_0:0:17101179"] = animal_and_octopus,   -- Mikee
  ["STEAM_0:0:13707575"] = animal_and_octopus,   -- Stebbzor
  ["STEAM_0:0:42679469"] = animal_and_octopus,   -- MKA
  ["STEAM_0:1:38668721"] = animal_and_octopus,   -- nns
  ["STEAM_0:0:49611408"] = animal_and_octopus,   -- Loqrin
  ["STEAM_0:1:522967"]   = animal_and_octopus,   -- Spanser
  ["STEAM_0:1:9385614"]  = animal_and_octopus,   -- Mellow
  ["STEAM_0:1:80932517"] = animal_and_octopus,   -- Sinncere
}

function isCustomSkin(skin)
	local foundSkin = false
	for k,v in pairs(custom_skins) do
		if skin == GetHashKey(v) then foundSkin = true end
	end
	return foundSkin
end

function isInSkins(skin)
    local foundSkin = false
    -- force lower case to prevent TyPe ErRoRs AnD ShItT
    skin = string.lower(skin)
    for k,v in pairs(custom_skins) do
        if skin == string.lower(v) then
            return true
        end
    end
    for k,v in pairs(animal_skins) do
      if skin == string.lower(v) then
          return true
      end
    end
    for k,v in pairs(octopus_skins) do
      if skin == string.lower(v) then
          return true
      end
    end
    for k,v in pairs(fr_skins) do
        if skin == string.lower(v) then
            return true
        end
    end
    for k,v in pairs(frm_skins) do
        if skin == string.lower(v) then
            return true
        end
    end
    return false
end

function canUseCustomSkins()
    local steamId = RPC.execute("skins:getSteamId")
    for k, v in pairs(whitelisted_to_use_custom_skins) do
        if steamId == k then
            return true
        end
    end
    return false
end

--player_zero player_one player_two
fr_skins = {
    'mp_f_freemode_01',
    'a_f_m_beach_01',
    'a_f_m_bevhills_01',
    'a_f_m_bevhills_02',
    'a_f_m_bodybuild_01',
    'a_f_m_business_02',
    'a_f_m_downtown_01',
    'a_f_m_eastsa_01',
    'a_f_m_eastsa_02',
    'a_f_m_fatbla_01',
    'a_f_m_fatcult_01',
    'a_f_m_fatwhite_01',
    'a_f_m_ktown_01',
    'a_f_m_ktown_02',
    'a_f_m_prolhost_01',
    'a_f_m_salton_01',
    'a_f_m_skidrow_01',
    'a_f_m_soucentmc_01',
    'a_f_m_soucent_01',
    'a_f_m_soucent_02',
    'a_f_m_tourist_01',
    'a_f_m_trampbeac_01',
    'a_f_m_tramp_01',
    'a_f_o_genstreet_01',
    'a_f_o_indian_01',
    'a_f_o_ktown_01',
    'a_f_o_salton_01',
    'a_f_o_soucent_01',
    'a_f_o_soucent_02',
    'a_f_y_beach_01',
    'a_f_y_bevhills_01',
    'a_f_y_bevhills_02',
    'a_f_y_bevhills_03',
    'a_f_y_bevhills_04',
    'a_f_y_business_01',
    'a_f_y_business_02',
    'a_f_y_business_03',
    'a_f_y_business_04',
    'a_f_y_eastsa_01',
    'a_f_y_eastsa_02',
    'a_f_y_eastsa_03',
    'a_f_y_epsilon_01',
    'a_f_y_fitness_01',
    'a_f_y_fitness_02',
    'a_f_y_genhot_01',
    'a_f_y_golfer_01',
    'a_f_y_hiker_01',
    'a_f_y_hipster_01',
    'a_f_y_hipster_02',
    'a_f_y_hipster_03',
    'a_f_y_hipster_04',
    'a_f_y_indian_01',
    'a_f_y_juggalo_01',
    'a_f_y_runner_01',
    'a_f_y_rurmeth_01',
    'a_f_y_scdressy_01',
    'a_f_y_skater_01',
    'a_f_y_soucent_01',
    'a_f_y_soucent_02',
    'a_f_y_soucent_03',
    'a_f_y_tennis_01',
    'a_f_y_tourist_01',
    'a_f_y_tourist_02',
    'a_f_y_vinewood_01',
    'a_f_y_vinewood_02',
    'a_f_y_vinewood_03',
    'a_f_y_vinewood_04',
    'a_f_y_yoga_01',
    'g_f_y_ballas_01',
    'g_f_y_families_01',
    'g_f_y_lost_01',
    'g_f_y_vagos_01',
    'mp_f_deadhooker',
    'mp_f_misty_01',
    'mp_f_stripperlite',
    'mp_s_m_armoured_01',
    's_f_m_fembarber',
    's_f_m_maid_01',
    's_f_m_shop_high',
    's_f_m_sweatshop_01',
    's_f_y_airhostess_01',
    's_f_y_bartender_01',
    's_f_y_baywatch_01',
    's_f_y_cop_01',
    's_f_y_factory_01',
    's_f_y_hooker_01',
    's_f_y_hooker_02',
    's_f_y_hooker_03',
    's_f_y_migrant_01',
    's_f_y_movprem_01',
    'ig_kerrymcintosh',
    'ig_janet',
    'ig_jewelass',
    'ig_magenta',
    'ig_marnie',
    'ig_patricia',
    'ig_screen_writer',
    'ig_tanisha',
    'ig_tonya',
    'ig_tracydisanto',
    'u_f_m_corpse_01',
    'u_f_m_miranda',
    'u_f_m_promourn_01',
    'u_f_o_moviestar',
    'u_f_o_prolhost_01',
    'u_f_y_bikerchic',
    'u_f_y_comjane',
    'u_f_y_corpse_01',
    'u_f_y_corpse_02',
    'u_f_y_hotposh_01',
    'u_f_y_jewelass_01',
    'u_f_y_mistress',
    'u_f_y_poppymich',
    'u_f_y_princess',
    'u_f_y_spyactress',
    'ig_amandatownley',
    'ig_ashley',
    'ig_andreas',
    'ig_ballasog',
    'ig_maryannn',
    'ig_maude',
    'ig_michelle',
    'ig_mrs_thornhill',
    'ig_natalia',
    's_f_y_scrubs_01',
    's_f_y_sheriff_01',
    's_f_y_shop_low',
    's_f_y_shop_mid',
    's_f_y_stripperlite',
    's_f_y_stripper_01',
    's_f_y_stripper_02',
    'ig_mrsphillips',
    'ig_mrs_thornhill',
    'ig_molly',
    'ig_natalia',
    's_f_y_sweatshop_01',
    'ig_paige',
    'a_f_y_femaleagent',
    'a_f_y_hippie_01'
}

--101 grills
--429 male

frm_skins = {
    'mp_m_freemode_01',

    'player_one',
    'player_two',
    'player_zero',

    'ig_trafficwarden',
    'hc_driver',
    'hc_gunman',
    'hc_hacker',
    'ig_paige',
    'ig_abigail',
    'ig_bankman',
    'ig_barry',
    'ig_bestmen',
    'ig_beverly',
    'ig_brad',
    'ig_bride',
    'ig_car3guy1',
    'ig_car3guy2',
    'ig_casey',
    'ig_chef',
    'ig_chengsr',
    'ig_chrisformage',
    'ig_clay',
    'ig_claypain',
    'ig_cletus',
    'ig_dale',
    'ig_davenorton',
    'ig_denise',
    'ig_devin',
    'ig_dom',
    'ig_dreyfuss',
    'ig_drfriedlander',
    'ig_fabien',
    'ig_fbisuit_01',
    'ig_floyd',
    'ig_groom',
    'ig_hao',
    'ig_hunter',
    'csb_prolsec',
    'ig_jimmyboston',
    'ig_jimmydisanto',
    'ig_joeminuteman',
    'ig_johnnyklebitz',
    'ig_josef',
    'ig_josh',
    'ig_lamardavis',
    'ig_lazlow',
    'ig_lestercrest',
    'ig_lifeinvad_01',
    'ig_lifeinvad_02',
    'ig_manuel',
    'ig_mrk',
    'ig_nervousron',
    'ig_nigel',
    'ig_old_man1a',
    'ig_old_man2',
    'ig_oneil',
    'ig_orleans',
    'ig_ortega',
    'ig_paper',
    'ig_priest',
    'ig_prolsec_02',
    'ig_ramp_gang',
    'ig_ramp_hic',
    'ig_ramp_hipster',
    'ig_ramp_mex',
    'ig_roccopelosi',
    'ig_russiandrunk',
    'ig_siemonyetarian',
    'ig_solomon',
    'ig_stevehains',
    'ig_stretch',
    'ig_talina',
    'ig_taocheng',
    'ig_taostranslator',
    'ig_tenniscoach',
    'ig_terry',
    'ig_tomepsilon',
    'ig_tylerdix',
    'ig_wade',
    'ig_zimbor',
    's_m_m_paramedic_01',
    'a_m_m_afriamer_01',
    'a_m_m_beach_01',
    'a_m_m_beach_02',
    'a_m_m_bevhills_01',
    'a_m_m_bevhills_02',
    'a_m_m_business_01',
    'a_m_m_eastsa_01',
    'a_m_m_eastsa_02',
    'a_m_m_farmer_01',
    'a_m_m_fatlatin_01',
    'a_m_m_genfat_01',
    'a_m_m_genfat_02',
    'a_m_m_golfer_01',
    'a_m_m_hasjew_01',
    'a_m_m_hillbilly_01',
    'a_m_m_hillbilly_02',
    'a_m_m_indian_01',
    'a_m_m_ktown_01',
    'a_m_m_malibu_01',
    'a_m_m_mexcntry_01',
    'a_m_m_mexlabor_01',
    'a_m_m_og_boss_01',
    'a_m_m_paparazzi_01',
    'a_m_m_polynesian_01',
    'a_m_m_prolhost_01',
    'a_m_m_rurmeth_01',
    'a_m_m_salton_01',
    'a_m_m_salton_02',
    'a_m_m_salton_03',
    'a_m_m_salton_04',
    'a_m_m_skater_01',
    'a_m_m_skidrow_01',
    'a_m_m_socenlat_01',
    'a_m_m_soucent_01',
    'a_m_m_soucent_02',
    'a_m_m_soucent_03',
    'a_m_m_soucent_04',
    'a_m_m_stlat_02',
    'a_m_m_tennis_01',
    'a_m_m_tourist_01',
    'a_m_m_trampbeac_01',
    'a_m_m_tramp_01',
    'a_m_m_tranvest_01',
    'a_m_m_tranvest_02',
    'a_m_o_beach_01',
    'a_m_o_genstreet_01',
    'a_m_o_ktown_01',
    'a_m_o_salton_01',
    'a_m_o_soucent_01',
    'a_m_o_soucent_02',
    'a_m_o_soucent_03',
    'a_m_o_tramp_01',
    'a_m_y_beachvesp_01',
    'a_m_y_beachvesp_02',
    'a_m_y_beach_01',
    'a_m_y_beach_02',
    'a_m_y_beach_03',
    'a_m_y_bevhills_01',
    'a_m_y_bevhills_02',
    'a_m_y_breakdance_01',
    'a_m_y_busicas_01',
    'a_m_y_business_01',
    'a_m_y_business_02',
    'a_m_y_business_03',
    'a_m_y_cyclist_01',
    'a_m_y_dhill_01',
    'a_m_y_downtown_01',
    'a_m_y_eastsa_01',
    'a_m_y_eastsa_02',
    'a_m_y_epsilon_01',
    'a_m_y_epsilon_02',
    'a_m_y_gay_01',
    'a_m_y_gay_02',
    'a_m_y_genstreet_01',
    'a_m_y_genstreet_02',
    'a_m_y_golfer_01',
    'a_m_y_hasjew_01',
    'a_m_y_hiker_01',
    'a_m_y_hipster_01',
    'a_m_y_hipster_02',
    'a_m_y_hipster_03',
    'a_m_y_indian_01',
    'a_m_y_jetski_01',
    'a_m_y_juggalo_01',
    'a_m_y_ktown_01',
    'a_m_y_ktown_02',
    'a_m_y_latino_01',
    'a_m_y_methhead_01',
    'a_m_y_mexthug_01',
    'a_m_y_motox_01',
    'a_m_y_motox_02',
    'a_m_y_musclbeac_01',
    'a_m_y_musclbeac_02',
    'a_m_y_polynesian_01',
    'a_m_y_roadcyc_01',
    'a_m_y_runner_01',
    'a_m_y_runner_02',
    'a_m_y_salton_01',
    'a_m_y_skater_01',
    'a_m_y_skater_02',
    'a_m_y_soucent_01',
    'a_m_y_soucent_02',
    'a_m_y_soucent_03',
    'a_m_y_soucent_04',
    'a_m_y_stbla_01',
    'a_m_y_stbla_02',
    'a_m_y_stlat_01',
    'a_m_y_stwhi_01',
    'a_m_y_stwhi_02',
    'a_m_y_sunbathe_01',
    'a_m_y_surfer_01',
    'a_m_y_vindouche_01',
    'a_m_y_vinewood_01',
    'a_m_y_vinewood_02',
    'a_m_y_vinewood_03',
    'a_m_y_vinewood_04',
    'a_m_y_yoga_01',
    'g_m_m_armboss_01',
    'g_m_m_armgoon_01',
    'g_m_m_armlieut_01',
    'g_m_m_chemwork_01',
    'g_m_m_chiboss_01',
    'g_m_m_chicold_01',
    'g_m_m_chigoon_01',
    'g_m_m_chigoon_02',
    'g_m_m_korboss_01',
    'g_m_m_mexboss_01',
    'g_m_m_mexboss_02',
    'g_m_y_armgoon_02',
    'g_m_y_azteca_01',
    'g_m_y_ballaeast_01',
    'g_m_y_ballaorig_01',
    'g_m_y_ballasout_01',
    'g_m_y_famca_01',
    'g_m_y_famdnf_01',
    'g_m_y_famfor_01',
    'g_m_y_korean_01',
    'g_m_y_korean_02',
    'g_m_y_korlieut_01',
    'g_m_y_lost_01',
    'g_m_y_lost_02',
    'g_m_y_lost_03',
    'g_m_y_mexgang_01',
    'g_m_y_mexgoon_01',
    'g_m_y_mexgoon_02',
    'g_m_y_mexgoon_03',
    'g_m_y_pologoon_01',
    'g_m_y_pologoon_02',
    'g_m_y_salvaboss_01',
    'g_m_y_salvagoon_01',
    'g_m_y_salvagoon_02',
    'g_m_y_salvagoon_03',
    'g_m_y_strpunk_01',
    'g_m_y_strpunk_02',
    'mp_m_claude_01',
    'mp_m_exarmy_01',
    'mp_m_shopkeep_01',
    's_m_m_ammucountry',
    's_m_m_autoshop_01',
    's_m_m_autoshop_02',
    's_m_m_bouncer_01',
    's_m_m_chemsec_01',
    's_m_m_cntrybar_01',
    's_m_m_dockwork_01',
    's_m_m_doctor_01',
    's_m_m_fiboffice_01',
    's_m_m_fiboffice_02',
    's_m_m_gaffer_01',
    's_m_m_gardener_01',
    's_m_m_gentransport',
    's_m_m_hairdress_01',
    's_m_m_highsec_01',
    's_m_m_highsec_02',
    's_m_m_janitor',
    's_m_m_lathandy_01',
    's_m_m_lifeinvad_01',
    's_m_m_linecook',
    's_m_m_lsmetro_01',
    's_m_m_mariachi_01',
    's_m_m_marine_01',
    's_m_m_marine_02',
    's_m_m_migrant_01',
    's_m_m_movalien_01',
    's_m_m_movprem_01',
    's_m_m_movspace_01',
    's_m_m_pilot_01',
    's_m_m_pilot_02',
    's_m_m_postal_01',
    's_m_m_postal_02',
    's_m_m_scientist_01',
    's_m_m_security_01',
    's_m_m_strperf_01',
    's_m_m_strpreach_01',
    's_m_m_strvend_01',
    's_m_m_trucker_01',
    's_m_m_ups_01',
    's_m_m_ups_02',
    's_m_o_busker_01',
    's_m_y_airworker',
    's_m_y_ammucity_01',
    's_m_y_armymech_01',
    's_m_y_autopsy_01',
    's_m_y_barman_01',
    's_m_y_baywatch_01',
    's_m_y_blackops_01',
    's_m_y_blackops_02',
    's_m_y_busboy_01',
    's_m_y_chef_01',
    's_m_y_clown_01',
    's_m_y_construct_01',
    's_m_y_construct_02',
    's_m_y_cop_01',
    's_m_y_dealer_01',
    's_m_y_devinsec_01',
    's_m_y_dockwork_01',
    's_m_y_doorman_01',
    's_m_y_dwservice_01',
    's_m_y_dwservice_02',
    's_m_y_factory_01',
    's_m_y_garbage',
    's_m_y_grip_01',
    's_m_y_marine_01',
    's_m_y_marine_02',
    's_m_y_marine_03',
    's_m_y_mime',
    's_m_y_pestcont_01',
    's_m_y_pilot_01',
    's_m_y_prismuscl_01',
    's_m_y_prisoner_01',
    's_m_y_robber_01',
    's_m_y_shop_mask',
    's_m_y_strvend_01',
    's_m_y_uscg_01',
    's_m_y_valet_01',
    's_m_y_waiter_01',
    's_m_y_winclean_01',
    's_m_y_xmech_01',
    's_m_y_xmech_02',
    'u_m_m_aldinapoli',
    'u_m_m_bankman',
    'u_m_m_bikehire_01',
    'u_m_m_fibarchitect',
    'u_m_m_filmdirector',
    'u_m_m_glenstank_01',
    'u_m_m_griff_01',
    'u_m_m_jesus_01',
    'u_m_m_jewelsec_01',
    'u_m_m_jewelthief',
    'u_m_m_markfost',
    'u_m_m_partytarget',
    'u_m_m_prolsec_01',
    'u_m_m_promourn_01',
    'u_m_m_rivalpap',
    'u_m_m_spyactor',
    'u_m_m_willyfist',
    'u_m_o_finguru_01',
    'u_m_o_taphillbilly',
    'u_m_o_tramp_01',
    'u_m_y_abner',
    'u_m_y_antonb',
    'u_m_y_babyd',
    'u_m_y_baygor',
    'u_m_y_burgerdrug_01',
    'u_m_y_chip',
    'u_m_y_cyclist_01',
    'u_m_y_fibmugger_01',
    'u_m_y_guido_01',
    'u_m_y_gunvend_01',
    'u_m_y_imporage',
    'u_m_y_mani',
    'u_m_y_militarybum',
    'u_m_y_paparazzi',
    'u_m_y_party_01',
    'u_m_y_pogo_01',
    'u_m_y_prisoner_01',
    'u_m_y_proldriver_01',
    'u_m_y_rsranger_01',
    'u_m_y_sbike',
    'u_m_y_staggrm_01',
    'u_m_y_tattoo_01',
    'u_m_y_zombie_01',
    'u_m_y_hippie_01',
    'a_m_y_hippy_01',
    'a_m_y_stbla_m',
    'ig_terry_m',
    'a_m_m_ktown_m',
    'a_m_y_skater_m',
    'u_m_y_coop',
    'ig_car3guy1_m',
    'tony',
    'g_m_m_chigoon_02_m',
    'g_m_y_famfor_01_m',
    'ig_trafficwarden_m',
    'g_m_m_chiboss_01_m',
}

function GetCustomSkins()
    return custom_skins
end