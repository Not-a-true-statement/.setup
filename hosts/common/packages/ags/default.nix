{
  # System
  system = { ... }:{};


  # Home manager
  home = { inputs, pkgs, ... }:{
    # Home manager module
    imports = [ inputs.ags.homeManagerModules.default ];
    
    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      # configDir = ./config;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
        sassc # For dynamic sccs generation for colors
      ];
    };
  };

}