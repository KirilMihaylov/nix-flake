{
  flake.nixosModules'.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        attrsToList
        boolToString
        concatMap
        escapeShellArg
        flip
        getExe
        isBool
        join
        mkIf
        pipe
        ;

      inherit (pkgs) less packages tmuxPlugins;

      tmuxConfig = flip pipe [
        attrsToList
        (concatMap (
          {
            name,
            value,
          }:
          let
            option = name;
          in
          pipe value [
            attrsToList
            (map (
              {
                name,
                value,
              }:
              let
                mapValue = if isBool value then boolToString else toString;
              in
              "${option} ${name} ${mapValue value}\n"
            ))
          ]
        ))
        (join "\n")
      ];
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

        fish = {
          enable = true;

          interactiveShellInit =
            let
              inherit (config.programs.tmux) enable package;
            in
            mkIf enable ''
              if not set -q 'TMUX'
                  exec ${
                    pipe package [
                      getExe
                      escapeShellArg
                    ]
                  } new-session
              end
            '';
        };

        htop.enable = true;

        less.enable = true;

        nix-index = {
          enable = true;

          enableBashIntegration = false;

          enableFishIntegration = true;

          enableZshIntegration = false;
        };

        tmux = {
          aggressiveResize = true;

          baseIndex = 1;

          clock24 = true;

          enable = true;

          escapeTime = 0;

          extraConfig = tmuxConfig {
            bind-key = {
              p = "previous-window";

              n = "next-window";

              x = "kill-pane";
            };

            "set-option -g" = {
              allow-rename = "off";

              allow-set-title = "on";

              automatic-rename = "on";

              detach-on-destroy = "on";

              display-time = 0;

              exit-empty = "on";

              extended-keys = "on";

              focus-events = "on";

              message-line = 1;

              mouse = "on";

              remain-on-exit = "failed-key";

              renumber-windows = "on";

              set-titles = "on";

              status = "on";
            };
          };

          extraConfigBeforePlugins = tmuxConfig {
            "set-option -g" = {
              "@dracula-clients-minimum" = 1;

              "@dracula-clients-plural" = ''"clients"'';

              "@dracula-clients-singular" = ''"client"'';

              "@dracula-plugins" =
                pipe
                  [
                    "cpu-usage"
                    "ram-usage"
                    "gpu-info"
                    "ssh-session"
                    "synchronize-panes"
                    "time"
                    "cpu-arch"
                    "attached-clients"
                  ]
                  [
                    (join " ")
                    (value: ''"${value}"'')
                  ];

              "@dracula-refresh-rate" = 10;

              "@dracula-show-battery" = false;

              "@dracula-show-powerline" = false;

              "@dracula-show-ssh-only-when-connected" = true;

              "@dracula-synchronize-panes-auto-hide" = true;

              "@dracula-synchronize-panes-label" = "Sync";

              "@dracula-time-format" = ''"%R"'';
            };
          };

          historyLimit = 5000;

          newSession = false;

          plugins = with tmuxPlugins; [
            dracula
            resurrect
          ];

          secureSocket = true;

          shortcut = "a";

          keyMode = "vi";

          terminal = "tmux-direct";
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
