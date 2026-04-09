# Home Manager Zsh aliases module. Do not remove this header.
{
  platform,
  ...
}:
let
  cfg = platform.cfg;

  # Lazygit path differs by platform
  lazygitPath = if platform.isLinux then "/run/current-system/sw/bin/lazygit" else "lazygit"; # macOS uses PATH lookup

  aliases = {
    # AI commit message
    gcoA = "git commit -m \"$(git diff --cached | ollama run qwen3-coder-next:cloud 'Write a commit message in the Conventional Commits format...')\"";

    # GitHub
    _githubCheckApiRates = "curl -H \"Authorization: token $GH_TOKEN\" https://api.github.com/rate_limit";

    # ===== Git helpers  =====
    g = "git";
    gsb = "g sb";

    # Lazygit
    lgF = "${lazygitPath} --path ${cfg.flakeSrcPath}";

    # GitGuardian
    ggs = "ggshield --no-check-for-updates";
    ggssr = "ggshield --no-check-for-updates secret scan repo";

    # GitHub CLI
    ghrw = "gh run watch";
    ghwv = "gh workflow view";
  };
in
{
  inherit aliases;
}
