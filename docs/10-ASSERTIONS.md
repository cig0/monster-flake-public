# Assertions and Warnings System

This document explains the assertion and warning systems used in the NixOS configuration to ensure consistency, prevent conflicts, and provide helpful feedback.

## Overview

**Assertions** are validation checks that run during NixOS evaluation. If an assertion fails, the build **stops** with a clear error message. This prevents misconfigurations and ensures the system behaves as expected.

**Warnings** are non-fatal messages that print during evaluation but **don't stop the build**. They inform users about suboptimal configurations, deprecated options, or work-in-progress features.

## Types of Assertions

### 1. Conflict Prevention Assertions

These assertions prevent users from enabling both the toggle-based modules (`myNixos.*`) and the direct NixOS/Home Manager options (`services.*`, `programs.*`, etc.) for the same functionality.

**Example:**
```nix
{
  assertion = !(config.myNixos.services.openssh.enable && config.services.openssh.enable);
  message = "Only one of `myNixos.services.openssh.enable` (toggle-based) or `services.openssh.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
}
```

**Why this exists:** The toggle-based modules provide additional configuration, validation, and integration. Using both approaches simultaneously can lead to conflicts and unpredictable behavior.

### 2. Dependency Assertions

These assertions ensure that required dependencies are enabled when a module needs them.

**Example:**
```nix
{
  assertion = config.myNixos.security.sshguard.enable -> config.myNixos.services.openssh.enable;
  message = "SSHGuard requires OpenSSH server. Enable `myNixos.services.openssh.enable` when using `myNixos.security.sshguard.enable`.";
}
```

**Why this exists:** Some modules depend on others to function properly. These assertions prevent incomplete configurations.

### 3. Configuration Validation Assertions

These assertions validate that configuration values are within acceptable ranges or meet specific requirements.

**Example:**
```nix
{
  assertion = config.myNixos.networking.firewall.allowedTCPPorts != [];
  message = "At least one TCP port must be allowed when firewall is enabled";
}
```

## Assertion Structure

Each assertion follows this pattern:

```nix
{
  assertion = <boolean expression>;
  message = "<error message to display if assertion fails>";
}
```

- **`assertion`**: A boolean expression that evaluates to `true` if the configuration is valid
- **`message`**: A clear, actionable error message explaining what's wrong and how to fix it

## Assertion Files

Assertions are organized in several locations:

### NixOS Module Assertions
- `config/nixos/build/modules/security/assertions.nix` - Security-related assertions
- `config/nixos/build/modules/secrets/assertions.nix` - Secrets management assertions
- Other module-specific assertion files

### Home Manager Assertions
- `config/build/home-manager/modules/applications/assertions.nix` - Application-related assertions
- `config/build/home-manager/modules/environment/assertions.nix` - Environment-related assertions

## Common Assertion Patterns

### Conflict Prevention Pattern
```nix
{
  assertion = !(config.myNixos.<module>.enable && config.<direct-option>.enable);
  message = "Only one of `myNixos.<module>.enable` (toggle-based) or `<direct-option>.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
}
```

### Dependency Pattern
```nix
{
  assertion = config.myNixos.<dependent>.enable -> config.myNixos.<dependency>.enable;
  message = "<Dependent> requires <Dependency>. Enable `myNixos.<dependency>.enable` when using `myNixos.<dependent>.enable`.";
}
```

### Mutual Exclusion Pattern
```nix
{
  assertion = !(config.myNixos.<module-a>.enable && config.myNixos.<module-b>.enable);
  message = "<Module A> and <Module B> cannot be enabled simultaneously";
}
```

## Writing New Assertions

When adding a new module, consider these assertions:

1. **Conflict Prevention**: If your module wraps an existing NixOS/Home Manager option
2. **Dependencies**: If your module requires other modules to be enabled
3. **Validation**: If your module has specific configuration requirements

### Example: Adding a New Module

If you're adding `myNixos.services.newservice` that wraps `services.newservice`:

```nix
# In config/nixos/build/modules/services/assertions.nix
{
  assertion = !(config.myNixos.services.newservice.enable && config.services.newservice.enable);
  message = "Only one of `myNixos.services.newservice.enable` (toggle-based) or `services.newservice.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
}
```

## Troubleshooting

### Assertion Failed Error

When an assertion fails, you'll see an error like:

```
error:
Failed assertions:
- Only one of `myNixos.services.openssh.enable` (toggle-based) or `services.openssh.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.
```

**To fix:**
1. Identify which assertion is failing
2. Check your configuration for the mentioned options
3. Disable the direct NixOS/Home Manager option and use only the toggle-based option
4. Or disable the toggle-based option if you intentionally want to use the direct approach

### Common Issues

1. **Forgot to disable direct option**: When enabling a toggle-based module, remember to disable any direct NixOS/Home Manager options for the same service
2. **Missing dependencies**: Enable required dependencies mentioned in the error message
3. **Configuration conflicts**: Review your configuration for conflicting settings

## Best Practices

1. **Clear error messages**: Write messages that explain what's wrong and how to fix it
2. **Consistent naming**: Use the same naming pattern for similar assertions
3. **Logical grouping**: Group related assertions in the same file
4. **Documentation**: Document complex assertions with comments
5. **Testing**: Test assertions by intentionally triggering them to ensure messages are helpful

## Limitations

1. **Runtime vs. evaluation time**: Assertions only run during evaluation, not at runtime
2. **Complex conditions**: Very complex assertions can be hard to debug
3. **Performance**: Many assertions can slow down evaluation slightly

## Warnings System

### Overview

Warnings provide non-fatal feedback during evaluation. Unlike assertions, warnings **don't stop the build** - they simply inform you about potential issues or suboptimal configurations.

### Warning Files

Warnings are organized similarly to assertions:

**NixOS Warnings:**
- `config/nixos/build/warnings.nix` - System-wide warnings

**Home Manager Warnings:**
- `config/build/home-manager/modules/common/warnings.nix` - HM-specific warnings

### Types of Warnings

#### 1. Work-in-Progress Module Warnings

Warn when incomplete or experimental modules are enabled:

```nix
config.warnings = lib.optionals config.myNixos.services.ollama.enable [
  ''
    The Ollama module is currently Work In Progress.
    Some features may not work as expected.
  ''
];
```

#### 2. Suboptimal Configuration Warnings

Inform about configurations that work but aren't ideal:

```nix
config.warnings = lib.optionals (cfg.programs.git.enable && !cfg.configFile.enable) [
  ''
    Git is enabled but config file generation is disabled.
    Make sure you have your own .gitconfig.
  ''
];
```

#### 3. Missing Optional Features

Warn about missing optional dependencies or features:

```nix
config.warnings = lib.optionals (cfg.secrets.github.gh_token == "") [
  ''
    GitHub token is not set (myHmStandalone.secrets.github.gh_token).
    Some GitHub CLI features may not work. Set the token in ~/.env or use the GH_TOKEN environment variable.
  ''
];
```

### Warning Structure

Warnings use the `config.warnings` list:

```nix
config.warnings = lib.flatten [
  (lib.optionals <condition> [
    "Warning message here"
  ])
  
  (lib.optionals <another-condition> [
    "Another warning message"
  ])
];
```

### When to Use Warnings vs Assertions

| Situation | Use |
|-----------|-----|
| Configuration **will break** the system | **Assertion** |
| Configuration is **suboptimal** but works | **Warning** |
| Module is **incomplete/WIP** | **Warning** |
| Option is **deprecated** but still works | **Warning** |
| Option is **removed** | **Assertion** |
| Missing **required** dependency | **Assertion** |
| Missing **optional** dependency | **Warning** |
| Conflicting options | **Assertion** |
| Unusual but valid configuration | **Warning** |

### Writing New Warnings

When adding warnings, consider:

1. **Is it actionable?** - User should know what to do
2. **Is it non-fatal?** - Build should still succeed
3. **Is it helpful?** - Provides value without noise

**Example: Adding a WIP Warning**

```nix
# In config/nixos/build/warnings.nix
config.warnings = lib.optionals config.myNixos.services.newservice.enable [
  ''
    The newservice module is currently Work In Progress.
    Feature X is not yet implemented. See module documentation for details.
  ''
];
```

### Deprecation Warnings

For deprecated options, use NixOS's built-in deprecation system:

```nix
# Rename an option with automatic migration
imports = [
  (lib.mkRenamedOptionModule 
    [ "myNixos" "oldName" ] 
    [ "myNixos" "newName" ]
  )
];

# Remove an option with a warning
imports = [
  (lib.mkRemovedOptionModule 
    [ "myNixos" "removedOption" ]
    "This option has been removed. Use alternativeOption instead."
  )
];
```

## Future Enhancements

Potential improvements to the assertion and warning systems:

1. **Automatic fixes**: Suggestions for automatic configuration corrections
2. **Dependency graph visualization**: Visual representation of module dependencies
3. **Enhanced error messages**: More detailed error messages with context and examples
4. **Warning categories**: Group warnings by severity (info, warning, critical)
