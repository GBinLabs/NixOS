# Home-manager/Aplicaciones/EasyEffects/EasyEffects.nix (versión simplificada)
{ pkgs, ... }:
let
  loadPresetsScript = pkgs.writeShellScript "load-easyeffects-presets" ''
    sleep 3
    ${pkgs.easyeffects}/bin/easyeffects --load-preset "Voice"
    ${pkgs.easyeffects}/bin/easyeffects --load-preset "Audio"
  '';
in {
  home.file = {
    ".config/easyeffects/input/Voice.json".source = ./Presets/Voice.json;
    ".config/easyeffects/output/Audio.json".source = ./Presets/Audio.json;
  };

  services.easyeffects = {
    enable = true;
    preset = "Audio";  # Preset por defecto
  };

  # Script manual de recarga
  home.packages = [ (pkgs.writeShellScriptBin "ee-reload" loadPresetsScript) ];
}
