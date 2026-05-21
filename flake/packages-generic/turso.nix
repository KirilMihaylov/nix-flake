{
  inputs,
  ...
}:
{
  flake.packages-generic.turso =
    {
      python3,
      rust,
    }:
    rust.platform.buildRustPackage rec {
      cargoLock = {
        lockFile = src + "/Cargo.lock";

        outputHashes."syntect-5.2.0" = "sha256-KfKM1VaTW3G236E96F3a8x/GgG6wIbGXrupQvrRrH3Q=";
      };

      doCheck = false;

      meta.mainProgram = "tursodb";

      name = "turso_cli";

      nativeBuildInputs = [
        python3
      ];

      src = inputs.turso;
    };
}
