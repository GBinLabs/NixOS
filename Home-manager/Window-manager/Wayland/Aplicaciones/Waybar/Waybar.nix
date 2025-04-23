{ pkgs, ... }:

{

  programs.waybar = {
	enable = true;
	package = pkgs.waybar; ## MIT
	systemd = {
		enable = true;
		target = "graphical-session.target";
	};
	style = ''
		* {
			font-family: "JetBrainsMono Nerd Font";
                	/*font-size: ;*/
                	font-weight: bold;
			font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
			min-height: 0;
			padding: 1px;
		}

		@define-color base #1e1e2e;
		@define-color mantle #181825;
		@define-color crust #11111b;

		@define-color text #cdd6f4;
		@define-color subtext0 #a6adc8;
		@define-color subtext1 #bac2de;

		@define-color surface0 #313244;
		@define-color surface1 #45475a;
		@define-color surface2 #585b70;

		@define-color overlay0 #6c7086;
		@define-color overlay1 #7f849c;
		@define-color overlay2 #9399b2;

		@define-color blue #89b4fa;
		@define-color lavender #b4befe;
		@define-color sapphire #74c7ec;
		@define-color sky #89dceb;
		@define-color teal #94e2d5;
		@define-color green #a6e3a1;
		@define-color yellow #f9e2af;
		@define-color peach #fab387;
		@define-color maroon #eba0ac;
		@define-color red #f38ba8;
		@define-color mauve #cba6f7;
		@define-color pink #f5c2e7;
		@define-color flamingo #f2cdcd;
		@define-color rosewater #f5e0dc;

		window#waybar {
			transition-property: background-color;
			transition-duration: 0.5s;
			background: black;
			border-radius: 10px;
		}

		window#waybar.hidden {
			opacity: 0.2;
		}

		#waybar.empty #window {
			background: none;
		}

		/* Separar modulos de waybar */
		.modules-left, .modules-center, .modules-right {
			background: #000000;
			border: 0px solid @overlay0;
			padding-top: 0px;
			padding-bottom: 0px;
			padding-right: 4px;
			padding-left: 4px;
			border-radius: 12px;
		}

		.modules-left, .modules-right {
			border: 0px solid @blue;
			padding-top: 1px;
			padding-bottom: 1px;
			padding-right: 4px;
			padding-left: 4px;
		}

		#backlight,
		#backlight-slider,
		#battery,
		#bluetooth,
		#clock,
		#cpu,
		#disk,
		#idle_inhibitor,
		#keyboard-state,
		#memory,
		#mode,
		#mpris,
		#network,
		#pulseaudio,
		#pulseaudio-slider,
		#taskbar button,
		#taskbar,
		#temperature,
		#tray,
		#window,
		#wireplumber,
		#workspaces,
		#custom-backlight,
		#custom-cycle_wall,
		#custom-keybinds,
		#custom-keyboard,
		#custom-light_dark,
		#custom-lock,
		#custom-menu,
		#custom-power_vertical,
		#custom-power,
		#custom-swaync,
		#custom-updater,
		#custom-weather,
		#custom-weather.clearNight,
		#custom-weather.cloudyFoggyDay,
		#custom-weather.cloudyFoggyNight,
		#custom-weather.default,
		#custom-weather.rainyDay,
		#custom-weather.rainyNight,
		#custom-weather.severe,
		#custom-weather.snowyIcyDay,
		#custom-weather.snowyIcyNight,
		#custom-weather.sunnyDay {
			padding-top: 3px;
			padding-bottom: 3px;
			padding-right: 6px;
			padding-left: 6px;
		}

		#idle_inhibitor {
			color: @blue;
		}

		#bluetooth,
		#backlight {
			color: @blue;
		}

		#battery {
			color: @green;
		}

		@keyframes blink {
			to {
				color: @surface0;
			}
		}

		#battery.critical:not(.charging) {
			background-color: @red;
			color: @theme_text_color;
			animation-name: blink;
			animation-duration: 0.5s;
			animation-timing-function: linear;
			animation-iteration-count: infinite;
			animation-direction: alternate;
			box-shadow: inset 0 -3px transparent;
		}

		#clock {
			color: @text;
		}

		#cpu {
			color: @green;
		}

		#custom-keyboard,
		#memory {
			color: @sky;
		}

		#disk {
			color: @sapphire;
		}

		#temperature {
			color: @teal;
		}

		#temperature.critical {
			background-color: @red;
		}

		#tray > .passive {
			-gtk-icon-effect: highlight;
		}

		#tray > .needs-attention {
			-gtk-icon-effect: highlight;
		}

		#keyboard-state {
			color: @flamingo;
		}

		#workspaces button {
			box-shadow: none;
			text-shadow: none;
			padding: 0px;
			border-radius: 9px;
			padding-left: 4px;
			padding-right: 4px;
			animation: gradient_f 20s ease-in infinite;
			transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
		}

		#workspaces button:hover {
			border-radius: 10px;
			color: @overlay0;
			background-color: @surface0;
			padding-left: 2px;
			padding-right: 2px;
			animation: gradient_f 20s ease-in infinite;
			transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
		}

		#workspaces button.persistent {
			color: @surface1;
			border-radius: 10px;
		}

		#workspaces button.active {
			color: @teal;
			border-radius: 10px;
			padding-left: 8px;
			padding-right: 8px;
			animation: gradient_f 20s ease-in infinite;
			transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
		}

		#workspaces button.urgent {
			color: @red;
			border-radius: 0px;
		}

		#taskbar button-active {
			padding-left: 8px;
			padding-right: 8px;
			animation: gradient_f 20s ease-in infinite;
			transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
		}

		#taskbar button:hover {
			padding-left: 2px;
			padding-right: 2px;
			animation: gradient_f 20s ease-in infinite;
			transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
		}

		#custom-menu {
			color: @teal;
		}

		#custom-power {
			color: @red;
		}

		#custom-light_dark {
			color: @blue;
		}

		#custom-weather {
			color: @lavender;
		}

		#custom-lock {
			color: @maroon;
		}

		#pulseaudio {
			color: @green;
		}

		#wireplumber {
			color: @green;
		}

		#wireplumber.muted {
			color: @red;
		}

		#pulseaudio.bluetooth {
			color: @pink;
		}

		#pulseaudio.muted {
			color: @red;
		}

		#window {
			color: @mauve;
		}

		#custom-waybar-mpris {
			color: @lavender;
		}

		#network {
			color: @teal;
		}

		#network.disconnected,
		#network.disabled {
			background-color: @surface0;
			color: @text;
		}

		#pulseaudio-slider slider {
			min-width: 0px;
			min-height: 0px;
			opacity: 0;
			background-image: none;
			border: none;
			box-shadow: none;
		}

		#pulseaudio-slider trough {
			min-width: 80px;
			min-height: 5px;
			border-radius: 5px;
		}

		#pulseaudio-slider highlight {
			min-height: 10px;
			border-radius: 5px;
		}

		#backlight-slider slider {
			min-width: 0px;
			min-height: 0px;
			opacity: 0;
			background-image: none;
			border: none;
			box-shadow: none;
		}

		#backlight-slider trough {
			min-width: 80px;
			min-height: 10px;
			border-radius: 5px;
		}

		#backlight-slider highlight {
			min-width: 10px;
			border-radius: 5px;
		}
	'';

	settings = [{
        	layer = "top";
        	position = "top";
		exclusive = true;
		passthrough = false;
		spacing = 3;
		fixed-center = true;
		ipc = true;
		margin-top = 3;
		margin-left = 8;
		margin-right = 8;

        	modules-left = [
			"hyprland/workspaces#pacman"
          		"custom/separator#blank"
          		"group/motherboard"
			"custom/cava-internal"
        	];
        	modules-center = [
			"custom/menu"
          		"clock"
			"custom/lock"
        	];
        	modules-right = [
			"tray"
			"network#speed"
			"wireplumber"
			"group/laptop"
			"custom/power"
        	];

		/* Espacio de trabajo - predeterminado */
        	"hyprland/workspaces" = {
			active-only = false;
    			all-outputs = true; 
    			format = "{icon}";
    			show-special = false;
    			on-click = "activate";
    			persistent-workspaces = {
      				"1" = [];
      				"2" = [];
      				"3" = [];
      				"4" = [];
    			};
    			format-icons = {
      				"active" = "";
      				"default" = "";
			};
		};

		/* Espacio de trabajo - romano */
		"hyprland/workspaces#roman" = {
    			active-only = false;
    			all-outputs = true;
    			format = "{icon}";
    			show-special = false;
    			on-click = "activate";
    			persistent-workspaces = {
        			"1" = [];
        			"2" = [];
        			"3" = [];
        			"4" = [];
    			};
    			format-icons = {
      				"1" = "I";
      				"2" = "II";
      				"3" = "III";
      				"4" = "IV";
      				"5" = "V";
      				"6" = "VI";
      				"7" = "VII";
      				"8" = "VIII";
      				"9" = "IX";
      				"10" = "X";
    			};
		};

		/* Espacio de trabajo - pacman */
  		"hyprland/workspaces#pacman" = {
    			active-only = false;
    			all-outputs = true;
    			format = "{icon}";
    			on-click = "activate";
    			show-special = false;
    			persistent-workspaces = {
        			"1" = [];
        			"2" = [];
        			"3" = [];
        			"4" = [];
    			};
    			format-icons = {
      				"active" = " 󰮯 ";
      				"default" = "󰊠";
      				"persistent" = "󰊠";
    			};
		};
  
		/* Espacio de trabajo - kanji */
		"hyprland/workspaces#kanji" = {
    			disable-scroll = true;
    			all-outputs = true;
    			format = "{icon}";
    			persistent-workspaces = {
      				"1" = [];
      				"2" = [];
      				"3" = [];
      				"4" = [];
      			};
    			format-icons = {
      				"1" = "一";
      				"2" = "二";
      				"3" = "三";
      				"4" = "四";
      				"5" = "五";
      				"6" = "六";
      				"7" = "七";
      				"8" = "八";
      				"9" = "九";
      				"10" = "十";
    			};
		};
 
		/* Grupos */
		"group/motherboard" = {
    			orientation = "horizontal";
    			modules = [
      				"cpu"
				"custom/separator#blank"
      				"memory"
				"custom/separator#blank"
      				"temperature"
				"custom/separator#blank"
      				"disk"
      			];
		};
  
		"group/laptop" = {
    			orientation = "horizontal";
    			modules = [
      				"backlight"
				"custom/separator#blank"
      				"battery"
      			];	
		};

		/* Módulos */

		/* Brillo */
		"backlight" = {
    			interval = 2;
    			align = 0;
    			rotate = 0;
    			/* format = "{icon} {percent}%"; */
    			format-icons = [ " " " " " " "󰃝 " "󰃞 " "󰃟 " "󰃠 "];
    			format = "{icon}";
    			/* format-icons = ["" "" "" "" "" "" "" "" "" "" "" "" "" "" ""]; */
    			tooltip-format = "backlight {percent}%";
    			icon-size = 12;
    			smooth-scrolling-threshold = 1;
		};

		/* Bateria */
		"battery" = {
    			/* interval = 5; */
    			align = 0;
    			rotate = 0;
    			/* bat = "BAT1"; */
    			/* adapter = "ACAD"; */
    			full-at = 100;
    			design-capacity = false;
    			states = {
      				"good" = 95;
      				"warning" = 30;
      				"critical" = 15;
             		};
    			format = "{icon} {capacity}%";
    			format-charging = " {capacity}%";
    			format-plugged = "󱘖 {capacity}%";
			format-alt-click = "click";
    			format-full = "{icon} Full";
    			format-alt = "{icon} {time}";
    			format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
    			format-time = "{H}h {M}min";
    			tooltip = true;
    			tooltip-format = "{timeTo} {power}w";
		};

		/* Reloj */
		"clock" = {
    			interval = 1;
    			/* format = " {:%I:%M %p}"; */ /* AM PM format */
    			format = " {:%H:%M}";
    			format-alt = " {:%H:%M:%S   %Y, %d %B, %A}";
    			tooltip-format = "<tt><small>{calendar}</small></tt>";
			timezone = "America/Argentina/Tucuman";
    			calendar = {
      				mode = "year";
      				mode-mon-col = 3;
      				weeks-pos = "right";
      				on-scroll = 1;
      				format = {
      					"months" = "<span color='#ffead3'><b>{}</b></span>";
      					"days" = "<span color='#ecc6d9'><b>{}</b></span>";
      					"weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
      					"weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
      					"today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
                		};
                	};
    		
		};

		/* CPU */   
		"cpu" = {
    			format = "{usage}% 󰍛";  
    			interval = 1;
    			/* format-alt-click = "click"; */
    			/* format-alt = "{icon0}{icon1}{icon2}{icon3} {usage:>2}% 󰍛"; */
    			/* format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"]; */
    			on-click-right = "gnome-system-monitor";
		};

		/* Discos */
		"disk" = {
    			interval = 30;
    			/* format = "󰋊"; */
    			path = "/";
    			/* format-alt-click = "click"; */
    			format = "{percentage_used}% 󰋊";
    			/* tooltip = true; */
    			tooltip-format = "{used} used out of {total} on {path} ({percentage_used}%)";
		};

		/* Memoria RAM */
		"memory" = {
    			interval = 10;
    			format = "{used:0.1f}G 󰾆";
    			format-alt = "{percentage}% 󰾆";
    			format-alt-click = "click";
    			tooltip = true;
    			tooltip-format = "{used:0.1f}GB/{total:0.1f}G";
    			on-click-right = "kitty --title btop sh -c 'btop'";
		};

		/* Conexión */
		"network#speed" = {
    			interval = 1;
    			format = "{ifname}";
    			format-wifi = " {bandwidthUpBytes}  {bandwidthDownBytes}";
			/* format-wifi = "{icon}  {bandwidthUpBytes}  {bandwidthDownBytes}"; */
    			format-ethernet = " {bandwidthUpBytes}  {bandwidthDownBytes}";
			/* format-ethernet = "󰌘   {bandwidthUpBytes}  {bandwidthDownBytes}"; */
    			format-disconnected = "󰌙";
    			tooltip-format = "{ipaddr}";
    			format-linked = "󰈁 {ifname} (No IP)";
    			tooltip-format-wifi = "{essid} {icon} {signalStrength}%";
    			tooltip-format-ethernet = "{ifname} 󰌘";
    			tooltip-format-disconnected = "󰌙 Disconnected";
    			max-length = 50;
    			format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
			icon-size = 8;
		};

		/* Temperatura del CPU */
		"temperature" = {
    			interval = 10;
    			tooltip = true;
    			hwmon-path = ["/sys/class/hwmon/hwmon1/temp1_input" "/sys/class/thermal/thermal_zone0/temp"];
    			/* thermal-zone = 0; */
    			critical-threshold = 82;
    			format-critical = "{temperatureC}°C {icon}";
    			format = "{temperatureC}°C {icon}";
    			format-icons = ["󰈸"];
    			on-click-right = "kitty --title nvtop sh -c 'nvtop'";
		};

		/* Aplicaciones en segundo plano */
		"tray" = {
    			icon-size = 15;
    			spacing = 8;
		};

		/*
		"custom/swaync": {
    			"tooltip":true,     
    			"format": "{icon} {}",
    			"format-icons": {
      				"notification": "<span foreground='red'><sup></sup></span>",
      				"none": "",
      				"dnd-notification": "<span foreground='red'><sup></sup></span>",
      				"dnd-none": "",
      				"inhibited-notification": "<span foreground='red'><sup></sup></span>",
      				"inhibited-none": "",
      				"dnd-inhibited-notification": "<span foreground='red'><sup></sup></span>",
      				"dnd-inhibited-none": ""
    			},
    			"return-type": "json",
    			"exec-if": "which swaync-client",
    			"exec": "swaync-client -swb",
    			"on-click": "sleep 0.1 && swaync-client -t -sw",
    			"on-click-right": "swaync-client -d -sw",
    			"escape": true,
		}, */

		/* Sonido */
		"wireplumber" = {
			format = "{icon} {volume}%";
			format-muted = " Mute";
			on-click-right = "pavucontrol";
			format-icons = ["" "" "󰕾" ""];
			tooltip-format = "{icon} {desc} | {volume}%"; 
		};

		/* Cava */
		"custom/cava-internal" = {
			"exec" = "sleep 1s && cava-internal";
			tooltip = false;
		};

		/* Logout */
		"custom/power" = {
			tooltip = false;
			format = "⏻ ";
			on-click = "sleep 0.1 && wlogout";
  		};

		/* Bloquear pantalla */
		"custom/lock" = {
			format = "󰌾";
			"exec" = "echo ; echo 󰷛  screen lock";
			interval = 300;
			tooltip = true;
			on-click = "sleep 0.1 && hyprlock";
		};

		/* Logo */
		"custom/menu" = {
			format = " ";
			tooltip = false;
			on-click = "nixos-help";
		};

		/* Separadores */
		"custom/separator#dot" = {
    			format = "";
    			interval = "once";
    			tooltip = false;
		};
  
		"custom/separator#dot-line" = {
    			format = "";
    			interval = "once";
    			tooltip = false;
		};
  
		"custom/separator#line" = {
    			format = "|";
    			interval = "once";
    			tooltip = false;
		};
  
		"custom/separator#blank" = {
    			format = "";
    			interval = "once";
    			tooltip = false;
		};
  
		"custom/separator#blank_2" = {
			format = "  ";
    			interval = "once";
    			tooltip = false;
		};

		"custom/separator#blank_3" = {
			format = "   ";
    			interval = "once";
    			tooltip = false;
		};
  
      	}];
  };

}
