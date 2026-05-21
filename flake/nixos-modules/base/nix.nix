{
  flake.nixosModules.nix.nix = {
    channel.enable = true;

    settings.auto-optimise-store = true;
  };
}
