# NixOS + Hyprland Configuration

Configuración de NixOS con Hyprland optimizada para alto rendimiento, usando flakes modernos y gestión declarativa completa.

## 🚀 Características

- **Window Manager**: Hyprland con UWSM
- **Display Manager**: SDDM con tema Astronaut
- **Shell**: Zsh con Powerlevel10k
- **Gestión de Secretos**: SOPS + age
- **Impermanence**: Sistema de archivos efímero con Btrfs
- **Particionado**: Disko para configuración declarativa
- **Optimizaciones**: 
  - Zram para gaming (200% RAM)
  - Kernel Zen con parámetros optimizados
  - Drivers AMD/Intel/NVIDIA configurables
  - PipeWire + EasyEffects para audio profesional

## 📁 Estructura
```
.
├── flake.nix              # Entrada principal
├── Hosts/                 # Configuraciones por máquina
│   ├── PC/               # Desktop gaming (AMD)
│   ├── Notebook/         # Laptop híbrida (Intel+NVIDIA)
│   └── Netbook/          # Ultrabook ligera (Intel)
├── Modules/              # Módulos del sistema
│   ├── Drivers/         # CPU y GPU
│   ├── Impermanence/    # Persistencia
│   ├── Network/         # Red por host
│   └── ...
├── Home-manager/         # Configuraciones de usuario
│   ├── Aplicaciones/    # Apps y dotfiles
│   └── Window-Manager/  # Hyprland + Waybar
└── Secrets/             # Secretos encriptados (SOPS)
```

## 🔧 Instalación
```bash
# Clonar repositorio
git clone https://github.com/TU_USUARIO/nixos-config.git
cd nixos-config

# Generar clave age para SOPS
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# Editar secretos (agregar tu hash de contraseña)
# Obtener hash: mkpasswd -m sha-512
sops Secrets/secrets.yaml

# Instalar (reemplaza HOST por: PC, Notebook o Netbook)
sudo nixos-rebuild switch --flake .#HOST
```

## 🖥️ Hosts Disponibles

| Host | CPU | GPU | Uso |
|------|-----|-----|-----|
| PC | AMD Ryzen 5 3600 | AMD RX 5500 XT | Gaming de alto rendimiento |
| Notebook | Intel i5 (4th gen) | Intel + NVIDIA 820M | Laptop híbrida |
| Netbook | Intel Celeron N4020 | Intel UHD 600 | Portátil básica |

## ⌨️ Atajos de Teclado (Hyprland)

| Atajo | Acción |
|-------|--------|
| `Super + Return` | Terminal (Kitty) |
| `Super + D` | Lanzador de apps (Rofi) |
| `Super + Shift + Q` | Cerrar ventana |
| `Super + F` | Pantalla completa |
| `Super + Space` | Flotante/Tiling |
| `Print` | Screenshot completo |
| `Shift + Print` | Screenshot área |
| `Super + Esc` | Bloquear pantalla |
| `Super + Shift + Esc` | Menú de apagado |
