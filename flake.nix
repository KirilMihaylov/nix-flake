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

    niri-sticky-window = {
      flake = false;

      url = "github:KirilMihaylov/niri-sticky-window";
    };

    nixos-hardware = {
      inputs.nixpkgs.follows = "nixpkgs";

      url = "github:NixOS/nixos-hardware";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    rust = {
      inputs.nixpkgs.follows = "nixpkgs";

      url = "github:oxalica/rust-overlay";
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
