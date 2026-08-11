{
  self,
  ...
}:
{
  flake.nixosConfigurations = import ../system-generic.nix self;
}
