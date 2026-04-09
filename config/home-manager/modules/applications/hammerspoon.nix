# Hammerspoon configuration for macOS (Darwin) only
# Writes ~/.hammerspoon/init.lua with Terminal toggle functionality
{
  config,
  hostKind,
  lib,
  ...
}:
{
  # Only apply on Darwin systems and when enabled
  config =
    lib.mkIf (hostKind == "darwin" && (config.myHmStandalone.programs.hammerspoon.enable or false))
      {
        # Write the init.lua configuration file
        home.file.".hammerspoon/init.lua".text = ''
          -- Define your preferred keybinding here (e.g., Command + Shift + Return)
          local toggleMods = {"cmd", "shift"}
          local toggleKey = "return"

          -- Set your preferred terminal app here
          local appName = "Ghostty"

          hs.hotkey.bind(toggleMods, toggleKey, function()
              local app = hs.application.get(appName)
              
              if app then
                  -- If the app is running
                  if app:isFrontmost() then
                      -- And if it is currently in focus, hide it
                      app:hide()
                  else
                      -- If it's running but hidden or behind other windows, focus it
                      hs.application.launchOrFocus(appName)
                      
                      -- If the app is running but all windows were closed, open a new window
                      if app:mainWindow() == nil then
                          -- Synthesize 'Cmd + N' to open a new terminal window
                          hs.eventtap.keyStroke({"cmd"}, "n", 200000, app)
                      end
                  end
              else
                  -- If the app is entirely closed, launch it
                  hs.application.launchOrFocus(appName)
              end
          end)
        '';
      };
}
