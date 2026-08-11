{
  flake.homeModules.zed-editor =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getExe;

      inherit (pkgs) libclang package-version-server packages;
    in
    {
      programs.zed-editor = {
        enable = true;

        userSettings = {
          buffer_font_size = 15;

          disable_ai = true;

          inlay_hints = {
            edit_debounce_ms = 700;

            enabled = true;

            scroll_debounce_ms = 50;

            show_background = false;

            show_other_hints = true;

            show_parameter_hints = true;

            show_type_hints = true;

            show_value_hints = true;

            toggle_on_modifiers_press = {
              alt = false;

              control = false;

              function = false;

              platform = false;

              shift = false;
            };
          };

          minimap.show = "auto";

          languages.Rust.formatter = "language_server";

          lsp = {
            clangd.binary.path = getExe libclang;

            package-version-server.binary.path = getExe package-version-server;

            rust-analyzer =
              let
                rust-analyzer = getExe packages.rust-analyzer;
              in
              {
                binary.path = rust-analyzer;

                initialization_options = {
                  assist.emitMustUse = true;

                  diagnostics.styleLints.enable = true;

                  hover.actions.references.enable = true;

                  imports = {
                    granularity.enforce = true;

                    prefix = "self";
                  };

                  inlayHints = {
                    bindingModeHints.enable = true;

                    closureCaptureHints.enable = true;

                    closureReturnTypeHints.enable = "always";

                    discriminantHints.enable = "fieldless";

                    expressionAdjustmentHints.enable = "always";

                    expressionAdjustmentHints.mode = "prefer_postfix";

                    genericParameterHints.lifetime.enable = true;

                    genericParameterHints.type.enable = true;

                    implicitDrops.enable = true;

                    implicitSizedBoundHints.enable = true;

                    lifetimeElisionHints.enable = "always";

                    lifetimeElisionHints.useParameterNames = true;

                    rangeExclusiveHints.enable = true;

                    reborrowHints.enable = "always";
                  };

                  lens.references = {
                    adt.enable = true;

                    enumVariant.enable = true;

                    method.enable = true;

                    trait.enable = true;
                  };

                  restartServerOnConfigChange = true;

                  server.path = rust-analyzer;

                  statusBar = {
                    clickAction = "stopServer";

                    showStatusBar = "always";
                  };

                  testExplorer = true;

                  workspace.symbol.search.kind = "all_symbols";
                };
              };
          };

          telemetry = {
            diagnostics = true;

            metrics = false;
          };

          theme = {
            dark = "Ayu Dark";

            light = "One Light";

            mode = "system";
          };

          ui_font_family = ".ZedMono";

          ui_font_size = 16;
        };
      };
    };
}
