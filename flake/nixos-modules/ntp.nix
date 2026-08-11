{
  flake.nixosModules'.ntp =
    {
      lib,
      ...
    }:
    let
      inherit (lib) range toList;

      domain = "pool.ntp.org";
    in
    {
      services.timesyncd = {
        servers = toList domain ++ map (index: "${toString index}.${domain}") (range 0 3);
      };
    };
}
