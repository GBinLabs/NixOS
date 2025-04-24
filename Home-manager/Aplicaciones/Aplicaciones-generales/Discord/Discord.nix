{pkgs, ...}: {
  programs.nixcord = {
    enable = true;
    vesktop = {
      enable = true;
      package = pkgs.vesktop;
      autoscroll = {
    	  enable = false;
      };
    };

    #config = {
     # plugins = {
      #  clearURLs.enable = true;
       # voiceChatDoubleClick.enable = true;
        #streamerModeOnStream.enable = true;
        #silentTyping.enable = true;
      #};
    #};
  };
}
