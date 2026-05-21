{
  flake.nixosModules.signal-desktop =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        signal-desktop
      ];
    };
}
