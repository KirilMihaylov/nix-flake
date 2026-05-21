{
  inputs,
  ...
}:
{
  flake.packages-generic.noctalia-shell =
    {
      stdenv,
      symlinkJoin,
    }:
    let
      inherit (inputs) noctalia-shell;

      inherit (noctalia-shell) packages;

      inherit (stdenv.hostPlatform) system;

      noctalia-qs = noctalia-shell.inputs.noctalia-qs.packages.${system}.default;

      pkg = packages.${system}.default;
    in
    symlinkJoin {
      inherit (pkg)
        meta
        name
        outputs
        passthru
        pname
        version
        ;

      paths = [
        noctalia-qs
        pkg
      ];
    };
}
