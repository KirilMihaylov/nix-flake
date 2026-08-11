{
  flake.nixosModules'.base.nix = {
    channel.enable = true;

    settings.auto-optimise-store = true;
  };
}
