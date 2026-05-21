{
  self,
  ...
}:
{
  flake.nixosConfigurations = import (self + /system-generic.nix) self;
}
