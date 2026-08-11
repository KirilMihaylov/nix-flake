{
  flake.nixosModules'.base =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.host.hardware) cpu hardware-acceleration;

      inherit (lib) elem;
    in
    {
      nixpkgs = {
        config = {
          checkMeta = true;

          cudaSupport = elem "cuda" hardware-acceleration;

          problems.handlers."gtk+".broken = "warn";

          rocmSupport = elem "rocm" hardware-acceleration;
        };

        hostPlatform.system = "${cpu.arch}-linux";
      };
    };
}
