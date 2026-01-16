{
  disko.devices = {
    disk = {
      # ========== SSD SATA (/dev/sda) ==========
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
                  allowDiscards = true; # ← Para SSD
                };
                extraFormatArgs = [
                  # ← LUKS2 moderno
                  "--type luks2"
                  "--pbkdf argon2id"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "subvol=root"
                        "compress=zstd"
                        "noatime"
                        "space_cache=v2"
                        "discard=async" # ← TRIM asíncrono para SSD
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "subvol=nix"
                        "compress=zstd"
                        "noatime"
                        "space_cache=v2"
                        "discard=async" # ← TRIM asíncrono para SSD
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };

      # ========== HDD (/dev/sdb) ==========
      hdd = {
        device = "/dev/sdb";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            #windows = {
            #  priority = 1;
            #  size = "200G";
            #  type = "0700";
            #};
            crypt_p2 = {
              priority = 1; # 2 si está activada la partición Windows
              size = "100%"; # ← Cambiado de "0" a "100%" (más explícito)
              content = {
                type = "luks";
                name = "p2";
                settings = {
                  allowDiscards = false; # ← Correcto para HDD
                };
                extraFormatArgs = [
                  # ← LUKS2 también para HDD
                  "--type luks2"
                  "--pbkdf argon2id"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  subvolumes = {
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "subvol=home"
                        "compress=zstd"
                        "noatime"
                        "space_cache=v2"
                        "autodefrag" # ← Útil para HDDs (desfragmenta automáticamente)
                      ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "subvol=persist"
                        "compress=zstd"
                        "noatime"
                        "space_cache=v2"
                        "autodefrag" # ← Útil para HDDs
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
