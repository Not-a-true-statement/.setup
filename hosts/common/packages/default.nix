let

  # programs to be imported
  importPrograms = [
    # Dev utilities
    (import ./git.nix)
    (import ./neovim)

    # Desktop environment
    # (import ./ags)

    # Programs
    (import ./obs.nix)
    (import ./firefox.nix)
    # (import ./lan-mouse.nix)
    (import ./ranger.nix)
  ];

in {

  # System
  system = { importSystem, pkgs, user, ... }: {

    # TEMP
    services.gvfs.enable = true;
    services.nfs.server.enable = true;

    # Apply programs
    imports = importSystem importPrograms;

    # System packages
    users.users."${user}".packages = with pkgs; [

      # Filesystem
      partition-manager # GUI partition
      gparted # GUI partition
      ntfs3g # NTFS support
      exfat # exFat support
      nfs-utils # dis

      # Utilities
      killall # Killall programs with name
      nano # Text editor
      vim # Text editor
      git # Source control
      pciutils # Pcie Utilities
      usbutils # USB Utilities
      wget # Retrive from web server
      libnotify # Norification Utilities
      ddcutil
      nmap

      glmark2
      furmark
      mission-center

      killall
      git
      nurl # Fetch GitHub info for Nix
      jq # Also used in HyprLand script
      dmidecode
      dig
      memtester

      vlc
      # Wayland utilities
      wdisplays
      # waypaper
      # wpaperd

      # Nix utilities
      nix-output-monitor
      expect
      nixpkgs-fmt # Formatter for nix code
      nixfmt-classic # Formatter for nix code
    ];
  };

  # Home manager
  home = { importHome, pkgs, inputs, ... }: {

    # Apply programs
    imports = importHome importPrograms;

    # User packages
    home.packages = with pkgs; [
      spotify
      kate
      thunderbird
      vscode-fhs
      zoom-us
      btop
      ungoogled-chromium
      google-chrome
      monero-gui
      xmrig
      msr-tools
      fastfetch

      # (pkgs.extend (final: prev: {
      #   lan-mouse = prev.lan-mouse.overrideAttrs (old: rec {
      #     # cmakeFlags = old.cmakeFlags ++ [ (lib.cmakeBool "USE_WAYLAND_GRIM" true) ];
      #     version = "0.10.0";
      #     src = fetchFromGitHub {
      #       owner = "feschber";
      #       repo = "lan-mouse";
      #       # rev = "31366f42550d89b41c26f4d2cba1068acb4a0e5a";
      #       rev = "v${version}";
      #       hash = "sha256-iNkj4gvVAc7Ai7rc1D2ODG1qSAvaZ2gw5jnpvcJwq1k=";
      #     };

      #     cargoHash = "";
      #   });
      # })).lan-mouse

      # inputs.lan-mouse.packages.${pkgs.stdenv.hostPlatform.system}.default
      lan-mouse

      adoptopenjdk-icedtea-web

      # Terminal
      btop # Resource Manager
      fastfetch # system fetch
      # ranger                    # File Manager

      # File Management
      okular # PDF viewer
      pcmanfm # File Manager
      nemo # File Manager
      file-roller # Archive Manager
      gnome-disk-utility # (Required for nemo disk view)
      rsync # Syncer $ rsync -r dir1/ dir2/
      unzip # Zip files
      unrar # Rar files

      nfs-utils

      lens
      kubectl

      # transmission_4
      # transmission_4-gtk
      transmission-remote-gtk # Remote torrent management
      qbittorrent
      # qbittorrent-enhanced
      deluge

      waypaper
      hyprpaper
      mpvpaper
      wallutils
      (pkgs.extend (final: prev: {
        gowall = prev.gowall.overrideAttrs (old: rec {
          version = "0.2.0";
          src = fetchFromGitHub {
            owner = "Achno";
            repo = "gowall";
            rev = "v0.2.0";
            hash = "sha256-QKukWA8TB0FoNHu0Wyco55x4oBY+E33qdoT/SaXW6DE=";
          };
        });
      })).gowall

      prismlauncher
      minecraft-server

      # Creative
      davinci-resolve
      kdePackages.kdenlive # Video editor
      mediainfo # Required by kdenlive
      audacity # Audio editor
      # tenacity # Audio editor
      gimp # Image editor
      libreoffice-qt # Libre office
      hunspell # Libre office spell check
      hunspellDicts.en_GB-large # Libre office spell check
      hunspellDicts.en_US # Libre office spell check
      hunspellDicts.sv_SE # Libre office spell check
      obsidian
      yt-dlp

      fatrace

      # Windows application support
      wineWowPackages.waylandFull
      # wineWowPackages.stable
      winetricks

      # Wayland
      waybar
      swww
      kanshi
      # wofi
      rofi-wayland
      libnotify
      brightnessctl
      dunst
      (pkgs.extend (final: prev: {
        ags_1 = prev.ags_1.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [
            prev.libdbusmenu-gtk3

            gtksourceview
            webkitgtk
            accountsservice
            sassc # For dynamic sccs generation for colors
            upower
          ];
        });
      })).ags_1
      # ags
      # inputs.ags.packages.${pkgs.stdenv.hostPlatform.system}.default
      wallust
      sassc

      libinput
      # xorg.xf86inputsynaptics
      # xorg.xev
      # evtest

      # Nvim
      xclip
      wl-clipboard

      # audio
      pavucontrol
      qjackctl
      jacktrip
      pulseaudio

      (pkgs.extend (final: prev: {
        raysession = prev.raysession.overrideAttrs (old: rec {
          version = "0.14.4";
          src = fetchurl {
            url =
              "https://github.com/Houston4444/RaySession/releases/download/v${version}/RaySession-${version}-source.tar.gz";
            sha256 = "sha256-cr9kqZdqY6Wq+RkzwYxNrb/PLFREKUgWeVNILVUkc7A=";
          };
        });
      })).raysession

      # Temp
      networkmanagerapplet
      blueman
      pasystray
      overskride

      keepassxc

      feh
      # ranger

      # (ranger.override { imagePreviewSupport = false; })

      (pkgs.extend (final: prev: {
        flameshot = prev.flameshot.overrideAttrs (old: {
          cmakeFlags = old.cmakeFlags
            ++ [ (lib.cmakeBool "USE_WAYLAND_GRIM" true) ];
        });
      })).flameshot
      grim

      python3Full
      socat
      bash
      # terminus-nerdfont
      # nerdfonts
      # iosevka
      nerd-fonts.iosevka-term

      #       (pkgs.extend (final: prev: {
      #   iosevka = prev.iosevka.overrideAttrs (old: {
      #     privateBuildPlan = builtins.readFile ./fonts/custom.toml; 
      #     set = "Iosevka-custom";
      #   });
      # })).iosevka

      (pkgs.discord.override { withVencord = true; })
      vesktop
      # vencord
      # discord
      # betterdiscordctl
    ];

    # Custom desktop entries
    xdg.desktopEntries = {
      firefox-incognito = {
        name = "Firefox Incognito";
        genericName = "Web Browser";
        icon = "firefox";
        exec = "firefox --private-window";
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
      };
    };

  };

}
