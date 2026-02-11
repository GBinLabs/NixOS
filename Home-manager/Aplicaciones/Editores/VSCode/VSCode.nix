{  pkgs, ... }:let
  quarkdown = pkgs.callPackage ./quarkdown.nix { };
in
{
  # ═══════════════════════════════════════════════════════════════════════════
  # PAQUETES DEL SISTEMA
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # ─────────────────────────────────────────────────────────────────────────
    # ConTeXt LMTX - Sistema de composición tipográfica moderno
    # ─────────────────────────────────────────────────────────────────────────
    texliveConTeXt
    
    # Language servers y herramientas
    ltex-ls-plus        # LSP para gramática (soporta ConTeXt nativamente)
    
    # Nix
    nixd                # LSP para Nix
    nixfmt              # Formateador para Nix
    
    quarkdown

    # Typst (mantenido para tu libro de Álgebra Lineal)
    tinymist            # LSP para Typst
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
        extensions = with pkgs.vscode-marketplace; [
          # ═══════════════════════════════════════════════════════════════════
          # ConTeXt - Syntax highlighting
          # ═══════════════════════════════════════════════════════════════════
          juliangmp.context-syntax

          # Nix
          jnoortheen.nix-ide

          # Typst (mantenido para tu libro)
          myriad-dreamin.tinymist

          # Tema
          jdinhlife.gruvbox

          # Git
          eamodio.gitlens

          # Spell check
          streetsidesoftware.code-spell-checker
          streetsidesoftware.code-spell-checker-spanish
          ltex-plus.vscode-ltex-plus
          
        ] ++ [
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "quarkdown-vscode";
      publisher = "quarkdown";
      version = "1.0.4";
      hash = "sha256-Nwt8/wdb8SgD7zVZStygKA3xHeGmGOjfrZwsvoRVcdc=";
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
            # Archivos auxiliares de ConTeXt
            "**/*.tuc" = true;
            "**/*.log" = true;
            "**/*.synctex.gz" = true;
            "**/*.pgf" = true;
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
          # TYPST - Configuración de tinymist (mantenido para tu libro)
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
          # CONTEXT - Configuración para ConTeXt LMTX
          # ═══════════════════════════════════════════════════════════════════════
          
          # Configuración específica de ConTeXt por lenguaje
          "[context]" = {
            "editor.tabSize" = 2;
            "editor.insertSpaces" = true;
            "editor.wordWrap" = "on";
            "editor.wordWrapColumn" = 100;
          };
          
          # ═══════════════════════════════════════════════════════════════════════
          # LTEX-PLUS - Corrección gramatical con soporte para ConTeXt
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
          
          # ─────────────────────────────────────────────────────────────────────────
          # Lenguajes habilitados para LTeX (incluyendo ConTeXt)
          # ─────────────────────────────────────────────────────────────────────────
          "ltex.enabled" = [
            "context"       # ConTeXt - soporte nativo
            "latex"         # LaTeX legacy si lo necesitas
            "bibtex"
            "markdown"
            "typst"
          ];
          
          # ─────────────────────────────────────────────────────────────────────────
          # Diccionario personalizado - términos matemáticos
          # ─────────────────────────────────────────────────────────────────────────
          "ltex.dictionary" = {
            "es-AR" = [
              # Términos matemáticos comunes
              # Términos de ConTeXt
              "metapost"
              "luametatex"
              "mkxl"
            ];
            "en-GB" = [
            ];
          };
          
          # ─────────────────────────────────────────────────────────────────────────
          # Reglas deshabilitadas
          # ─────────────────────────────────────────────────────────────────────────
          "ltex.disabledRules" = {
            "es-AR" = [ ];
            "en-GB" = [ ];
          };
          
          # ─────────────────────────────────────────────────────────────────────────
          # Comandos ConTeXt a ignorar (LTeX tiene soporte nativo)
          # ─────────────────────────────────────────────────────────────────────────
          # Nota: LTeX ya conoce la sintaxis de ConTeXt, pero puedes agregar
          # comandos personalizados aquí si es necesario
          
          # Rendimiento de LTeX
          "ltex.sentenceCacheSize" = 5000;
          
          # ═══════════════════════════════════════════════════════════════════════
          # SPELL CHECKER (backup/adicional)
          # ═══════════════════════════════════════════════════════════════════════
          "cSpell.language" = "es,en";
          "cSpell.enableFiletypes" = [ "context" "typst" "nix" ];
          
          # ═══════════════════════════════════════════════════════════════════════
          # ARCHIVOS Y ASOCIACIONES
          # ═══════════════════════════════════════════════════════════════════════
          "files.associations" = {
            # ConTeXt
            "*.tex" = "context";     # Asociar .tex a ConTeXt por defecto
            "*.mkiv" = "context";    # ConTeXt Mark IV
            "*.mkxl" = "context";    # ConTeXt Mark XL (LMTX)
            "*.mkvi" = "context";
            "*.mkii" = "context";    # ConTeXt Mark II (legacy)
            # Typst
            "*.typ" = "typst";
            # Nix
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
          
          # ═══════════════════════════════════════════════════════════════════════
          # TAREAS PERSONALIZADAS - Compilación de ConTeXt
          # ═══════════════════════════════════════════════════════════════════════
          # Nota: Las tareas se definen en .vscode/tasks.json del proyecto
          # Aquí solo configuramos keybindings relacionados
        };
      };
    };
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # ARCHIVO DE TAREAS - .vscode/tasks.json para compilar ConTeXt
  # ═══════════════════════════════════════════════════════════════════════════
  # Este archivo se puede colocar en tu directorio de proyecto
  home.file.".config/Code/User/tasks-context-template.json".text = builtins.toJSON {
    version = "2.0.0";
    tasks = [
      {
        label = "ConTeXt: Compilar documento";
        type = "shell";
        command = "context";
        args = [
          "--synctex"
          "--nonstopmode"
          "\${file}"
        ];
        group = {
          kind = "build";
          isDefault = true;
        };
        presentation = {
          reveal = "always";
          panel = "shared";
        };
        problemMatcher = {
          owner = "context";
          fileLocation = [ "relative" "\${workspaceFolder}" ];
          pattern = {
            regexp = "^(.*):(\\d+):\\s+(.*)$";
            file = 1;
            line = 2;
            message = 3;
          };
        };
      }
      {
        label = "ConTeXt: Compilar con opciones";
        type = "shell";
        command = "context";
        args = [
          "--synctex"
          "--nonstopmode"
          "--mode=\${input:contextMode}"
          "\${file}"
        ];
        presentation = {
          reveal = "always";
          panel = "shared";
        };
      }
      {
        label = "ConTeXt: Limpiar auxiliares";
        type = "shell";
        command = "context";
        args = [
          "--purgeall"
        ];
        presentation = {
          reveal = "silent";
          panel = "shared";
        };
      }
    ];
    inputs = [
      {
        id = "contextMode";
        description = "Modo de ConTeXt";
        default = "print";
        type = "pickString";
        options = [
          "print"
          "screen"
          "draft"
        ];
      }
    ];
  };
}
