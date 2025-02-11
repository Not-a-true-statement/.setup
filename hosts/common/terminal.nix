# Terminal
{
  system = { };

  home = { configName, location, user, ... }: {

    programs.alacritty = { enable = true; };

    # Shell configuration
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        tput cup 9999 0
        # fill-terminal
      '';
    };
    programs.zsh = {
      enable = true;

      oh-my-zsh = { enable = true; };
    };
    home.shellAliases = let
      # The order of aliases are random therefore they are defined in let in block so they can be referenced.

      # Utilities
      fill-terminal = "tput cup 9999 0";
      clear = "clear && ${fill-terminal}";

      # Nix management
      rebuild-normal =
        "nice -n 19 sudo nixos-rebuild switch --flake ${location}#${configName} --impure";
      rebuild = "${rebuild-normal} |& nom";

      rebuild-test-normal = 
        "nice -n 19 sudo nixos-rebuild test --flake ${location}#${configName} --impure";
      rebuild-test = "${rebuild-test-normal} |& nom";

      update-normal =
        "nice -n 19 sudo nix flake update --flake ${location} && ${rebuild-normal}";
      update =
        "nice -n 19 sudo nix flake update  --flake ${location} |& nom && ${rebuild}";

      # FANCY shit
      system = "fastfetch";
      system-clean = "${clear} && ${system}";

      # AUDIO
      audiocarla =
        "PIPEWIRE_LATENCY=1024/48000 carla --cnprefix Microphone ~/.config/audio/carla/rack.carxp";
      audiojacktrip =
        "while true; do PIPEWIRE_LATENCY=1024/48000 jacktrip -s -q auto -B 4465 -D --udprt; sleep 1; done";
      audio =
        "${audiocarla} & ${audiojacktrip} &"; # Run both carla and jacktrip
      restart-audio =
        "systemctl --user restart pipewire{,-pulse}.socket audio-auto-start.service";
    in {

      # Utilities
      fill-terminal = "${fill-terminal}";
      clear = "clear && ${fill-terminal}";

      # Improvements
      ls = "ls -lh --color=auto"; # Output as list by default

      # Nix management
      rebuild = "${rebuild}";
      rebuild-normal = "${rebuild-normal}";
      rebuild-test = "${rebuild-test}";
      rebuild-test-normal = "${rebuild-test-normal}";
      update = "${update}";
      update-normal = "${update-normal}";

      # FANCY shit
      system = "${system}";
      system-clean = "${system-clean}";

      # AUDIO
      audiocarla = "${audiocarla}";
      audiojacktrip = "${audiojacktrip}";
      audio = "${audio}";
      restart-audio = "${restart-audio}";

      k8 = "kubectl --kubeconfig ~/.kube/k3s-prod1.yaml";
      k8prd = "kubectl --kubeconfig ~/.kube/k3s-prod1.yaml";
    };

  };
}
