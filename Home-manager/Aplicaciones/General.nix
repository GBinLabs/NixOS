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
    # Upscaling
    upscayl
    # Inkscape
    inkscape-with-extensions
    # SVG
    svg2tikz
    # Conversor de archivos.
    morphosis
    # LibreOffice
    libreoffice
    # JabRef
    #jabref
    # Visualizador de videos.
    vlc
    # Editor de Video.
    shotcut
    # Herramientas.
    pciutils
    # Btop.
    btop
    # Piper
    piper
    # Obsidian
    obsidian
  ];
}
