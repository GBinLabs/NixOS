{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      # Languagetool.
      ltex-ls-plus
      # LaTeX.
      texliveFull
      # LaTeX editor.
      texstudio
      # GIMP.
      #gimp
      # Conversor de archivos.
      morphosis
      # Editores de video.
      shotcut
      # LibreOffice
      libreoffice
      # JabRef
      jabref
    ];
  };
}
