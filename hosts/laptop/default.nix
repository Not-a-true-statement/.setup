let

  # Components
  modules = [
    (import ./battery.nix)
  ];

in
{
  system = { ... }:{

    # Apply components
    imports = (map (import: import.system) modules) ++ [ (import ./hardware-configuration.nix) ];
  
  };
  
  
  home = { ... }:{

    # Apply components
    imports = map (import: import.home) modules;
  
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