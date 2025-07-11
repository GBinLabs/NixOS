{pkgs, ...}: {
  programs = {
    helix = {
      enable = true;
      defaultEditor = true;

      extraPackages = with pkgs; [
        nixd
        nixfmt-rfc-style
        alejandra
        statix
        deadnix
      ];

      settings = {
        theme = "catppuccin_mocha";

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
        };

        language = [
          {
            name = "nix";
            auto-format = true;
            formatter = {
              #command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
              command = "${pkgs.alejandra}/bin/alejandra";
              args = [];
            };
            language-servers = ["nixd"];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }
        ];
      };
    };
  };

  home = {
    sessionVariables = {
      EDITOR = "hx";
    };
  };
}
