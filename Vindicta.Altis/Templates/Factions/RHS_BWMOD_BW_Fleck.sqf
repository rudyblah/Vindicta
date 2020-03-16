/*
BWMOD: Bundeswehr (Flecktarn) templates for ARMA III
*/

_array = [];

_array set [T_SIZE-1, nil];									//Make an array having the size equal to the number of categories first

// Name, description, faction, addons, etc
_array set [T_NAME, "tRHS_BWMOD_BW_Fleck"];
_array set [T_DESCRIPTION, "German Armed forces with American Vehicles. Uses BWmod and RHSUSAF."];
_array set [T_DISPLAY_NAME, "RHS-BW Fleck Custom"];
_array set [T_FACTION, T_FACTION_Military];
_array set [T_REQUIRED_ADDONS, [
							"rhsusf_c_troops",	// RHSUSAF
							"bwa3_common" 		//BWmod
]];

//==== Infantry ====
_inf = [];
_inf resize T_INF_SIZE;
_inf set [T_INF_DEFAULT, ["BWA3_Rifleman_Fleck"]];

_inf set [T_INF_SL, ["BW_Fleck_SL","BW_Fleck_SL_2"]];
_inf set [T_INF_TL, ["BW_Fleck_TL"]];
_inf set [T_INF_officer, ["BW_Fleck_officer"]];
_inf set [T_INF_GL, ["BW_Fleck_grenadier","BW_Fleck_grenadier2","BW_Fleck_grenadier3"]];
_inf set [T_INF_rifleman, ["BW_Fleck_rifleman"]];
_inf set [T_INF_marksman, ["BW_Fleck_marksman"]];
_inf set [T_INF_sniper, ["BW_Fleck_sniper","BW_Fleck_sniper_2"]];
_inf set [T_INF_spotter, ["BW_Fleck_spotter"]];
_inf set [T_INF_exp, ["BW_Fleck_explosives"]];
_inf set [T_INF_ammo, ["BW_Fleck_AT_2","BW_Fleck_MG_2","BW_Fleck_MG_4"]];
_inf set [T_INF_LAT, ["BW_Fleck_AT"]];
_inf set [T_INF_AT, ["BW_Fleck_AT","BW_Fleck_AT_3"]];
_inf set [T_INF_AA, ["BW_Fleck_AA"]];
_inf set [T_INF_LMG, ["BW_Fleck_LMG"]];
_inf set [T_INF_HMG, ["BW_Fleck_MG","BW_Fleck_MG_3"]];
_inf set [T_INF_medic, ["BW_Fleck_medic"]];
_inf set [T_INF_engineer, ["BW_Fleck_engineer"]];
_inf set [T_INF_crew, ["BW_Fleck_crew"]];
_inf set [T_INF_crew_heli, ["BW_Fleck_helicrew"]];
_inf set [T_INF_pilot, ["BW_Fleck_pilot"]];
_inf set [T_INF_pilot_heli, ["BW_Fleck_helipilot"]];
//_inf set [T_INF_survivor, [""]];
//_inf set [T_INF_unarmed, [""]];

// Recon
_inf set [T_INF_recon_TL, ["BW_Fleck_recon_TL"]];
_inf set [T_INF_recon_rifleman, ["BW_Fleck_Recon_Rifleman"]];
_inf set [T_INF_recon_medic, ["BW_Fleck_recon_medic"]];
_inf set [T_INF_recon_exp, ["BW_Fleck_recon_explosives"]];
_inf set [T_INF_recon_LAT, ["BW_Fleck_recon_LAT"]];
//_inf set [T_INF_recon_LMG, ["BW_Fleck_Recon_LMG"]];
_inf set [T_INF_recon_marksman, ["BW_Fleck_recon_sniper","BW_Fleck_Recon_sniper_2"]];
_inf set [T_INF_recon_JTAC, ["BW_Fleck_recon_JTAC"]];


// Divers, from vanilla
//_inf set [T_INF_diver_TL, ["B_diver_TL_F"]];
//_inf set [T_INF_diver_rifleman, ["B_diver_F"]];
//_inf set [T_INF_diver_exp, ["B_diver_exp_F"]];


//==== Vehicles ====
_veh = +(tDefault select T_VEH);
_veh set [T_VEH_SIZE-1, nil];
_veh set [T_VEH_DEFAULT, ["BWA3_Eagle_Fleck"]];

_veh set [T_VEH_car_unarmed, [ "BWA3_Eagle_Fleck", "rhsusf_m1025_w", "rhsusf_m998_w_4dr"]];
_veh set [T_VEH_car_armed, ["BWA3_Eagle_FLW100_Fleck","rhsusf_m1025_w_m2"]];

_veh set [T_VEH_MRAP_unarmed, ["rhsusf_M1232_usarmy_wd", "rhsusf_CGRCAT1A2_usmc_wd", "rhsusf_m1240a1_usmc_wd", "rhsusf_M1220_usarmy_wd"]];
_veh set [T_VEH_MRAP_HMG, ["rhsusf_CGRCAT1A2_M2_usmc_wd", "rhsusf_m1240a1_m2_usmc_wd", "rhsusf_m1240a1_m240_usmc_wd","rhsusf_M1220_M2_usarmy_wd","rhsusf_M1220_MK19_usarmy_wd"]];
_veh set [T_VEH_MRAP_GMG, ["rhsusf_m1240a1_mk19_usmc_wd", "rhsusf_CGRCAT1A2_Mk19_usmc_wd", "rhsusf_M1232_MC_MK19_usmc_wd", "rhsusf_m1025_w_s_Mk19"]];

_veh set [T_VEH_IFV, ["BWA3_Puma_Fleck", "RHS_M2A2_wd", "RHS_M2A2_BUSKI_WD"]];
_veh set [T_VEH_APC, ["rhsusf_stryker_m1126_m2_wd","rhsusf_m113_usarmy_M240","rhsusf_m113_usarmy","rhsusf_m113_usarmy_MK19","rhsusf_M1117_W"]];
_veh set [T_VEH_MBT, ["BWA3_Leopard2_Fleck"]];

_veh set [T_VEH_MRLS, ["rhsusf_M142_usarmy_WD"]];
_veh set [T_VEH_SPA, ["rhsusf_m109_usarmy"]];
_veh set [T_VEH_SPAA, ["RHS_M6_wd"]];

_veh set [T_VEH_stat_HMG_high, ["RHS_M2StaticMG_WD"]];
//_veh set [T_VEH_stat_GMG_high, [""]];
_veh set [T_VEH_stat_HMG_low, ["RHS_M2StaticMG_MiniTripod_WD"]];
_veh set [T_VEH_stat_GMG_low, ["RHS_MK19_TriPod_WD"]];
_veh set [T_VEH_stat_AA, ["RHS_Stinger_AA_pod_WD"]];
_veh set [T_VEH_stat_AT, ["RHS_TOW_TriPod_WD"]];

_veh set [T_VEH_stat_mortar_light, ["RHS_M252_WD"]];
_veh set [T_VEH_stat_mortar_heavy, ["RHS_M119_WD"]];

_veh set [T_VEH_heli_light, ["RHS_UH60M", "RHS_UH60M2", "RHS_UH60M_ESSS", "RHS_UH60M_ESSS2"]];
_veh set [T_VEH_heli_heavy, ["RHS_CH_47F"]];
_veh set [T_VEH_heli_cargo, ["RHS_CH_47F"]];
_veh set [T_VEH_heli_attack, ["BWA3_Tiger_RMK_FZ"]];

_veh set [T_VEH_plane_attack, ["RHS_A10"]];
_veh set [T_VEH_plane_fighter , ["rhsusf_f22"]];
_veh set [T_VEH_plane_cargo, ["RHS_C130J"]];
_veh set [T_VEH_plane_unarmed , ["RHS_C130J"]];
//_veh set [T_VEH_plane_VTOL, [""]];
_veh set [T_VEH_boat_unarmed, ["B_Boat_Transport_01_F", "I_C_Boat_Transport_02_F"]];
_veh set [T_VEH_boat_armed, ["rhsusf_mkvsoc"]];
_veh set [T_VEH_personal, ["rhsusf_mrzr4_w"]];

_veh set [T_VEH_truck_inf, ["rhsusf_M1083A1P2_WD_fmtv_usarmy", "rhsusf_M1078A1P2_WD_fmtv_usarmy", "rhsusf_M1078A1P2_B_WD_fmtv_usarmy", "rhsusf_M1083A1P2_B_M2_WD_fmtv_usarmy", "rhsusf_M1083A1P2_B_M2_WD_fmtv_usarmy"]];
_veh set [T_VEH_truck_cargo, ["rhsusf_M977A4_usarmy_wd", "rhsusf_M977A4_BKIT_M2_usarmy_wd", "rhsusf_M977A4_BKIT_usarmy_wd",
"rhsusf_M1083A1P2_WD_flatbed_fmtv_usarmy", "rhsusf_M1083A1P2_B_WD_flatbed_fmtv_usarmy", "rhsusf_M1083A1P2_B_M2_WD_flatbed_fmtv_usarmy",
"rhsusf_M1084A1P2_WD_fmtv_usarmy", "rhsusf_M1084A1P2_B_WD_fmtv_usarmy", "rhsusf_M1084A1P2_B_M2_WD_fmtv_usarmy",
"rhsusf_M1078A1P2_WD_flatbed_fmtv_usarmy", "rhsusf_M1078A1P2_B_WD_flatbed_fmtv_usarmy", "rhsusf_M1078A1P2_B_M2_WD_flatbed_fmtv_usarmy"]];
_veh set [T_VEH_truck_ammo, ["rhsusf_M977A4_AMMO_usarmy_wd", "rhsusf_M977A4_AMMO_BKIT_usarmy_wd", "rhsusf_M977A4_AMMO_BKIT_M2_usarmy_wd"]];
_veh set [T_VEH_truck_repair, ["rhsusf_M977A4_REPAIR_BKIT_M2_usarmy_wd", "rhsusf_M977A4_REPAIR_usarmy_wd", "rhsusf_M977A4_REPAIR_BKIT_usarmy_wd"]];
_veh set [T_VEH_truck_medical , ["rhsusf_m113_usarmy_medical", "rhsusf_M1085A1P2_B_WD_Medical_fmtv_usarmy", "rhsusf_M1230a1_usarmy_wd"]];
_veh set [T_VEH_truck_fuel, ["rhsusf_M978A4_usarmy_wd", "rhsusf_M978A4_BKIT_usarmy_wd"]];

//_veh set [T_VEH_submarine, ["B_SDV_01_F"]];



//==== Drones ====
_drone = +(tDefault select T_DRONE);
//_drone set [T_DRONE_SIZE-1, nil];
//_drone set [T_DRONE_DEFAULT, ["I_UGV_01_F"]];
//_drone set [T_DRONE_UGV_unarmed, ["I_UGV_01_F"]];
//_drone set [T_DRONE_UGV_armed, ["I_UGV_01_rcws_F"]];
//_drone set [T_DRONE_plane_attack, ["I_UAV_02_dynamicLoadout_F"]];
//_drone set [T_DRONE_plane_unarmed, ["I_UAV_02_dynamicLoadout_F"]];
//_drone set [T_DRONE_heli_attack, ["I_UAV_02_dynamicLoadout_F"]];
//_drone set [T_DRONE_quadcopter, ["I_UAV_01_F"]];
//_drone set [T_DRONE_designator, [""]];
//_drone set [T_DRONE_stat_HMG_low, ["I_HMG_01_A_F"]];
//_drone set [T_DRONE_stat_GMG_low, ["I_GMG_01_A_F"]];
//_drone set [T_DRONE_stat_AA, [""]];

//==== Cargo ====
_cargo = +(tDefault select T_CARGO);

//==== Groups ====
_group = +(tDefault select T_GROUP);

//==== Set arrays ====
_array set [T_INF, _inf];
_array set [T_VEH, _veh];
_array set [T_DRONE, _drone];
_array set [T_CARGO, _cargo];
_array set [T_GROUP, _group];

_array // End template
