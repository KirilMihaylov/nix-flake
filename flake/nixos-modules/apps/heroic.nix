{
  flake.nixosModules.heroic =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        (heroic.override {
          extraPkgs =
            pkgs: with pkgs; [
              gamemode
              mangohud
              mono
              protontricks
              winetricks
              wineWow64Packages.full
            ];
        })
      ];
    };
}
