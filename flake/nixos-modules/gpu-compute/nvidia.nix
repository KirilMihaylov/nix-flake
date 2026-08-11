{
  flake.nixosModules'.gpu-compute-nvidia = {
    hardware.nvidia-container-toolkit.enable = true;

    virtualisation.vmVariant.hardware.nvidia-container-toolkit.suppressNvidiaDriverAssertion = true;
  };
}
