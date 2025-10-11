_: {
  programs = {
    mangohud = {
      enable = true;
      settings = {
        legacy_layout = true;
        background_alpha = 0.6;
        background_color = "000000";
        round_corners = 1;
        font_size = 20;
        text_color = "FFFFFF";
        position = "top-right";
        pci_dev = "0:2b:00.0";
        table_columns = 3;
        gpu_text = "GPU";
        gpu_stats = true;
        gpu_temp = true;
        gpu_color = "2E9762";
        cpu_text = "CPU";
        cpu_stats = true;
        cpu_temp = true;
        cpu_color = "2E97CB";
        vram = true;
        vram_color = "AD64C1";
        ram = true;
        ram_color = "C26693";
        battery = false;
        fps = true;
        fps_metrics = "avg 0.01";
        percentiles = true;
        engine_version = true;
        engine_color = "EB5B5B";
        arch = true;
        display_server = true;
        resolution = true;
        vulkan_driver = true;
        wine = true;
        wine_color = "EB5B5B";
        frame_timing = true;
        frametime_color = "00FF00";
        fps_limit_method = "late";
        show_fps_limit = true;
        fps_limit = 165;
        gamemode = true;
        vsync = true;
        gl_vsync = false;
        blacklist = "pamac-manager lact ghb bitwig-studio ptyxis yumex";
      };
      enableSessionWide = false;
    };
  };
}
