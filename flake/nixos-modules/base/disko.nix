{
  inputs,
  ...
}:
{
  flake.nixosModules'.base.imports = [
    inputs.disko.nixosModules.default
  ];
}
