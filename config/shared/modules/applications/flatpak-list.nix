# @MODULON_SKIP
{
  skipPackages ? [ ],
}:
let
  allPackages = [
    # { appId = "com.brave.Browser"; origin = "flathub";  }

    # ASCII fun
    "io.github.nokse22.asciidraw"
    "io.gitlab.gregorni.Letterpress"

    # Comms
    "com.discordapp.Discord"
    "io.github.milkshiift.GoofCord" # https://flathub.org/apps/io.github.milkshiift.GoofCord
    "im.riot.Riot" # Element - Matrix client
    "org.telegram.desktop"
    "com.rtosta.zapzap" # https://flathub.org/apps/com.rtosta.zapzap
    "us.zoom.Zoom"

    # Games
    "org.naev.Naev"

    # Infrastructure: CNCF / K8s / OCI / virtualization
    "app.freelens.Freelens"

    # Maintenance
    "com.github.tchx84.Flatseal"
    "io.github.giantpinkrobots.flatsweep"
    "io.github.flattool.Warehouse"

    # Multimedia
    "org.gimp.GIMP"
    "fr.handbrake.ghb"
    "org.nickvision.tubeconverter"
    "org.videolan.VLC"

    # Networking
    "org.wireshark.Wireshark"

    # Productivity
    "org.libreoffice.LibreOffice"
    "org.fedoraproject.MediaWriter"

    /*
      Flatpak is not officialy supported by Obsidian, see:
      https://publish.obsidian.md/git-doc/Installation

      I guess I could make Flatpak work with my Git configuration
      managed with NixOS (nixos/modules/applications/git/git.nix)
      to read the /etc/gitconfig file, but I don't see the point
      as Obsidian is packaged by some wonderful folks at Nixpkgs.

      I leave here the Flatpak reference for future use if needed:
    */
    "md.obsidian.Obsidian"

    # Programming
    "net.werwolv.ImHex"

    # Radio
    "com.github.louis77.tuner"

    # Secrets
    "com.bitwarden.desktop"
    "org.keepassxc.KeePassXC"

    # Security
    "com.protonvpn.www"

    # Sharing-is-caring
    "org.nicotine_plus.Nicotine"
    "com.rustdesk.RustDesk"

    # Storage

    # Web
    "com.brave.Browser"
    "com.google.Chrome"
    "com.google.EarthPro"

    # Work
    "com.github.IsmaelMartinez.teams_for_linux"
  ];
in
{
  all = builtins.filter (pkg: !(builtins.elem pkg skipPackages)) allPackages;
}
