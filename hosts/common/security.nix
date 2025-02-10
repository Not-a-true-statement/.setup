# Security
{

  # System
  system = { ... }:{

    # Sudo
    security.sudo.wheelNeedsPassword = false;

    services.gnome.gnome-keyring.enable = true;
    # services.fprintd.enable = true;
    # security.pam.services."${user}".fprintAuth = true;
  };

  # Home manager
  home = { ... }:{};

}