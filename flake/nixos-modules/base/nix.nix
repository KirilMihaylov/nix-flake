{
  flake.nixosModules'.base.nix = {
    channel.enable = false;

    settings.auto-optimise-store = true;
  };
}
