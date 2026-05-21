{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      inherit (pkgs) packages;
    };
}
