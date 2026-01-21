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
      
      # Grammar checking (ES + EN)
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
        
        # Configuración CORREGIDA de ltex-ls-plus
        ltex-ls-plus = {
          command = "ltex-ls-plus";
          timeout = 30;
          config.ltex = {
            # QUITADO: enabled = ["typst" "markdown"]; - No es necesario
            language = "es-AR";
            motherTongue = "es-AR";
            enablePickyRules = true;
            completionEnabled = true;
            
            dictionary = {
              "es-AR" = [ ];
              "en-GB" = [ ];
            };
            
            # Opcional: deshabilitar reglas específicas
            # disabledRules = {
            #   "es-AR" = [ "PROFANITY" ];
            #   "en-GB" = [ "PROFANITY" ];
            # };
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
            "ltex-ls-plus"  # Asignado correctamente al lenguaje
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
          language-servers = [ "ltex-ls-plus" ];  # También habilitado para markdown
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
