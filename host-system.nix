let
  inherit (builtins) readFile;

  host = readFile <host>;

  system = import ./system.nix;
in
system.${host}
