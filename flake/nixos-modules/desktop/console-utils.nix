{
  flake.nixosModules.desktop-console-utils =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        glib
      ];
    };
}
