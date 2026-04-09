# Import all function modules found in the functions directory
{
  config,
  isDarwin ? false,
  isLinux ? false,
  libAnsiColors,
  nixosConfig ? null,
  self,
  system ? "x86_64-linux",
  ...
}:
let
  # Platform detection that works for both standalone HM and NixOS HM
  platform =
    # If nixosConfig is available, use the full platform-config
    if nixosConfig != null then
      (import ../../../../shared/platform-config.nix {
        inherit
          config
          nixosConfig
          isDarwin
          isLinux
          ;
      }).platform
    else
      # Standalone Home Manager - simple detection
      {
        isDarwin = isDarwin;
        isLinux = isLinux;
        isNixOS = false;
      };

  # Check if the first line matches the required header
  hasValidHeader =
    file:
    let
      content = builtins.readFile file;
      firstLine = builtins.head (builtins.split "\n" content);
    in
    firstLine == "# Home Manager Zsh functions module. Do not remove this header.";

  # Import function files, dynamically passing inputs (e.g. `platform`) when required
  importFunctionFiles =
    dir:
    let
      files = builtins.attrNames (builtins.readDir dir);
      nixFiles = builtins.filter (n: builtins.match ".*\\.nix" n != null) files;
      fullPaths = map (f: dir + "/${f}") nixFiles;
      validFiles = builtins.filter hasValidHeader fullPaths;
      contents = map (
        file:
        let
          importedFn = import file; # Returns a function
          actualArgs = {
            inherit
              config
              libAnsiColors
              platform
              self
              system
              ;
          };
          result = importedFn actualArgs; # Call the function with appropriate args
        in
        if builtins.hasAttr "functions" result then result.functions else ""
      ) validFiles;
      merged = builtins.concatStringsSep "\n" contents;
    in
    merged;
in
{
  allFunctions = importFunctionFiles ./functions;
}
