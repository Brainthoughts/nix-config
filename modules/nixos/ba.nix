{ self, ... }:
{
  flake.nixosModules.ba =
    { config, pkgs, ... }:
    {
      home-manager.users.${config.my.username}.imports = [ self.homeModules.ba ];

      nixpkgs.config.android_sdk.accept_license = true;
      virtualisation.waydroid = {
        enable = true;
        package = pkgs.waydroid-nftables;
      };
    };

  flake.homeModules.ba =
    { config, pkgs, ... }:
    let
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        includeEmulator = true;
        includeNDK = true;
        includeSystemImages = true;
        systemImageTypes = [ "google_apis" ];
        abiVersions = [ "x86_64" ];
        platformVersions = [
          "36"
        ];
      };

      myAndroidSdk = androidComposition.androidsdk;
    in
    {
      # Set the environment variables so emulator knows where the unified SDK lives
      home.sessionVariables = {
        ANDROID_HOME = "${myAndroidSdk}/libexec/android-sdk";
        ANDROID_SDK_ROOT = "${myAndroidSdk}/libexec/android-sdk";
        ANDROID_AVD_HOME = "$HOME/.android/avd";
      };

      home.packages = with pkgs; [
        (lib.lowPrio myAndroidSdk)
        chromium
      ];
    };
}
