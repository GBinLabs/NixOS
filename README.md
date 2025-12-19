# NixOS + GNOME Configuration

Configuración de NixOS con GNOME optimizada para gaming de alto rendimiento, implementada mediante flakes y gestión declarativa completa del sistema.

## Filosofía del proyecto

Este repositorio documenta una implementación de NixOS enfocada en extraer el máximo rendimiento de hardware AMD para gaming mientras mantiene seguridad y reproducibilidad. El sistema utiliza impermanence con Btrfs, reseteando completamente el estado del sistema en cada arranque mientras preserva únicamente los datos esenciales en volúmenes persistentes.

## Características principales

El sistema implementa GNOME sobre Wayland como entorno de escritorio, gestión de secretos mediante SOPS con encriptación age, y particionado declarativo con Disko. Las optimizaciones incluyen kernel CachyOS con parámetros ajustados para latencia mínima, scheduler scx_lavd en modo performance, Zram con swappiness de 180 para gaming, drivers AMD con todas las optimizaciones RADV habilitadas, y PipeWire configurado para latencia de audio inferior a 2 milisegundos.

## Hardware de referencia

El sistema principal opera sobre procesador AMD Ryzen 5 3600, tarjeta gráfica RX 5500 XT con 4GB de VRAM, 16GB de RAM, SSD de 240GB para sistema y HDD de 2TB para datos de usuario. La configuración secundaria utiliza procesador Intel N4020 con gráficos integrados Intel UHD Graphics 600 y 8GB de RAM.

## Estructura modular

El proyecto organiza la configuración en módulos independientes dentro del directorio Modules, abarcando audio, arranque, DNS, escritorio, impermanence, teclado, optimizaciones de Nix, red, seguridad, servicios, gaming y shell. La configuración de usuario se gestiona completamente mediante Home-manager en el directorio correspondiente, separando aplicaciones, configuración de editores, gestor de archivos, navegadores y terminal.

## Seguridad implementada

El sistema utiliza DNS over TLS estricto con Quad9, proporcionando cifrado completo de consultas DNS, validación DNSSEC obligatoria y bloqueo automático de dominios maliciosos. LUKS2 con Argon2id protege el almacenamiento mediante encriptación de disco completo. El firewall bloquea conexiones entrantes no solicitadas mientras permite todo el tráfico saliente necesario para gaming y comunicaciones de red.

## Propósito educativo

Este repositorio se proporciona como referencia para usuarios que implementan configuraciones similares de NixOS. La exploración del código fuente y la estructura de módulos proporciona comprensión profunda de las decisiones de diseño y optimizaciones aplicadas. Se recomienda estudiar cada módulo individualmente para adaptar las soluciones a necesidades específicas en lugar de implementar directamente la configuración completa.
