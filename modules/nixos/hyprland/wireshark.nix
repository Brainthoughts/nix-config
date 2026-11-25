{ self, ... }:
{
  flake.nixosModules.wireshark =
    { config, pkgs, ... }:
    {
      programs.wireshark = {
        enable = true;
        package = pkgs.wireshark;
      };

      users.users.${config.my.username}.extraGroups = [ "wireshark" ];
    };
}
