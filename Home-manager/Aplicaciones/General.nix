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
    # Languagetool.
    ltex-ls-plus
    # LaTeX.
    texliveFull
    # LaTeX editor.
    texstudio
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
    jabref
    # Visualizador de videos.
    vlc
    # Editor de Video.
    #shotcut
    # Herramientas.
    pciutils
    # Btop.
    btop
    # Captura de pantalla.
    grimblast
    wl-clipboard
    imagemagick
    # Mouse.
    piper
  ];
}
