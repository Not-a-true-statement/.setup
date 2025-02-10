# Graphical

{
  system = {pkgs, user, ...}:{
    
    services.xserver.enable = true;
    services.xserver.displayManager = {
      # session = [
      #   {
      #     manage = "desktop";
      #     name="TESTKDE";
      #     start = "${pkgs.plasma-workspace}/bin/startplasma-x11";
      #   }
      # ];
      # defaultSession = "none+awesome";
      #     sddm.theme = "${(pkgs.fetchFromGitHub {
      #   owner = "Not-a-true-statement";
      #   repo = "sddm-sugar-light";
      #   rev = "157ce05970a93968032dfd5b67dbe9205602aa9b";
      #   hash = "sha256-XXvLEDdUuojuB3yFxxTyv6MEsRjP0/ko3RJI1xPtirw=";
      # })}";
      
      # sddm.theme = "${(pkgs.fetchFromGitHub {
      #   owner = "MarianArlt";
      #   repo = "kde-plasma-chili";
      #   rev = "a371123959676f608f01421398f7400a2f01ae06";
      #   sha256 = "17pkxpk4lfgm14yfwg6rw6zrkdpxilzv90s48s2hsicgl3vmyr3x";
      # })}";
      # sddm.theme = "./sddm-theme";
    };
    # services.xserver.desktopManager.plasma5.enable = true;
    services.displayManager.sddm.enable = false;
    services.greetd = {
      enable = true;
      package = pkgs.greetd.tuigreet;
      # package = (pkgs.callPackage ./packages/my-greeter/flake.nix {});
      settings = {
        default_session = {
          # ./packages/my-greeter/flake.nix
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          # command = "${my-greeter}/bin/my-greeter";
          user = "${user}";
        };
      };
    };
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    users.users."${user}".packages = with pkgs; [
      hyprpolkitagent
    ];
  };


  home = {... }:{

  };
}