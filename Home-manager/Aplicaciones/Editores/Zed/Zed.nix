{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      nixd
      nixfmt
    ];
    sessionVariables.ZED_WINDOW_DECORATIONS = "server";
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "typst"
      "toml"
      "json"
      "typos"
      "git-firefly"
      "ltex"
    ];

    userSettings = {
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      features.edit_prediction_provider = "none";
      agent.enabled = false;

      theme = {
        mode = "dark";
        dark = "Noctalia dark transparent";
        light = "Noctalia light";
      };

      theme_overrides."Noctalia dark transparent" = {
        "background" = "#00000000";
        "editor.background" = "#00000000";
        "tab_bar.background" = "#00000000";
        "toolbar.background" = "#00000000";
        "panel.background" = "#00000000";
        "status_bar.background" = "#00000000";
        "title_bar.background" = "#00000000";
        "background.appearance" = "transparent";
      };

      buffer_font_family = "JetBrains Mono";
      terminal.font_family = "JetBrains Mono";

      languages = {
        Nix.language_servers = [ "nixd" ];
        Nix.formatter.external.command = "nixfmt";
        Typst.language_servers = [
          "tinymist"
          "ltex"
        ];
        Markdown.language_servers = [ "ltex" ];
      };

      lsp = {
        tinymist.settings.exportPdf = "onSave";
        ltex.settings.ltex.language = "es-AR";
      };
    };
  };
}
