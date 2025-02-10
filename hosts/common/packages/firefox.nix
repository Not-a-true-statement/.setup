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
  };
}