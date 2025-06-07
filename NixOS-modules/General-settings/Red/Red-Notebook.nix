{
  config,
  lib,
  ...
}: {
  options = {
    Red-Notebook.enable = lib.mkEnableOption "Habilitar Red-Notebook";
  };

  config = lib.mkIf config.Red-Notebook.enable {
    networking = {
      hostName = "Bin-Notebook";
      networkmanager.enable = true;
    };
    #boot = {
      #kernelModules = ["wl"];
      #extraModulePackages = with config.boot.kernelPackages; [broadcom_sta];
    #};
  };
}
