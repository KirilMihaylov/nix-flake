{
  flake.packages-generic.vscodium' =
    {
      rust-analyzer-vscode,
      vscode-extensions,
      vscode-with-extensions,
      vscodium,
    }:
    (vscode-with-extensions.override {
      vscode = vscodium.override {
        commandLineArgs = "--wayland-text-input-version=3";
      };

      vscodeExtensions = [
        rust-analyzer-vscode
      ]
      ++ (with vscode-extensions; [
        eamodio.gitlens
        golang.go
        jnoortheen.nix-ide
        llvm-vs-code-extensions.vscode-clangd
        llvm-vs-code-extensions.lldb-dap
        mkhl.direnv
        mkhl.shfmt
        ms-azuretools.vscode-docker
        ms-vscode.hexeditor
        nimlang.nimlang
        redhat.vscode-xml
        redhat.vscode-yaml
        tamasfe.even-better-toml
        ziglang.vscode-zig
      ]);
    }).overrideAttrs
      {
        inherit (vscodium)
          meta
          name
          outputs
          passthru
          pname
          version
          ;
      };
}
