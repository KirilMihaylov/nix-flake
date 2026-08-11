let
  package = "niri-sticky-window";
in
{
  inputs,
  ...
}:
{
  flake.packages'.${package} =
    {
      lib,
      rust-stable,
    }:
    rust-stable.platform.buildRustPackage (final: {
      inherit package;

      cargoLock.lockFile = final.src + "/Cargo.lock";

      meta = {
        license = lib.licenses.asl20;

        mainProgram = final.pname;
      };

      name = final.pname;

      pname = final.package;

      src = inputs.niri-sticky-window;
    });
}
