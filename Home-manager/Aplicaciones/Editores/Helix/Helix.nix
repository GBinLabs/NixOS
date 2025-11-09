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
        ltex-ls
      ];
      
      settings = {
        theme = "gruvbox_transparent";
        
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
      
      # Tema transparente personalizado mejorado
      themes = {
        gruvbox_transparent = {
          inherits = "gruvbox_dark_hard";
          "ui.background" = {};
          "ui.statusline" = { fg = "fg1"; bg = "bg1"; };
          "ui.statusline.inactive" = { fg = "fg4"; bg = "bg1"; };
          "ui.bufferline" = { fg = "fg2"; bg = "bg0"; };
          "ui.bufferline.active" = { fg = "orange"; bg = "bg1"; modifiers = ["bold"]; };
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
                language = "es";  # Idioma principal
                enabled = ["es" "en-US"];  # Ambos idiomas habilitados
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
              max-wrap = 80;  # Ancho típico para texto de libros
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

  # Launcher personalizado de Helix que usa Kitty
  xdg.desktopEntries = {
    helix = {
      name = "Helix";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "${pkgs.kitty}/bin/kitty ${pkgs.helix}/bin/hx %F";
      icon = "utilities-terminal";
      terminal = false;
      type = "Application";
      categories = ["Utility" "TextEditor"];
      mimeType = [
        "text/plain"
        "text/x-nix"
        "text/x-typst"
        "application/x-typst"
        "text/markdown"
      ];
    };
  };

  # Ocultar el launcher automático que crea NixOS
  xdg.dataFile."applications/hx.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=hx
    Hidden=true
    NoDisplay=true
  '';

  # Registrar tipo MIME de Typst
  xdg.configFile."mime/packages/typst.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
      <mime-type type="text/x-typst">
        <comment>Typst document</comment>
        <glob pattern="*.typ"/>
        <sub-class-of type="text/plain"/>
      </mime-type>
    </mime-info>
  '';

  # Asociaciones MIME
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = "helix.desktop";
      "text/x-nix" = "helix.desktop";
      "text/x-typst" = "helix.desktop";
      "application/x-typst" = "helix.desktop";
      "text/markdown" = "helix.desktop";
    };
  };

  # Variables de entorno
  home = {
    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      TERMINAL = "${pkgs.kitty}/bin/kitty";
    };
  };

  # Configuración de Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      env = [
        "TERMINAL,kitty"
      ];
      
      windowrulev2 = [
        "float,class:^(kitty)$,title:^(hx)"
        "size 85% 85%,class:^(kitty)$,title:^(hx)"
        "center,class:^(kitty)$,title:^(hx)"
      ];
    };
  };
}
