{pkgs, ...}: {
  home.packages = with pkgs; [
    # Languagetool.
    ltex-ls-plus # Mozilla Public License 2.0
    # LaTeX.
    texliveFull # Muchas licencias
    # LaTeX editor.
    texstudio # GNU GPL v2.0 or Later
    # GIMP.
    gimp # GNU GPL v3.0 or Later
    # Conversor de archivos.
    morphosis # GNU GPL v3.0
    # Editores de video.
    shotcut # GNU GPL v3.0 or Later
    # LibreOffice
    libreoffice # GNU LGPL v3.0 or Later
    # JabRef
    jabref
  ];
}
