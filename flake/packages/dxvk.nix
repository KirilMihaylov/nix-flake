{
  inputs,
  ...
}:
{
  flake.packages' = {
    dxvk =
      {
        bash,
        dxvk_3,
        lib,
        overrideCC,
        pkgsCross,
        stdenvNoCC,
      }:
      let
        inherit (lib) escapeShellArg;

        dxvk32 = dxvk "32";

        dxvk64 = dxvk "W64";

        dxvk =
          env:
          let
            inherit (pkgsCross."mingw${env}") stdenv windows;
          in
          dxvk_3.override {
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
          };
      in
      stdenvNoCC.mkDerivation (final: {
        inherit (dxvk_3) name pname version;

        __structuredAttrs = true;

        buildCommand = ''
          'mkdir' '-p' "''${bin}" "''${lib}" "''${out}/bin"

          'substitute' ${
            escapeShellArg (inputs.nixpkgs + "/pkgs/by-name/dx/dxvk/setup_dxvk.sh")
          } "''${out}/bin/setup_dxvk.sh" \
            '--subst-var-by' 'bash' ${escapeShellArg bash} \
            '--subst-var-by' 'dxvk32' ${escapeShellArg dxvk32} \
            '--subst-var-by' 'dxvk64' ${escapeShellArg dxvk64} \
            '--subst-var-by' 'version' ${escapeShellArg final.version}

          'chmod' 'a+x' "''${out}/bin/setup_dxvk.sh"

          declare -rA derivations=(
            ["x32"]=${escapeShellArg dxvk32}
            ["x64"]=${escapeShellArg dxvk64}
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
          inherit dxvk32 dxvk64;
        };

        strictDeps = true;
      });

    dxvk_3 =
      {
        extraBuildInputs ? [ ],
        glfw3,
        glslang,
        lib,
        meson,
        ninja,
        pkg-config,
        pkgsBuildHost,
        runCommandLocal,
        SDL2,
        sdl3,
        spirv-headers,
        stdenv,
        vulkan-headers,
      }:
      let
        inherit (inputs) dxvk;

        inherit (lib)
          escapeShellArgs
          flip
          fromJSON
          getExe
          id
          optional
          optionals
          pipe
          readFile
          ;

        inherit (stdenv.hostPlatform) isWindows;
      in
      stdenv.mkDerivation (final: {
        buildInputs = [
          spirv-headers
          vulkan-headers
        ]
        ++ optionals (!isWindows) [
          glfw3
          SDL2
          sdl3
        ]
        ++ extraBuildInputs;

        doCheck = true;

        mesonBuildType = "release";

        nativeBuildInputs = [
          glslang
          meson
          ninja
        ]
        ++ optional (!isWindows) pkg-config;

        pname = "dxvk";

        postPatch = escapeShellArgs [
          "substituteInPlace"
          "./subprojects/libdisplay-info/tool/gen-search-table.py"
          "--replace-fail"
          "/usr/bin/env python3"
          (getExe pkgsBuildHost.python3)
        ];

        preConfigure = escapeShellArgs [
          "rm"
          "-f"
          "-R"
          "./include/spirv/include"
          "./include/vulkan/include"
        ];

        src = dxvk;

        strictDeps = true;

        version = pipe "${final.pname}-version" [
          runCommandLocal
          (flip id {
            inherit (final) src;

            nativeBuildInputs = [
              meson
            ];
          })
          (flip id ''"meson" "introspect" "--projectinfo" "''${src}/meson.build" >"''${out}"'')
          readFile
          fromJSON
          (set: set.version)
        ];
      });
  };
}
