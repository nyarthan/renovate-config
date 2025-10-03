{
  description = "Formeta flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        {
          pkgs,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.dprint
              pkgs.lefthook
              pkgs.nixfmt-rfc-style
              pkgs.renovate
            ];

            shellHook = ''
              export DPRINT_PLUGIN_JSON='${pkgs.dprint-plugins.dprint-plugin-json}/plugin.wasm'
              export DPRINT_PLUGIN_MARKDOWN='${pkgs.dprint-plugins.dprint-plugin-markdown}/plugin.wasm'
              lefthook install
            '';
          };
        };
    };
}
