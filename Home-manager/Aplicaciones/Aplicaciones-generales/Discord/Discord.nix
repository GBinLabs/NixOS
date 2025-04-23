{pkgs, ...}: {
  programs.nixcord = {
    enable = true;
    discord = {
      enable = true;
      package = pkgs.discord;
      vencord = {
        enable = false;
      };
      openASAR.enable = true;
    };

    config = {
      transparent = true;
      useQuickCss = true;
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
