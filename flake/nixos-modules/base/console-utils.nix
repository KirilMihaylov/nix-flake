{
  flake.nixosModules.console-utils =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getExe;

      inherit (pkgs) most packages;
    in
    {
      environment = {
        sessionVariables =
          let
            helix = getExe config.programs.helix.package;
          in
          {
            EDITOR = helix;

            PAGER = getExe most;

            VISUAL = helix;
          };

        systemPackages =
          with pkgs;
          [
            bashInteractive
            coreutils
            curl
            dash
            fd
            fuse3
            fzf
            gnutar
            gzip
            jq
            libressl
            most
            nano
            nix-tree
            polkit
            procs
            ripgrep
            rsync
            smartmontools
            util-linux
            wget
            xz
            yazi
            zellij
            zip
            zstd
          ]
          ++ (with fishPlugins; [
            done
            forgit
            fzf-fish
            hydro
          ])
          ++ (with packages; [
            enter-fhs
          ]);
      };

      programs = {
        bat.enable = true;

        direnv = {
          enable = true;

          loadInNixShell = true;
        };

        fish.enable = true;

        htop.enable = true;

        less.enable = true;

        nix-index = {
          enable = true;

          enableBashIntegration = false;

          enableFishIntegration = true;

          enableZshIntegration = false;

          package = packages.nix-index;
        };

        vim.enable = true;
      };
    };
}
