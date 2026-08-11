{
  flake.nixosModules'.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getExe;

      inherit (pkgs) less packages;
    in
    {
      environment = {
        sessionVariables =
          let
            helix = getExe config.programs.helix.package;
          in
          {
            EDITOR = helix;

            PAGER = getExe less;

            VISUAL = helix;
          };

        systemPackages =
          with pkgs;
          [
            bashInteractive
            coreutils
            cryptsetup
            curl
            dash
            fastfetch
            fd
            file
            fuse3
            fzf
            gnutar
            gzip
            jaq
            libressl
            most
            nano
            nix-tree
            polkit
            procs
            ripgrep
            rsync
            sequoia-sq
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
        };

        vim.enable = true;

        zoxide = {
          enable = true;

          flags = [
            "--cmd cd"
          ];
        };
      };
    };
}
