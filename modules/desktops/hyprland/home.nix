{ self, osConfig, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeModules.desktops.hyprland;
in
{
  options.homeModules.desktops.hyprland = {
    enable = mkEnableOption "hyprland desktop config";
    modKey = mkOption {
      description = "Modifier Key";
      type = types.str;
      default = "SUPER";
    };
    terminal = mkOption {
      description = "Default Terminal";
      type = types.str;
      default = "alacritty";
    };
    launcher = mkOption {
      description = "Default Launcher";
      type = types.str;
      default = "fuzzel";
    };
  };
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {};
    };
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "${pkgs.alacritty}/bin/alacritty";
          lines = 5;
        };
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "${cfg.modKey}";
        "$terminal" = "${cfg.terminal}";
        "$launcher" = "${cfg.launcher}";
        animations = {
          enabled = false;
        };
        general = {
          border_size = 2;
          cursor_inactive_timeout = 2;
          gaps_in = 0;
          gaps_out = 0;
          layout = "dwindle";
        };
        decoration = {
          rounding = 0;
          blur = {
            enabled = false;
          };
        };
        input = {
          kb_options = "ctrl:nocaps";
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
        };
        debug = {
          disable_logs = false;
          enable_stdout_logs = false;
        };
        env = [
          "NIXOS_OZONE_WL,1"
        ];
        bind = [
          "$mod, Return, exec, $terminal"
          "$mod, Space, exec, $launcher"
          "$mod, Q, killactive"
          "$mod, F, togglefloating"
          "$mod SHIFT, F, fullscreen"
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"
          "$mod, 1, workspace, 1"          
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"
          "$mod SHIFT, j, workspace, e-1"
          "$mod SHIFT, k, workspace, e+1"
          "$mod SHIFT, h, movetoworkspace, e-1"
          "$mod SHIFT, l, movetoworkspace, e+1"
          ",Print,exec,grim"
          "$mod SHIFT, X, exit"
        ];
        bindr = [
          "$mod, TAB, cyclenext, prev"
          "$mod, grave, workspace, previous"
        ];
        binde = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86MonBrightnessUp, exec, brightnessctl s +10%"
          ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];
        bindm = [
          "$mod,mouse:272,movewindow"
          "$mod,mouse:273,resizewindow"
        ];
        monitor = [
          ",preferred,auto,1"
        ];
      };
    };
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-center = [
            "hyprland/window"
          ];
          modules-right = [
            "tray"
            "pulseaudio"
            "network"
            "battery"
            "clock"
          ];
          "hyprland/workspaces" = {
            "active-only" = false;
            "persistent-workspaces" = {
              "*" = 5;
            };
          };
        };
      };
      style = ./waybar-style.css;
    };
    services.mako = {
      enable = true;
    };
    programs.wpaperd = {
      enable = true;
      settings = {
        default = {
          path = "${config.xdg.userDirs.pictures}";
        };
      };
    };
    systemd.user.services.wpaperd = {
      Unit = {
        Description = "Wallpaper daemon wpaperd";
        Documentation = "https://github.com/danyspin97/wpaperd/blob/main/README.md#wallpaper-configuration";
        PartOf = [ "graphical-session.target" ];
        After = ["graphical-session-pre.target"];
      };
      Service = {
        ExecStart = "${config.programs.wpaperd.package}/bin/wpaperd -n";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
    home.packages = with pkgs; [
      libsForQt5.polkit-kde-agent
      libsForQt5.qt5.qtwayland
      qt6.qtwayland
      xdg-desktop-portal
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      libnotify
      nwg-look
      workstyle
      grim
      bemenu
      brightnessctl
      workstyle
      wl-clipboard
    ];
    services.wlsunset = {
      enable = true;
      latitude = "-34.60";
      longitude = "-58.38";
    };
  };
}

