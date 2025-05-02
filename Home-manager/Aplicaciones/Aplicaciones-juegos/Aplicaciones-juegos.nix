{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    Aplicaciones-juegos.enable = lib.mkEnableOption "Habilitar Aplicaciones-juegos";
  };

  config = lib.mkIf config.Aplicaciones-juegos.enable {
    home.packages = with pkgs; [
      # Estadisticas.
      mangohud # MIT
      goverlay # GNU GPL v3.0 or Later
      # Minecraft.
      prismlauncher
    ];
  };
}
