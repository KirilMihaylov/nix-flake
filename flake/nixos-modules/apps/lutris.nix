{
  flake.nixosModules'.lutris =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        (lutris.override {
          extraPkgs =
            pkgs: with pkgs; [
              gamemode
              mangohud
              mono
              protontricks
              winetricks
            ];

          steamSupport = false;
        })
      ];
    };
}
