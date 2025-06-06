{ pkgs, ... }:

{
  # Habilitar virtualización
  virtualisation.libvirtd.enable = true;

  # Instalar QEMU y herramientas relacionadas
  environment.systemPackages = with pkgs; [
    qemu
    qemu_kvm
    virt-manager # Interfaz gráfica opcional
    bridge-utils
  ];
}
