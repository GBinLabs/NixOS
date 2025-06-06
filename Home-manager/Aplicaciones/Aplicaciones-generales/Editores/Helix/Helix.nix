{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "onedarker_transparent";
      editor = {
        # Configuración del cursor
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
    };
    # Tema personalizado
    themes = {
      onedarker_transparent = {
        "inherits" = "onedarker";
        "ui.background" = { };
        "ui.background.separator" = { };
        "ui.statusline" = {
          bg = "background";
        };
        "ui.statusline.inactive" = {
          bg = "background";
        };
        "ui.popup" = {
          bg = "background";
        };
        "ui.help" = {
          bg = "background";
        };
        "ui.menu" = {
          bg = "background";
        };
        "ui.window" = {
          bg = "background";
        };
        "ui.text" = {
          fg = "foreground";
        };
      };
    };

    # Configuración de lenguajes
    languages = {
      # Servidores de lenguaje
      language-server = {
        # Nix Language Server
        nixd = {
          command = "nixd";
          config = {
            nixpkgs = {
              expr = "import <nixpkgs> { }";
            };
            formatting = {
              command = [ "nixfmt-rfc-style" ];
            };
            options = {
              nixos = {
                expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.HOSTNAME.options";
              };
              home-manager = {
                expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.USERNAME.options";
              };
            };
            diagnostic = {
              suppress = [ "sema-escaping-with" ];
            };
          };
        };
      };

      # Definición de lenguajes
      language = [
        # Configuración para Nix
        {
          name = "nix";
          scope = "source.nix";
          injection-regex = "nix";
          file-types = [ "nix" ];
          shebangs = [ ];
          comment-token = "#";
          language-servers = [ "nixd" ];
          auto-format = true;
          formatter = {
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt-rfc-style";
            args = [ ];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          roots = [
            "flake.nix"
            "shell.nix"
            "default.nix"
          ];
        }
      ];
    };
  };

  # Paquetes necesarios
  home.packages = with pkgs; [
    # Herramientas para Nix
    nixd
    nixfmt-rfc-style
  ];

  # Configuración adicional de shell para comandos útiles
  home.shellAliases = {
    # Aliases para Nix
    nix-fmt = "nixfmt-rfc-style";
    nix-check = "nix flake check";
    nix-update = "nix flake update";

    # Aliases para Helix
    hx = "helix";
    edit = "helix";
  };
}
