{
  flake.nixosModules.rust-development =
    {
      pkgs,
      lib,
      ...
    }:
    {
      environment.systemPackages =
        with pkgs;
        let
          inherit (packages) rust-analyzer rust-stable;
        in
        [
          cargo-audit
          cargo-deny
          cargo-nextest
          rust-analyzer
          rust-stable
          (
            let
              inherit (lib) getExe';

              echo = getExe' coreutils "echo";

              test = getExe' coreutils "test";
            in
            writeShellScriptBin "rust-doc" ''
              set -eu

              case "''${#}" in
                ("0" | "1") ;;
                (*)
                  "${echo}" \
                    "Expected at most one argument!" \
                    >&2

                  exit "1"
              esac

              docs_path="${rust-stable + /share/doc/rust/html}"

              if "${test}" -n "''${1+"set"}"
              then
                docs_path="''${docs_path}/''${1}"

                if ! "${test}" -d "''${docs_path}"
                then
                  "${echo}" \
                    "No such subdirectory \"''${1}\" exists!" \
                    >&2
                fi
              fi

              "${getExe' xdg-utils "xdg-open"}" "''${docs_path}/index.html"
            ''
          )
        ];
    };
}
