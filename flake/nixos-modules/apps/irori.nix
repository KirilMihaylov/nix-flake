{
  flake.nixosModules'.irori =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs.packages; [
        irori
      ];
    };
}
