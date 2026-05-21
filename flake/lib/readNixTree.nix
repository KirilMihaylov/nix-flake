{
  nixpkgs,
  ...
}:
{
  flake.lib.readNixTree =
    let
      readNixTree =
        let
          inherit (nixpkgs.lib)
            attrNames
            foldl'
            head
            match
            readDir
            ;
        in
        dir:
        let
          content = readDir dir;
        in
        foldl' (
          accumulator: name:
          accumulator
          // (
            let
              path = dir + "/${name}";

              buildAttr = name: value: {
                ${name} =
                  if accumulator ? ${name} then
                    throw ''Field "${name}" is duplicated as there is a directory and a ".nix"-suffixed file with that name.''
                  else
                    value;
              };
            in
            if content.${name} == "directory" then
              let
                content = readNixTree path;
              in
              if content == { } then { } else (buildAttr name content)
            else
              let
                matches = match "(.+)\.nix" name;
              in
              if matches == null then { } else (buildAttr (head matches) path)
          )
        ) { } (attrNames content);
    in
    readNixTree;
}
