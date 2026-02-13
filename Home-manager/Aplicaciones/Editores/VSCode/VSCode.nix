{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Nix
    nixd
    nixfmt

    # LaTeX
    texliveFull
    
    # Utilidades
    pdf2svg
    ghostscript
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-marketplace; [
        # Nix
        jnoortheen.nix-ide

        # LaTeX
        james-yu.latex-workshop

        # Tema
        jdinhlife.gruvbox

        # Git
        eamodio.gitlens

        # Corrección ortográfica y gramatical
        streetsidesoftware.code-spell-checker
        streetsidesoftware.code-spell-checker-spanish
        ltex-plus.vscode-ltex-plus
      ];

      userSettings = {
        # Rendimiento
        "telemetry.telemetryLevel" = "off";
        "update.mode" = "none";
        "extensions.autoUpdate" = false;
        "workbench.enableExperiments" = false;
        "workbench.settings.enableNaturalLanguageSearch" = false;
        "editor.minimap.enabled" = false;
        "search.followSymlinks" = false;
        "git.autorefresh" = false;
        "git.autoRepositoryDetection" = "openEditors";

        "files.watcherExclude" = {
          "**/.git/objects/**" = true;
          "**/.git/subtree-cache/**" = true;
          "**/node_modules/**" = true;
          "**/result" = true;
          "**/*.aux" = true;
          "**/*.bbl" = true;
          "**/*.blg" = true;
          "**/*.fdb_latexmk" = true;
          "**/*.fls" = true;
          "**/*.log" = true;
          "**/*.out" = true;
          "**/*.synctex.gz" = true;
          "**/*.toc" = true;
        };

        # Editor
        "editor.fontFamily" = "'JetBrains Mono', 'Noto Sans Mono', monospace";
        "editor.fontSize" = 14;
        "editor.lineNumbers" = "relative";
        "editor.wordWrap" = "on";
        "editor.wordWrapColumn" = 100;
        "editor.rulers" = [ 80 100 ];
        "editor.renderWhitespace" = "boundary";
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = true;
        "editor.cursorBlinking" = "solid";
        "editor.cursorStyle" = "block";
        "editor.smoothScrolling" = false;
        "editor.acceptSuggestionOnEnter" = "smart";
        "editor.formatOnSave" = true;
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 5000;
        "files.encoding" = "utf8";

        # Tema
        "workbench.colorTheme" = "Gruvbox Dark Hard";
        "workbench.iconTheme" = "vs-minimal";
        "window.titleBarStyle" = "custom";
        "workbench.activityBar.location" = "top";

        # Nix
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings".nixd.formatting.command = [ "nixfmt" ];

        "[nix]" = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.formatOnSave" = true;
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };

        # LaTeX Workshop
        "latex-workshop.latex.autoBuild.run" = "onSave";
        "latex-workshop.latex.clean.fileTypes" = [
          "*.aux" "*.bbl" "*.blg" "*.fdb_latexmk" "*.fls"
          "*.log" "*.out" "*.synctex.gz" "*.toc"
        ];
        "latex-workshop.view.pdf.viewer" = "tab";
        "latex-workshop.synctex.afterBuild.enabled" = true;

        "[latex]" = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.wordWrap" = "on";
          "editor.wordWrapColumn" = 80;
          "editor.formatOnSave" = false;
        };

        # LTeX
        "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
        "ltex.java.path" = "${pkgs.temurin-bin-25}";
        "ltex.language" = "es-AR";
        "ltex.additionalRules.motherTongue" = "es-AR";
        "ltex.additionalRules.enablePickyRules" = true;
        "ltex.diagnosticSeverity" = "information";
        "ltex.completionEnabled" = true;
        "ltex.enabled" = [ "latex" "bibtex" "markdown" ];
        "ltex.sentenceCacheSize" = 5000;

        # cSpell
        "cSpell.language" = "es,en";
        "cSpell.enableFiletypes" = [ "latex" "nix" ];

        # Asociaciones de archivos
        "files.associations" = {
          "*.tex" = "latex";
          "*.nix" = "nix";
          "flake.lock" = "json";
        };

        # Git
        "git.enableSmartCommit" = true;
        "git.confirmSync" = false;
      };
    };
  };
}
