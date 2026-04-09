{ ... }:
{
  # Environment assertions have been moved to warnings.nix
  # Most environment checks are non-fatal and should warn rather than block the build
  assertions = [ ];
}
