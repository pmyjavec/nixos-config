# This file is deprecated in favor of the new cross-platform structure.
# Use ./linux.nix for Linux-specific configuration or ./darwin.nix for macOS.
# Common configuration is in ./common.nix

# For backwards compatibility, import the Linux configuration
{ config, pkgs, inputs, ... }:

{
  imports = [ ./linux.nix ];
}
