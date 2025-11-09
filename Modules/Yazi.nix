{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      manager = {
        # Mostrar archivos ocultos por defecto
        show_hidden = false;
        # Ordenar por nombre, case-insensitive
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        # Buscar mientras escribes
        linemode = "size";
        show_symlink = true;
      };

      preview = {
        # Vistas previas optimizadas
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
        image_filter = "lanczos3";
        image_quality = 80;
        sixel_fraction = 15;
      };

      opener = {
        # Editores de texto
        edit = [
          {
            run = ''hx "$@"'';
            block = true;
            for = "unix";
          }
        ];
        # Visor de texto
        text = [
          {
            run = ''hx "$@"'';
            block = true;
          }
        ];
        # PDFs
        pdf = [
          {
            run = ''evince "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
        # Imágenes
        image = [
          {
            run = ''eog "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
        # Videos
        video = [
          {
            run = ''vlc "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
        # Archivos comprimidos
        archive = [
          {
            run = ''file-roller "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
      };

      open = {
        rules = [
          {
            name = "*/";
            use = "edit";
          }
          {
            mime = "text/*";
            use = "text";
          }
          {
            mime = "image/*";
            use = "image";
          }
          {
            mime = "video/*";
            use = "video";
          }
          {
            mime = "application/pdf";
            use = "pdf";
          }
          {
            mime = "application/*zip";
            use = "archive";
          }
          {
            mime = "application/x-tar";
            use = "archive";
          }
          {
            mime = "application/x-bzip*";
            use = "archive";
          }
          {
            mime = "application/x-7z-compressed";
            use = "archive";
          }
          {
            mime = "application/x-rar";
            use = "archive";
          }
        ];
      };

      tasks = {
        micro_workers = 5;
        macro_workers = 10;
        bizarre_retry = 5;
        image_alloc = 536870912; # 512MB
        image_bound = [2048 2048];
      };
    };

    # Atajos de teclado personalizados
    keymap = {
      manager.prepend_keymap = [
        # Navegación mejorada
        {
          on = ["k"];
          run = "arrow -1";
          desc = "Subir";
        }
        {
          on = ["j"];
          run = "arrow 1";
          desc = "Bajar";
        }
        {
          on = ["h"];
          run = "leave";
          desc = "Volver";
        }
        {
          on = ["l"];
          run = "enter";
          desc = "Entrar";
        }

        # Navegación rápida
        {
          on = ["g" "g"];
          run = "arrow -99999999";
          desc = "Ir al inicio";
        }
        {
          on = ["G"];
          run = "arrow 99999999";
          desc = "Ir al final";
        }

        # Operaciones de archivos
        {
          on = ["d" "d"];
          run = "remove";
          desc = "Mover a papelera";
        }
        {
          on = ["d" "D"];
          run = "remove --permanently";
          desc = "Eliminar permanentemente";
        }
        {
          on = ["y" "y"];
          run = "yank";
          desc = "Copiar";
        }
        {
          on = ["x" "x"];
          run = "yank --cut";
          desc = "Cortar";
        }
        {
          on = ["p" "p"];
          run = "paste";
          desc = "Pegar";
        }
        {
          on = ["p" "P"];
          run = "paste --force";
          desc = "Pegar (sobrescribir)";
        }

        # Crear archivos y directorios
        {
          on = ["a"];
          run = "create";
          desc = "Crear archivo";
        }
        {
          on = ["A"];
          run = "create --dir";
          desc = "Crear directorio";
        }
        {
          on = ["r"];
          run = "rename";
          desc = "Renombrar";
        }

        # Búsqueda y filtros
        {
          on = ["/"];
          run = "find --smart";
          desc = "Buscar";
        }
        {
          on = ["?"];
          run = "find --previous --smart";
          desc = "Buscar atrás";
        }
        {
          on = ["n"];
          run = "find_arrow";
          desc = "Siguiente resultado";
        }
        {
          on = ["N"];
          run = "find_arrow --previous";
          desc = "Resultado anterior";
        }
        {
          on = ["f"];
          run = "filter --smart";
          desc = "Filtrar";
        }

        # Selección
        {
          on = ["<Space>"];
          run = "select --state=none";
          desc = "Seleccionar/deseleccionar";
        }
        {
          on = ["v"];
          run = "visual_mode";
          desc = "Modo visual";
        }
        {
          on = ["V"];
          run = "visual_mode --unset";
          desc = "Salir modo visual";
        }

        # Ordenar
        {
          on = ["," "m"];
          run = "sort modified --dir-first";
          desc = "Ordenar por modificación";
        }
        {
          on = ["," "n"];
          run = "sort natural --dir-first";
          desc = "Ordenar por nombre";
        }
        {
          on = ["," "s"];
          run = "sort size --dir-first";
          desc = "Ordenar por tamaño";
        }

        # Vista previa
        {
          on = ["z" "h"];
          run = "hidden toggle";
          desc = "Toggle archivos ocultos";
        }

        # Abrir con aplicaciones externas
        {
          on = ["o"];
          run = "open";
          desc = "Abrir";
        }
        {
          on = ["O"];
          run = "open --interactive";
          desc = "Abrir con...";
        }
        {
          on = ["e"];
          run = ''shell 'hx "$@"' --block --confirm'';
          desc = "Editar con Helix";
        }

        # Shell
        {
          on = ["!"];
          run = "shell --block --confirm";
          desc = "Ejecutar comando";
        }
        {
          on = ["<C-s>"];
          run = ''shell "$SHELL" --block --confirm'';
          desc = "Abrir shell";
        }

        # Salir
        {
          on = ["q"];
          run = "quit";
          desc = "Salir";
        }
        {
          on = ["Q"];
          run = "quit --no-cwd-file";
          desc = "Salir sin cd";
        }
      ];
    };

    # Tema Gruvbox Dark
    theme = {
      filetype = {
        rules = [
          # Directorios
          {
            name = "*/";
            fg = "#83a598";
          }

          # Links
          {
            name = "*";
            is = "link";
            fg = "#d3869b";
          }
          {
            name = "*";
            is = "orphan";
            fg = "#fb4934";
          }

          # Código
          {
            mime = "text/x-{c,c++,python,rust,go,java,javascript,typescript}";
            fg = "#b8bb26";
          }
          {
            mime = "text/html";
            fg = "#fe8019";
          }
          {
            mime = "text/css";
            fg = "#8ec07c";
          }

          # Documentos
          {
            mime = "application/pdf";
            fg = "#fb4934";
          }
          {
            mime = "application/*office*";
            fg = "#d3869b";
          }
          {
            mime = "text/*";
            fg = "#ebdbb2";
          }

          # Multimedia
          {
            mime = "image/*";
            fg = "#d3869b";
          }
          {
            mime = "video/*";
            fg = "#fe8019";
          }
          {
            mime = "audio/*";
            fg = "#b8bb26";
          }

          # Archivos comprimidos
          {
            mime = "application/*zip";
            fg = "#fabd2f";
          }
          {
            mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
            fg = "#fabd2f";
          }

          # Default
          {
            name = "*";
            fg = "#a89984";
          }

          {
            name = "*/";
            fg = "#83a598";
          }
          {
            name = "*";
            is = "link";
            fg = "#d3869b";
          }
          {
            name = "*";
            is = "orphan";
            fg = "#fb4934";
          }
          {
            mime = "image/*";
            fg = "#d3869b";
          }
          {
            mime = "video/*";
            fg = "#fe8019";
          }
          {
            mime = "audio/*";
            fg = "#b8bb26";
          }
          {
            mime = "application/*zip";
            fg = "#fabd2f";
          }
          {
            name = "*";
            fg = "#a89984";
          }
        ];
      };

      manager = {
        cwd = {fg = "#8ec07c";};

        # Barra de estado
        hovered = {
          fg = "#282828";
          bg = "#83a598";
        };
        preview_hovered = {underline = true;};

        # Encontrar
        find_keyword = {
          fg = "#fabd2f";
          italic = true;
        };
        find_position = {
          fg = "#fe8019";
          bg = "reset";
          italic = true;
        };

        # Marcadores
        marker_selected = {
          fg = "#b8bb26";
          bg = "#b8bb26";
        };
        marker_copied = {
          fg = "#fabd2f";
          bg = "#fabd2f";
        };
        marker_cut = {
          fg = "#fb4934";
          bg = "#fb4934";
        };

        # Tabs
        tab_active = {
          fg = "#282828";
          bg = "#83a598";
        };
        tab_inactive = {
          fg = "#a89984";
          bg = "#3c3836";
        };
        tab_width = 1;

        # Selección
        selected = {fg = "#b8bb26";};
        copied = {fg = "#fabd2f";};
        cut = {fg = "#fb4934";};

        # Bordes
        border_symbol = "│";
        border_style = {fg = "#665c54";};
      };

      status = {
        separator_open = "";
        separator_close = "";
        separator_style = {
          fg = "#3c3836";
          bg = "#3c3836";
        };

        # Modo
        mode_normal = {
          fg = "#282828";
          bg = "#83a598";
          bold = true;
        };
        mode_select = {
          fg = "#282828";
          bg = "#b8bb26";
          bold = true;
        };
        mode_unset = {
          fg = "#282828";
          bg = "#a89984";
          bold = true;
        };

        # Progreso
        progress_label = {
          fg = "#ebdbb2";
          bold = true;
        };
        progress_normal = {
          fg = "#83a598";
          bg = "#3c3836";
        };
        progress_error = {
          fg = "#fb4934";
          bg = "#3c3836";
        };

        # Permisos
        permissions_t = {fg = "#b8bb26";};
        permissions_r = {fg = "#fabd2f";};
        permissions_w = {fg = "#fb4934";};
        permissions_x = {fg = "#8ec07c";};
        permissions_s = {fg = "#a89984";};
      };

      input = {
        border = {fg = "#83a598";};
        title = {};
        value = {};
        selected = {reversed = true;};
      };

      select = {
        border = {fg = "#83a598";};
        active = {fg = "#fe8019";};
        inactive = {};
      };

      tasks = {
        border = {fg = "#83a598";};
        title = {};
        hovered = {underline = true;};
      };

      which = {
        mask = {bg = "#3c3836";};
        cand = {fg = "#8ec07c";};
        rest = {fg = "#a89984";};
        desc = {fg = "#fe8019";};
        separator = "  ";
        separator_style = {fg = "#665c54";};
      };

      help = {
        on = {fg = "#fe8019";};
        exec = {fg = "#8ec07c";};
        desc = {fg = "#a89984";};
        hovered = {
          bg = "#504945";
          bold = true;
        };
        footer = {
          fg = "#3c3836";
          bg = "#a89984";
        };
      };
    };

    # Plugins útiles
    plugins = {
      # Plugin para vista previa mejorada
      previewers = pkgs.writeText "previewers.yazi" ''
        # Previewers mejorados para diferentes tipos de archivo
      '';
    };
  };

  # Paquetes adicionales para funcionalidad completa
  environment.systemPackages = with pkgs; [
    # Dependencias para vistas previas
    ffmpegthumbnailer # Videos
    unar # Archivos comprimidos
    jq # JSON
    poppler_utils # PDFs
    fd # Búsqueda rápida
    ripgrep # Grep mejorado
    fzf # Fuzzy finder
    zoxide # Navegación inteligente

    # Utilidades de terminal
    file # Detección de tipos
    mediainfo # Info de multimedia
  ];

  # Aliases útiles en Zsh
  programs.zsh.shellAliases = {
    # Yazi con cd al salir
    y = "yazi";
    # Función para cd automático
  };

  # Script para cd automático al salir de Yazi
  programs.zsh.initExtra = ''
    # Función yazi con cd automático
    function yy() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
      fi
      rm -f -- "$tmp"
    }
  '';

  # Integración con Kitty para mejores imágenes
  programs.kitty.settings = {
    allow_remote_control = "yes";
    listen_on = "unix:/tmp/kitty";
  };
}
