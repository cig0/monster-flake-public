{
  config,
  lib,
  self,
  ...
}:
{
  assertions = [
    {
      # Ensure secrets files exist when mySecrets is used
      assertion =
        config.mySecrets.secretsFile.host != ""
        -> builtins.pathExists "${self}/${config.mySecrets.secretsFile.host}";
      message = "Host secrets file not found: ${config.mySecrets.secretsFile.host}. Ensure the file exists or set mySecrets.secretsFile.host to an empty string to disable.";
    }

    {
      # Ensure shared secrets file exists when mySecrets is used
      assertion =
        config.mySecrets.secretsFile.shared != ""
        -> builtins.pathExists "${self}/${config.mySecrets.secretsFile.shared}";
      message = "Shared secrets file not found: ${config.mySecrets.secretsFile.shared}. Ensure the file exists or set mySecrets.secretsFile.shared to an empty string to disable.";
    }

    {
      # Ensure secrets are not empty when accessed
      assertion =
        let
          secretsInUse = builtins.attrNames config.mySecrets.raw;
          hasSecrets = builtins.length secretsInUse > 0;
        in
        !hasSecrets;
      message = "Secrets files appear to be empty. Ensure your secrets.json files contain actual secret values.";
    }
  ];
}
