{
  flake.packages'.proton-ge-bin' =
    {
      fetchzip,
      proton-ge-bin,
      stdenv,
    }:
    proton-ge-bin.overrideAttrs (_: rec {
      src = fetchzip {
        hash = "sha256-rX27DUrrrHtR1cgyr/424m9JPjrdASIisVGv2vWzMAs=";

        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}-${stdenv.hostPlatform.uname.processor}.tar.gz";
      };

      version = "GE-Proton11-6";
    });
}
