let

  # Components
  modules = [
    (import ./graphical.nix)
  ];

in {

  system = { inputs, ... }: {

    # Apply components
    imports = (map (import: import.system) modules)
      ++ [
        inputs.disko.nixosModules.disko
         (import ./hardware-configuration.nix) (import ./disko-config.nix) ];

  };

  home = { ... }: {

    # Apply components
    imports = map (import: import.home) modules;

  };
}
