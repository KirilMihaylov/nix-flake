{
  flake.nixosModules'.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkIf config.networking.networkmanager.enable (
      let
        inherit (pkgs) gcr networkmanagerapplet;
      in
      {
        environment.systemPackages = [
          networkmanagerapplet
        ];

        services.dbus.packages = [
          gcr
        ];
      }
    );
}
