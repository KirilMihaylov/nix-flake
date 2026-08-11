let
  package = "niri-sticky-window";
in
{
  inputs,
  ...
}:
{
  ${package} =
    {
      lib,
      rust-stable,
    }:
    rust-stable.platform.buildRustPackage rec {
      inherit package;

      cargoLock.lockFile = src + "/Cargo.lock";

      meta = {
        license = lib.licenses.asl20;

        mainProgram = package;
      };

      name = package;

      pname = package;

      src = inputs.niri-sticky-window;
    };
}
