# Home Manager Zsh functions module. Do not remove this header.
{ platform, ... }:
let
  # Cross-platform functions
  sharedFunctions = ''
    bkp() {
      source="''${1}"
      cp -i "$source" "$source.bkp"
    }
  '';

  # GNU/Linux only functions
  linuxFunctions =
    if platform.isLinux then
      ''
        freemem() {
          printf '\n=== Superuser password required to elevate permissions ===\n\n'
          su -c "echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\\n%s\\n' 'RAM-cache and Swap Cleared'" root
        }

        memusage() {
          ps -eo comm,%mem,rss --sort=comm | awk 'NR > 1 {a[$1]+=$2; b[$1]+=$3} END {for (i in a) printf "%-20s %5.2f%% %10.2f MB\n", i, a[i], b[i]/1024}' | sort -k2 -nr | head -n 20
        }
      ''
    else
      "";

  # macOS functions
  darwinFunctions =
    if platform.isDarwin then
      ''
        memusage() {
          ps -eo comm,%mem,rss | awk 'NR > 1 {a[$1]+=$2; b[$1]+=$3} END {for (i in a) printf "%-20s %5.2f%% %10.2f MB\n", i, a[i], b[i]/1024}' | sort -k2 -nr | head -n 20
        }
      ''
    else
      "";

  functions = sharedFunctions + linuxFunctions + darwinFunctions;
in
{
  inherit functions;
}
