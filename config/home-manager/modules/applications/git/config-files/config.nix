{
  config,
  lib,
  nixosConfig ? null,
  ...
}:
let
  platform = import ../../../../../shared/platform-config.nix {
    inherit config nixosConfig;
  };
  cfg = platform.cfg.programs.git;
  homeDir = config.home.homeDirectory;
in
{
  config = lib.mkIf ((cfg.enable || cfg.configOnly) && cfg.configFile.enable) {
    xdg.configFile."git/config".text = ''
      [color]
      	diff = true
      	status = true
      	branch = true
      	interactive = true
      	ui = true
      	pager = true
      	log = true

      [color "branch"]
      	current = yellow reverse
      	local = yellow
      	remote = green

      [color "diff"]
      	meta = yellow bold
      	frag = magenta bold
      	old = red bold
      	new = green bold

      [color "status"]
      	added = yellow
      	changed = green
      	untracked = cyan

      [commit]
      	template = ${homeDir}/.config/git/stCommitMsg
      	gpgsign = true

      [core]
      	excludesFile = ${homeDir}/.config/git/gitignore
      	pager = delta
      	editor = nvim

      [credential "https://github.com"]
      	helper = !gh auth git-credential

      [credential "https://gist.github.com"]
      	helper = !gh auth git-credential

      [delta]
      	light = false
      	navigate = true
      	side-by-side = true
      	tabs = 2
      	true-color = auto

      [diff]
      	colorMoved = default
      	tool = difftastic

      [difftool]
      	prompt = false

      [difftool "difftastic"]
      	cmd = difft "$LOCAL" "$REMOTE"

      [filter "lfs"]
      	process = git-lfs filter-process
      	required = true
      	clean = git-lfs clean -- %f
      	smudge = git-lfs smudge -- %f

      [gpg]
      	format = ssh

      [include]
      	path = ${homeDir}/.config/git/gitconfig-aliases

      [includeIf "gitdir:${homeDir}/workdir/work/"]
      	path = ${homeDir}/.config/git/gitconfig-work

      [init]
      	defaultBranch = main

      [interactive]
      	diffFilter = delta --color-only --tabs 2 --true-color auto

      [add "interactive"]
      	useBuiltin = false

      [merge]
      	conflictstyle = diff3

      [pack]
      	packSizeLimit = 2g
      	threads = 2

      [pager]
      	branch = false
      	difftool = true

      [tag]
      	gpgsign = true
      	forceSignAnnotated = true

      [url "git@github.com:"]
      	insteadOf = https://github.com/

      [user]
      	name = Martín Cigorraga
      	email = cig0.github@gmail.com
      	signingkey = ${homeDir}/.ssh/keys/github_main

      [color "branch"]
      	current = yellow reverse
      	local = yellow
      	remote = green

      [color "diff"]
      	meta = yellow bold
      	frag = magenta bold
      	old = red bold
      	new = green bold

      [color "status"]
      	added = yellow
      	changed = green
      	untracked = cyan
    '';
  };
}
