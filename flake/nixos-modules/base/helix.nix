{
  flake.nixosModules.helix =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkOption types;

      inherit (pkgs.packages) helix' helix-config;

      inherit (types) package path;
    in
    {
      config.environment.systemPackages = [
        config.programs.helix.package
      ];

      options.programs.helix = {
        config = mkOption {
          default = helix-config;

          description = "Configuration file for the Helix editor.";

          type = path;
        };

        package = mkOption {
          apply =
            pkg:
            pkg.override {
              config-file = config.programs.helix.config;
            };

          default = helix';

          description = "Configures the package to be used as base to be bundled with the configuration file.";

          type = package;
        };
      };
    };
}
