{
  inputs,
  ...
}:
{
  flake.packages' =
    let
      mkRust =
        let
          channelToAttr = {
            beta = "beta";

            nightly = "complete";

            stable = "stable";
          };
        in
        channel:
        let
          attr = channelToAttr.${channel};
        in
        {
          components ? [ ],
          targetComponents ? [ ],
        }:
        {
          lib,
          makeRustPlatform,
          stdenv,
        }:
        let
          inherit (lib)
            concat
            flip
            lessThan
            pipe
            sort
            toList
            ;

          inherit (packages) combine targets;

          packages = inputs.fenix.packages.${stdenv.hostPlatform.system};

          rust' =
            pipe
              [
                "cargo"
                "clippy"
                "llvm-tools"
                "rust-docs"
                "rust-src"
                "rust-std"
                "rustc"
                "rustfmt"
              ]
              [
                (baseComponents: baseComponents ++ components)
                (sort lessThan)
                packages.${attr}.withComponents
                toList
                (pipe targetComponents [
                  (map (target: targets.${target}.${attr}.rust-std))
                  (flip concat)
                ])
                combine
                (
                  rust:
                  rust.overrideAttrs (base: {
                    passthru = base.passthru // {
                      platform =
                        assert !(base.passthru ? platform);
                        makeRustPlatform {
                          cargo = rust';

                          rustc = rust';
                        };
                    };
                  })
                )
              ];
        in
        rust';
    in
    {
      miri =
        {
          lib,
          rust-runner,
          writeShellScriptBin,
        }:
        let
          inherit (lib) escapeShellArg getExe;
        in
        writeShellScriptBin "miri" ''
          exec ${escapeShellArg (getExe rust-runner)} n cargo miri "''${@}"
        '';

      rust =
        {
          exportMiri ? true,
          exportRustAnalyzer ? true,
          exportRustDoc ? true,
          exportStable ? true,
          lib,
          miri,
          rust-analyzer,
          rust-doc,
          rust-runner,
          symlinkJoin,
        }:
        symlinkJoin {
          inherit (rust-runner) meta name;

          paths =
            let
              inherit (lib) optional;
            in
            [
              rust-runner
            ]
            ++ (optional exportMiri miri)
            ++ (optional exportRustAnalyzer rust-analyzer)
            ++ (optional exportRustDoc rust-doc)
            ++ (optional exportStable rust-runner.rust-stable);
        };

      rust-doc =
        {
          coreutils,
          lib,
          rust-runner,
          writeShellScriptBin,
          xdg-utils,
        }:
        let
          inherit (lib) escapeShellArg getExe getExe';
        in
        writeShellScriptBin "rust-doc" ''
          set -eu
          case "''${#}" in
            ("0"|"1") channel="s" ;;
            ("2")
              channel="''${1}"
              shift
              ;;
            (*)
              command ${getExe' coreutils "echo"} "Got ''${#} arguments when at most two were expected!" 1>&2
              exit 1
              ;;
          esac
          if sysroot="''$(command ${escapeShellArg (getExe rust-runner)} "''${channel}" "rustc" --print "sysroot")"
          then
            exec ${escapeShellArg (getExe' xdg-utils "xdg-open")} "''${sysroot}/share/doc/rust/html''${1:+"/''${1}"}/index.html" 1>"/dev/null"
          else
            command ${getExe' coreutils "echo"} "Failed to retrieve Rust's system root path!" 1>&2
            exit 1
          fi
        '';

      rust-runner =
        let
          channels = [
            "beta"
            "nightly"
            "stable"
          ];

          src = ../../files/packages/rust-runner;
        in
        args@{
          lib,
          rust-beta,
          rust-nightly,
          rust-stable,
        }:
        let
          inherit (lib) escapeShellArg foldl' toUpper;
        in
        rust-stable.platform.buildRustPackage (self: {
          inherit src;

          cargoLock.lockFile = self.src + "/Cargo.lock";

          meta.mainProgram = "rust";

          name = "rust-runner";

          passthru = {
            inherit rust-beta rust-nightly rust-stable;
          };

          preBuild = foldl' (
            accumulator: channel:
            let
              uppercase = toUpper channel;
            in
            accumulator
            + ''
              ${uppercase}_PATH="''${out}/bin/rust-${channel}/bin"
              export ${uppercase}_PATH
            ''
          ) "" channels;

          postInstall = foldl' (
            accumulator: channel:
            accumulator
            + ''
              ln -s ${escapeShellArg args.${"rust-${channel}"}} "''${out}/bin/rust-${channel}"
            ''
          ) "" channels;
        });

      rust-beta = mkRust "beta" {
        targetComponents = [
          "wasm32-unknown-unknown"
        ];
      };

      rust-nightly = mkRust "nightly" {
        components = [
          "miri"
        ];
      };

      rust-stable = mkRust "stable" {
        targetComponents = [
          "wasm32-unknown-unknown"
        ];
      };
    };
}
