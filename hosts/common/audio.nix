# AUDIO
{
  # System
  system = { user, pkgs, inputs, ... }: {

    imports = [ inputs.musnix.nixosModules.musnix ];

    # sound.enable = true;
    services.pulseaudio.enable = false;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      #media-session.enable = true;
    };

    musnix = {
      enable = true;
      kernel.realtime = true;
      # ffado.enable = false; # Firewire drivers
      rtcqs.enable = true; # Commandline tool for checking configuration

      # magic to me
      # rtirq = {
      #   # highList = "snd_hrtimer";
      #   # resetAll = 1;
      #   # prioLow = 0;
      #   # enable = true;
      #   # nameList = "rtc0 snd";
      # };
    };

    services.pipewire.extraConfig.pipewire = {

      # "audio-seperation-setup" = {
      #   "context.modules" = [
      #     {

      #     }
      #   ];
      # };

      # "20-audio-seperation-setup" = {
      #   "context.objects" = [
      #     # Test device
      #     {
      #       "factory" = "adapter";
      #       "args" = {
      #         "factory.name" = "support.null-audio-sink";
      #         "node.name" = "my-virtual-device";
      #         "media.class" = Audio/Sink;
      #         "audio.position" = [ "FL" "FR" ];
      #         "adapter.auto-port-config" = {
      #           "mode" = "dsp";
      #           "monitor" = true;
      #           "position" = "preserve";
      #         };
      #       };
      #     }
      #   ];
      # };

      "20-external-network-audio" = {
        "context.modules" = [
          # Netjack2
          {
            "name" = "libpipewire-module-netjack2-manager";
            "args" = {
              "net.ip" = "10.0.0.20";
              "netjack2.sample-rate" = 48000;
              "netjack2.period-size" = 512;
              "audio.channels" = 2;
              "audio.position" = [ "FL,FR" ];

              "node.name" = "windows-remote";
              "node.passive" = true;

              # extra sink properties
              # "source.props" = { };
              # extra sink properties
              # "sink.props" = { };
            };
          }
        ];
      };

    };
  };

  # Home manager
  home = { pkgs, ... }: {
    systemd.user.services."audio-auto-start" = {
      Unit = {
        Description = "Load PulseAudio Remap Sink on Startup";
        Wants = [ "pipewire.service pipewire-pulse.service" ];
        After = [ "pipewire.service pipewire-pulse.service" ];
        # partOf = [ "default.target" ];
      };

      Install = { WantedBy = [ "default.target" ]; };

      Service = {
        Type = "simple";

        ExecStart = let pactl = "${pkgs.pulseaudio}/bin/pactl";
        in "${pkgs.writeShellScript "audio-auto-start" ''
          #${pkgs.bash}/bin/bash

          # Input Output.
          ${pactl} load-module module-remap-source media.class=Audio/Source/Virtual source_name=Main_Microphone remix=false
          ${pactl} load-module module-remap-sink media.class=Audio/Sink/Virtual sink_name=Main_Headphone remix=false monitor.channel-volumes=true

          # AI outputs (LOOPBACK, both record and output).
          ${pactl} load-module module-null-sink media.class=Audio/Duplex sink_name=AI audio.position=FL,FR

          # Seperate appllications
          ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Discord monitor.channel-volumes=true
          ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Discord-RAW monitor.channel-volumes=false
          ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Browser monitor.channel-volumes=true
          ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Browser-RAW monitor.channel-volumes=false
          ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Music monitor.channel-volumes=true
          ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Music-RAW monitor.channel-volumes=false
          ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=VM monitor.channel-volumes=true
          ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=VM-RAW monitor.channel-volumes=false
          ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=VOIP monitor.channel-volumes=true
          ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=VOIP-RAW monitor.channel-volumes=false

          sleep infinity
        ''}";

        ExecStop = let pactl = "${pkgs.pulseaudio}/bin/pactl";
        in "${pkgs.writeShellScript "audio-auto-stop" ''
          #${pkgs.bash}/bin/bash

          # Unload all modules
          ${pactl} unload-module module-remap-source
          ${pactl} unload-module module-remap-sink
          ${pactl} unload-module module-null-sink

        ''}";

        #   ExecStop = let
        #     pactl = "${pkgs.pulseaudio}/bin/pactl";
        #   in"${pkgs.writeShellScript "audio-auto-stop" ''
        #     #!/run/current-system/sw/bin/bash

        #     # Unload module with sink name.
        #     unloadModule () {
        #       ${pactl} list short modules | grep "sink_name=$1" | cut -f1 | xargs -L1 pactl unload-module
        #     } 

        #     # Input Output.
        #     unloadModule Main_Microphone
        #     unloadModule Main_Headphone

        #     # AI.
        #     unloadModule AI

        #     # Applications.
        #     unloadModule Discord
        #     unloadModule Browser
        #     unloadModule Music
        #     unloadModule VM
        #     unloadModule VOIP

        #     ''}";
      };
    };

    # User packages
    home.packages = with pkgs; [
      carla
      yabridge
      yabridgectl

      # (pkgs.extend (final: prev: {
      #   carla = prev.carla.overrideAttrs (old: {
      #     buildInputs = old.buildInputs ++ [
      #       # wine
      #       # wine64
      #       wineWowPackages.waylandFull
      #       ];
      #   });
      # })).carla

      # (pkgs.extend (final: prev: {
      #   airwave = prev.airwave.overrideAttrs (old: {
      #     wine-wow64 = wine.override {
      #       wineRelease = "unstable";
      #       wineBuild = "wineWow";
      #     };

      #   });
      # })).airwave

    ];

  };
}
