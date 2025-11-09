{pkgs, lib, ...}: {
  programs = {
    helix = {
      enable = true;
      #defaultEditor = true;
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
        ltex-ls
      ];

      settings = {
        theme = "gruvbox_transparent";

        editor = {
          terminal = "kitty";
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

      # Tema transparente personalizado mejorado
      themes = {
        gruvbox_transparent = {
          inherits = "gruvbox_dark_hard";
          "ui.background" = {};
          "ui.statusline" = {
            fg = "fg1";
            bg = "bg1";
          };
          "ui.statusline.inactive" = {
            fg = "fg4";
            bg = "bg1";
          };
          "ui.bufferline" = {
            fg = "fg2";
            bg = "bg0";
          };
          "ui.bufferline.active" = {
            fg = "orange";
            bg = "bg1";
            modifiers = ["bold"];
          };
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
          ltex-ls = {
            command = "${pkgs.ltex-ls}/bin/ltex-ls";
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
  programs.helix.extraConfig = lib.mkForce "";

  
  # ==== CREAR TU ÚNICO LANZADOR MANUAL ====
  # El nombre "helix" aquí creará el archivo ~/.local/share/applications/helix.desktop
  xdg.desktopEntries.helix = {
    name = "Helix";
    genericName = "Text Editor";
    comment = "A post-modern modal text editor";
    exec = "${pkgs.kitty}/bin/kitty --class helix-editor ${pkgs.helix}/bin/hx %F";
    icon = "helix";
    terminal = false;  # <--- CRUCIAL: Kitty ya es el terminal
    categories = [ "Development" "TextEditor" ];
    startupNotify = true;
    #mimeTypes = [
     # "text/plain"
     # "text/x-nix"
     # "text/x-typst"
     # "text/markdown"
     # "application/x-shellscript"
     # "text/x-diff"
    #];
  };

  # ==== ASOCIAR ARCHIVOS A HELIX.DESKTOP ====
  xdg.mimeApps.defaultApplications = {
    "text/plain" = "helix.desktop";
    "text/x-nix" = "helix.desktop";
    "text/x-typst" = "helix.desktop";
    "text/markdown" = "helix.desktop";
    "application/x-shellscript" = "helix.desktop";
  };

  ## ==== ACTUALIZAR CACHE MIME (corrección del error 'hm') ====
  #home.activation.updateMime = lib.dag.entryAfter ["writeBoundary"] ''
   # ${pkgs.shared-mime-info}/bin/update-mime-database ~/.local/share/mime
  #'';
}
