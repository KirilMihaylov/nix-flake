{
  inputs,
  ...
}:
{
  flake.packages-generic.nix-index =
    {
      stdenv,
    }:
    inputs.nix-index.packages.${stdenv.hostPlatform.system}.default;
}
