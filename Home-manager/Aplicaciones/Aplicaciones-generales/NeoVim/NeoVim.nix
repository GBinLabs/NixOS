{pkgs, ...}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        languages = {
          enableLSP = true; # habilita cliente LSP de Neovim
          enableFormat = true; # integra formateo (via LSP/null-ls)
          enableTreesitter = true; # resaltado de sintaxis con Tree-sitter
          enableExtraDiagnostics = true; # habilita linters/diagnósticos extra

          nix = {
            enable = true;
            extraDiagnostics = {
              enable = true;
              types = [
                "statix"
                "deadnix"
              ];
            };
            format = {
              enable = true;
              package = pkgs.alejandra;
              type = "alejandra";
            };
            lsp = {
              enable = true;
              package = pkgs.nixd;
              #options = ;
              server = "nixd";
            };
            treesitter = {
              enable = true;
              package = pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix;
            };
          };

          python = {
            enable = true;
            dap = {
              enable = true;
              package = with pkgs; python312.withPackages (ps: with ps; [debugpy]);
              debugger = "debugpy";
            };
            format = {
              enable = true;
              package = pkgs.black;
              type = "black";
            };
            lsp = {
              enable = true;
              package = pkgs.basedpyright;
              server = "basedpyright";
            };
            treesitter = {
              enable = true;
              package = pkgs.vimPlugins.nvim-treesitter-parsers.python;
            };
          };

          #r.enable = true;
          #markdown.enable = true;
          #html.enable = true;
        };
        lsp = {
          formatOnSave = true; # formateo automático al guardar
        };

        theme = {
          enable = true;
          name = "rose-pine"; # Tema de colores atractivo (Catppuccin)
          style = "moon"; # Estilo del tema (por ej. "mocha")
          transparent = true;
        };

        statusline.lualine = {
          enable = true;
          globalStatus = true;
          icons = {
            enable = true;
          };
          refresh = {
            statusline = 1000;
            tabline = 1000;
            winbar = 1000;
          };
          theme = "moonfly";
        };

        visuals = {
          nvim-web-devicons = {
            enable = true;
          };
          fidget-nvim = {
            enable = true;
          };
        };
        binds.whichKey = {
          enable = true;
          #register = ;
        };
        filetree.neo-tree = {
          enable = true;
        };

        autocomplete = {
          nvim-cmp = {
            enable = true;
            #format = ;
          };
        };
        snippets.luasnip = {
          enable = true;
        };
        autopairs = {
          nvim-autopairs = {
            enable = true;
          };
        };

        debugger = {
          nvim-dap = {
            enable = true;
          };
        };
      };
    };
  };
}
