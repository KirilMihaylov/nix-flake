{
  flake.nixosModules'.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkOption types;

      inherit (pkgs.packages) helix helix-config;

      inherit (types) package path;

      cfg = config.programs.helix;
    in
    {
      config.environment.systemPackages = [
        cfg.package
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
              helix-config = cfg.config;
            };

          default = helix;

          description = "Configures the package to be used as base to be bundled with the configuration file.";

          type = package;
        };
      };
    };
}
