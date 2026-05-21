{
  flake.nixosModules.terminal =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        getExe
        getName
        mkIf
        mkOption
        types
        ;
    in
    {
      config.environment =
        let
          inherit (config.host) terminal;
        in
        {
          etc."xdg/kitty/kitty.conf" = mkIf ((getName terminal) == "kitty") {
            text = ''
              background_opacity 0.6

              shell_integration no-rc
            '';
          };

          sessionVariables.TERMINAL = getExe terminal;

          systemPackages = [
            terminal
          ];
        };

      options.host.terminal = mkOption {
        default = pkgs.kitty;

        description = "Sets the host's preferred terminal emulator.";

        type = types.package;
      };
    };
}
