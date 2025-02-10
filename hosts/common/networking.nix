# Networking

{
  system = { ... }:{
    networking.networkmanager.enable = true;
    networking.hostName = "nixos"; # TODO change nixos to variable

    # Firewall
    # TODO implement firewall
    networking.firewall.enable = false;

    # SSH
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        UseDns = true;
        PermitRootLogin = "yes";
      };
    };
  };


  home = { ... }:{

  };
}