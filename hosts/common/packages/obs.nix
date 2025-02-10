{

  # System
  system = { config, lib, ... }:{

  #   boot.kernelModules = lib.mkMerge [
  #   config.boot.kernelModules
  #   [ "v4l2loopback" ]
  # ];

  # boot.kernelModules = lib.mkIf (!lib.elem "v4l2loopback" config.boot.kernelModules) [
  #   "v4l2loopback"
  # ] ++ config.boot.kernelModules;

  };

  
  # Home manager
  home = { pkgs, ... }:{
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs; [
        # obs-studio-plugins.obs-ndi # Replaced by obs-teleport
        obs-studio-plugins.obs-teleport
      ];
    };
  };

}