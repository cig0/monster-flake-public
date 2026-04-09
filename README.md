![bandbnixos](./assets/images/ChuckCarson-Ed-Roths-F100%20png.png)

<p align="right"><em>Image credits: <a href="https://www.behance.net/gallery/94441087/Ed-Roths-F100">Chuck Carson — Ed Roth's F100</a></em></p>

<br><br>

<p align="center" style="font-size: 1.5em;"><strong>-=- MONSTER FLAKE -=-</strong></p>

<p align="center">Rock-solid NixOS, GNU/Linux, and macOS Nix flake<br>Powered by <a href="https://github.com/cig0/nix-modulon">Modulon 🤖</a></p>
<br>

## Why this flake?

Rev your engines with **Monster Flake**—a high-octane, high-clearance 4x4 for your Nix setup!

Whether you’re cruising or tearing up the road, this rig gives you:

- **Single source of truth** for hosts, packages, and options
- **Auto-discovered modules** courtesy of Modulon
- **Shared abstractions** that run on NixOS and GNU/Linux & macOS (via Home Manager)
- **Declarative, idempotent Homebrew & Flatpak management** that just works with `nh home switch .`
- **Channel combinations** for any appetite:
  - **Stable release with stable packages** — a reliable workhorse
  - **Stable release with unstable packages** — best of both worlds
  - **Development snapshot with unstable packages** — bleeding edge
  - **Development snapshot with selected stable packages** — for compatibility needs

It's battle-tested daily, but still evolving—expect the occasional tire burning 🔥

## Supported platforms

| Platform | Entry point | Package target | Status |
|----------|-------------|----------------|--------|
| NixOS + HM as a module | `nixosConfigurations` | `environment.systemPackages` | ✅ shipping |
| GNU/Linux | `homeConfigurations` | `home.packages` | ✅ shipping |
| macOS | `homeConfigurations` | `home.packages` | ✅ shipping |

### TL;DR - Who reads manuals anyway ¯\\_(ツ)_/¯

Need the elevator pitch? Skim the [Flake Tree](docs/03-FLAKE-TREE.md) for a less than five-minute tour of every folder and module, then dive deeper wherever you need.

Also, check out the [config/shortcuts](config/shortcuts) directory—adds a touch for maintainability that solves the "where the hell is that file?" problem common in large flakes.

## Learn more

The README stays light; dive into `docs/` for specifics:

- [01-ARCHITECTURE](docs/01-ARCHITECTURE.md) – how everything fits together
- [02-NIX-QUICK-REFERENCE](docs/02-NIX-QUICK-REFERENCE.md) – nix CLI primer
- [03-FLAKE-TREE](docs/03-FLAKE-TREE.md) – annotated repository map
- [04-FLAKE-DOT-NIX](docs/04-FLAKE-DOT-NIX.md) – deep dive into flake.nix wiring
- [05-0-PACKAGE-MANAGEMENT](docs/05-0-PACKAGE-MANAGEMENT.md) – adding packages the smart way
  - [05-1-HOMEBREW](docs/05-1-HOMEBREW.md) – declarative Homebrew management (macOS, GNU/Linux)
  - [05-2-FLATPAK](docs/05-2-FLATPAK.md) – declarative Flatpak management (GNU/Linux)
- [06-ADDING-HOSTS](docs/06-ADDING-HOSTS.md) – NixOS, macOS, GNU/Linux walkthroughs
- [07-TOGGLES-AND-PROFILES](docs/07-TOGGLES-AND-PROFILES.md) – feature switches & profiles
- [08-HOME-MANAGER-STATE](docs/08-HOME-MANAGER-STATE.md) – managing Home Manager state versions
- [09-NIXOS-HOST-MODULES-SECRETS](docs/09-NIXOS-HOST-MODULES-SECRETS.md) – how plaintext secrets feed NixOS modules
- [10-ASSERTIONS](docs/10-ASSERTIONS.md) – validation and safety checks
- [11-MODULON](docs/11-MODULON.md) – auto-discovery and module management system
- [12-0-OPTIONS-REFERENCE](docs/12-0-OPTIONS-REFERENCE.md) – complete options catalog
  - [12-1-ALL-OPTIONS](docs/12-1-ALL-OPTIONS.md) – detailed options reference
- [13-TESTING](docs/13-TESTING.md) – test strategies and validation
- [14-LIMITATIONS](docs/14-LIMITATIONS.md) – system constraints and design decisions

## Quick start

1. **Clone** – `git clone https://github.com/cig0/monster-flake.git && cd monster-flake`
2. **Add your host** – edit `flake.nix` and copy an existing entry (see [07-ADDING-HOSTS](docs/07-ADDING-HOSTS.md))
3. **Customize programs & packages** – flip toggles under `myHmStandalone` / `myNixos.myOptions`
4. **Switch** – `nix run home-manager -- switch --flake .#<username>@<hostname>`<br>
*Note:* After a successful build, you can start using [nh](/config/home-manager/modules/applications/zsh/aliases/nix.nix) right away (`nhhs` and `nhhsd` will become your best friends)

Need details on any step? The docs break down each subsystem so beginners and veterans can go as deep as they like.

### Secrets (NixOS only)

- Secrets live in `secrets/` (host JSON, shared JSON, Wi-Fi PSKs, optional Tailscale auth keys)
- Populate the skeleton files manually, via `sops`/`agenix`, or by piping environment variables before `nh os switch`
- See [11-NIXOS-HOST-MODULES-SECRETS](docs/11-NIXOS-HOST-MODULES-SECRETS.md) for structure, validation rules, setup instructions, and expanding it for your needs
- See [14-LIMITATIONS](docs/14-LIMITATIONS.md) for more information about secrets encryption

## Contributing

PRs welcome! Please test changes on the platforms you touch.

## License

```plaintext
GNU Affero General Public License v3 or later.
See LICENSE for the full text.
```
