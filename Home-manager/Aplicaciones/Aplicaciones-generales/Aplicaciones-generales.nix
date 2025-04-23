{ pkgs, ... }:

{

  home.packages = with pkgs; [
	# Estadisticas de almacenamiento.
	baobab
	# Audio.
	pavucontrol       # Control gráfico de volumen
	# Editor de texto.
	gnome-text-editor
	# Limpieza.
	bleachbit
	# Administrador de discos.
	gnome-disk-utility
	# Descompresor de archivos.
	file-roller
	# Visor de documento.
	evince
	# Visor de imagenes.
	eog
	# Visualizador de videos.
	vlc
	# Herramientas.
	pciutils
	# Mouse.
	piper
	# Captura de pantalla.
	grim
	slurp
	wl-clipboard
  ];

}
