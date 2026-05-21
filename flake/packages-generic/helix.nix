{
  inputs,
  self,
  ...
}:
{
  flake.packages-generic = {
    helix =
      let
        inherit (inputs.helix) packages shortRev;
      in
      {
        stdenv,
      }:
      packages.${stdenv.hostPlatform.system}.default.overrideAttrs (base: {
        pname =
          assert !(base ? pname);
          "helix";

        version =
          assert !(base ? version);
          shortRev;
      });

    helix' =
      {
        config-file,
        helix,
        lib,
        makeBinaryWrapper,
        symlinkJoin,
      }:
      self.lib.wrapBinary
        {
          inherit lib makeBinaryWrapper symlinkJoin;
        }
        helix
        [
          "--config"
          config-file
        ];

    helix-config =
      {
        formats,
      }:
      (formats.toml { }).generate "helix-config.toml" {
        editor = {
          atomic-save = true;

          auto-completion = true;

          auto-format = true;

          auto-info = true;

          auto-pairs = {
            "\"" = "\"";
            "(" = ")";
            "[" = "]";
            "`" = "`";
            "{" = "}";
          };

          auto-save = {
            after-delay = {
              enable = false;

              timeout = 3000;
            };

            focus-lost = false;
          };

          bufferline = "always";

          clipboard-provider = "wayland";

          color-modes = true;

          completion-replace = false;

          completion-timeout = 25;

          completion-trigger-len = 0;

          cursor-shape = {
            insert = "bar";

            normal = "bar";

            select = "bar";
          };

          cursorcolumn = false;

          cursorline = true;

          default-line-ending = "native";

          default-yank-register = ''"'';

          editor-config = true;

          end-of-line-diagnostics = "disable";

          file-picker = {
            deduplicate-links = false;

            follow-symlinks = true;

            git-exclude = true;

            git-global = true;

            git-ignore = true;

            hidden = true;

            ignore = true;

            parents = true;
          };

          gutters = {
            layout = [
              "diagnostics"
              "spacer"
              "line-numbers"
              "spacer"
              "diff"
            ];

            line-numbers.min-width = 1;
          };

          idle-timeout = 250;

          indent-guides = {
            character = "╎";

            render = true;

            skip-levels = 0;
          };

          indent-heuristic = "hybrid";

          inline-diagnostics = {
            cursor-line = "hint";

            max-diagnostics = 10;

            max-wrap = 20;

            other-lines = "hint";

            prefix-len = 1;
          };

          insert-final-newline = true;

          jump-label-alphabet = "abcdefghijklmnopqrstuvwxyz";

          line-number = "relative";

          lsp = {
            auto-signature-help = true;

            display-color-swatches = true;

            display-inlay-hints = true;

            display-messages = true;

            display-progress-messages = false;

            display-signature-help-docs = true;

            enable = true;

            goto-reference-include-declaration = false;

            snippets = false;
          };

          middle-click-paste = true;

          mouse = true;

          popup-border = "all";

          preview-completion-insert = true;

          rulers = [
            40
            80
            120
          ];

          scroll-lines = 3;

          scrolloff = 5;

          search = {
            smart-case = true;

            wrap-around = true;
          };

          shell = [
            "sh"
            "-c"
          ];

          smart-tab = {
            enable = false;

            supersede-menu = false;
          };

          soft-wrap = {
            enable = true;

            max-indent-retain = 20;

            max-wrap = 20;

            wrap-at-text-width = false;

            wrap-indicator = "↪";
          };

          statusline = {
            center = [
              "position"
              "primary-selection-length"
              "selections"
              "register"
            ];

            diagnostics = [
              "warning"
              "error"
            ];

            left = [
              "mode"
              "spinner"
              "file-name"
              "file-encoding"
              "read-only-indicator"
              "file-modification-indicator"
            ];

            mode = {
              insert = "INSERT";
              normal = "NORMAL";
              select = "SELECT";
            };

            right = [
              "total-line-numbers"
              "spacer"
              "register"
              "spacer"
              "diagnostics"
              "spacer"
              "workspace-diagnostics"
              "spacer"
              "version-control"
            ];

            separator = "|";

            workspace-diagnostics = [
              "warning"
              "error"
            ];
          };

          text-width = 80;

          trim-final-newlines = true;

          trim-trailing-whitespace = true;

          true-color = false;

          undercurl = false;

          whitespace = {
            characters = {
              nbsp = "⍽";

              newline = "⏎";

              nnbsp = "␣";

              space = "·";

              tab = "→";

              tabpad = "·";
            };

            render = {
              nbsp = "none";

              newline = "none";

              nnbsp = "none";

              space = "none";

              tab = "all";
            };
          };

          workspace-lsp-roots = [ ];
        };

        keys = {
          insert = {
            C-end = [
              "goto_file_end"
              "goto_line_start"
            ];

            C-home = "goto_file_start";

            C-space = "completion";
          };

          normal = {
            C-d = "hover";

            C-end = [
              "goto_file_end"
              "goto_line_start"
            ];

            C-home = "goto_file_start";

            S-tab = "unindent";

            tab = "indent";
          };

          select = {
            C-end = [
              "goto_file_end"
              "goto_line_start"
            ];

            C-home = "goto_file_start";

            S-tab = "unindent";

            tab = "indent";
          };
        };

        theme = "dark_plus";
      };
  };
}
