# Channel input processing - normalizes input names by stripping channel suffixes
# This allows modules to reference inputs without knowing which channel they're on
{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  ...
}:
let
  # Function to build a set of third-party inputs based on channel context
  buildChannelInputsSet =
    channel: nixpkgsSource:
    let
      # Filter inputs based on channel: unstable gets only -unstable suffixed inputs,
      # stable gets all others (including -stable or no suffix)
      inputsByChannel = nixpkgsSource.lib.filterAttrs (
        name: _:
        if channel == "unstable" then
          nixpkgsSource.lib.hasSuffix "-unstable" name
        else
          !nixpkgsSource.lib.hasSuffix "-unstable" name
      ) inputs;

      # Include channel-agnostic inputs (those without any suffix) in both channels
      agnosticInputs = nixpkgsSource.lib.filterAttrs (
        name: _:
        !nixpkgsSource.lib.hasSuffix "-unstable" name && !nixpkgsSource.lib.hasSuffix "-stable" name
      ) inputs;

      # Combine filtered inputs with agnostic ones for the appropriate channel
      combinedInputs =
        if channel == "unstable" then agnosticInputs // inputsByChannel else inputsByChannel;

      inputsBaseNames = nixpkgsSource.lib.mapAttrs' (name: value: {
        /*
          Create clean base names by removing channel suffixes for consistent referencing
          in modules; unstable removes -unstable, stable removes -stable if present,
          otherwise keeps original name, ensuring normalized names for imports
        */
        name =
          if channel == "unstable" then
            nixpkgsSource.lib.removeSuffix "-unstable" name
          else if nixpkgsSource.lib.hasSuffix "-stable" name then
            nixpkgsSource.lib.removeSuffix "-stable" name
          else
            name;
        inherit value;
      }) combinedInputs;
    in
    inputsBaseNames;
in
{
  inherit buildChannelInputsSet;
  channelInputsStable = buildChannelInputsSet "stable" nixpkgs;
  channelInputsUnstable = buildChannelInputsSet "unstable" nixpkgs-unstable;
}
