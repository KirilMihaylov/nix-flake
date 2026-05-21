{
  flake.nixosModules.steam =
    {
      pkgs,
      ...
    }:
    {
      programs.steam = {
        enable = true;

        extraCompatPackages = with pkgs; [
          dwproton-bin
          proton-ge-bin
        ];

        gamescopeSession.enable = false;

        protontricks.enable = true;
      };
    };
}
