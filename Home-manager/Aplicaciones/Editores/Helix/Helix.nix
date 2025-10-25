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
      
      # Tema transparente personalizado
      themes = {
        gruvbox_transparent = {
          inherits = "gruvbox_dark_hard";
          "ui.background" = {};
          "ui.statusline" = { fg = "fg1"; bg = "bg1"; };
          "ui.statusline.inactive" = { fg = "fg4"; bg = "bg1"; };
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
          
          ltex-ls = {
            command = "${pkgs.ltex-ls}/bin/ltex-ls";
            config = {
              ltex = {
                language = "es";
                checkFrequency = "save";
                additionalRules = {
                  enablePickyRules = true;
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
            auto-format = true;
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
