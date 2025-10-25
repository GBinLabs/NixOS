_: {
  programs = {
    kitty = {
      enable = true;
      theme = "Gruvbox Dark Hard";  # ← Tema Gruvbox integrado
      
      settings = {
        confirm_os_window_close = 0;
        background_opacity = "0.66";
        scrollback_lines = 10000;
        enable_audio_bell = false;
        
        # Fuente (opcional, para que coincida con tu sistema)
        font_family = "JetBrains Mono";
        font_size = "11.0";
        
        # Mejorar renderizado con transparencia
        background_blur = 20;
      };
    };
};
}
