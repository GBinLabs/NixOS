{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    Aplicaciones-juegos.enable = lib.mkEnableOption "Habilitar Aplicaciones-juegos";
  };

  config = lib.mkIf config.Aplicaciones-juegos.enable {
    home.packages = with pkgs; [
      # Minecraft.
      prismlauncher
      # Lutris
      lutris
    ];
  };
}
