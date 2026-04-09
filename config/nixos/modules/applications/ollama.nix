{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myNixos.services.ollama;
in
{
  options.myNixos.services.ollama = {
    enable = lib.mkEnableOption "Ollama local AI model server";

    acceleration = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "cuda"
          "rocm"
        ]
      );
      default = null;
      description = ''
        Hardware acceleration to use for Ollama.
        - `null`: CPU-only (no acceleration)
        - `"cuda"`: NVIDIA GPU acceleration
        - `"rocm"`: AMD GPU acceleration
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ollama;
      defaultText = lib.literalExpression "pkgs.ollama";
      description = "The ollama package to use.";
    };

    environmentVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        OLLAMA_LLM_LIBRARY = "cpu";
        HIP_VISIBLE_DEVICES = "0,1";
      };
      description = ''
        Environment variables for the ollama service.
        These are only seen by the ollama server (systemd service), not normal invocations like `ollama run`.
      '';
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "The host address to bind to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 11434;
      example = 8080;
      description = "The port to listen on.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the ollama port.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "ollama";
      description = "User account under which ollama runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "ollama";
      description = "Group under which ollama runs.";
    };

    home = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/ollama";
      description = "Home directory for ollama data and configuration.";
    };

    models = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.home}/models";
      defaultText = lib.literalExpression ''"''${config.myNixos.services.ollama.home}/models"'';
      description = "Directory where ollama stores downloaded models.";
    };

    loadModels = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "llama3.2"
        "codellama"
      ];
      description = ''
        List of models to preload when the service starts.
        Models will be downloaded if not already present.
      '';
    };

    rocmOverrideGfx = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "10.3.0";
      description = ''
        Override the GPU architecture for ROCm.
        Useful for unsupported or newer AMD GPUs.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      inherit (cfg)
        acceleration
        package
        environmentVariables
        host
        port
        user
        group
        home
        models
        loadModels
        rocmOverrideGfx
        ;
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
