{
  flake.nixosModules.containerisation =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        ctop
        docker-buildx
        docker-compose
        docker-credential-helpers
        podman-compose
      ];

      virtualisation = {
        docker = {
          enable = true;

          rootless = {
            daemon.settings.dns = [
              "1.1.1.1"
              "1.2.3.4"
              "9.9.9.9"
              "8.8.8.8"
            ];

            enable = true;

            extraPackages = [
              pkgs.passt
            ];

            setSocketVariable = true;
          };

          storageDriver = "overlay2";
        };

        podman.enable = true;
      };
    };
}
