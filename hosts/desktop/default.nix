let

  # Components
  modules = [
    (import ./graphical.nix)
  ];

in {

  system = { importSystem, inputs, ... }: {

    # Apply components
    imports = importSystem modules
      ++ [
        inputs.disko.nixosModules.disko
         (import ./hardware-configuration.nix) (import ./disko-config.nix) ];

  };

  home = { importHome, ... }: {

    # Apply components
    imports = importHome modules;

  };
}
