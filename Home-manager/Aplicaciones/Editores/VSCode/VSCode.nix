{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nixfmt
    ltex-ls-plus
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-marketplace; [
        # Nix
        jnoortheen.nix-ide

        # Typst
        myriad-dreamin.tinymist
        calebfiggers.typst-companion

        # Gramática y ortografía
        ltex-plus.vscode-ltex-plus
      ];

      userSettings = {
        "telemetry.telemetryLevel" = "off";
        "update.mode" = "none";
        "extensions.autoUpdate" = false;

        # Editor
        "editor.fontFamily" = "'JetBrains Mono', monospace";
        "editor.fontSize" = 14;
        "editor.formatOnSave" = true;
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = true;

        # ── Nix ──────────────────────────────────────────────────────────────
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          nixd = {
            formatting.command = [ "nixfmt" ];
            # Diagnósticos completos: opciones de NixOS y Home-manager
            options = {
              nixos.expr = "(builtins.getFlake (toString ./.)).nixosConfigurations.PC.options";
              home-manager.expr = "(builtins.getFlake (toString ./.)).homeConfigurations.german.options";
            };
          };
        };

        "[nix]" = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.formatOnSave" = true;
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };

        # ── Typst ─────────────────────────────────────────────────────────────
        "tinymist.exportPdf" = "onSave";
        "tinymist.formatterMode" = "typstyle";
        "tinymist.completion.triggerOnSnippetPlaceholders" = true;
        "tinymist.preview.cursorIndicator" = true;

        "[typst]" = {
          "editor.wordWrap" = "on";
          "editor.wordWrapColumn" = 100;
          "editor.formatOnSave" = true;
          "editor.defaultFormatter" = "myriad-dreamin.tinymist";
        };

        # ── LTeX ──────────────────────────────────────────────────────────────
        "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
        "ltex.language" = "es-AR";
        "ltex.additionalRules.motherTongue" = "es-AR";
        "ltex.additionalRules.enablePickyRules" = true;
        "ltex.diagnosticSeverity" = "information";
        "ltex.completionEnabled" = true;
        "ltex.enabled" = [ "typst" "markdown" ];

        # ── Asociaciones de archivos ──────────────────────────────────────────
        "files.associations" = {
          "*.nix" = "nix";
          "flake.lock" = "json";
          "*.typ" = "typst";
        };
      };
    };
  };
}
