{
  description = "Application layer for UnveilingPartner's PythonEDA realm";
  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    pythoneda-base = {
      url = "github:pythoneda/base/0.0.1a18";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pythoneda-infrastructure-base = {
      url = "github:pythoneda-infrastructure/base/0.0.1a12";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-application-base = {
      url = "github:pythoneda-application/base/0.0.1a11";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-infrastructure-base.follows =
        "pythoneda-infrastructure-base";
    };
    pythoneda-artifact-event-changes = {
      url = "github:pythoneda-artifact-event/changes/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-artifact-shared-changes.follows =
        "pythoneda-artifact-shared-changes";
    };
    pythoneda-artifact-event-git-tagging = {
      url = "github:pythoneda-artifact-event/git-tagging/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-artifact-event-infrastructure-changes = {
      url = "github:pythoneda-artifact-event-infrastructure/changes/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-artifact-event-changes.follows =
        "pythoneda-artifact-event-changes";
    };
    pythoneda-artifact-event-infrastructure-git-tagging = {
      url =
        "github:pythoneda-artifact-event-infrastructure/git-tagging/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-artifact-event-git-tagging.follows =
        "pythoneda-artifact-event-git-tagging";
    };
    pythoneda-artifact-shared-changes = {
      url = "github:pythoneda-artifact-shared/changes/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-realm-unveilingpartner = {
      url = "github:pythoneda-realm/unveilingpartner/0.0.1a2";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-artifact-event-git-tagging.follows =
        "pythoneda-artifact-event-git-tagging";
      inputs.pythoneda-shared-git.follows = "pythoneda-shared-git";
    };
    pythoneda-realm-infrastructure-unveilingpartner = {
      url = "github:pythoneda-realm-infrastructure/unveilingpartner/0.0.1a2";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-infrastructure-base.follows =
        "pythoneda-infrastructure-base";
      inputs.pythoneda-realm-unveilingpartner.follows =
        "pythoneda-realm-unveilingpartner";
      inputs.pythoneda-shared-git.follows = "pythoneda-shared-git";
    };
    pythoneda-shared-git = {
      url = "github:pythoneda-shared/git/0.0.1a4";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        pname = "pythoneda-realm-application-unveilingpartner";
        description =
          "Application layer for UnveilingPartner's PythonEDA realm";
        license = pkgs.lib.licenses.gpl3;
        homepage =
          "https://github.com/pythoneda-realm-application/unveilingpartner";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./nix/shared.nix;
        pythonpackage = "pythonedarealmapplicationunveilingpartner";
        entrypoint = "${pythonpackage}/${pname}.py";
        pythoneda-realm-application-unveilingpartner-for = { python
          , pythoneda-application-base, pythoneda-artifact-event-changes
          , pythoneda-artifact-event-git-tagging
          , pythoneda-artifact-event-infrastructure-changes
          , pythoneda-artifact-event-infrastructure-git-tagging
          , pythoneda-artifact-shared-changes, pythoneda-base
          , pythoneda-infrastructure-base, pythoneda-realm-unveilingpartner
          , pythoneda-realm-infrastructure-unveilingpartner
          , pythoneda-shared-git, version }:
          let
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            src = ./.;
            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              dbus-next
              grpcio
              oauth2
              pythoneda-application-base
              pythoneda-artifact-event-changes
              pythoneda-artifact-event-git-tagging
              pythoneda-artifact-event-infrastructure-changes
              pythoneda-artifact-event-infrastructure-git-tagging
              pythoneda-artifact-shared-changes
              pythoneda-base
              pythoneda-infrastructure-base
              pythoneda-realm-infrastructure-unveilingpartner
              pythoneda-realm-unveilingpartner
              pythoneda-shared-git
              requests
              requests-oauthlib
              unidiff
            ];

            checkInputs = with python.pkgs; [ pytest ];

            pythonImportsCheck = [ pythonpackage ];

            preBuild = ''
              python -m venv .env
              source .env/bin/activate
              pip install ${pythoneda-base}/dist/pythoneda_base-${pythoneda-base.version}-py3-none-any.whl
              pip install ${pythoneda-infrastructure-base}/dist/pythoneda_infrastructure_base-${pythoneda-infrastructure-base.version}-py3-none-any.whl
              pip install ${pythoneda-application-base}/dist/pythoneda_application_base-${pythoneda-application-base.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-event-changes}/dist/pythoneda_artifact_event_changes-${pythoneda-artifact-event-changes.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-event-git-tagging}/dist/pythoneda_artifact_event_git_tagging-${pythoneda-artifact-event-git-tagging.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-event-infrastructure-changes}/dist/pythoneda_artifact_event_infrastructure_changes-${pythoneda-artifact-event-infrastructure-changes.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-event-infrastructure-git-tagging}/dist/pythoneda_artifact_event_infrastructure_git_tagging-${pythoneda-artifact-event-infrastructure-git-tagging.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-shared-changes}/dist/pythoneda_artifact_shared_changes-${pythoneda-artifact-shared-changes.version}-py3-none-any.whl
              pip install ${pythoneda-realm-unveilingpartner}/dist/pythoneda_realm_unveilingpartner-${pythoneda-realm-unveilingpartner.version}-py3-none-any.whl
              pip install ${pythoneda-realm-infrastructure-unveilingpartner}/dist/pythoneda_realm_infrastructure_unveilingpartner-${pythoneda-realm-infrastructure-unveilingpartner.version}-py3-none-any.whl
              pip install ${pythoneda-shared-git}/dist/pythoneda_shared_git-${pythoneda-shared-git.version}-py3-none-any.whl
              rm -rf .env
            '';

            postInstall = ''
              mkdir $out/dist $out/bin
              cp dist/${wheelName} $out/dist
              jq ".url = \"$out/dist/${wheelName}\"" $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json > temp.json && mv temp.json $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json
              chmod +x $out/lib/python${pythonMajorMinorVersion}/site-packages/${entrypoint}
              echo '#!/usr/bin/env sh' > $out/bin/${pname}.sh
              echo "export PYTHONPATH=$PYTHONPATH" >> $out/bin/${pname}.sh
              echo '${python}/bin/python ${entrypoint} $@' >> $out/bin/${pname}.sh
              chmod +x $out/bin/${pname}.sh
            '';

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
        pythoneda-realm-application-unveilingpartner-0_0_1a2-for = { python
          , pythoneda-application-base, pythoneda-artifact-event-changes
          , pythoneda-artifact-event-git-tagging
          , pythoneda-artifact-event-infrastructure-changes
          , pythoneda-artifact-event-infrastructure-git-tagging
          , pythoneda-artifact-shared-changes, pythoneda-base
          , pythoneda-infrastructure-base, pythoneda-realm-unveilingpartner
          , pythoneda-realm-infrastructure-unveilingpartner
          , pythoneda-shared-git }:
          pythoneda-realm-application-unveilingpartner-for {
            version = "0.0.1a2";
            inherit python pythoneda-application-base
              pythoneda-artifact-event-changes
              pythoneda-artifact-event-git-tagging
              pythoneda-artifact-event-infrastructure-changes
              pythoneda-artifact-event-infrastructure-git-tagging
              pythoneda-artifact-shared-changes pythoneda-base
              pythoneda-infrastructure-base pythoneda-realm-unveilingpartner
              pythoneda-realm-infrastructure-unveilingpartner
              pythoneda-shared-git;
          };
      in rec {
        apps = rec {
          pythoneda-realm-application-unveilingpartner-0_0_1a2-python39 =
            shared.app-for {
              package =
                self.packages.${system}.pythoneda-realm-application-unveilingpartner-0_0_1a2-python39;
              inherit pname;
            };
          pythoneda-realm-application-unveilingpartner-0_0_1a2-python310 =
            shared.app-for {
              package =
                self.packages.${system}.pythoneda-realm-application-unveilingpartner-0_0_1a2-python310;
              inherit pname;
            };
          pythoneda-realm-application-unveilingpartner-latest-python39 =
            pythoneda-realm-application-unveilingpartner-0_0_1a2-python39;
          pythoneda-realm-application-unveilingpartner-latest-python310 =
            pythoneda-realm-application-unveilingpartner-0_0_1a2-python310;
          pythoneda-realm-application-unveilingpartner-latest =
            pythoneda-realm-application-unveilingpartner-latest-python310;
          default = pythoneda-realm-application-unveilingpartner-latest;
        };
        defaultApp = apps.default;
        defaultPackage = packages.default;
        devShells = rec {
          default = pythoneda-realm-application-unveilingpartner-latest;
          pythoneda-realm-application-unveilingpartner-0_0_1a2-python39 =
            shared.devShell-for {
              package =
                packages.pythoneda-realm-application-unveilingpartner-0_0_1a2-python39;
              inherit pkgs nixpkgsRelease;
              python = pkgs.python39;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
            };
          pythoneda-realm-application-unveilingpartner-0_0_1a2-python310 =
            shared.devShell-for {
              package =
                packages.pythoneda-realm-application-unveilingpartner-0_0_1a2-python310;
              inherit pkgs nixpkgsRelease;
              python = pkgs.python310;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
            };
          pythoneda-realm-application-unveilingpartner-latest =
            pythoneda-realm-application-unveilingpartner-latest-python310;
          pythoneda-realm-application-unveilingpartner-latest-python39 =
            pythoneda-realm-application-unveilingpartner-0_0_1a2-python39;
          pythoneda-realm-application-unveilingpartner-latest-python310 =
            pythoneda-realm-application-unveilingpartner-0_0_1a2-python310;
        };
        packages = rec {
          default = pythoneda-realm-application-unveilingpartner-latest;
          pythoneda-realm-application-unveilingpartner-0_0_1a2-python39 =
            pythoneda-realm-application-unveilingpartner-0_0_1a2-for {
              python = pkgs.python39;
              pythoneda-application-base =
                pythoneda-application-base.packages.${system}.pythoneda-application-base-latest-python39;
              pythoneda-artifact-event-changes =
                pythoneda-artifact-event-changes.packages.${system}.pythoneda-artifact-event-changes-latest-python39;
              pythoneda-artifact-event-git-tagging =
                pythoneda-artifact-event-git-tagging.packages.${system}.pythoneda-artifact-event-git-tagging-latest-python39;
              pythoneda-artifact-event-infrastructure-changes =
                pythoneda-artifact-event-infrastructure-changes.packages.${system}.pythoneda-artifact-event-infrastructure-changes-latest-python39;
              pythoneda-artifact-event-infrastructure-git-tagging =
                pythoneda-artifact-event-infrastructure-git-tagging.packages.${system}.pythoneda-artifact-event-infrastructure-git-tagging-latest-python39;
              pythoneda-artifact-shared-changes =
                pythoneda-artifact-shared-changes.packages.${system}.pythoneda-artifact-shared-changes-latest-python39;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
              pythoneda-infrastructure-base =
                pythoneda-infrastructure-base.packages.${system}.pythoneda-infrastructure-base-latest-python39;
              pythoneda-realm-unveilingpartner =
                pythoneda-realm-unveilingpartner.packages.${system}.pythoneda-realm-unveilingpartner-latest-python39;
              pythoneda-realm-infrastructure-unveilingpartner =
                pythoneda-realm-infrastructure-unveilingpartner.packages.${system}.pythoneda-realm-infrastructure-unveilingpartner-latest-python39;
              pythoneda-shared-git =
                pythoneda-shared-git.packages.${system}.pythoneda-shared-git-latest-python39;
            };
          pythoneda-realm-application-unveilingpartner-0_0_1a2-python310 =
            pythoneda-realm-application-unveilingpartner-0_0_1a2-for {
              python = pkgs.python310;
              pythoneda-application-base =
                pythoneda-application-base.packages.${system}.pythoneda-application-base-latest-python310;
              pythoneda-artifact-event-changes =
                pythoneda-artifact-event-changes.packages.${system}.pythoneda-artifact-event-changes-latest-python310;
              pythoneda-artifact-event-git-tagging =
                pythoneda-artifact-event-git-tagging.packages.${system}.pythoneda-artifact-event-git-tagging-latest-python310;
              pythoneda-artifact-event-infrastructure-changes =
                pythoneda-artifact-event-infrastructure-changes.packages.${system}.pythoneda-artifact-event-infrastructure-changes-latest-python310;
              pythoneda-artifact-event-infrastructure-git-tagging =
                pythoneda-artifact-event-infrastructure-git-tagging.packages.${system}.pythoneda-artifact-event-infrastructure-git-tagging-latest-python310;
              pythoneda-artifact-shared-changes =
                pythoneda-artifact-shared-changes.packages.${system}.pythoneda-artifact-shared-changes-latest-python310;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
              pythoneda-infrastructure-base =
                pythoneda-infrastructure-base.packages.${system}.pythoneda-infrastructure-base-latest-python310;
              pythoneda-realm-unveilingpartner =
                pythoneda-realm-unveilingpartner.packages.${system}.pythoneda-realm-unveilingpartner-latest-python310;
              pythoneda-realm-infrastructure-unveilingpartner =
                pythoneda-realm-infrastructure-unveilingpartner.packages.${system}.pythoneda-realm-infrastructure-unveilingpartner-latest-python310;
              pythoneda-shared-git =
                pythoneda-shared-git.packages.${system}.pythoneda-shared-git-latest-python310;
            };
          pythoneda-realm-application-unveilingpartner-latest =
            pythoneda-realm-application-unveilingpartner-latest-python310;
          pythoneda-realm-application-unveilingpartner-latest-python39 =
            pythoneda-realm-application-unveilingpartner-0_0_1a2-python39;
          pythoneda-realm-application-unveilingpartner-latest-python310 =
            pythoneda-realm-application-unveilingpartner-0_0_1a2-python310;
        };
      });
}
