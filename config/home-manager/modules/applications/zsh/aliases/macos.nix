# Home Manager Zsh aliases module. Do not remove this header.
{ platform, ... }:
let
  aliases =
    if platform.isDarwin then
      {
        # Applications
        safari = "open -a Safari";
        xcode_clear_cache = "rm -rf ~/Library/Developer/Xcode/DerivedData";

        # Brew
        brewdeps = "brew deps --tree --installed";
        brewleaves = "brew leaves";
        brewup = "brew update && brew upgrade && brew cleanup";

        # Clipboard
        cb = "pbcopy";
        cbp = "pbpaste";
        pbc = "pbcopy";
        pbp = "pbpaste";

        # Disk & Storage
        mac_disk_usage = "df -h";
        mac_eject_all = "osascript -e 'tell application \"Finder\" to eject (every disk whose ejectable is true)'";

        # Finder & Files
        finder = "open -a Finder";
        o = "open";
        oo = "open .";
        ql = "qlmanage -p"; # Quick Look preview
        trash = "rm -rf ~/.Trash/*";

        # Network
        mac_ip_local = "ipconfig getifaddr en0";
        mac_ip_public = "curl -s ifconfig.me";
        mac_ports = "lsof -iTCP -sTCP:LISTEN -n -P";
        mac_wifi_password = "security find-generic-password -ga \"$(networksetup -getairportnetwork en0 | cut -d' ' -f4)\" 2>&1 | grep password";
        mac_wifi_scan = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s";

        # Notifications
        mac_dnd_off = "defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean false && killall NotificationCenter";
        mac_dnd_on = "defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean true && killall NotificationCenter";

        # Process Management
        mac_top_cpu = "ps aux | sort -nrk 3,3 | head -10";
        mac_top_mem = "ps aux | sort -nrk 4,4 | head -10";

        # Screenshots
        mac_screenshot_format = "defaults write com.apple.screencapture type"; # png, jpg, pdf, etc.
        mac_screenshot_location = "defaults write com.apple.screencapture location";

        # Spotlight
        mac_spotlight_off = "sudo mdutil -a -i off";
        mac_spotlight_on = "sudo mdutil -a -i on";
        mac_spotlight_rebuild = "sudo mdutil -E /";

        # System
        mac_desktop_hide = "defaults write com.apple.finder CreateDesktop -bool false && killall Finder";
        mac_desktop_show = "defaults write com.apple.finder CreateDesktop -bool true && killall Finder";
        mac_flush_dns = "sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder";
        mac_hide_hidden = "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder";
        mac_lock = "pmset displaysleepnow";
        mac_show_hidden = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";
        mac_sleep = "pmset sleepnow";
        mac_uptime = "uptime && system_profiler SPSoftwareDataType | grep 'Time since boot'";

        # System Info
        mac_battery = "pmset -g batt";
        mac_cpu = "sysctl -n machdep.cpu.brand_string";
        mac_mem = "system_profiler SPHardwareDataType | grep Memory";
        mac_serial = "system_profiler SPHardwareDataType | grep Serial";
      }
    else
      { };
in
{
  inherit aliases;
}
