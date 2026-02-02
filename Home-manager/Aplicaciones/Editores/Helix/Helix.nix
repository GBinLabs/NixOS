{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      # Nix
      nixd
      nixfmt

      # Typst
      tinymist
      typstyle
      typst

      # Grammar checking - ltex-ls-plus actúa como cliente del servidor local
      ltex-ls-plus

      # Python
      python3
      ruff
      pyright

      # Rust
      rust-analyzer
      rustfmt
      clippy
    ];

    settings = {
      theme = "gruvbox_dark_hard";

      editor = {
        line-number = "relative";
        mouse = false;

        soft-wrap = {
          enable = true;
          max-wrap = 100;
          wrap-indicator = "↪ ";
        };

        scroll-lines = 3;
        scrolloff = 5;

        color-modes = true;
        bufferline = "multiple";
        true-color = true;

        gutters = [
          "diagnostics"
          "line-numbers"
          "spacer"
        ];

        whitespace = {
          render = "all";
          characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⏎";
          };
        };

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
          auto-signature-help = true;
        };

        auto-format = true;
        auto-save = true;
      };
    };

    languages = {
      language-server = {
        nixd = {
          command = "nixd";
        };

        tinymist = {
          command = "tinymist";
          config.exportPdf = "onSave";
        };

        # ═══════════════════════════════════════════════════════════════
        # LTEX-LS-PLUS - Configuración para servidor LanguageTool local
        # ═══════════════════════════════════════════════════════════════
        ltex-ls-plus = {
          command = "ltex-ls-plus";
          timeout = 120;
          config.ltex = {
            # ─────────────────────────────────────────────────────────────
            # Conexión al servidor LanguageTool local
            # ─────────────────────────────────────────────────────────────
            # CRÍTICO: Esta opción conecta ltex-ls-plus a tu servidor local
            # en lugar de usar el LanguageTool embebido
            #languageToolHttpServerUri = "http://localhost:8081/";

            # ─────────────────────────────────────────────────────────────
            # Idioma y configuración regional
            # ─────────────────────────────────────────────────────────────
            language = "es";
            motherTongue = "es";

            # ─────────────────────────────────────────────────────────────
            # Nivel de diagnóstico
            # ─────────────────────────────────────────────────────────────
            # "error" | "warning" | "information" | "hint"
            # Usar "information" para ver todos los problemas
            diagnosticSeverity = "information";

            # ─────────────────────────────────────────────────────────────
            # Reglas adicionales - Máxima rigurosidad
            # ─────────────────────────────────────────────────────────────
            additionalRules = {
              # Habilita reglas "picky" - detecta más problemas estilísticos
              enablePickyRules = true;
            };

            # ─────────────────────────────────────────────────────────────
            # Cache de oraciones - Mejora rendimiento
            # ─────────────────────────────────────────────────────────────
            # Número de oraciones cacheadas en ltex-ls-plus
            # Para archivos grandes: 2000-5000
            sentenceCacheSize = 5000;

            # ─────────────────────────────────────────────────────────────
            # Autocompletado y features
            # ─────────────────────────────────────────────────────────────
            completionEnabled = true;
            
            # ─────────────────────────────────────────────────────────────
            # Configuración de Java para ltex-ls-plus embebido
            # ─────────────────────────────────────────────────────────────
            # Aumentar memoria si trabajas con archivos grandes
            "ltex-ls".logLevel = "warning";
            java = {
              initialHeapSize = 256;
              maximumHeapSize = 2048; # 2GB máximo
            };

            # ─────────────────────────────────────────────────────────────
            # Diccionarios personalizados
            # ─────────────────────────────────────────────────────────────
            # Agregar palabras que LanguageTool marca incorrectamente
            # Ejemplo: términos técnicos, nombres propios, etc.
            dictionary = {
              "es" = [
                # Términos matemáticos comunes
                "subespacio"
                "subespacios"
                "autovalor"
                "autovalores"
                "autovector"
                "autovectores"
                "eigenvalor"
                "eigenvalores"
                "eigenvector"
                "eigenvectores"
                "biyectiva"
                "sobreyectiva"
                "inyectiva"
                "homomorfismo"
                "homomorfismos"
                "isomorfismo"
                "isomorfismos"
                "endomorfismo"
                "endomorfismos"
                # Agregar más términos según necesites
              ];
              "en-GB" = [
                "eigenvalue"
                "eigenvalues"
                "eigenvector"
                "eigenvectors"
              ];
            };

            # ─────────────────────────────────────────────────────────────
            # Reglas deshabilitadas
            # ─────────────────────────────────────────────────────────────
            # Deshabilitar reglas que generen muchos falsos positivos
            # Encontrar IDs de reglas: ver diagnósticos en Helix
            disabledRules = {
              "es" = [
              ];
              "en-GB" = [
                # Ejemplo: deshabilitar profanity check
                # "PROFANITY"
              ];
            };

            # ─────────────────────────────────────────────────────────────
            # Falsos positivos ocultos
            # ─────────────────────────────────────────────────────────────
            # Patrones regex para ocultar errores en contextos específicos
            # Útil para fórmulas matemáticas o código inline
            hiddenFalsePositives = {
              "es-AR" = [
                # Ejemplo: ignorar contenido entre $ $ (fórmulas)
                # "\\$.*?\\$"
              ];
              "en-GB" = [ ];
            };

            # ─────────────────────────────────────────────────────────────
            # Configuración de LaTeX/Typst
            # ─────────────────────────────────────────────────────────────
            latex = {
              # Comandos cuyos argumentos deben ignorarse
              commands = {
                # Ejemplo para Typst (si usas comandos personalizados)
                # "\\label{}" = "ignore";
                # "\\ref{}" = "ignore";
              };
              # Entornos cuyo contenido debe ignorarse
              environments = {
                # "lstlisting" = "ignore";
                # "verbatim" = "ignore";
              };
            };

            # ─────────────────────────────────────────────────────────────
            # Configuración de Markdown
            # ─────────────────────────────────────────────────────────────
            markdown = {
              # Nodos cuyo contenido debe ignorarse
              nodes = {
                # "CodeBlock" = "ignore";
                # "FencedCodeBlock" = "ignore";
              };
            };
          };
        };

        pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
          config.python.analysis = {
            typeCheckingMode = "basic";
            autoSearchPaths = true;
            useLibraryCodeForTypes = true;
          };
        };

        ruff = {
          command = "ruff";
          args = [ "server" ];
        };

        rust-analyzer = {
          command = "rust-analyzer";
          config = {
            check.command = "clippy";
            cargo.allFeatures = true;
            procMacro.enable = true;
          };
        };
      };

      language = [
        {
          name = "typst";
          language-servers = [
            "tinymist"
            "ltex-ls-plus"
          ];
          auto-format = true;
          formatter = {
            command = "typstyle";
          };
          soft-wrap = {
            enable = true;
            max-wrap = 80;
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "nix";
          auto-format = true;
          formatter.command = "nixfmt";
          language-servers = [ "nixd" ];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "markdown";
          language-servers = [ "ltex-ls-plus" ];
          soft-wrap = {
            enable = true;
            max-wrap = 80;
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "python";
          language-servers = [
            "pyright"
            "ruff"
          ];
          auto-format = true;
          formatter = {
            command = "ruff";
            args = [
              "format"
              "-"
            ];
          };
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }

        {
          name = "rust";
          language-servers = [ "rust-analyzer" ];
          auto-format = true;
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }
      ];
    };
  };
}
