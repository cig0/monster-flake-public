{
  config,
  ...
}:
{
  assertions = [
    {
      # Prevent conflicts between direct console-keymap and our module
      assertion =
        !(
          config.myNixos.environment.console-keymap.enable or false && config.console.keyMap or null != null
        );
      message = "Only one of `myNixos.environment.console-keymap.enable` (toggle-based) or `console.keyMap` (direct NixOS) can be set at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct i18n and our module
      assertion =
        !(
          config.myNixos.environment.i18n.enable or false
          && ((config.i18n.defaultLocale or null) != null || (config.i18n.extraLocaleSettings or { }) != { })
        );
      message = "Only one of `myNixos.environment.i18n.enable` (toggle-based) or direct `i18n.*` options can be set at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct xdg-portal and our module
      assertion =
        !(config.myNixos.environment.xdg-portal.enable or false && config.xdg.portal.enable or false);
      message = "Only one of `myNixos.environment.xdg-portal.enable` (toggle-based) or `xdg.portal.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }
  ];
}
