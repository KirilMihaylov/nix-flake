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
            pipe
            zipAttrs
            ;
        in
        pipe self.nixosConfigurations [
          (mapAttrs (
            host: system: {
              "vm-${host}" = system.config.system.build.vm;
            }
          ))
          attrValues
          zipAttrs
          (mapAttrs (
            _: derivations:
            assert length derivations == 1;
            head derivations
          ))
        ];
    };
}
