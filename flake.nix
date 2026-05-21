{
  description = "NixOS system configuration flake.";

  inputs = {
    bore-scheduler = {
      flake = false;

      url = "github:firelzrd/bore-scheduler";
    };

    fenix = {
      inputs.nixpkgs.follows = "nixpkgs";

      url = "github:nix-community/fenix";
    };

    flake-compat.url = "github:NixOS/flake-compat";

    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";

      url = "github:hercules-ci/flake-parts";
    };

    helix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";

        rust-overlay.follows = "rust";
      };

      url = "github:helix-editor/helix";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";

      url = "github:nix-community/home-manager";
    };

    niri = {
      inputs = {
        nixpkgs.follows = "nixpkgs";

        rust-overlay.follows = "rust";
      };

      url = "github:niri-wm/niri";
    };

    nix-index = {
      inputs = {
        flake-compat.follows = "flake-compat";

        nixpkgs.follows = "nixpkgs";
      };

      url = "github:nix-community/nix-index";
    };

    nixos-hardware = {
      inputs.nixpkgs.follows = "nixpkgs";

      url = "github:NixOS/nixos-hardware";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia-shell = {
      inputs = {
        nixpkgs.follows = "nixpkgs";

        noctalia-qs.follows = "noctalia-qs";
      };

      url = "github:noctalia-dev/noctalia-shell/v4.7.7";
    };

    noctalia-qs = {
      inputs.nixpkgs.follows = "nixpkgs";

      url = "github:noctalia-dev/noctalia-qs";
    };

    rust = {
      inputs.nixpkgs.follows = "nixpkgs";

      url = "github:oxalica/rust-overlay";
    };

    turso = {
      flake = false;

      url = "github:tursodatabase/turso/v0.6.1";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      (
        {
          lib,
          ...
        }:
        let
          inherit (lib)
            filesystem
            filter
            hasSuffix
            sources
            ;
        in
        {
          imports = filter (hasSuffix ".nix") (
            filesystem.listFilesRecursive ((sources.cleanSource ./.) + /flake)
          );
        }
      );
}
