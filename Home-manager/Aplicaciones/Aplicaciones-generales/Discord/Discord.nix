{ pkgs, ... }:

{

  programs = {
    nixcord = {
      enable = true;
      discord = {
        enable = false;
      };
      vesktop = {
        enable = true;
        package = pkgs.vesktop;
        autoscroll = {
          enable = false;
        };
      };
      vesktopConfig = {
        plugins = {
          clearURLs = {
            enable = true;
          };
          crashHandler = {
            enable = true;
            attemptToPreventCrashes = true;
          };
          fixImagesQuality = {
            enable = true;
          };
          noF1 = {
            enable = true;
          };
          silentTyping = {
            enable = true;
            showIcon = true;
            contextMenu = true;
            isEnabled = true;
          };
          webScreenShareFixes = {
            enable = true;
          };
        };
      };
    };
  };

}
