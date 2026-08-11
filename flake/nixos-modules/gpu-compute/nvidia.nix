{
  flake.nixosModules'.gpu-compute-nvidia =
    {
      lib,
      ...
    }:
    let
      inherit (lib) mkForce;
    in
    {
      hardware.nvidia-container-toolkit.enable = true;

      virtualisation.vmVariant.hardware.nvidia-container-toolkit.enable = mkForce false;
    };
}
