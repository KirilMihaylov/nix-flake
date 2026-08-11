{
  flake.overlays.patch-brave-src =
    final: prev:
    let
      name = "brave-origin";
    in
    {
      ${name} = prev.${name}.overrideAttrs (base: rec {
        version = "1.98.60";

        src = final.fetchurl {
          hash = "sha256-VKBbHBK684D7dwqyhhwh87uQJfU3VQ9tNEHxre9S5jk=";

          url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-origin_${version}_amd64.deb";
        };
      });
    };
}
