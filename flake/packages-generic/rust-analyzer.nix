{
  inputs,
  ...
}:
{
  flake.packages-generic = {
    rust-analyzer =
      {
        stdenv,
      }:
      inputs.fenix.packages.${stdenv.hostPlatform.system}.rust-analyzer;

    rust-analyzer-vscode =
      {
        stdenv,
      }:
      inputs.fenix.packages.${stdenv.hostPlatform.system}.rust-analyzer-vscode-extension;
  };
}
