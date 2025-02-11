{

  # System
  system = { ... }:{};

  # Home manager
  home = { pkgs, ... }:{
    programs.firefox = {
      enable = true;
      # package = pkgs.firefox-esr;

      profiles.default = {
        name = "default";
        isDefault = true;
      };

    };

    # userChrome
    home.file."firefox-userChrome" = {
      enable = true;
      target =".mozilla/firefox/default/chrome";
      source = ../dotfiles/firefox;
      recursive = true;
    };


  };
}