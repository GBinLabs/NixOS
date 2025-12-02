{pkgs, ...}: {
  programs = {
    helix = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        # Nix
        nixd
        nixfmt-rfc-style
        alejandra
        statix
        deadnix

        # Typst
        typst
        tinymist

        # LanguageTool
        ltex-ls-plus
      ];

      settings = {
        theme = "gruvbox_dark_hard";

        editor = {
          line-number = "relative";
          mouse = false;

          # Soft wrap para líneas largas
          soft-wrap = {
            enable = true;
            max-wrap = 100;
            wrap-indicator = "↪ ";
          };

          # Navegación más fluida
          scroll-lines = 3;
          scrolloff = 5;

          # Visualización mejorada
          color-modes = true;
          bufferline = "multiple";
          true-color = true;
          gutters = ["diagnostics" "line-numbers" "spacer"];

          # Espacios en blanco visibles (útil para Typst)
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
          shell = ["${pkgs.kitty}/bin/kitty" "--class" "helix-term"];
        };
      };

      languages = {
        language-server = {
          nixd = {
            command = "${pkgs.nixd}/bin/nixd";
            config = {
              nixd = {
                options = {
                  enable = true;
                  target = {
                    installable = "nixpkgs#nixosConfigurations.$(hostname).options";
                  };
                };
                eval = {
                  enable = true;
                  target = {
                    installable = ".";
                  };
                };
              };
            };
          };

          tinymist = {
            command = "${pkgs.tinymist}/bin/tinymist";
            config = {
              exportPdf = "onSave";
              formatterMode = "typstyle";
            };
          };

          # LTeX con español e inglés
          ltex-ls-plus = {
            command = "${pkgs.ltex-ls-plus}/bin/ltex-ls";
            config = {
              ltex = {
                language = "es"; # Idioma principal
                enabled = ["es" "en-US"]; # Ambos idiomas habilitados
                checkFrequency = "save";
                additionalRules = {
                  enablePickyRules = true;
                  motherTongue = "es";
                };
                # Diccionarios personalizados (opcional)
                dictionary = {
                  "es" = [];
                  "en-US" = [];
                };
              };
            };
          };
        };

        language = [
          {
            name = "nix";
            auto-format = true;
            formatter = {
              command = "${pkgs.alejandra}/bin/alejandra";
              args = [];
            };
            language-servers = ["nixd"];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }

          {
            name = "typst";
            scope = "source.typst";
            file-types = ["typ"];
            roots = ["template.typ"];
            language-servers = ["tinymist" "ltex-ls"];

            # Formateo automático al guardar
            auto-format = true;

            # Soft wrap específico para Typst (ideal para libros)
            soft-wrap = {
              enable = true;
              max-wrap = 80; # Ancho típico para texto de libros
            };

            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }
        ];
      };
    };
  };
}
