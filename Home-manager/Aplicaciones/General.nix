{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Editor de texto.
    gnome-text-editor
    # Administrador de discos.
    gnome-disk-utility
    # Visor de documento.
    papers
    # Descompresor de archivos.
    file-roller
    # Visor de imagenes.
    eog
    # Upscaling
    upscayl
    # Inkscape
    inkscape-with-extensions
    # Conversor de archivos.
    morphosis
    # LibreOffice
    libreoffice
    # Visualizador de videos.
    vlc
    # Editor de Video.
    shotcut
    # Herramientas.
    pciutils
    # Btop.
    btop
    # Piper.
    piper
    # FastFetch.
    # Obsidian.
    obsidian
  ];
}
