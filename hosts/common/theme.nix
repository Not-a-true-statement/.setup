{
  system = { ... }:{
  };


  home = {pkgs, ...}:{
    gtk = {
      enable = true;

      # font = {
      #   name = "terminus-nerdfont";
      #   # font = ;
      #   package = pkgs.terminus-nerdfont;
      # };

      theme = {
        package = pkgs.kdePackages.breeze-gtk;
        name = "Breeze-Dark";
      };

      # cursorTheme = {
      #   package = pkgs.
      #   name = "";
      # };

      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };
  };
}