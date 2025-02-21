# User

{
  system = { pkgs, user, lib, ... }: {
    hardware.i2c.enable = true;

    console = {
      earlySetup = true;
      packages = with pkgs; [ terminus_font ];
      font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    };

    users.users."${user}" = {
      # shell = pkgs.zsh;
      isNormalUser = true;
      description = "${user}";
      extraGroups =
        [ "networkmanager" "input" "audio" "realtime" "video" "wheel" ];
    };

    # Localization
    services.localtimed.enable = true;
    services.geoclue2.enable = true;
    time.timeZone = lib.mkDefault "Europe/Stockholm";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "sv_SE.UTF-8";
        LC_IDENTIFICATION = "sv_SE.UTF-8";
        LC_MEASUREMENT = "sv_SE.UTF-8";
        LC_MONETARY = "sv_SE.UTF-8";
        LC_NAME = "sv_SE.UTF-8";
        LC_NUMERIC = "sv_SE.UTF-8";
        LC_PAPER = "sv_SE.UTF-8";
        LC_TELEPHONE = "sv_SE.UTF-8";
        LC_TIME = "sv_SE.UTF-8";
      };
    };
    
    # Keyboard
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

  };

  home = { stateVersion, user, config, ... }: {
    home = {
      inherit stateVersion;
      username = "${user}";
      homeDirectory = "/home/${user}";

      preferXdgDirectories = true;

      # OUTPUT DEBU GGING
      # file."/home/tar/testfile.txt" = {
      #   text = "${config.home.homeDirectory}";
      # };
    };

    xdg = {
      enable = true;

      # Default directories
      userDirs = let homeDirectory = "${config.home.homeDirectory}";
      in {
        enable = true;
        createDirectories = true;
        desktop = "${homeDirectory}/desktop";
        documents = "${homeDirectory}/documents";
        download = "${homeDirectory}/downloads";
        music = "${homeDirectory}/music";
        pictures = "${homeDirectory}/pictures";
        videos = "${homeDirectory}/videos";
        publicShare = "${homeDirectory}/public";
        templates = "${homeDirectory}/templates";

        extraConfig = {
          XDG_DEVELOPMENT_DIR = "${homeDirectory}/development";
          XDG_TMP_DIR = "${homeDirectory}/temp";
        };
      };

      # Default applications for file types
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/plain" = "vscode.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
        };
      };
    };

    # Session terminal variables
    home.sessionVariables = {
      EDITOR = "nano";
      SUDO_EDITOR = "code --wait";
    };
  };
}
