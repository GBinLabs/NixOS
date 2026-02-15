{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nixfmt
    texliveFull
    texlab
    pdf2svg
    ghostscript
    typos-lsp
  ];

  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;

    extensions = [
      "nix"
      "latex"
      "toml"
      "json"
      "typos"
      "git-firefly"
      "ltex"
    ];

    userSettings = {
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      # Tema - usar el nombre exacto generado por Noctalia
      theme = {
        mode = "dark";
        dark = "Noctalia dark transparent";
        light = "Noctalia light";
      };

      experimental = {
        theme_overrides = {
          "background" = "#00000000";
          "editor.background" = "#00000000";
          "background.appearance" = "transparent";
        };
      };

      ui_font_size = 14;
      ui_font_family = "Inter";
      buffer_font_size = 14;
      buffer_font_family = "JetBrains Mono";
      buffer_font_features = {
        calt = true;
        liga = true;
      };

      tab_size = 2;
      hard_tabs = false;
      show_whitespaces = "boundary";
      wrap_guides = [
        80
        100
      ];
      soft_wrap = "editor_width";
      preferred_line_length = 100;
      format_on_save = "on";
      cursor_blink = false;

      scrollbar = {
        show = "auto";
      };

      gutter = {
        line_numbers = true;
        code_actions = true;
        folds = true;
      };

      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };

      inlay_hints = {
        enabled = true;
      };

      autosave = "off";

      toolbar = {
        breadcrumbs = true;
        quick_actions = true;
        selections_menu = true;
      };

      tabs = {
        close_position = "right";
        file_icons = true;
        git_status = true;
      };

      project_panel = {
        dock = "left";
        git_status = true;
      };

      git = {
        git_gutter = "tracked_files";
        inline_blame = {
          enabled = true;
        };
      };

      terminal = {
        shell = {
          program = "zsh";
        };
        font_family = "JetBrains Mono";
        font_size = 14;
      };

      file_scan_exclusions = [
        "**/.git"
        "**/node_modules"
        "**/result"
        "**/*.aux"
        "**/*.bbl"
        "**/*.blg"
        "**/*.fdb_latexmk"
        "**/*.fls"
        "**/*.log"
        "**/*.out"
        "**/*.synctex.gz"
        "**/*.toc"
      ];

      # IA desactivada
      features = {
        edit_prediction_provider = "none";
      };

      agent = {
        enabled = false;
      };

      hour_format = "hour24";

      languages = {
        Nix = {
          language_servers = [ "nixd" ];
          formatter = {
            external = {
              command = "nixfmt";
              arguments = [ ];
            };
          };
          tab_size = 2;
          format_on_save = "on";
        };
        LaTeX = {
          language_servers = [
            "texlab"
            "ltex"
          ];
          tab_size = 2;
          soft_wrap = "editor_width";
          format_on_save = "off";
        };
        Markdown = {
          language_servers = [ "ltex" ];
        };
        BibTeX = {
          language_servers = [ "ltex" ];
        };
      };

      lsp = {
        nixd = {
          binary = {
            path_lookup = true;
          };
        };
        texlab = {
          binary = {
            path_lookup = true;
          };
          settings = {
            texlab = {
              build = {
                onSave = true;
                forwardSearchAfter = true;
              };
              chktex = {
                onOpenAndSave = true;
              };
            };
          };
        };
        typos = {
          binary = {
            path_lookup = true;
          };
        };
        ltex = {
          settings = {
            ltex = {
              language = "es-AR";
              additionalRules = {
                motherTongue = "es-AR";
                enablePickyRules = true;
              };
              completionEnabled = true;
              diagnosticSeverity = "information";
            };
          };
        };
      };
    };
  };
}
