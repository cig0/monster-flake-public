{
  lib,
  ...
}:
{
  options.myNixos.myOptions = {
    flakeSrcPath = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nixos/";
      description = "The path for the flake source code.  A handy option for use with shell aliases and functions.";
    };

    allowUnfree = lib.mkOption {
      type = lib.types.bool;
      description = "Allow unfree packages. Must be explicitly set to true or false.";
    };
  };
}
