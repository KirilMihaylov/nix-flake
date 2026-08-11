{
  self,
  ...
}:
{
  perSystem =
    {
      lib,
      ...
    }:
    {
      packages =
        let
          inherit (lib)
            attrValues
            head
            length
            mapAttrs
            zipAttrs
            ;
        in
        mapAttrs
          (
            _: derivations:
            assert length derivations == 1;
            head derivations
          )
          (
            zipAttrs (
              attrValues (
                mapAttrs (host: system: {
                  "vm-${host}" = system.config.system.build.vm;
                }) self.nixosConfigurations
              )
            )
          );
    };
}
