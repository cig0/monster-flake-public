# Limitations

## Secrets management

🔴 **IN THE WORKS:** I'm evaluating choosing between Mozilla SOPTS and Agenix for proper secrets encryption.

## Package Management Constraints

This configuration system has specific limitations regarding package management and host-specific customization. Understanding these constraints is crucial for effectively using this flake.

### Bulk Package Selection

🟢 The package selection system works in **bulk rather than by host**. This means:

- When building a new flake generation, **all packages** defined in `/config/shared/modules/applications/packages/*` are included in that generation, provided the module toggle is set
- There is **no mechanism** to define groups of packages per individual host
- The same limitation applies to `/config/home-manager/modules/applications/homebrew` for Homebrew packages
- However, it is possible to skip chosen Flatpak packages using myHmStandalone.programs.flatpak.skipPackages

### Design Philosophy

This behavior is **intentional by design**. The goal is to maintain **consistency across all computers** in the environment, ensuring that the same tools and applications are available everywhere. This approach:

- Simplifies maintenance and updates
- Ensures a uniform experience across different machines
- Reduces complexity in the configuration system

### Workarounds for Host-Specific Packages

If you need to have different packages installed on different hosts, you have two options:

#### Option A: Group-Based Package Selection

Use the `/config/shared/modules/applications/packages/baseline.nix` module to define package sets by category:

1. **Enable/disable existing groups**: Use the existing categories in hosts' `profile.nix` files
2. **Create new categories**: Add new package modules in the packages directory
3. **Extend baseline.nix**: Modify the baseline module to include additional groupings

#### Option B: Profile-Based Toggles

Add toggles in the hosts' `profile.nix` modules to control package installation:

```nix
myHmStandalone.packages = {
  baseline = true;      # Core packages
  cli._all = false;     # Disable all CLI tools
  cli.programming = true; // Only enable programming tools
  gui = false;          // Disable GUI applications
  # Add custom toggles as needed
};
```

### Implications

- **All-or-nothing approach**: Package modules are either included entirely or not at all
- **No per-host granularity**: Cannot install package X on host A but not on host B through the standard module system
- **Profile complexity**: Host-specific customization requires manual toggle management in profile files
- **Testing considerations**: Changes to package modules affect all hosts using those modules

### Best Practices

1. **Plan package categories carefully**: Design your package modules with logical groupings that make sense across all hosts
2. **Use toggles strategically**: Leverage the built-in toggle system in profile.nix for fine-grained control
3. **Document host differences**: Clearly document which hosts deviate from standard package sets and why
4. **Consider alternatives**: For truly host-specific needs, consider using host-specific configuration files or external package managers

### Future Considerations

While the current design emphasizes consistency, future enhancements could potentially include:

- Host-specific package filters [none apply to all, tags per host]
- Conditional package inclusion based on host attributes
- Dynamic package selection mechanisms

However, any such changes would need to balance the benefits of granular control against the increased complexity and maintenance overhead.