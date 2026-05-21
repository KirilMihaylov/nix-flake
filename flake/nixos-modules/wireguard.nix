{
  flake.nixosModules.wireguard =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.wireguard-tools
      ];

      networking.wireguard.enable = true;
    };
}
