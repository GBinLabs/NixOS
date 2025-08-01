{ pkgs,... }:


{


  programs = {
  	nixcord = {
  		enable = true;
  		discord = {
  			enable = false;
  		};
  		vesktop = {
  			enable = false;
  		};
  		dorion = {
  			enable = true;
  			package = pkgs.dorion;
  			blur = "blur";
  			blurCss = true;
  			clientMods = ["Shelter"];
  			rpcWebsocketConnector = true;
  		};
  	};
  };


}
