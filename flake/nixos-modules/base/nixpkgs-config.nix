{
  self,
  ...
}:
{
  flake.nixosModules'.base =
    {
      config,
      lib,
      ...
    }:
    {
      nixpkgs =
        let
          inherit (config.host.hardware) cpu hardware-acceleration;

          inherit (lib) attrValues elem;
        in
        {
          config = {
            checkMeta = true;

            cudaSupport = elem "cuda" hardware-acceleration;

            rocmSupport = elem "rocm" hardware-acceleration;
          };

          hostPlatform.system = "${cpu.arch}-linux";

          overlays = [
            (
              _: prev:
              let
                field = "systemFlake";
              in
              assert !(prev ? ${field});
              {
                ${field} = self;
              }
            )
          ]
          ++ attrValues self.overlays;
        };
    };
}
