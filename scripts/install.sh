
export NIX_CONFIG="experimental-features = nix-command flakes"

# FIX ~ should be invalid since no user exsists
nix shell nixpkgs#git --command nix flake clone github:username/repo --dest ~/.setup
nix shell nixpkgs#git --command sudo nixos-rebuild switch --flake ~/.setup#desktop

# Download to .setup
