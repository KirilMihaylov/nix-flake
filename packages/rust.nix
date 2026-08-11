{
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (builtins) path;

  inherit (lib)
    concat
    escapeShellArg
    flip
    lessThan
    pipe
    sort
    toList
    ;

  fenix =
    let
      index-fenix = pkgs: pkgs.fenix;

      overlay-pipe = pipe inputs.fenix.overlays.default;
    in
    {
      pkgs,
    }:
    overlay-pipe [
      (pkgs.extend)
      index-fenix
    ];

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
      makeRustPlatform,
      pkgs,
    }:
    let
      inherit (fenix') combine targets;

      inherit (fenix'.${attr}) withComponents;

      fenix' = fenix {
        inherit pkgs;
      };

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
            (flip concat components)
            (sort lessThan)
            withComponents
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
      rust-runner,
      writeShellApplication,
    }:
    writeShellApplication {
      name = "miri";

      runtimeInputs = toList rust-runner;

      text = ''exec ${escapeShellArg rust-runner.meta.mainProgram} n cargo miri "$@"'';
    };

  rust-analyzer =
    {
      pkgs,
    }:
    (fenix {
      inherit pkgs;
    }).rust-analyzer;

  rust-analyzer-vscode =
    {
      pkgs,
    }:
    (fenix {
      inherit pkgs;
    }).rust-analyzer-vscode-extension;

  rust-beta = mkRust "beta" {
    targetComponents = [
      "wasm32-unknown-unknown"
    ];
  };

  rust-doc =
    {
      rust-runner,
      writeShellApplication,
      xdg-utils,
    }:
    writeShellApplication {
      name = "rust-doc";

      runtimeInputs = [
        rust-runner
        xdg-utils
      ];

      text = ''
        case "$#" in
          ('0'|'1') channel='s';;
          ('2')
            channel="$1"

            shift
            ;;
          (*)
            echo "Got $# arguments when at most two are expected!" 1>&2

            exit 1
        esac

        if sysroot="$(${escapeShellArg rust-runner.meta.mainProgram} "$channel" 'rustc' --print 'sysroot')"
        then
          exec 'xdg-open' "$sysroot/share/doc/rust/html''${1:+"/$1"}/index.html" 1>'/dev/null'
        else
          echo "Failed to retrieve Rust's system root path!" 1>&2

          exit 1
        fi
      '';
    };

  rust-nightly = mkRust "nightly" {
    components = [
      "miri"
    ];
  };

  rust-runner =
    let
      channels = [
        "beta"
        "nightly"
        "stable"
      ];

      src = path {
        name = "source";

        path = self + "/files/packages/rust-runner";
      };
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
    rust-stable.platform.buildRustPackage (final: {
      inherit src;

      cargoLock.lockFile = final.src + "/Cargo.lock";

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

  rust-stable = mkRust "stable" {
    targetComponents = [
      "wasm32-unknown-unknown"
    ];
  };

  rust-toolchain =
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
}
