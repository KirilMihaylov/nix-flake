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
          cargo-nextest
          cargo-owi
          rust-toolchain
        ];
    };
}
