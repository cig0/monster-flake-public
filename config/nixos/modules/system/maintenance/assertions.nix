{
  config,
  ...
}:
{
  assertions = [
    {
      # nix-store.nix
      assertion =
        !(config.myNixos.nix.gc.automatic or false && config.myNixos.programs.nh.clean.enable or false);
      message = "Only one of `myNixos.nix.gc.automatic` or `myNixos.programs.nh.clean.enable` can be enabled at a time.";
    }
  ];
}
