{
  flake.lib.attrByPathOrElse =
    let
      inherit (builtins)
        head
        isAttrs
        isFunction
        isList
        tail
        ;

      f =
        or_else:
        let
          f =
            path: attrs:
            if path == [ ] then
              attrs
            else
              let
                attr = head path;
              in
              if attrs ? ${attr} then
                assert isAttrs attrs;
                f (tail path) (attrs.${attr})
              else
                or_else {
                  inherit attrs path;
                };
        in
        f;
    in
    path:
    assert isList path;
    or_else:
    assert isFunction or_else;
    f or_else path;
}
