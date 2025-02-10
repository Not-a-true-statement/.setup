{

  # System
  system = { ... }:{};

  
  # Home manager
  home = {pkgs, ...}:{
    programs.ranger = {
      enable = false;

      extraPackages = with pkgs; [
        w3m
      ];
    };
  };
}