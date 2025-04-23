{
  disko.devices = {
    disk = {
      # Disco SSD - Contiene /boot y /root
      ssd = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2048M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            crypt_p1 = {
              size = "100%";
              content = {
                type = "luks";
                name = "p1";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "subvol=root"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "subvol=nix"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };

      # Disco HDD - Contiene /home y /persist
      hdd = {
        device = "/dev/sdb";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # Primera partición para Windows
            windows = {
              priority = 1;
              size = "200G";
              type = "0700"; # Tipo para Microsoft básico de datos
              # Omitimos cualquier content para evitar formato
            };

            # Segunda partición para Linux
            crypt_p2 = {
              priority = 2;
              size = "0"; # Usa el espacio restante
              content = {
                type = "luks";
                name = "p2";
                settings = {
                  allowDiscards = false;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [];
                  subvolumes = {
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "subvol=home"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "subvol=persist"
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
