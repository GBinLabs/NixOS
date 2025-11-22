{...}: {
  networking.networkmanager.wifi = {
    backend = "iwd";
    powersave = false;
  };
}
