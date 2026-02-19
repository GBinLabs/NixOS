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
      show_welcome_view = false;
      restore_on_startup = "none";

      theme = {
        mode = "dark";
        dark = "Noctalia Dark Transparent";
        light = "Noctalia Light Transparent";
      };

      "experimental.theme_overrides" = {
        "background.appearance" = "transparent";
      };

      buffer_font_family = "JetBrains Mono";
      terminal.font_family = "JetBrains Mono";

      languages = {
        Nix.language_servers = [ "nixd" ];
        Nix.formatter.external.command = "nixfmt";
        Typst = {
          language_servers = [
            "tinymist"
            "ltex"
          ];
          soft_wrap = "editor_width";
        };
        Markdown = {
          language_servers = [ "ltex" ];
          soft_wrap = "editor_width";
        };
      };

      lsp = {
        tinymist.settings.exportPdf = "onSave";
        ltex.settings.ltex = {
          language = "es-AR";
          enabled = [
            "markdown"
            "typst"
          ];
        };
      };
    };
  };
}
