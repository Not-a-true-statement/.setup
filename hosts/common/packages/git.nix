{

  # System
  system = { ... }:{};

  
  # Home manager
  home = {...}:{
    programs.git = {
      enable = true;

      userName = "user";
      userEmail = "email@generic.com";
    };
  };
}