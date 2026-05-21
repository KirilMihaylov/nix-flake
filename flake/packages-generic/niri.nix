{
  inputs,
  ...
}:
{
  flake.packages-generic = {
    niri =
      {
        stdenv,
      }:
      inputs.niri.packages.${stdenv.hostPlatform.system}.default;

    niri-config =
      {
        extraConfig ? "",
        fuzzel,
        lib,
        noctalia-shell,
        systemd,
        terminal,
        writeText,
        xwayland-satellite,
      }:
      let
        inherit (lib)
          foldl'
          getExe
          getExe'
          getName
          ;

        noctalia-shell' = ''"${getExe noctalia-shell}"'';

        noctalia-ipc =
          target: args:
          ''${noctalia-shell'} "ipc" "call" "${target}"${
            foldl' (accumulator: arg: ''${accumulator} "${arg}"'') "" args
          }'';
      in
      writeText "niri-config.kdl" ''
        binds {
          Mod+Shift+Slash { show-hotkey-overlay; }

          Mod+T hotkey-overlay-title="Open a Terminal: ${getName terminal}" { spawn "${getExe terminal}"; }

          Mod+D hotkey-overlay-title="Run an Application: fuzzel" { spawn "${getExe fuzzel}"; }

          Super+L hotkey-overlay-title="Lock the Screen" { spawn ${
            noctalia-ipc "lockScreen" [
              "lock"
            ]
          }; }

        ${foldl'
          (
            let
              logout = ''"${getExe' systemd "systemctl"}" "--user" "stop" "graphical-session.target"'';
            in
            accumulator: bind: ''
              ${accumulator}  ${bind} hotkey-overlay-title="Logout" { spawn ${logout}; }
            ''
          )
          ""
          [
            "Mod+Shift+M    "
            "Ctrl+Alt+Delete"
          ]
        }

          XF86AudioRaiseVolume allow-when-locked=true { spawn ${
            noctalia-ipc "volume" [
              "increase"
            ]
          }; }
          XF86AudioLowerVolume allow-when-locked=true { spawn ${
            noctalia-ipc "volume" [
              "decrease"
            ]
          }; }
          XF86AudioMute        allow-when-locked=true { spawn ${
            noctalia-ipc "volume" [
              "muteOutput"
            ]
          }; }
          XF86AudioMicMute                            { spawn ${
            noctalia-ipc "volume" [
              "muteInput"
            ]
          }; }

          XF86AudioPlay allow-when-locked=true { spawn ${
            noctalia-ipc "media" [
              "playPause"
            ]
          }; }
          XF86AudioStop allow-when-locked=true { spawn ${
            noctalia-ipc "media" [
              "pause"
            ]
          }; }
          XF86AudioPrev allow-when-locked=true { spawn ${
            noctalia-ipc "media" [
              "previous"
            ]
          }; }
          XF86AudioNext allow-when-locked=true { spawn ${
            noctalia-ipc "media" [
              "next"
            ]
          }; }

          XF86MonBrightnessUp   allow-when-locked=true { spawn ${
            noctalia-ipc "brightness" [
              "increase"
            ]
          }; }
          XF86MonBrightnessDown allow-when-locked=true { spawn ${
            noctalia-ipc "brightness" [
              "decrease"
            ]
          }; }

          Mod+O repeat=false hotkey-overlay-title="Toggle Overview" { toggle-overview; }

          Mod+Q repeat=false hotkey-overlay-title="Close Window" { close-window; }

          Mod+Left  hotkey-overlay-title="Move Focus Left"  { focus-column-left; }
          Mod+Down  hotkey-overlay-title="Move Focus Down"  { focus-window-or-workspace-down; }
          Mod+Up    hotkey-overlay-title="Move Focus Up"    { focus-window-or-workspace-up; }
          Mod+Right hotkey-overlay-title="Move Focus Right" { focus-column-right; }

          Mod+Ctrl+Left  { move-column-left; }
          Mod+Ctrl+Down  { move-window-down-or-to-workspace-down; }
          Mod+Ctrl+Up    { move-window-up-or-to-workspace-up; }
          Mod+Ctrl+Right { move-column-right; }

          Mod+Home      { focus-column-first; }
          Mod+End       { focus-column-last; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End  { move-column-to-last; }

          Mod+Shift+Left  { focus-monitor-left; }
          Mod+Shift+Down  { focus-monitor-down; }
          Mod+Shift+Up    { focus-monitor-up; }
          Mod+Shift+Right { focus-monitor-right; }

          Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }

          Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
          Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }

          Mod+Shift+Page_Down hotkey-overlay-title="Move Workspace Down" { move-workspace-down; }
          Mod+Shift+Page_Up   hotkey-overlay-title="Move Workspace Up"   { move-workspace-up; }

          Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
          Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

          Mod+WheelScrollRight      { focus-column-right; }
          Mod+WheelScrollLeft       { focus-column-left; }
          Mod+Ctrl+WheelScrollRight { move-column-right; }
          Mod+Ctrl+WheelScrollLeft  { move-column-left; }

          Mod+Shift+WheelScrollDown      { focus-column-right; }
          Mod+Shift+WheelScrollUp        { focus-column-left; }
          Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
          Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

          Mod+BracketLeft  { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }

          Mod+Comma  hotkey-overlay-title="Consume Window Into Column" { consume-window-into-column; }
          Mod+Period hotkey-overlay-title="Expel Window From Column"   { expel-window-from-column; }

          Mod+F       hotkey-overlay-title="Maximize Column"   { maximize-column; }
          Mod+Shift+F hotkey-overlay-title="Toggle Fullscreen" { fullscreen-window; }

          Mod+Minus hotkey-overlay-title="Decrease Window Width" { set-column-width "-10%"; }
          Mod+Equal hotkey-overlay-title="Increase Window Width" { set-column-width "+10%"; }

          Mod+Shift+Minus hotkey-overlay-title="Decrease Window Height" { set-window-height "-10%"; }
          Mod+Shift+Equal hotkey-overlay-title="Increase Window Height" { set-window-height "+10%"; }

          Mod+V       hotkey-overlay-title="Toggle Floating Window"                   { toggle-window-floating; }
          Mod+Shift+V hotkey-overlay-title="Switch Focus Between Floating And Tiling" { switch-focus-between-floating-and-tiling; }

          Mod+W hotkey-overlay-title="Toggle Tabbed Display" { toggle-column-tabbed-display; }

          Mod+S      hotkey-overlay-title="Screenshot Area"   { screenshot; }
          Print      hotkey-overlay-title="Screenshot Area"   { screenshot; }
          Alt+Print  hotkey-overlay-title="Screenshot Window" { screenshot-window; }
          Ctrl+Print hotkey-overlay-title="Screenshot Screen" { screenshot-screen; }

          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
        }

        clipboard {
          disable-primary
        }

        hotkey-overlay {
          hide-not-bound

          skip-at-startup
        }

        input {
          keyboard {
            numlock
          }

          touchpad {
            disabled-on-external-mouse

            natural-scroll

            scroll-method "two-finger"

            tap
          }
        }

        layout {
          always-center-single-column

          border {
            active-color "#ffc87f"

            inactive-color "#505050"

            off

            urgent-color "#9b0000"

            width 4
          }

          default-column-width { proportion 0.5; }

          empty-workspace-above-first

          focus-ring {
            width 4

            active-color "#7fc8ff"

            inactive-color "#505050"
          }

          gaps 16

          shadow {
            color "#0007"

            offset x=0 y=5

            softness 30

            spread 5
          }
        }

        prefer-no-csd

        screenshot-path null

        spawn-at-startup ${noctalia-shell'}

        xwayland-satellite {
          path "${getExe xwayland-satellite}"
        }

        ${extraConfig}
      '';
  };
}
