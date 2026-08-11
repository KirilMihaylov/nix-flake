{
  inputs,
  ...
}:
{
  imports = map (path: inputs.nixos-hardware + "/${path}") [
    "common/cpu/intel/raptor-lake"
    "common/gpu/intel/disable.nix"
    "common/gpu/nvidia"
    "common/gpu/nvidia/ada-lovelace"
    "common/hidpi.nix"
    "common/pc"
    "common/pc/laptop"
    "common/pc/ssd"
  ];
}
