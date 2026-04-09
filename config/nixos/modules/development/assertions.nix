{
  config,
  ...
}:
{
  assertions = [
    {
      # Prevent conflicts between direct rustc and our rust-oxalica-flake module
      assertion =
        !(
          config.myNixos.development.rust-oxalica-flake.enable or false
          && config.programs.rustc.enable or false
        );
      message = "Only one of `myNixos.development.rust-oxalica-flake.enable` (toggle-based) or `programs.rustc.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }
  ];
}
