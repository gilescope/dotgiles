#! /usr/bin/env bash
cp /etc/nixos/configuration.nix .
cp /etc/nixos/hardware-configuration.nix .
cp ~/.config/nixpkgs/home.nix .
rm user.channels
nix-channel --list > user.channels
rm root.channels
sudo nix-channel --list > root.channels
