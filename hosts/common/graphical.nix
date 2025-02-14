# Graphical

{
  system = { pkgs, user, config, ... }: {

    # Enable OpenGL
    hardware.graphics = { enable = true; };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {

      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    services.xserver.enable = true;
    services.xserver.displayManager = {
      session = [
        # {
        #   manage = "desktop";
        #   name="TESTKDE";
        #   start = "${pkgs.plasma-workspace}/bin/startplasma-x11";
        # }
        {
          manage = "desktop";
          name="TESTHYPR";
          start = "Hyprland";
        }
      ];
      # defaultSession = "none+awesome";
      #     sddm.theme = "${(pkgs.fetchFromGitHub {
      #   owner = "Not-a-true-statement";
      #   repo = "sddm-sugar-light";
      #   rev = "157ce05970a93968032dfd5b67dbe9205602aa9b";
      #   hash = "sha256-XXvLEDdUuojuB3yFxxTyv6MEsRjP0/ko3RJI1xPtirw=";
      # })}";

      # sddm.theme = "${(pkgs.fetchFromGitHub {
      #   owner = "MarianArlt";
      #   repo = "kde-plasma-chili";
      #   rev = "a371123959676f608f01421398f7400a2f01ae06";
      #   sha256 = "17pkxpk4lfgm14yfwg6rw6zrkdpxilzv90s48s2hsicgl3vmyr3x";
      # })}";
      # sddm.theme = "./sddm-theme";
    };
    # services.xserver.desktopManager.plasma5.enable = true;

    services.displayManager.sddm.enable = true;
    services.greetd = {
      enable = false;
      package = pkgs.greetd.tuigreet;
      # package = (pkgs.callPackage ./packages/my-greeter/flake.nix {});
      settings = {
        default_session = {
          # ./packages/my-greeter/flake.nix
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          # command = "${my-greeter}/bin/my-greeter";
          user = "${user}";
        };
      };
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    users.users."${user}".packages = with pkgs; [ hyprpolkitagent ];
  };

  home = { config, ... }: {
    home.file."hyprland" = {
      enable = true;
      target = ".config/hypr";
      source = dotfiles/hyprland;
      recursive = true;
    };
  };
}
