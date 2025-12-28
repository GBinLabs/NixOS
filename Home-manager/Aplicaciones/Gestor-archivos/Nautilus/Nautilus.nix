{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      mgr = {
        ratio = [1 4 3];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = false;
        show_symlink = true;
      };

      preview = {
        image_filter = "lanczos3";
        image_quality = 90;
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
        ueberzug_scale = 1;
        ueberzug_offset = [0 0 0 0];
      };

      tasks = {
        micro_workers = 5;
        macro_workers = 10;
        bizarre_retry = 5;
      };

      opener = {
        edit = [
          {run = ''hx "$@"''; block = true; for = "unix";}
        ];
        open = [
          {run = ''xdg-open "$@"''; desc = "Abrir";}
        ];
        extract = [
          {run = ''7z x -o"$1" "$0"''; desc = "Extraer aquí";}
        ];
      };

      open = {
        rules = [
          {name = "*/"; use = ["edit" "open"];}
          {mime = "text/*"; use = ["edit"];}
          {mime = "image/*"; use = ["open"];}
          {mime = "video/*"; use = ["open"];}
          {mime = "audio/*"; use = ["open"];}
          {mime = "application/pdf"; use = ["open"];}
          {mime = "application/zip"; use = ["extract"];}
          {mime = "application/gzip"; use = ["extract"];}
          {mime = "application/x-tar"; use = ["extract"];}
          {mime = "application/x-7z-compressed"; use = ["extract"];}
          {mime = "application/x-rar"; use = ["extract"];}
          {mime = "*"; use = ["open"];}
        ];
      };
    };

    keymap = {
      mgr.keymap = [
        {on = ["<Esc>"]; run = "escape"; desc = "Salir del modo visual";}
        {on = ["q"]; run = "quit"; desc = "Salir";}
        {on = ["Q"]; run = "quit --no-cwd-file"; desc = "Salir sin cambiar directorio";}
        {on = ["<C-q>"]; run = "close"; desc = "Cerrar pestaña";}

        # Navegación
        {on = ["k"]; run = "arrow -1"; desc = "Arriba";}
        {on = ["j"]; run = "arrow 1"; desc = "Abajo";}
        {on = ["K"]; run = "arrow -5"; desc = "Arriba x5";}
        {on = ["J"]; run = "arrow 5"; desc = "Abajo x5";}
        {on = ["h"]; run = "leave"; desc = "Directorio padre";}
        {on = ["l"]; run = "enter"; desc = "Entrar";}
        {on = ["<Up>"]; run = "arrow -1"; desc = "Arriba";}
        {on = ["<Down>"]; run = "arrow 1"; desc = "Abajo";}
        {on = ["<Left>"]; run = "leave"; desc = "Directorio padre";}
        {on = ["<Right>"]; run = "enter"; desc = "Entrar";}
        {on = ["g" "g"]; run = "arrow -99999999"; desc = "Inicio";}
        {on = ["G"]; run = "arrow 99999999"; desc = "Final";}
        {on = ["H"]; run = "back"; desc = "Historial atrás";}
        {on = ["L"]; run = "forward"; desc = "Historial adelante";}

        # Selección
        {on = ["<Space>"]; run = ["select --state=none" "arrow 1"]; desc = "Seleccionar";}
        {on = ["v"]; run = "visual_mode"; desc = "Modo visual";}
        {on = ["V"]; run = "visual_mode --unset"; desc = "Salir modo visual";}
        {on = ["<C-a>"]; run = "select_all --state=true"; desc = "Seleccionar todo";}
        {on = ["<C-r>"]; run = "select_all --state=none"; desc = "Invertir selección";}

        # Operaciones
        {on = ["o"]; run = "open"; desc = "Abrir";}
        {on = ["O"]; run = "open --interactive"; desc = "Abrir con...";}
        {on = ["<Enter>"]; run = "open"; desc = "Abrir";}
        {on = ["y"]; run = "yank"; desc = "Copiar";}
        {on = ["x"]; run = "yank --cut"; desc = "Cortar";}
        {on = ["p"]; run = "paste"; desc = "Pegar";}
        {on = ["P"]; run = "paste --force"; desc = "Pegar (sobrescribir)";}
        {on = ["d"]; run = "remove"; desc = "Mover a papelera";}
        {on = ["D"]; run = "remove --permanently"; desc = "Eliminar permanente";}
        {on = ["a"]; run = "create"; desc = "Crear archivo/directorio";}
        {on = ["r"]; run = "rename --cursor=before_ext"; desc = "Renombrar";}

        # Búsqueda y filtro
        {on = ["/"]; run = "find --smart"; desc = "Buscar";}
        {on = ["?"]; run = "find --previous --smart"; desc = "Buscar anterior";}
        {on = ["n"]; run = "find_arrow"; desc = "Siguiente resultado";}
        {on = ["N"]; run = "find_arrow --previous"; desc = "Resultado anterior";}
        {on = ["f"]; run = "filter --smart"; desc = "Filtrar";}

        # Ordenamiento
        {on = ["," "m"]; run = "sort modified --dir-first"; desc = "Ordenar por fecha";}
        {on = ["," "M"]; run = "sort modified --reverse --dir-first"; desc = "Ordenar por fecha (inv)";}
        {on = ["," "n"]; run = "sort natural --dir-first"; desc = "Ordenar natural";}
        {on = ["," "N"]; run = "sort natural --reverse --dir-first"; desc = "Ordenar natural (inv)";}
        {on = ["," "s"]; run = "sort size --dir-first"; desc = "Ordenar por tamaño";}
        {on = ["," "S"]; run = "sort size --reverse --dir-first"; desc = "Ordenar por tamaño (inv)";}

        # Pestañas
        {on = ["t"]; run = "tab_create --current"; desc = "Nueva pestaña";}
        {on = ["1"]; run = "tab_switch 0"; desc = "Pestaña 1";}
        {on = ["2"]; run = "tab_switch 1"; desc = "Pestaña 2";}
        {on = ["3"]; run = "tab_switch 2"; desc = "Pestaña 3";}
        {on = ["4"]; run = "tab_switch 3"; desc = "Pestaña 4";}
        {on = ["["]; run = "tab_switch -1 --relative"; desc = "Pestaña anterior";}
        {on = ["]"]; run = "tab_switch 1 --relative"; desc = "Pestaña siguiente";}

        # Atajos de directorio
        {on = ["g" "h"]; run = "cd ~"; desc = "Ir a home";}
        {on = ["g" "d"]; run = "cd ~/Descargas"; desc = "Ir a Descargas";}
        {on = ["g" "D"]; run = "cd ~/Documentos"; desc = "Ir a Documentos";}
        {on = ["g" "c"]; run = "cd ~/.config"; desc = "Ir a .config";}
        {on = ["g" "n"]; run = "cd ~/.GitHub"; desc = "Ir a GitHub";}

        # Varios
        {on = ["."]; run = "hidden toggle"; desc = "Mostrar ocultos";}
        {on = ["z"]; run = "plugin fzf"; desc = "Búsqueda fzf";}
        {on = ["<C-s>"]; run = "shell \"$SHELL\" --block --confirm"; desc = "Abrir shell";}
        {on = ["~"]; run = "help"; desc = "Ayuda";}
      ];
    };

    theme = {
      mgr = {
        cwd = {fg = "#83a598";};
        hovered = {fg = "#282828"; bg = "#83a598";};
        preview_hovered = {underline = true;};
        find_keyword = {fg = "#fabd2f"; italic = true;};
        find_position = {fg = "#fe8019"; bg = "reset"; italic = true;};
        marker_selected = {fg = "#b8bb26"; bg = "#b8bb26";};
        marker_copied = {fg = "#fabd2f"; bg = "#fabd2f";};
        marker_cut = {fg = "#fb4934"; bg = "#fb4934";};
        tab_active = {fg = "#282828"; bg = "#504945";};
        tab_inactive = {fg = "#a89984"; bg = "#3c3836";};
        border_symbol = "│";
        border_style = {fg = "#665c54";};
      };

      status = {
        separator_open = "";
        separator_close = "";
        separator_style = {fg = "#3c3836"; bg = "#3c3836";};
        mode_normal = {fg = "#282828"; bg = "#a89984"; bold = true;};
        mode_select = {fg = "#282828"; bg = "#b8bb26"; bold = true;};
        mode_unset = {fg = "#282828"; bg = "#d3869b"; bold = true;};
        progress_label = {fg = "#ebdbb2"; bold = true;};
        progress_normal = {fg = "#3c3836"; bg = "#504945";};
        progress_error = {fg = "#fb4934"; bg = "#504945";};
        permissions_t = {fg = "#83a598";};
        permissions_r = {fg = "#fabd2f";};
        permissions_w = {fg = "#fb4934";};
        permissions_x = {fg = "#b8bb26";};
        permissions_s = {fg = "#665c54";};
      };

      filetype = {
        rules = [
          {mime = "image/*"; fg = "#d3869b";}
          {mime = "video/*"; fg = "#fabd2f";}
          {mime = "audio/*"; fg = "#fabd2f";}
          {mime = "application/zip"; fg = "#fb4934";}
          {mime = "application/gzip"; fg = "#fb4934";}
          {mime = "application/x-tar"; fg = "#fb4934";}
          {mime = "application/x-7z-compressed"; fg = "#fb4934";}
          {mime = "application/pdf"; fg = "#fb4934";}
          {mime = "text/*"; fg = "#b8bb26";}
          {name = "*.nix"; fg = "#83a598";}
          {name = "*.typ"; fg = "#8ec07c";}
          {name = "*.md"; fg = "#ebdbb2";}
        ];
      };
    };
  };

  home.packages = with pkgs; [
    p7zip
    fzf
    ripgrep
    file
    ffmpegthumbnailer
    poppler
  ];
}
