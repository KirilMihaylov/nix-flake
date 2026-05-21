{
  flake.nixosModules.easyeffects =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        easyeffects
      ];
    };
}
