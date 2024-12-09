{
  description = "VBAN Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      vban' = {binary}:
        pkgs.stdenv.mkDerivation {
          name = binary;
          version = "4f69e5a6cd02627a891f2b15c2cf01bf4c87d23d";

          src = pkgs.fetchFromGitHub {
            owner = "quiniouben";
            repo = "vban";
            rev = "4f69e5a6cd02627a891f2b15c2cf01bf4c87d23d";
            sha256 = "sha256-V7f+jcj3NpxXNr15Ozx2is4ReeeVpl3xvelMuPNfNT0=";
          };

          buildInputs = [pkgs.cmake pkgs.alsa-lib pkgs.pulseaudio.dev];

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
            "-DCMAKE_VERBOSE_MAKEFILE=OFF"
            "-DCMAKE_C_FLAGS=-w"
            "-DWITH_PULSEAUDIO=Yes"
            "-DWITH_ALSA=No"
            "-DWITH_JACK=No"
          ];

          meta = with pkgs.lib; {
            description = "A C++ library and tools for VBAN protocol";
            homepage = "https://github.com/quiniouben/vban";
            license = licenses.gpl3Plus;
            platforms = platforms.linux;
          };
        };
    in {
      packages = {
        vban_receptor = vban' {binary = "vban_receptor";};
        vban_emitter = vban' {binary = "vban_emitter";};
        vban_sendtext = vban' {binary = "vban_sendtext";};
      };
    });
}
