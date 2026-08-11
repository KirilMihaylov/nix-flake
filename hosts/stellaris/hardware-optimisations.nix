{
  inputs,
  ...
}:
{
  imports = map (path: inputs.nixos-hardware + "/common/${path}") [
    "cpu/intel/raptor-lake"
    "gpu/intel/disable.nix"
    "gpu/nvidia"
    "gpu/nvidia/ada-lovelace"
    "hidpi.nix"
    "pc"
    "pc/laptop"
    "pc/ssd"
  ];
}
