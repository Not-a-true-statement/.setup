let

  # Devices to be imported
  importDevices = [
      (import ./qudelix-5k.nix)
  ];

in
{

  # System
  system = { pkgs, user, ... }:{

    # Apply devies
    imports = (map (import: import.system) importDevices);
  };

  # Home manager
  home = { pkgs, inputs, ... } : {

    # Apply devices
    imports = (map (import: import.home) importDevices);
  };

}
