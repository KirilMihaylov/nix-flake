{
  flake.nixosModules'.steam =
    {
      pkgs,
      ...
    }:
    {
      programs.steam = {
        enable = true;

        extraCompatPackages = with pkgs; [
          dwproton-bin
          packages.proton-ge-bin'
        ];

        gamescopeSession.enable = false;

        protontricks.enable = true;
      };
    };
}
