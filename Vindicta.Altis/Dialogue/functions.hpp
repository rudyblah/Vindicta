class pr0 {

	class dialogue_common {
		file = "Dialogue\Common";
		class dialogue_common_bearingToID {};
		class dialogue_common_unitSideColor {};
	};

	class dialogue {
		file = "Dialogue";
		class dialogue_create {};

		class dialogue_setDataSets {};
		class dialogue_registerDataSet {};
		
		class dialogue_createSentence {};
		class dialogue_deleteSentence {};
		class dialogue_updateSentence {};
		
		class dialogue_createHUD {};
		class dialogue_deleteHUD {postinit = 1;};//remove old hud
	};

	class dialogue_example {
		file = "Dialogue\Testing";
		class example {};
	};

};