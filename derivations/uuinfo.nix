# https://github.com/Racum/uuinfo
{pkgs, ...}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "uuinfo";
  version = "218f2b86d4b0851710f8211e152bf7e68d7c6b27";
  src = pkgs.fetchFromGitHub {
    owner = "Racum";
    repo = pname;
    rev = version;
    hash = "sha256-tbsQT9QFjKEikT+vzEjCac3w8D3O+mOZueKWKppr0Ok=";
  };

  cargoHash = "sha256-hG/uGYtFVBDkLcB8skUc3iuNvJEBw/fbtK8ZbYeJk1g=";
  doCheck = false;
}
