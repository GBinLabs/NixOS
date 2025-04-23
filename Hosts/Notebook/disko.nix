{
  disko.devices = {
    disk = {
      # Disco SSD - Contiene /boot y /root
      ssd = {
        device = "/dev/sda";  # Ajusta según tu sistema
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2048M";
              type = "EF00";   # EFI
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            crypt_p1 = {
              size = "100%";
              content = {
                type = "luks";
                name = "p1";   # /dev/mapper/p1
                settings = {
                  allowDiscards = true;  # Para SSD
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
        device = "/dev/sdb";  # Ajusta según tu sistema
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            crypt_p2 = {
              size = "100%";
              content = {
                type = "luks";
                name = "p2";  # /dev/mapper/p2
                settings = {
                  allowDiscards = false;  # HDD, no necesita discard
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
