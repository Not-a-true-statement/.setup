let

  # Devices to be imported
  importDevices = [
      (import ./qudelix-5k.nix)
  ];

in
{

  # System
  system = { pkgs, user, importSystem, ... }:{

    # Apply devies
    imports = importSystem importDevices;
  };

  # Home manager
  home = { importHome, pkgs, inputs, ... } : {

    # Apply devices
    imports = importHome importDevices;
  };

}
