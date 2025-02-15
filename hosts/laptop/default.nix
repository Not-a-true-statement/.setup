let

  # Components
  modules = [
    (import ./battery.nix)
  ];

in
{
  system = { importSystem, ... }:{

    # Apply components
    imports = importSystem modules ++ [ (import ./hardware-configuration.nix) ];
  
  };
  
  
  home = { importHome, ... }:{

    # Apply components
    imports = importHome modules;
  
  };
}


















  # imports =
  #   [
  #     #System specific configuration
  #   ];

  # home = {

  #   # Specific packages for laptop
  #   packages = with pkgs; [
  #     # Display
  #     #light                              # xorg.xbacklight not supported. Other option is just use xrandr.

  #     # Power Management
  #     #auto-cpufreq                       # Power management
  #     #tlp                                # Power management
  #   ];
  # };