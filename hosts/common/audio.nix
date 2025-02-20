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
    # services.jack.jackd.enable = true;

    # Realtime kernel
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

    # Audio configuration for seperating audio sources.
    # Note: node.name must be unique otherwise programs like obs is connecting to first instance of name.
    # pw-loopback --name='test' --capture-props='node.description="test monitor" media.class=Audio/Sink node.name=test-capture audio.position=[FL FR]' --playback-props='node.description="test" node.name=test-playback audio.position=[FL FR] target.object=headphone-capture'
    services.pipewire.extraConfig.pipewire = {

      "audio-seperation-setup" = {
        "context.modules" = [

          # Remap the default microphone
          {
            "name" = "libpipewire-module-loopback";
            "args" = {
              "name" = "Microphone";
              "node.description" = "Microphone";

              # Autoconnect to default input device
              "capture.props" = {
                "node.name" = "microphone-capture";
                "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                "node.name" = "microphone-playback";
                "media.class" = "Audio/Source";
                "audio.position" = [ "FL" "FR" ];
                "stream.dont-remix" = true;
                "node.passive" = true;
              };
            };
          }

          # Remap the default headphone
          {
            "name" = "libpipewire-module-loopback";
            "args" = {
              "name" = "Headpones";
              "node.description" = "Headphone";
              "capture.props" = {
                "node.name" = "headphone-capture";
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" ];
              };

              # Auto connect to default output device
              "playback.props" = {
                "node.name" = "headphone-playback";
                "audio.position" = [ "FL" "FR" ];
                "stream.dont-remix" = true;
                "node.passive" = true;
              };
            };
          }

          # Discord
          {
            "name" = "libpipewire-module-loopback";
            "args" = {
              "node.description" = "Discord Monitor";
              "capture.props" = {
                "node.name" = "discord-capture";
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                "node.description" = "Discord";
                "node.name" = "discord-playback";
                "audio.position" = [ "FL" "FR" ];
                "stream.dont-remix" = true;
                "node.passive" = true;
                "target.object" = "headphone-capture";
              };
            };
          }

          # Music
          {
            "name" = "libpipewire-module-loopback";
            "args" = {
              "node.description" = "Music Monitor";
              "capture.props" = {
                "node.name" = "music-capture";
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                "node.description" = "Music";
                "node.name" = "music-playback";
                "audio.position" = [ "FL" "FR" ];
                "stream.dont-remix" = true;
                "node.passive" = true;
                "target.object" = "headphone-capture";
              };
            };
          }

          # Games
          {
            "name" = "libpipewire-module-loopback";
            "args" = {
              "node.description" = "Games Monitor";
              "capture.props" = {
                "node.name" = "games-capture";
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                "node.description" = "Games";
                "node.name" = "games-playback";
                "audio.position" = [ "FL" "FR" ];
                "stream.dont-remix" = true;
                "node.passive" = true;
                "target.object" = "headphone-capture";
              };
            };
          }

          # Browser
          {
            "name" = "libpipewire-module-loopback";
            "args" = {
              "node.description" = "Browser Monitor";
              "capture.props" = {
                "node.name" = "browser-capture";
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                "node.description" = "Browser";
                "node.name" = "browser-playback";
                "audio.position" = [ "FL" "FR" ];
                "stream.dont-remix" = true;
                "node.passive" = true;
                "target.object" = "headphone-capture";
              };
            };
          }

          # VoIP
          {
            "name" = "libpipewire-module-loopback";
            "args" = {
              "node.description" = "VoIP Monitor";
              "capture.props" = {
                "node.name" = "voip-capture";
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                "node.description" = "VoIP";
                "node.name" = "voip-playback";
                "audio.position" = [ "FL" "FR" ];
                "stream.dont-remix" = true;
                "node.passive" = true;
                "target.object" = "headphone-capture";
              };
            };
          }

        ];
      };

      "network-audio" = {
        "context.modules" = [
          # Netjack2
          {
            "name" = "libpipewire-module-netjack2-manager";
            "flags" = [ "ifexists" "nofail" ];
            "args" = {
              # node.name
              "net.ip" = "10.0.0.20";
              "netjack2.sample-rate" = 48000;
              "netjack2.period-size" = 512;

              # # extra source properties
              "source.props" = {
                "node.description" = "Netjack2";
                "netjack2.connect" = true;
                "midi.ports" = 0;
                "audio.channels" = 2;
                "audio.position" = [ "FL" "FR" ];
                # "node.name" = "windows-source";
                # "node.passive" = true;
                # "target.object" = "headphone-capture";
              };
              # # extra sink properties
              "sink.props" = {
                "node.description" = "Netjack2";
                "netjack2.connect" = true;
                
                "node.dont-reconnect" = false;
                "node.autoconnect" = true;


                "midi.ports" = 0;
                "audio.channels" = 2;
                "audio.position" = [ "FL" "FR" ];
                "stream.dont-remix" = true;
                "node.passive" = true;
                # "target.object" = "headphone-capture";
                "target.object" = "games-capture";
                # "node.name" = "windows-sink";
                # "node.passive" = true;
              };
            };
          }
        ];
      };

    };
  };

  # Home manager
  home = { pkgs, ... }: {
    # systemd.user.services."audio-auto-start" = {
    #   Unit = {
    #     Description = "Load PulseAudio Remap Sink on Startup";
    #     Wants = [ "pipewire.service pipewire-pulse.service" ];
    #     After = [ "pipewire.service pipewire-pulse.service" ];
    #     # partOf = [ "default.target" ];
    #   };

    #   Install = { WantedBy = [ "default.target" ]; };

    #   Service = {
    #     Type = "simple";

    #     ExecStart = let pactl = "${pkgs.pulseaudio}/bin/pactl";
    #     in "${pkgs.writeShellScript "audio-auto-start" ''
    #       #${pkgs.bash}/bin/bash

    #       # Input Output.
    #       ${pactl} load-module module-remap-source media.class=Audio/Source/Virtual source_name=Microphone-RAW remix=false monitor.channel-volumes=false
    #       ${pactl} load-module module-null-source media.class=Audio/Source/Virtual source_name=Microphone monitor.channel-volumes=true
    #       ${pactl} load-module module-remap-sink media.class=Audio/Sink/Virtual sink_name=Main_Headphone remix=false monitor.channel-volumes=true

    #       # AI outputs (LOOPBACK, both record and output).
    #       ${pactl} load-module module-null-sink media.class=Audio/Duplex sink_name=AI audio.position=FL,FR

    #       # Seperate appllications
    #       ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Discord monitor.channel-volumes=true
    #       ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Discord-RAW monitor.channel-volumes=false
    #       ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Browser monitor.channel-volumes=true
    #       ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Browser-RAW monitor.channel-volumes=false
    #       ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Music monitor.channel-volumes=true
    #       ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=Music-RAW monitor.channel-volumes=false
    #       ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=VM monitor.channel-volumes=true
    #       ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=VM-RAW monitor.channel-volumes=false
    #       ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=VOIP monitor.channel-volumes=true
    #       ${pactl} load-module module-null-sink media.class=Audio/Sink sink_name=VOIP-RAW monitor.channel-volumes=false

    #       sleep infinity
    #     ''}";

    #     ExecStop = let pactl = "${pkgs.pulseaudio}/bin/pactl";
    #     in "${pkgs.writeShellScript "audio-auto-stop" ''
    #       #${pkgs.bash}/bin/bash

    #       # Unload all modules
    #       ${pactl} unload-module module-remap-source
    #       ${pactl} unload-module module-remap-sink
    #       ${pactl} unload-module module-null-sink

    #     ''}";
    #   };
    # };

    # User packages
    home.packages = with pkgs; [
      carla
      yabridge
      yabridgectl

      lsp-plugins
      deepfilternet

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
