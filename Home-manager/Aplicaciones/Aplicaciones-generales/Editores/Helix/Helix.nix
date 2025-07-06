{ pkgs, ... }:

{
  programs.helix = {
    enable = true;                   # Activa Helix:contentReference[oaicite:4]{index=4}
    package = pkgs.helix;            # (por defecto usa pkgs.helix):contentReference[oaicite:5]{index=5}
    languages = {
      language-server.nixd = {
        command = "${pkgs.nixd}/bin/nixd";    # Servidor LSP para Nix
        formatting = {
          command = ["${pkgs.alejandra}/bin/alejandra"]; # Formateador
        };
        nixpkgs = {
          expr = "import (builtins.getFlake \"/etc/nixos\").inputs.nixpkgs { }";
        };
      };
      language = [{
        name = "nix";
        file-types = [ "nix" ];
        auto-format = true;                   # Formatea al guardar:contentReference[oaicite:6]{index=6}
        formatter = {
          command = ["${pkgs.alejandra}/bin/alejandra"];
        };
      }];
    };
    settings = {
      theme = "base16";         # Ejemplo de tema; opcional
      # Otras opciones de editor (cursor, line-numbers, etc.)
    };
  };
}
