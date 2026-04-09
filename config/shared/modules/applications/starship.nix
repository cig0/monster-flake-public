# Shared starship configuration
# Used by both NixOS and Home Manager modules
# Based on the original HM configuration (preferred)
# See: config/nixos/modules/applications/starship.nix (NixOS)
# See: config/home-manager/modules/applications/starship.nix (Home Manager)
{
  settings = {
    format = "$aws\$azure\$gcloud\$kubernetes\$helm\$docker_context\$terraform\$package\$rust\$golang\$nodejs\$python\$env_var\$line_break\$username\$hostname\$nix_shell\$shlvl\$directory\$git_branch\$git_commit\$git_state\$git_status\$cmd_duration\$time\$status\$jobs\$character";

    character = {
      success_symbol = "[λ](bold green)";
      error_symbol = "[λ](bold red)";
    };

    cmd_duration = {
      disabled = false;
    };

    command_timeout = 2000;

    directory = {
      style = "white";
    };

    status = {
      disabled = false;
    };

    time = {
      disabled = true;
      style = "blue";
      utc_time_offset = "-3";
    };

    nix_shell = {
      disabled = false;
      heuristic = true;
      symbol = "(bold blue)\(nix\)";
      impure_msg = "[impure shell](bold red)";
      pure_msg = "[pure shell](bold green)";
      unknown_msg = "[unknown shell](bold yellow)";
      format = "[(bold blue)\(nix\) $state( \($name\))](bold blue) ";
    };

    shlvl = {
      disabled = false;
      format = "[$shlvl level(s) down ](bold red)";
      threshold = 2;
    };

    aws = {
      disabled = false;
      symbol = "🅰 ";
      format = "[($profile )(\($region\))](bold fg:215)";
      region_aliases = {
        ap-southeast-2 = "au";
        us-east-1 = "va";
        us-west-2 = "oregon";
      };
    };

    azure = {
      disabled = false;
      format = "[$subscription]($style)\${reset}";
      style = "blue bold";
    };

    gcloud = {
      disabled = true;
      format = "[$project]($style)\${reset}";
    };

    kubernetes = {
      disabled = false;
      style = "bold blue";
      format = " :: [$context]($style) [$namespace](bold white)\${reset}";
    };

    helm = {
      format = " :: [$version](bold fg:81)\${reset}";
      disabled = true;
    };

    docker_context = {
      format = " :: [$context](blue bold)\${reset}";
    };

    terraform = {
      disabled = false;
      version_format = "\${raw}";
      format = " :: [($style)OpenTofu $version WS $workspace]($style)\${reset}";
      detect_extensions = [
        "tf"
        "tfplan"
        "tfstate"
      ];
      detect_folders = [ ".terraform" ];
    };

    package = {
      format = " :: [$version](bold fg:212)\${reset}";
    };

    rust = {
      format = " :: [$version](red bold)\${reset}";
    };

    golang = {
      format = " :: [$version](bold cyan)\${reset}";
    };

    nodejs = {
      format = " :: [$version](bold green)\${reset}";
    };

    python = {
      python_binary = "python3";
      format = " :: [$version](bold fg:228)\${reset} :: [($virtualenv)](bold fg:228)\${reset}";
    };
  };
}
