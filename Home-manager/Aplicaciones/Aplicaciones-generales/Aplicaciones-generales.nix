{pkgs, ...}: {
  home.packages = with pkgs; [
    # Estadisticas de almacenamiento.
    baobab
    # Editor de texto.
    gnome-text-editor
    # Administrador de discos.
    gnome-disk-utility
    # Descompresor de archivos.
    file-roller
    # Visor de documento.
    evince
    # Visor de imagenes.
    eog
    # Visualizador de videos.
    vlc
    # Herramientas.
    pciutils
    # Mouse.
    piper
    # Discord.
    discord
  ];
}
