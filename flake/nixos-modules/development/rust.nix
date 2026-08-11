{
  flake.nixosModules'.development =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages =
        with pkgs;
        with packages;
        [
          bacon
          cargo-audit
          cargo-deny
          cargo-owi
          cargo-nextest
          rust-toolchain
        ];
    };
}
