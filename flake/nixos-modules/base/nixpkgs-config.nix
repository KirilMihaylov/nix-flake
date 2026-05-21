{
  self,
  ...
}:
{
  flake.nixosModules.nixpkgs-config =
    {
      config,
      lib,
      ...
    }:
    {
      nixpkgs =
        let
          inherit (config.host.hardware) cpu hardware-acceleration;
        in
        {
          config =
            let
              inherit (lib) elem;
            in
            {
              checkMeta = true;

              cudaSupport = elem "cuda" hardware-acceleration;

              rocmSupport = elem "rocm" hardware-acceleration;
            };

          hostPlatform.system = "${cpu.arch}-linux";

          overlays = with self.overlays; [
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
            packages
            patch-nixos-option
          ];
        };
    };
}
