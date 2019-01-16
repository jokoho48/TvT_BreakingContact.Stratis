class BC_setup {

	class client {
		file = BC_setup\functions\client;

        class addBriefing;
        class addInteractions;
        class chooseSpawn;
        class createStartMarker;
        class establishingShot;
        class initialSpawnClient;
        class isOnWater;
        class openSpawnDialog;
        class teleportPlayer;
        class TFARsettings { preInit = 1; }; 
    };

  class server {
		file = BC_setup\functions\server;

        class defineWoodland { preInit = 1; };
        class findRandomPos;
        class getHighestRankOfSide;
        class getIslandCfgEntry { preInit = 1; };
        class initialSpawnServer;
        class registerDynamicGroup;
        class showLeaderInformation;
        class teleportAI;     
    };
};
