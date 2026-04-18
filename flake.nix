{
  description = "mako - Lightweight Wayland notification daemon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          mako = pkgs.mako.overrideAttrs (old: {
            src = self;
            postPatch = (old.postPatch or "") + ''
              rm -rf build
            '';
          });
        in
        {
          inherit mako;
          default = mako;
        }
      );

      overlays.default = final: prev: {
        mako = self.packages.${final.stdenv.hostPlatform.system}.mako;
      };
    };
}
