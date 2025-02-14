# User

{
  system = { pkgs, user, lib, ... }: {
    hardware.i2c.enable = true;

    console = {
      earlySetup = true;
      packages = with pkgs; [ terminus_font ];
      font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    };

    services.localtimed.enable = true;
    services.geoclue2.enable = true;
    time.timeZone = lib.mkDefault "Europe/Stocholm";

    users.users."${user}" = {
      # shell = pkgs.zsh;
      isNormalUser = true;
      description = "${user}";
      extraGroups =
        [ "networkmanager" "input" "audio" "realtime" "video" "wheel" ];
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
