{
  inputs,
  ...
}:
{
  flake.packages-generic =
    let
      mkRust =
        rust: extensions:
        {
          makeRustPlatform,
          stdenv,
        }:
        let
          rust' =
            (inputs.rust.packages.${stdenv.hostPlatform.system}.${rust}.override {
              extensions = [
                "llvm-tools"
                "rust-src"
              ]
              ++ extensions;
            }).overrideAttrs
              (base: {
                passthru = base.passthru // {
                  platform =
                    assert !(base.passthru ? platform);
                    makeRustPlatform {
                      cargo = rust';

                      rustc = rust';
                    };
                };
              });
        in
        rust';
    in
    {
      rust-beta = mkRust "rust-beta" [ ];

      rust-nightly = mkRust "rust-nightly" [
        "miri"
      ];

      rust-stable = mkRust "rust" [ ];
    };
}
