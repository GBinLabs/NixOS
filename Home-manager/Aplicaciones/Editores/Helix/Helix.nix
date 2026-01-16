{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      # Nix
      nixd
      nixfmt
      # LaTeX
      texlab
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
        nixd.command = "nixd";

        texlab = {
          command = "texlab";
          config.texlab = {
            build = {
              executable = "latexmk";
              args = [
                "-pdf"
                "-interaction=nonstopmode"
                "-synctex=1"
                "%f"
              ];
              onSave = true;
              forwardSearchAfter = false;
            };
            forwardSearch = {
              executable = "zathura";
              args = [
                "--synctex-forward"
                "%l:1:%f"
                "%p"
              ];
            };
            chktex = {
              onOpenAndSave = true;
              onEdit = false;
            };
            diagnosticsDelay = 300;
            latexFormatter = "latexindent";
            latexindent = {
              modifyLineBreaks = true;
            };
          };
        };

        ltex-ls-plus = {
          command = "ltex-ls-plus";
          config.ltex = {
            language = "es-AR";
            additionalRules = {
              motherTongue = "es-AR";
              enablePickyRules = true;
            };
            completionEnabled = true;
            dictionary = {
              "es-AR" = [ ];
              "en-GB" = [ ];
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
          name = "latex";
          language-servers = [
            "texlab"
            "ltex-ls-plus"
          ];
          auto-format = true;
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
          name = "bibtex";
          language-servers = [ "texlab" ];
          auto-format = true;
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
