/*
Civilian template for ARMA III
*/
_civUniforms = [
	"tg_u_dadpat_floral",
	"tg_u_dadpat_tacky",
	"tg_u_dadpat_blue_hi",
	"tg_u_dadpat_red_hi",
	"tg_u_dadpat_grn_palm",
	"tg_u_dadpat_prp_palm",
    "tg_u_dadpat_blue_plaid",
    "tg_u_dadpat_grn_plaid",
    "tg_u_dadpat_orng_plaid",
    "tg_u_dadpat_red_plaid",
    "tg_u_dadpat_shorts_floral",
    "tg_u_dadpat_shorts_tacky",
    "tg_u_dadpat_shorts_blue_hi",
    "tg_u_dadpat_shorts_red_hi",
    "tg_u_dadpat_shorts_grn_palm",
    "tg_u_dadpat_shorts_prp_palm",
    "tg_u_dadpat_shorts_blue_plaid",
    "tg_u_dadpat_shorts_grn_plaid",
    "tg_u_dadpat_shorts_orng_plaid",
    "tg_u_dadpat_shorts_red_plaid",
    "tg_u_dadpat_tactical_floral",
    "tg_u_dadpat_tactical_tacky",
    "tg_u_dadpat_tactical_blue_hi",
    "tg_u_dadpat_tactical_red_hi",
    "tg_u_dadpat_tactical_grn_palm",
    "tg_u_dadpat_tactical_prp_palm",
    "tg_u_dadpat_tactical_blue_plaid",
    "tg_u_dadpat_tactical_grn_plaid",
    "tg_u_dadpat_tactical_orng_plaid",
    "tg_u_dadpat_tactical_red_plaid"
];

_civFacewear = [];

_civHeadgear = [];

_civVehicles = [];

_civItems = [
    "ACRE_PRC343",
    "ACRE_PRC152",
    "ACRE_PRC117F",
    "ACE_adenosine",
    "ACE_fieldDressing",
    "ACE_elasticBandage",
    "ACE_packingBandage",
    "ACE_quikclot",
    "ACE_bloodIV",
    "ACE_bloodIV_250",
    "ACE_bloodIV_500",
    "ACE_CableTie",
    "ACE_Cellphone",
    "ACE_DAGR",
    "ACE_DefusalKit",
    "ACE_EntrenchingTool",
    "ACE_epinephrine",
    "ACE_MapTools",
    "ACE_microDAGR",
    "ACE_morphine",
    "ACE_personalAidKit",
    "ACE_plasmaIV",
    "ACE_plasmaIV_250",
    "ACE_plasmaIV_500",
    "ACE_salineIV",
    "ACE_salineIV_250",
    "ACE_salineIV_500",
    "ACE_splint",
    "ACE_SpraypaintBlack",
    "ACE_SpraypaintBlue",
    "ACE_SpraypaintGreen",
    "ACE_SpraypaintRed",
    "ACE_surgicalKit",
    "ACE_tourniquet",
    "ACE_wirecutter",
    "ACRE_VHF30108SPIKE",
	"ACRE_VHF30108",
	"ACRE_VHF30108MAST"
];

_civVehiclesOnlyNames = _civVehicles select { _x isEqualType "" };

_array = [];

_array set [T_SIZE-1, nil]; //Make an array having the size equal to the number of categories first

// Name, description, faction, addons, etc
_array set [T_NAME, "tMisfitCivilian"];
_array set [T_DESCRIPTION, "Misfit Tactical's Custom Civilians."];
_array set [T_DISPLAY_NAME, "Misift Civilians"];
_array set [T_FACTION, T_FACTION_Civ];
_array set [T_REQUIRED_ADDONS, []];

//==== API ====
_api = [];
_api resize T_API_SIZE;
_api set [T_API_fnc_init, {}];
_array set [T_API, _api];

// ==== Undercover ====
_uc = [];
_uc resize T_UC_SIZE;
_uc set[T_UC_uniforms, +_civUniforms];
_uc set[T_UC_facewear, +_civFacewear];
_uc set[T_UC_headgear, +_civHeadgear];
_uc set[T_UC_civVehs, +_civVehiclesOnlyNames];
_uc set[T_UC_items, +_civItems];
_array set [T_UC, _uc];

// ==== Arsenal ====
_arsenal = [];
_arsenal resize T_ARSENAL_SIZE;
_arsenal set[T_ARSENAL_primary, []];
_arsenal set[T_ARSENAL_primary_items, []];
_arsenal set[T_ARSENAL_secondary, []];
_arsenal set[T_ARSENAL_secondary_items, []];
_arsenal set[T_ARSENAL_handgun, []];
_arsenal set[T_ARSENAL_handgun_items, []];
_arsenal set[T_ARSENAL_ammo, []];
_arsenal set[T_ARSENAL_items, [
    "ACE_Flashlight_Maglite_ML300L",
    "ACE_HandFlare_White",
    "ACRE_PRC343",
    "ACRE_PRC152",
    "ACRE_PRC117F",
    "ACE_adenosine",
    "ACE_fieldDressing",
    "ACE_elasticBandage",
    "ACE_packingBandage",
    "ACE_quikclot",
    "ACE_bloodIV",
    "ACE_bloodIV_250",
    "ACE_bloodIV_500",
    "ACE_CableTie",
    "ACE_Cellphone",
    "ACE_DAGR",
    "ACE_DeadManSwitch",
    "ACE_DefusalKit",
    "ACE_EntrenchingTool",
    "ACE_epinephrine",
    "ACE_M26_Clacker",
    "ACE_Clacker",
    "ACE_MapTools",
    "ACE_microDAGR",
    "MineDetector",
    "ACE_morphine",
    "ACE_personalAidKit",
    "ACE_plasmaIV",
    "ACE_plasmaIV_250",
    "ACE_plasmaIV_500",
    "ACE_salineIV",
    "ACE_salineIV_250",
    "ACE_salineIV_500",
    "ACE_splint",
    "ACE_SpraypaintBlack",
    "ACE_SpraypaintBlue",
    "ACE_SpraypaintGreen",
    "ACE_SpraypaintRed",
    "ACE_surgicalKit",
    "ToolKit",
    "ACE_tourniquet",
    "ACE_wirecutter",
    "ACRE_VHF30108SPIKE",
	"ACRE_VHF30108",
	"ACRE_VHF30108MAST"
]];
_arsenal set[T_ARSENAL_vests, []];
_arsenal set[T_ARSENAL_backpacks, [
    "ACE_TacticalLadder_Pack",
    "B_Messenger_Black_F",
    "B_Messenger_Coyote_F",
    "B_Messenger_Olive_F",
    "B_TacticalPack_blk"
]];
_arsenal set[T_ARSENAL_uniforms, [
    "U_BG_Guerilla2_1",
    "U_BG_Guerilla2_2",
    "U_BG_Guerilla2_3",
    "U_BG_Guerilla3_1",
    "U_BG_Guerilla3_2",
    "U_C_Commoner_shorts",
    "U_C_ConstructionCoverall_Black_F",
    "U_C_ConstructionCoverall_Blue_F",
    "U_C_ConstructionCoverall_Red_F",
    "U_C_ConstructionCoverall_Vrana_F",
    "U_C_Driver_1",
    "U_C_Driver_1_black",
    "U_C_Driver_1_blue",
    "U_C_Driver_1_green",
    "U_C_Driver_1_orange",
    "U_C_Driver_1_red",
    "U_C_Driver_1_white",
    "U_C_Driver_1_yellow",
    "U_C_Driver_2",
    "U_C_Driver_3",
    "U_C_Driver_4",
    "U_C_IDAP_Man_cargo_F",
    "U_C_IDAP_Man_casual_F",
    "U_C_IDAP_Man_Jeans_F",
    "U_C_IDAP_Man_shorts_F",
    "U_C_IDAP_Man_Tee_F",
    "U_C_IDAP_Man_TeeShorts_F",
    "U_C_Journalist",
    "U_C_Man_casual_1_F",
    "U_C_Man_casual_2_F",
    "U_C_Man_casual_3_F",
    "U_C_Man_casual_4_F",
    "U_C_Man_casual_5_F",
    "U_C_Man_casual_6_F",
    "U_C_man_sport_1_F",
    "U_C_man_sport_2_F",
    "U_C_man_sport_3_F",
    "U_C_Mechanic_01_F",
    "U_C_Paramedic_01_F",
    "U_C_Poloshirt_blue",
    "U_C_Poloshirt_burgundy",
    "U_C_Poloshirt_redwhite",
    "U_C_Poloshirt_salmon",
    "U_C_Poloshirt_stripped",
    "U_C_Poloshirt_tricolour",
    "U_C_Poor_1",
    "U_C_Poor_2",
    "U_C_Scientist",
    "U_C_TeeSurfer_shorts_1",
    "U_C_TeeSurfer_shorts_2",
    "U_C_WorkerCoveralls",
    "U_Competitor",
    "U_I_C_Soldier_Bandit_1_F",
    "U_I_C_Soldier_Bandit_2_F",
    "U_I_C_Soldier_Bandit_3_F",
    "U_I_C_Soldier_Bandit_4_F",
    "U_I_C_Soldier_Bandit_5_F",
    "U_IG_Guerilla2_1",
    "U_IG_Guerilla2_2",
    "U_IG_Guerilla2_3",
    "U_IG_Guerilla3_1",
    "U_IG_Guerilla3_2",
    "U_BG_Guerrilla_6_1",
    "U_I_C_Soldier_Para_4_F",
    "U_I_L_Uniform_01_camo_F",
    "U_I_L_Uniform_01_deserter_F",
    "U_I_G_resistanceLeader_F",
    "U_BG_Guerilla1_1",
    "U_I_C_Soldier_Para_3_F",
    "U_Marshal",
    "U_OG_Guerilla2_1",
    "U_OG_Guerilla2_2",
    "U_OG_Guerilla2_3",
    "U_OG_Guerilla3_1",
    "U_OG_Guerilla3_2",
    "U_C_HunterBody_grn",
    "U_OrestesBody",
    "U_Rangemaster",
    "U_BG_leader",

    // CONTACT DLC 
    "U_I_L_Uniform_01_tshirt_black_F",
    "U_I_L_Uniform_01_tshirt_olive_F",
    "U_I_L_Uniform_01_tshirt_skull_F",
    "U_I_L_Uniform_01_tshirt_sport_F",
    "U_C_Uniform_Scientist_01_F",
    "U_C_Uniform_Scientist_02_F",
    "U_C_Uniform_Scientist_01_formal_F",
    "U_C_Uniform_Scientist_02_formal_F",
    "U_O_R_Gorka_01_black_F",
    "U_C_E_LooterJacket_01_F",
    "tg_u_dadpat_floral",
	"tg_u_dadpat_tacky",
	"tg_u_dadpat_blue_hi",
	"tg_u_dadpat_red_hi",
	"tg_u_dadpat_grn_palm",
	"tg_u_dadpat_prp_palm",
    "tg_u_dadpat_blue_plaid",
    "tg_u_dadpat_grn_plaid",
    "tg_u_dadpat_orng_plaid",
    "tg_u_dadpat_red_plaid",
    "tg_u_dadpat_shorts_floral",
    "tg_u_dadpat_shorts_tacky",
    "tg_u_dadpat_shorts_blue_hi",
    "tg_u_dadpat_shorts_red_hi",
    "tg_u_dadpat_shorts_grn_palm",
    "tg_u_dadpat_shorts_prp_palm",
    "tg_u_dadpat_shorts_blue_plaid",
    "tg_u_dadpat_shorts_grn_plaid",
    "tg_u_dadpat_shorts_orng_plaid",
    "tg_u_dadpat_shorts_red_plaid",
    "tg_u_dadpat_tactical_floral",
    "tg_u_dadpat_tactical_tacky",
    "tg_u_dadpat_tactical_blue_hi",
    "tg_u_dadpat_tactical_red_hi",
    "tg_u_dadpat_tactical_grn_palm",
    "tg_u_dadpat_tactical_prp_palm",
    "tg_u_dadpat_tactical_blue_plaid",
    "tg_u_dadpat_tactical_grn_plaid",
    "tg_u_dadpat_tactical_orng_plaid",
    "tg_u_dadpat_tactical_red_plaid"
]];
_arsenal set[T_ARSENAL_facewear, [
    "G_Aviator",
    "G_Balaclava_blk",
    "G_Balaclava_oli",
    "G_Bandanna_beast",
    "G_Bandanna_blk",
    "G_Bandanna_khk",
    "G_Bandanna_oli",
    "G_Bandanna_tan",
    "G_AirPurifyingRespirator_01_F",
    "G_RegulatorMask_F",
    "G_Combat",
    "G_Combat_Goggles_tna_F",
    "G_EyeProtectors_Earpiece_F",
    "G_EyeProtectors_F",
    "G_Lady_Blue",
    "G_Lady_Dark",
    "G_Lady_Mirror",
    "G_Lady_Red",
    "G_Lowprofile",
    "G_Respirator_blue_F",
    "G_Respirator_white_F",
    "G_Respirator_yellow_F",
    "G_Shades_Black",
    "G_Shades_Blue",
    "G_Shades_Green",
    "G_Shades_Red",
    "G_Spectacles",
    "G_Spectacles_Tinted",
    "G_Sport_Blackred",
    "G_Sport_BlackWhite",
    "G_Sport_Blackyellow",
    "G_Sport_Checkered",
    "G_Sport_Greenblack",
    "G_Sport_Red",
    "G_Squares",
    "G_Squares_Tinted",
    "G_Tactical_Black",
    "G_Tactical_Clear"
]];
_arsenal set[T_ARSENAL_headgear, [
    "H_Shemag_olive",
    "H_ShemagOpen_tan",
    "H_ShemagOpen_khk",
    "H_Hat_Tinfoil_F",
    "H_Bandanna_blu",
    "H_Bandanna_camo",
    "H_Bandanna_cbr",
    "H_Bandanna_gry",
    "H_Bandanna_khk",
    "H_Bandanna_khk_hs",
    "H_Bandanna_mcamo",
    "H_Bandanna_sand",
    "H_Bandanna_sgg",
    "H_Bandanna_surfer",
    "H_Bandanna_surfer_blk",
    "H_Bandanna_surfer_grn",
    "H_Watchcap_blk",
    "H_Watchcap_cbr",
    "H_Watchcap_camo",
    "H_Watchcap_khk",
    "H_Booniehat_dirty",
    "H_Booniehat_grn",
    "H_Booniehat_khk_hs",
    "H_Booniehat_oli",
    "H_Booniehat_tan",
    "H_Cap_Black_IDAP_F",
    "H_Cap_blk",
    "H_Cap_blk_CMMG",
    "H_Cap_blk_ION",
    "H_Cap_blk_Syndikat_F",
    "H_Cap_blu",
    "H_Cap_grn",
    "H_Cap_grn_BI",
    "H_Cap_grn_Syndikat_F",
    "H_Cap_khaki_specops_UK",
    "H_Cap_oli",
    "H_Cap_oli_Syndikat_F",
    "H_Cap_Orange_IDAP_F",
    "H_Cap_press",
    "H_Cap_red",
    "H_Cap_surfer",
    "H_Cap_tan",
    "H_Cap_tan_Syndikat_F",
    "H_Cap_usblack",
    "H_Cap_White_IDAP_F",
    "H_Construction_basic_black_F",
    "H_Construction_basic_orange_F",
    "H_Construction_basic_red_F",
    "H_Construction_basic_vrana_F",
    "H_Construction_basic_white_F",
    "H_Construction_basic_yellow_F",
    "H_Construction_earprot_black_F",
    "H_Construction_earprot_orange_F",
    "H_Construction_earprot_red_F",
    "H_Construction_earprot_vrana_F",
    "H_Construction_earprot_white_F",
    "H_Construction_earprot_yellow_F",
    "H_Construction_headset_black_F",
    "H_Construction_headset_orange_F",
    "H_Construction_headset_red_F",
    "H_Construction_headset_vrana_F",
    "H_Construction_headset_white_F",
    "H_Construction_headset_yellow_F",
    "H_EarProtectors_black_F",
    "H_EarProtectors_orange_F",
    "H_EarProtectors_red_F",
    "H_EarProtectors_white_F",
    "H_EarProtectors_yellow_F",
    "H_HeadBandage_bloody_F",
    "H_HeadBandage_clean_F",
    "H_HeadBandage_stained_F",
    "H_HeadSet_black_F",
    "H_HeadSet_orange_F",
    "H_HeadSet_red_F",
    "H_HeadSet_white_F",
    "H_HeadSet_yellow_F",
    "H_Helmet_Skate",
    "H_RacingHelmet_1_black_F",
    "H_RacingHelmet_1_blue_F",
    "H_RacingHelmet_1_F",
    "H_RacingHelmet_1_green_F",
    "H_RacingHelmet_1_orange_F",
    "H_RacingHelmet_1_red_F",
    "H_RacingHelmet_1_white_F",
    "H_RacingHelmet_1_yellow_F",
    "H_RacingHelmet_2_F",
    "H_RacingHelmet_3_F",
    "H_RacingHelmet_4_F",
    "H_StrawHat",
    "H_StrawHat_dark"
]];

// ==== Infantry ====
_inf = [];
_inf resize T_INF_SIZE;
_inf = _inf apply { [] };
_inf set [T_INF_default, ["I_L_Looter_SG_F"]];
_inf set [T_INF_rifleman, [
    "MISFIT_PLAYER_1"
]];
_inf set [T_INF_unarmed, [
    "MISFIT_CIVILIAN_1"
]];
_inf set [T_INF_exp, [
    "MISFIT_CIVILIAN_Saboteur_1"
]];
_inf set [T_INF_survivor, [
    "MISFIT_CIVILIAN_Militant_1"
]];

// ==== Vehicles ====
_veh = +(tDefault select T_VEH);
_veh resize T_VEH_SIZE;
_veh set [T_VEH_default, [
    "C_Hatchback_01_sport_F",   5,
    "C_Hatchback_01_F",         20,
    "C_Truck_02_box_F",         3,
    "C_Truck_02_fuel_F",        0,
    "C_Offroad_02_unarmed_F",   10,
    "C_Van_01_fuel_F",          0,
    "C_Truck_02_transport_F",   3,
    "C_Truck_02_covered_F",     3,
    "C_Offroad_01_F",           5,
    "C_Offroad_01_repair_F",    0,
    "C_Quadbike_01_F",          1,
    "C_SUV_01_F",               3,
    "C_Van_01_transport_F",     1,
    "C_Van_02_medevac_F",       1,
    "C_Van_02_vehicle_F",       1,
    "C_Van_02_service_F",       1,
    "C_Van_02_transport_F",     1
]];

//==== Cargo ====
_cargo = +(tDefault select T_CARGO);

_array set [T_INF, _inf];
_array set [T_VEH, _veh];
_array set [T_DRONE, []];
_array set [T_CARGO, _cargo];
_array set [T_GROUP, []];
_array set [T_ARSENAL, _arsenal];

_array
