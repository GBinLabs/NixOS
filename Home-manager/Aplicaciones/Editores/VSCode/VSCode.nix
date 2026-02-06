{  pkgs, ... }:
{
  # ═══════════════════════════════════════════════════════════════════════════
  # PAQUETES DEL SISTEMA
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # LaTeX
    texliveFull
    
    # Language servers y herramientas
    texlab              # LSP para LaTeX (autocompletado, go-to-definition)
    ltex-ls-plus        # LSP para gramática (conecta con LanguageTool local)
    
    # Nix
    nixd                # LSP para Nix
    nixfmt              # Formateador para Nix

    # Typst
    tinymist            # LSP para Typst (incluido en extensión, pero útil como fallback)
    typstyle            # Formateador para Typst
    typst               # Compilador Typst

    # Utilidades
    pdf2svg             # Conversión para figuras
    ghostscript         # Manipulación de PostScript/PDF
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # VS CODE
  # ═══════════════════════════════════════════════════════════════════════════
  programs.vscode = {
    enable = true;
    
    # ─────────────────────────────────────────────────────────────────────────
    # Paquete base
    # ─────────────────────────────────────────────────────────────────────────
    package = pkgs.vscode;
    
    # ─────────────────────────────────────────────────────────────────────────
    # Extensiones
    # ─────────────────────────────────────────────────────────────────────────
    profiles = {
      default = {
        extensions = (with pkgs.vscode-marketplace; [
  # LaTeX
  james-yu.latex-workshop

  # Nix
  jnoortheen.nix-ide

  # Typst
  myriad-dreamin.tinymist

  # Tema
  jdinhlife.gruvbox

  # Git
  eamodio.gitlens

  # Spell check
  streetsidesoftware.code-spell-checker
  streetsidesoftware.code-spell-checker-spanish
]) ++  [
  (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ltex-plus";
      name = "vscode-ltex-plus";
      version = "15.7.0";
    };
    vsix = pkgs.fetchurl {
  url = "https://github.com/ltex-plus/vscode-ltex-plus/releases/download/nightly/vscode-ltex-plus-15.7.0-alpha.nightly.2026-02-03-offline-linux-x64.vsix";
  hash = "sha256-KgkzoQUqlzJL0W6K3pQHMPZ1X6lrrbsFOAq14nm0gCU=";
};
  })
];

        # ─────────────────────────────────────────────────────────────────────────
        # Configuración de usuario (settings.json)
        # ─────────────────────────────────────────────────────────────────────────
        userSettings = {
          # ═══════════════════════════════════════════════════════════════════════
          # RENDIMIENTO - Optimizaciones para hardware limitado
          # ═══════════════════════════════════════════════════════════════════════
          
          # Deshabilitar telemetría y características innecesarias
          "telemetry.telemetryLevel" = "off";
          "update.mode" = "none";
          "extensions.autoUpdate" = false;
          "workbench.enableExperiments" = false;
          "workbench.settings.enableNaturalLanguageSearch" = false;
          
          # Reducir uso de memoria
          "files.watcherExclude" = {
            "**/.git/objects/**" = true;
            "**/.git/subtree-cache/**" = true;
            "**/node_modules/**" = true;
            "**/*.aux" = true;
            "**/*.log" = true;
            "**/*.synctex.gz" = true;
            "**/*.fls" = true;
            "**/*.fdb_latexmk" = true;
            "**/*.bbl" = true;
            "**/*.bcf" = true;
            "**/*.blg" = true;
            "**/*.run.xml" = true;
            "**/*.out" = true;
            "**/*.toc" = true;
            "**/*.lof" = true;
            "**/*.lot" = true;
            "**/*.idx" = true;
            "**/*.ind" = true;
            "**/*.ilg" = true;
            "**/result" = true;          # Nix build symlinks
          };
          
          # Deshabilitar minimap (consume recursos en archivos grandes)
          "editor.minimap.enabled" = false;
          
          # Limitar procesos en background
          "search.followSymlinks" = false;
          "git.autorefresh" = false;
          "git.autoRepositoryDetection" = "openEditors";
          
          # ═══════════════════════════════════════════════════════════════════════
          # EDITOR - Configuración general
          # ═══════════════════════════════════════════════════════════════════════
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
          
          # Guardado automático
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 5000;
          
          # ═══════════════════════════════════════════════════════════════════════
          # TEMA Y APARIENCIA
          # ═══════════════════════════════════════════════════════════════════════
          "workbench.colorTheme" = "Gruvbox Dark Hard";
          "workbench.iconTheme" = "vs-minimal";
          "window.titleBarStyle" = "custom";
          "workbench.activityBar.location" = "top";
          
          # ═══════════════════════════════════════════════════════════════════════
          # NIX - Configuración de nix-ide con nixd
          # ═══════════════════════════════════════════════════════════════════════
          
          # Usar nixd como language server
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings" = {
            nixd = {
              formatting = {
                command = [ "nixfmt" ];
              };
            };
          };
          
          # Configuración específica de Nix por lenguaje
          "[nix]" = {
            "editor.tabSize" = 2;
            "editor.insertSpaces" = true;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
          };
          
          # ═══════════════════════════════════════════════════════════════════════
          # TYPST - Configuración de tinymist
          # ═══════════════════════════════════════════════════════════════════════
          
          # Exportar PDF al guardar
          "tinymist.exportPdf" = "onSave";
          
          # Formateador: typstyle
          "tinymist.formatterMode" = "typstyle";
          
          # Vista previa
          "tinymist.preview.refresh" = "onSave";
          
          # Configuración específica de Typst por lenguaje
          "[typst]" = {
            "editor.tabSize" = 2;
            "editor.insertSpaces" = true;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "myriad-dreamin.tinymist";
            "editor.wordWrap" = "on";
            "editor.wordWrapColumn" = 80;
          };
          
          # ═══════════════════════════════════════════════════════════════════════
          # LATEX WORKSHOP
          # ═══════════════════════════════════════════════════════════════════════
          
          # Motor de compilación: LuaLaTeX para soporte Unicode completo
          "latex-workshop.latex.recipe.default" = "latexmk (lualatex)";
          
          # Recetas de compilación
          "latex-workshop.latex.recipes" = [
            {
              name = "latexmk (lualatex)";
              tools = [ "lualatexmk" ];
            }
            {
              name = "latexmk (pdflatex)";
              tools = [ "pdflatexmk" ];
            }
            {
              name = "lualatex simple";
              tools = [ "lualatex" ];
            }
          ];
          
          # Herramientas de compilación
          "latex-workshop.latex.tools" = [
            {
              name = "lualatexmk";
              command = "latexmk";
              args = [
                "-synctex=1"
                "-interaction=nonstopmode"
                "-file-line-error"
                "-lualatex"
                "-outdir=%OUTDIR%"
                "%DOC%"
              ];
              env = {};
            }
            {
              name = "pdflatexmk";
              command = "latexmk";
              args = [
                "-synctex=1"
                "-interaction=nonstopmode"
                "-file-line-error"
                "-pdf"
                "-outdir=%OUTDIR%"
                "%DOC%"
              ];
              env = {};
            }
            {
              name = "lualatex";
              command = "lualatex";
              args = [
                "-synctex=1"
                "-interaction=nonstopmode"
                "-file-line-error"
                "-output-directory=%OUTDIR%"
                "%DOC%"
              ];
              env = {};
            }
          ];
          
          # Compilación automática al guardar
          "latex-workshop.latex.autoBuild.run" = "onSave";
          
          # Limpieza de archivos auxiliares
          "latex-workshop.latex.autoClean.run" = "onBuilt";
          "latex-workshop.latex.clean.fileTypes" = [
            "*.aux"
            "*.bbl"
            "*.bcf"
            "*.blg"
            "*.fdb_latexmk"
            "*.fls"
            "*.idx"
            "*.ilg"
            "*.ind"
            "*.lof"
            "*.log"
            "*.lot"
            "*.nav"
            "*.out"
            "*.run.xml"
            "*.snm"
            "*.synctex.gz"
            "*.toc"
            "*.vrb"
          ];
          
          # Formateador de LaTeX con latexindent
          "[latex]" = {
            "editor.tabSize" = 2;
            "editor.insertSpaces" = true;
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "james-yu.latex-workshop";
            "editor.wordWrap" = "on";
            "editor.wordWrapColumn" = 100;
          };
          
          # Configuración de latexindent (formateador de LaTeX Workshop)
          "latex-workshop.latexindent.path" = "latexindent";
          "latex-workshop.latexindent.args" = [
            "-c"
            "%DIR%/"
            "%TMPFILE%"
            "-m"               # Modifica line breaks
            "-l"               # Usa configuración local si existe
          ];
          
          # ─────────────────────────────────────────────────────────────────────────
          # Visor de PDF
          # ─────────────────────────────────────────────────────────────────────────
          "latex-workshop.view.pdf.viewer" = "tab";
          "latex-workshop.view.pdf.zoom" = "page-width";
          
          # ─────────────────────────────────────────────────────────────────────────
          # IntelliSense y autocompletado
          # ─────────────────────────────────────────────────────────────────────────
          "latex-workshop.intellisense.package.enabled" = true;
          "latex-workshop.intellisense.citation.backend" = "bibtex";
          "latex-workshop.intellisense.label.command" = [
            "ref"
            "eqref"
            "cref"
            "Cref"
            "autoref"
            "nameref"
            "pageref"
          ];
          
          # Hover para mostrar vista previa de matemáticas
          "latex-workshop.hover.preview.enabled" = true;
          "latex-workshop.hover.preview.mathjax.extensions" = [
            "ams"
            "physics"
          ];
          
          # ─────────────────────────────────────────────────────────────────────────
          # Diagnósticos y errores
          # ─────────────────────────────────────────────────────────────────────────
          "latex-workshop.message.error.show" = true;
          "latex-workshop.message.warning.show" = true;
          "latex-workshop.message.information.show" = false;
          "latex-workshop.message.badbox.show" = false;
          
          # ═══════════════════════════════════════════════════════════════════════
          # LTEX-PLUS - Corrección gramatical con LanguageTool local
          # ═══════════════════════════════════════════════════════════════════════
          
          "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
          "ltex.java.path" = "${pkgs.temurin-bin-25}";
          
          # Conectar al servidor LanguageTool local
          "ltex.languageToolHttpServerUri" = "http://localhost:8081/";
          
          # Idioma principal
          "ltex.language" = "es-AR";
          "ltex.additionalRules.motherTongue" = "es-AR";
          
          # Reglas estrictas para máxima rigurosidad
          "ltex.additionalRules.enablePickyRules" = true;
          
          # Nivel de diagnóstico
          "ltex.diagnosticSeverity" = "information";
          
          # Completado automático
          "ltex.completionEnabled" = true;
          
          # Habilitar LTeX también para Typst
          "ltex.enabled" = [
            "latex"
            "bibtex"
            "markdown"
            "typst"
          ];
          
          # ─────────────────────────────────────────────────────────────────────────
          # Diccionario personalizado - términos matemáticos
          # ─────────────────────────────────────────────────────────────────────────
          "ltex.dictionary" = {
            "es-AR" = [ ];
            "en-GB" = [ ];
          };
          
          # ─────────────────────────────────────────────────────────────────────────
          # Reglas deshabilitadas
          # ─────────────────────────────────────────────────────────────────────────
          "ltex.disabledRules" = {
            "es-AR" = [ "NOUN_PLURAL2" ];
            "en-GB" = [ ];
          };
          
          # ─────────────────────────────────────────────────────────────────────────
          # Comandos LaTeX a ignorar
          # ─────────────────────────────────────────────────────────────────────────
          "ltex.latex.commands" = {
            "\\label{}" = "ignore";
            "\\ref{}" = "ignore";
            "\\cref{}" = "ignore";
            "\\Cref{}" = "ignore";
            "\\eqref{}" = "ignore";
            "\\cite{}" = "ignore";
            "\\cite[]{}" = "ignore";
            "\\textcite{}" = "ignore";
            "\\parencite{}" = "ignore";
            "\\autocite{}" = "ignore";
            "\\index{}" = "ignore";
            "\\gls{}" = "ignore";
            "\\Gls{}" = "ignore";
            "\\glspl{}" = "ignore";
            "\\newacronym{}{}{}" = "ignore";
            "\\newglossaryentry{}{}" = "ignore";
            "\\SI{}{}" = "ignore";
            "\\si{}" = "ignore";
            "\\num{}" = "ignore";
            "\\tikz" = "ignore";
            "\\pgfplotsset{}" = "ignore";
          };
          
          # Entornos LaTeX a ignorar
          "ltex.latex.environments" = {
            "lstlisting" = "ignore";
            "verbatim" = "ignore";
            "equation" = "ignore";
            "equation*" = "ignore";
            "align" = "ignore";
            "align*" = "ignore";
            "gather" = "ignore";
            "gather*" = "ignore";
            "multline" = "ignore";
            "multline*" = "ignore";
            "tikzpicture" = "ignore";
            "tikzcd" = "ignore";
            "pgfplot" = "ignore";
          };
          
          # Rendimiento de LTeX
          "ltex.sentenceCacheSize" = 5000;
          
          # ═══════════════════════════════════════════════════════════════════════
          # SPELL CHECKER (backup/adicional)
          # ═══════════════════════════════════════════════════════════════════════
          "cSpell.language" = "es,en";
          "cSpell.enableFiletypes" = [ "latex" "bibtex" "typst" "nix" ];
          
          # ═══════════════════════════════════════════════════════════════════════
          # ARCHIVOS Y ASOCIACIONES
          # ═══════════════════════════════════════════════════════════════════════
          "files.associations" = {
            "*.tex" = "latex";
            "*.sty" = "latex";
            "*.cls" = "latex";
            "*.bib" = "bibtex";
            "*.tikz" = "latex";
            "*.typ" = "typst";
            "*.nix" = "nix";
            "flake.lock" = "json";
          };
          
          # Encoding
          "files.encoding" = "utf8";
          
          # ═══════════════════════════════════════════════════════════════════════
          # GIT
          # ═══════════════════════════════════════════════════════════════════════
          "git.enableSmartCommit" = true;
          "git.confirmSync" = false;
        };
      };
    };
  };
}
