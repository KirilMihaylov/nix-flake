{
  flake.packages'.cargo-owi =
    {
      owi,
      rust-stable,
    }:
    rust-stable.platform.buildRustPackage rec {
      cargoLock.lockFile = src + "/Cargo.lock";

      name = "cargo-owi";

      src = owi.src + "/src/lang_rust";
    };
}
