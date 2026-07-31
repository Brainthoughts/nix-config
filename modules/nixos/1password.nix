{
  flake.nixosModules."1password" =
    { config, ... }:
    {
      programs = {
        _1password.enable = true;
        _1password-gui = {
          enable = true;
          polkitPolicyOwners = [ config.my.username ];
        };
      };
    };
}
