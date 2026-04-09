# Ghostty HM module for standalone Home Manager (macOS/non-NixOS GNU/Linux)
#
# Writes ~/.config/ghostty/config with shared configuration
# Works with any Ghostty installation (Homebrew, manual, etc.)
#
# Shared config: config/shared/modules/applications/ghostty.nix
{
  config,
  hostKind,
  lib,
  self,
  ...
}:
let
  platform = import ../../../shared/platform-config.nix {
    inherit
      config
      ;
  };
  cfg = platform.cfg;
  sharedConfig = import "${self}/config/shared/modules/applications/ghostty.nix" { };

  # Convert Nix attribute set to Ghostty config file format
  settingsToConfig =
    settings:
    let
      formatValue =
        value:
        if builtins.isBool value then
          (if value then "true" else "false")
        else if builtins.isString value then
          "\"${value}\""
        else if builtins.isInt value || builtins.isFloat value then
          toString value
        else if builtins.isList value then
          "[ ${lib.concatMapStringsSep ", " formatValue value} ]"
        else
          "null";

      formatSetting =
        key: value:
        if builtins.isAttrs value then
          lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: formatSetting "${key}.${k}" v) value)
        else
          "${key} = ${formatValue value}";
    in
    lib.concatStringsSep "\n" (lib.mapAttrsToList formatSetting settings);

  # Merge base settings with platform-specific settings
  finalSettings =
    sharedConfig.settings
    // (if hostKind == "darwin" then sharedConfig.darwinOnly else { })
    // (if hostKind != "darwin" then sharedConfig.linuxOnly else { });

  configPath =
    if hostKind == "darwin" then
      "Library/Application Support/com.mitchellh.ghostty/config"
    else
      ".config/ghostty/config";

  hotReloadKey = if hostKind == "darwin" then "Command+Shift+," else "Control+Shift+,";

  configHeader = ''
    # Ghostty configuration managed by Home Manager
    # Generated from: config/shared/modules/applications/ghostty.nix
    # Do not edit manually - changes will be overwritten
    # Hot reload: Use ${hotReloadKey} to reload configuration'';
in
{
  # Write Ghostty configuration file to platform-specific location
  config = lib.mkIf config.myHmStandalone.programs.ghostty.enable {
    home.file."${configPath}".text = ''
      ${configHeader}

      ${settingsToConfig finalSettings}
    '';
  };
}
