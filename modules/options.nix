{ lib, ... }:
{
  options.my = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "alexn";
      description = "The username of your user";
    };
  };
}
