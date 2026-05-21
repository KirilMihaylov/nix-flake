{
  self,
  ...
}:
{
  flake.overlays.patch-nixos-option =
    final: prev:
    let
      name = "nixos-option";
    in
    {
      ${name} = prev.${name}.overrideAttrs (base: {
        dontPatch =
          assert base.dontPatch;
          false;

        dontUnpack =
          assert base.dontUnpack;
          false;

        unpackPhase =
          assert base.dontUnpack;
          ''
            src="$(
              new_src='./nixos-option.sh'

              cp "''${src}" "''${new_src}"

              echo "''${new_src}"
            )"
          '';

        patches =
          (base.patches or [ ])
          ++ (final.lib.filesystem.listFilesRecursive (self + /files/patches/nixos-option));
      });
    };
}
