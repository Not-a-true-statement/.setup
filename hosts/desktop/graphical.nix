# Graphical

{
  system = { ... }:{
  };


  home = { config, ... }:{

    # Display detection configuration
    home.file."kanshi" = {
      enable = true;
      target =".config/kanshi";
      source = dotfiles/kanshi;
      recursive = true;
    };
  };
}