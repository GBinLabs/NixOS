{ pkgs, ... }:
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
    # vscodium es la versión sin telemetría de Microsoft.
    # Si preferís VS Code oficial, cambiar a: package = pkgs.vscode;
    package = pkgs.vscode;
    
    # ─────────────────────────────────────────────────────────────────────────
    # Extensiones
    # ─────────────────────────────────────────────────────────────────────────
    profiles = {
    default = {
    extensions = with pkgs.vscode-marketplace; [
        # LaTeX
        james-yu.latex-workshop
        
        # Tema
        jdinhlife.gruvbox
        
        # Git
        eamodio.gitlens
        
        # Spell check
        streetsidesoftware.code-spell-checker
        streetsidesoftware.code-spell-checker-spanish
        
        # LTeX Plus
        ltex-plus.vscode-ltex-plus
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
      "editor.smoothScrolling" = false;  # Desactivar para rendimiento
      "editor.acceptSuggestionOnEnter" = "smart";
      
      # Guardado automático
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 5000;  # 5 segundos
      
      # ═══════════════════════════════════════════════════════════════════════
      # TEMA Y APARIENCIA
      # ═══════════════════════════════════════════════════════════════════════
      "workbench.colorTheme" = "Gruvbox Dark Hard";
      "workbench.iconTheme" = "vs-minimal";
      "window.titleBarStyle" = "custom";
      "workbench.activityBar.location" = "top";
      
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
      "latex-workshop.message.badbox.show" = false;  # Demasiado verboso
      
      # ═══════════════════════════════════════════════════════════════════════
      # LTEX-PLUS - Corrección gramatical con LanguageTool local
      # ═══════════════════════════════════════════════════════════════════════
      
      "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
      
      "ltex.java.path" = "${pkgs.temurin-bin-25}";
      
      # Conectar al servidor LanguageTool local (puerto 8081 de tu config)
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
      # Diccionario personalizado - términos matemáticos
      # ─────────────────────────────────────────────────────────────────────────
      "ltex.dictionary" = {
        "es-AR" = [
        ];
        "en-GB" = [
        ];
      };
      
      # ─────────────────────────────────────────────────────────────────────────
      # Reglas deshabilitadas (ajustar según necesidad)
      # ─────────────────────────────────────────────────────────────────────────
      "ltex.disabledRules" = {
        "es-AR" = [
        ];
        "en-GB" = [
        ];
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
      
      # Entornos LaTeX a ignorar (código, matemáticas extensas)
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
      
      # ─────────────────────────────────────────────────────────────────────────
      # Rendimiento de LTeX
      # ─────────────────────────────────────────────────────────────────────────
      "ltex.sentenceCacheSize" = 5000;
      
      # ═══════════════════════════════════════════════════════════════════════
      # SPELL CHECKER (backup/adicional)
      # ═══════════════════════════════════════════════════════════════════════
      "cSpell.language" = "es,en";
      "cSpell.enableFiletypes" = [ "latex" "bibtex" ];
      
      # ═══════════════════════════════════════════════════════════════════════
      # ARCHIVOS Y ASOCIACIONES
      # ═══════════════════════════════════════════════════════════════════════
      "files.associations" = {
        "*.tex" = "latex";
        "*.sty" = "latex";
        "*.cls" = "latex";
        "*.bib" = "bibtex";
        "*.tikz" = "latex";
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
