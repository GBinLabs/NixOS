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

    config = {
      transparent = true;
      plugins = {
        clearURLs.enable = true;
        voiceChatDoubleClick.enable = true;
        streamerModeOnStream.enable = true;
        silentTyping.enable = true;
        noTypingAnimation.enable = true;
        noF1.enable = true;
        noBlockedMessages.enable = true;
      };
    };
  };
}
