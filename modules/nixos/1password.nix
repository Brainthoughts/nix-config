{
  flake.nixosModules."1password" =
    { config, ... }:
    {
      services.gnome.gcr-ssh-agent.enable = false;
      programs = {
        _1password.enable = true;
        _1password-gui = {
          enable = true;
          polkitPolicyOwners = [ config.my.username ];
        };
      };
    };
}
