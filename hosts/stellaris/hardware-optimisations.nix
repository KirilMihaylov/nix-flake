{
  inputs,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel-cpu-only
    common-gpu-intel-disable
    common-gpu-nvidia-nonprime
    common-hidpi
    common-pc
    common-pc-laptop
    common-pc-laptop-ssd
  ];
}
