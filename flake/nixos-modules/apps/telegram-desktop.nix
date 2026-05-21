{
  flake.nixosModules.telegram-desktop =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        telegram-desktop
      ];
    };
}
