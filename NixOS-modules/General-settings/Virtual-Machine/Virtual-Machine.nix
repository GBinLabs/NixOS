{pkgs, ...}: {
  # Configuración de virtualización
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore"; # No iniciar VMs automáticamente al arrancar
      onShutdown = "shutdown"; # Apagar VMs correctamente al apagar
      qemu = {
        package = pkgs.qemu;
        runAsRoot = true;
        ovmf.enable = true;
        swtpm.enable = true; # Habilitar TPM virtual
      };
    };
  };

  # Sockets de libvirt
  systemd.sockets.libvirtd.enable = true;

  # Autenticación
  security.polkit.enable = true;
  programs.dconf.enable = true;

  # Paquetes necesarios
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice-gtk
    qemu
    OVMF
    libvirt
    polkit_gnome # Agente de polkit
  ];
}
