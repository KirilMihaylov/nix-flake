{
  inputs,
  self,
  ...
}:
{
  flake.packages' = {
    helix' =
      {
        config-file,
        helix,
        lib,
        makeBinaryWrapper,
        pkgs,
        symlinkJoin,
      }:
      let
        inherit (helix) pname;

        inherit (lib)
          flip
          id
          pipe
          readFile
          ;

        flake = inputs.helix;
      in
      pipe flake.overlays.default [
        pkgs.extend
        (
          pkgs:
          pkgs.helix.override {
            includeGrammarIf =
              {
                name,
                ...
              }:
              name != "perl";
          }
        )
        (helix: helix.overrideAttrs)
        (flip id (
          base:
          assert !(base ? pname);
          assert !(base ? version);
          {
            inherit pname;

            version = pipe (flake + /Cargo.toml) [
              readFile
              fromTOML
              (manifest: manifest.workspace.package.version)
            ];
          }
        ))
        (self.lib.wrapBinary {
          inherit lib makeBinaryWrapper symlinkJoin;
        })
        (flip id [
          "--config"
          config-file
        ])
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

          auto-pairs = { };

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

          completion-replace = true;

          completion-timeout = 50;

          completion-trigger-len = 2;

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

          line-number = "absolute";

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

          middle-click-paste = false;

          mouse = true;

          popup-border = "all";

          preview-completion-insert = true;

          rulers = [
            40
            80
            120
            160
            200
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
            C-d = "hover";

            C-end = "goto_file_end";

            C-home = "goto_file_start";

            C-space = "completion";

            S-tab = "unindent";

            end = "goto_line_end_newline";
          };

          normal = {
            C-d = "hover";

            C-end = "goto_file_end";

            C-home = "goto_file_start";

            C-space = [
              "insert_mode"
              "completion"
            ];

            S-tab = "unindent";

            end = "goto_line_end_newline";

            tab = "indent";
          };

          select = {
            C-d = "hover";

            C-end = "goto_file_end";

            C-home = "goto_file_start";

            C-space = [
              "delete_selection_noyank"
              "insert_mode"
              "completion"
            ];

            S-tab = "unindent";

            tab = "indent";
          };
        };

        theme = "dark_plus";
      };
  };
}
