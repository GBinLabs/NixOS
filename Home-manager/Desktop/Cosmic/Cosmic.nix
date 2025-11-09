{
  config,
  lib,
  pkgs,
  ...
}: {
  
  home.packages = with pkgs; [
    cosmic-files
    cosmic-edit
    evince
    eog
  ];

  # Configuración de idioma y región (igual que en Gnome)
  home.language = {
    base = "es_AR.UTF-8";
  };

  # Wallpapers
  home.file."Imágenes/Wallpapers/Astronauta1.png".source = ./Wallpapers/Astronauta1.png;
  home.file."Imágenes/Wallpapers/Astronauta2.png".source = ./Wallpapers/Astronauta2.png;

  # Configuración del cursor (compatible con Cosmic)
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 20;
  };

  # GTK settings para aplicaciones GTK que aún uses
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    font = {
      name = "Inter";
      size = 11;
    };
  };
  
  programs = {
    cosmic-applibrary = {
        enable = true;
        package = pkgs.cosmic-applibrary;
        settings = {
          groups = [
            {
                filter = cosmicLib.cosmic.mkRON "namedStruct" {
                    name = "Categories";
                    value = {
                        categories = [
                            "Office"
                        ];
                        exclude = [ ];
                        include = [ 
                        ];
                    };
                };
                icon = "folder-symbolic";
                name = "cosmic-office";
            }
       ];  
   };
   };
    cosmic-edit = {
        enable = true;
        package = pkgs.cosmic-edit;
        settings = {
  app_theme = cosmicLib.cosmic.mkRON "enum" "System";
  auto_indent = true;
  find_case_sensitive = false;
  find_use_regex = false;
  find_wrap_around = true;
  font_name = "Fira Mono";
  font_size = 16;
  highlight_current_line = true;
  line_numbers = true;
  syntax_theme_dark = "COSMIC Dark";
  syntax_theme_light = "COSMIC Light";
  tab_width = 2;
  vim_bindings = true;
    word_wrap = true;
        };
    
    };
   cosmic-ext-calculator = {
    enable = false;
   };
   cosmic-ext-ctl = {
    enable = true;
    package = pkgs.cosmic-ext-ctl; 
   };
   cosmic-ext-tweaks = {
    enable = false;
   };
   cosmic-files = {
    enable = true;
    package = pkgs.cosmic-files;
    settings = {
  app_theme = cosmicLib.cosmic.mkRON "enum" "System";
  desktop = {
    show_content = true;
    show_mounted_drives = true;
    show_trash = true;
  };
  favorites = [
    (cosmicLib.cosmic.mkRON "enum" "Home")
    (cosmicLib.cosmic.mkRON "enum" "Downloads")
    (cosmicLib.cosmic.mkRON "enum" "Documents")
    (cosmicLib.cosmic.mkRON "enum" "Music")
    (cosmicLib.cosmic.mkRON "enum" "Pictures")
    (cosmicLib.cosmic.mkRON "enum" "Videos")
    (cosmicLib.cosmic.mkRON "enum" {
      value = [
        "/home/user/Projects"
      ];
      variant = "Path";
    })
  ];
  show_details = false;
  tab = {
    folders_first = true;
    icon_sizes = {
      grid = 100;
      list = 100;
    };
    show_hidden = false;
    view = cosmicLib.cosmic.mkRON "enum" "List";
  };
};

   };
   cosmic-manager = {
    enable = true;
   };
   cosmic-player = {
    enable = false;
   };
   cosmic-store = {
    enable = false;
   };
   cosmic-term = {
    enable = true;
    package = pkgs.cosmic-term;
    colorSchemes = [
  {
    bright = {
      black = "#585B70";
      blue = "#89B4FA";
      cyan = "#94E2D5";
      green = "#A6E3A1";
      magenta = "#F5C2E7";
      red = "#F38BA8";
      white = "#A6ADC8";
      yellow = "#F9E2AF";
    };
    bright_foreground = "#CDD6F4";
    cursor = "#F5E0DC";
    dim = {
      black = "#45475A";
      blue = "#89B4FA";
      cyan = "#94E2D5";
      green = "#A6E3A1";
      magenta = "#F5C2E7";
      red = "#F38BA8";
      white = "#BAC2DE";
      yellow = "#F9E2AF";
    };
    dim_foreground = "#6C7086";
    foreground = "#CDD6F4";
    mode = "dark";
    name = "Catppuccin Mocha";
    normal = {
      black = "#45475A";
      blue = "#89B4FA";
      cyan = "#94E2D5";
      green = "#A6E3A1";
      magenta = "#F5C2E7";
      red = "#F38BA8";
      white = "#BAC2DE";
      yellow = "#F9E2AF";
    };
  }
];
  profiles = [
  {
    command = "bash";
    hold = false;
    is_default = true;
    name = "Default";
    syntax_theme_dark = "COSMIC Dark";
    syntax_theme_light = "COSMIC Light";
    tab_title = "Default";
    working_directory = "/home/user";
  }
  {
    command = "bash";
    hold = false;
    is_default = false;
    name = "New Profile";
    syntax_theme_dark = "Catppuccin Mocha";
    syntax_theme_light = "Catppuccin Latte";
    tab_title = "New Profile";
  }
];
settings = {
  app_theme = cosmicLib.cosmic.mkRON "enum" "Dark";
  bold_font_weight = 700;
  dim_font_weight = 300;
  focus_follows_mouse = true;
  font_name = "JetBrains Mono";
  font_size = 12;
  font_size_zoom_step_mul_100 = 100;
  font_stretch = 100;
  font_weight = 400;
  opacity = 100;
  show_headerbar = true;
  use_bright_bold = true;
};
};
    forecast = {
        enable = false;
    };
    tasks = {
        enable = true;
        package = pkgs.tasks;
        settings = {
  app_theme = cosmicLib.cosmic.mkRON "enum" "System";
};


    };
  };
  
  wayland = {
    desktopManager = {
        cosmic = {
            enable = true;
            appearance = {
                theme = {
                    dark = {
                        accent = cosmicLib.cosmic.mkRON "optional" {
  blue = 0.0;
  green = 0.0;
  red = 0.0;
};
active_hint = 3;
bg_color = cosmicLib.cosmic.mkRON "optional" {
  alpha = 1.0;
  blue = 0.0;
  green = 0.0;
  red = 0.0;
};
corner_radii = {
  radius_0 = cosmicLib.cosmic.mkRON "tuple" [
    0.0
    0.0
    0.0
    0.0
  ];
  radius_l = cosmicLib.cosmic.mkRON "tuple" [
    32.0
    32.0
    32.0
    32.0
  ];
  radius_m = cosmicLib.cosmic.mkRON "tuple" [
    16.0
    16.0
    16.0
    16.0
  ];
  radius_s = cosmicLib.cosmic.mkRON "tuple" [
    8.0
    8.0
    8.0
    8.0
  ];
  radius_xl = cosmicLib.cosmic.mkRON "tuple" [
    160.0
    160.0
    160.0
    160.0
  ];
  radius_xs = cosmicLib.cosmic.mkRON "tuple" [
    4.0
    4.0
    4.0
    4.0
  ];
};



                    };
                };
            };
            
        
        
        
        
        
        
        
        
        
        
        compositor = {
            xkb_config = {
  layout = "latam";
  model = "pc104";
  options = cosmicLib.cosmic.mkRON "optional" "terminate:ctrl_alt_bksp";
  repeat_delay = 600;
  repeat_rate = 25;
  rules = "";
  variant = "";
};

        };
        };
    };
  };
}
