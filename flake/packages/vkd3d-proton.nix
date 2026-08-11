{
  inputs,
  ...
}:
{
  flake.packages' = {
    vkd3d-proton =
      {
        vkd3d-proton_3,
        lib,
        overrideCC,
        pkgsCross,
        stdenvNoCC,
      }:
      let
        inherit (lib) escapeShellArg;

        inherit (vkd3d-proton_3)
          name
          pname
          src
          version
          ;

        vkd3d-proton32 = vkd3d-proton "32";

        vkd3d-proton64 = vkd3d-proton "W64";

        vkd3d-proton =
          env:
          let
            inherit (pkgsCross."mingw${env}") stdenv windows;
          in
          (vkd3d-proton_3.override {
            extraBuildInputs = [
              windows.pthreads
            ];

            stdenv = overrideCC stdenv (
              stdenv.cc.override (old: {
                cc = old.cc.override {
                  threadsCross = {
                    model = "win32";

                    package = null;
                  };
                };
              })
            );
          }).overrideAttrs
            {
              meta = { };
            };
      in
      stdenvNoCC.mkDerivation (final: {
        inherit name pname version;

        __structuredAttrs = true;

        buildCommand = ''
          'mkdir' '-p' "''${bin}" "''${lib}" "''${out}/bin"

          'cp' ${escapeShellArg (src + "/setup_vkd3d_proton.sh")} "''${out}/bin/setup_vkd3d_proton.sh"

          'chmod' 'a+x' "''${out}/bin/setup_vkd3d_proton.sh"

          declare -rA derivations=(
            ["x32"]=${escapeShellArg vkd3d-proton32}
            ["x64"]=${escapeShellArg vkd3d-proton64}
          )

          for derivation in "''${!derivations[@]}"
          do
            for output in 'bin' 'lib'
            do
              'ln' '-s' "''${derivations["''${derivation}"]}/''${output}" "''${!output}/''${derivation}"
            done
          done
        '';

        outputs = [
          "bin"
          "lib"
          "out"
        ];

        passthru = {
          inherit vkd3d-proton32 vkd3d-proton64;
        };

        strictDeps = true;
      });

    vkd3d-proton_3 =
      {
        extraBuildInputs ? [ ],
        lib,
        meson,
        stdenv,
        runCommandLocal,
        vkd3d-proton,
      }:
      let
        inherit (lib)
          flip
          fromJSON
          id
          pipe
          readFile
          ;
      in
      (vkd3d-proton.override {
        inherit stdenv;
      }).overrideAttrs
        (
          let
            inherit (inputs) vkd3d-proton;
          in
          final: base: rec {
            buildInputs = (base.buildInputs or [ ]) ++ extraBuildInputs;

            src = vkd3d-proton;

            version = pipe "${final.pname}-version" [
              runCommandLocal
              (flip id {
                inherit src;

                nativeBuildInputs = [
                  meson
                ];
              })
              (flip id ''"meson" "introspect" "--projectinfo" "''${src}/meson.build" >"''${out}"'')
              readFile
              fromJSON
              (set: set.version)
            ];
          }
        );
  };
}
