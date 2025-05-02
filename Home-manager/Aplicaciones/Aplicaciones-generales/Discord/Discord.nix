_: {
  programs.nixcord = {
    enable = true;
    discord = {
      vencord = {
        enable = true;
        unstable = true;
      };
    };

    config = {
      themeLinks = ["https://discordstyles.github.io/DarkMatter/DarkMatter.theme.css"];
      frameless = true;
      transparent = true;
      plugins = {
        clearURLs.enable = true;
        fixImagesQuality.enable = true;
        noF1.enable = true;
        noTypingAnimation.enable = true;
        voiceChatDoubleClick.enable = true;
        streamerModeOnStream.enable = true;
        silentTyping.enable = true;
      };
    };
  };
}
