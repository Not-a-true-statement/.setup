let

  # Components
  modules = [
    (import ./user.nix)
    (import ./terminal.nix)
    (import ./audio.nix)
    (import ./security.nix)
    (import ./networking.nix)
    (import ./graphical.nix)
    (import ./theme.nix)
    (import ./packages)

    (import ./device-specific)
  ];

in {

  # System
  system = { importSystem, stateVersion, pkgs, ... }: {
    # Services
    services.printing.enable = true;
    services.avahi.enable = true;

    # Nix
    system = { inherit stateVersion; };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.optimise.automatic = true;
    nix.settings.auto-optimise-store = true;
    nixpkgs.config.allowUnfree = true;
    # nixpkgs.config.allowBroken = true;

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Firmware update
    services.fwupd = { enable = true; };

    # Apply components
    imports = importSystem modules;

  };

  # Home manager
  home = { importHome, ... }: {
    # Enable Home Manager
    programs.home-manager.enable = true;

    # Apply components
    imports = importHome modules;
  };

}
