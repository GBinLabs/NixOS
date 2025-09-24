{ ... }:{

  zramSwap = {
	enable = true;
	algorithm = "zstd";
	swapDevices = 1;
	memoryPercent = 200;
	writebackDevice = null;
  };

  boot.kernel.sysctl."vm.swappiness" = 180;

}
