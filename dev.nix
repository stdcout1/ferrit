{
  perSystem = { pkgs, self', ... }:
    let
      devShells.default = self'.devenv.default;
    in

    {
      packages.container = pkgs.dockerTools.buildImageWithNixDb
        {
          name = "ihp-dev";
          tag = "latest";
          copyToRoot = pkgs.buildEnv {
            name = "ihp-dev-root";
            paths =
              (devShells.default.buildInputs or [ ])
              ++ (devShells.default.nativeBuildInputs or [ ]);
            pathsToLink = [ "/bin" "/lib" "/share" ];
          };
          config = {
            Cmd = [ "${pkgs.bashInteractive}/bin/bash" ];
            WorkingDir = "/workspaces";
            Env = [ "PATH=/bin" "DEVSHELL=1" ];
          };
        };

    };
}
