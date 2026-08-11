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
          packages.proton-ge-bin'
          dwproton-bin
        ];

        protontricks.enable = true;
      };
    };
}
