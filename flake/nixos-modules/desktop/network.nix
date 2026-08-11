{
  flake.nixosModules'.desktop =
    {
      config,
      ...
    }:
    {
      programs.nm-applet.enable = config.networking.networkmanager.enable;
    };
}
