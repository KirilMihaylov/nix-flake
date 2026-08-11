{
  inputs,
  self,
  ...
}:
{
  flake.packages' = {
    firefox =
      args@{
        firefox-unwrapped',
        wrapFirefox,
        ...
      }:
      (wrapFirefox firefox-unwrapped' { }).override (
        removeAttrs args [
          "firefox-unwrapped'"
          "wrapFirefox"
        ]
      );

    firefox-unwrapped =
      args@{
        buildMozillaMach,
        firefox-unwrapped,
        jaq,
        lib,
        ...
      }:
      let
        inherit (lib)
          concat
          filesystem
          flip
          pipe
          ;
      in
      (buildMozillaMach {
        inherit (firefox-unwrapped)
          meta
          pname
          src
          tests
          version
          ;

        extraNativeBuildInputs = [
          jaq
        ];

        extraPatches =
          pipe
            [
              "disable-data-reporting-at-compile-time"
              "eme-migrator"
              "extensions-setUninstallURL"
              "firefox-in-ua"
              "hide-disabled-urlbar-suggests"
              "include-policy-deletion"
              "link-preview"
              "newtab-fix"
              "remove-pingsender"
              "remove-openai"
              "ui-patches/eme-enable"
            ]
            [
              (map (name: inputs.librewolf + "/patches/${name}.patch"))
              (pipe (self + "/files/patches/firefox") [
                filesystem.listFilesRecursive
                (flip concat)
              ])
            ];

        extraPostPatch = ''
          rm -R {browser/{components/{aiwindow,contentanalysis,firefoxview,genai,passwordmgr,prompts,referrals,sharing,sidebar,syncedtabs,textrecognition,uitour},locales-preview/aiWindow.ftl},toolkit/components/{ml/{content/backends/OpenAIPipeline.mjs,vendor/openai},normandy}}

          find 'browser/locales/' -name 'aiWindow.ftl' -o -name 'genai.ftl' -o -name 'onboarding.ftl' -delete

          jaq \
            -c \
            -i \
            --arg old_lib 'c20989b1aa336b0849e96ec1b2beea1eab825ffd192c2c3a636e20f830b811d0' \
            --arg new_lib '0b43fbc5f86c6c247c5189af58be425a829c3b09018c6b26589661eec9a5ad24' \
            --arg old_mod '5bc8c9bbe8c0eabe408d9a7cd7a8e6e09eee0ead817607643882b38a36d07c91' \
            --arg new_mod 'bddacbe056ce7458663a39dc99d5bb3434099aa69cae793cf0c57d4e54f5a6a4' \
            --arg err_msg "Hashes don't match expected ones!" \
            'if (.files | ."src/lib.rs" == $old_lib and ."src/core/mod.rs" == $old_mod) then .files += { "src/lib.rs": $new_lib, "src/core/mod.rs": $new_mod } else $err_msg | error end' \
            'third_party/rust/glean-core/.cargo-checksum.json'
        '';
      }).override
        (
          removeAttrs args [
            "buildMozillaMach"
            "firefox-unwrapped"
            "jaq"
          ]
        );

    firefox-unwrapped' =
      {
        firefox-unwrapped,
      }:
      firefox-unwrapped.override {
        enableCrashReporter = false;

        enableDataReporting = false;

        enableLocation = false;

        enableWebRTC = true;

        withGSSAPI = false;
      };
  };
}
