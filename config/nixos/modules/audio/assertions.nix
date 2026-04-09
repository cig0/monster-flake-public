{
  config,
  ...
}:
{
  assertions = [
    {
      # Prevent conflicts between direct Pipewire and our audio-subsystem module
      assertion =
        !(config.myNixos.audio-subsystem.enable or false && config.services.pipewire.enable or false);
      message = "Only one of `myNixos.audio-subsystem.enable` (toggle-based) or `services.pipewire.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct PulseAudio and our audio-subsystem module
      assertion =
        !(config.myNixos.audio-subsystem.enable or false && config.services.pulseaudio.enable or false);
      message = "Only one of `myNixos.audio-subsystem.enable` (toggle-based) or `services.pulseaudio.enable` (direct NixOS) can be enabled at a time. The audio-subsystem module uses Pipewire and disables PulseAudio.";
    }

    {
      # Ensure speechd depends on audio-subsystem
      assertion =
        (config.myNixos.services.speechd.enable or false)
        -> (config.myNixos.audio-subsystem.enable or false);
      message = "Speech synthesis requires audio subsystem. Enable `myNixos.audio-subsystem.enable` when using `myNixos.services.speechd.enable`.";
    }
  ];
}
