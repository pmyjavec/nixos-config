# NixOS Configuration

This is my personal cross-platform dotfiles configuration using Nix flakes and Home Manager. It's designed to work on both Linux (NixOS) and macOS, currently targeting aarch64 architecture.

## Project Structure

### Core Files

- **`flake.nix`** - Main flake configuration that defines:
  - Input dependencies (nixpkgs, home-manager, nixvim)
  - NixOS system configurations
  - Home Manager configurations for macOS
- **`configuration.nix`** - NixOS system-level configuration
- **`graphical.nix`** - Graphical environment setup for Linux

### Home Manager Configuration

The `home/` directory contains platform-specific and shared configurations:

- **`home/common.nix`** - Shared configuration across all platforms including:
  - Cross-platform packages (development tools, CLI utilities)
  - Git configuration with conditional work email
  - Shell configuration (zsh, bash, starship prompt)
  - Common programs (bat, ssh, direnv)
  
- **`home/linux.nix`** - Linux-specific configuration:
  - Linux-only packages (system monitoring tools, Yubikey utilities)
  - GPG agent configuration with smart card support
  - Imports common.nix and i3 window manager config
  
- **`home/darwin.nix`** - macOS-specific configuration:
  - macOS-compatible packages and pinentry
  - GPG agent configuration for macOS
  - System defaults (dock, finder preferences)
  - Imports common.nix

### Specialized Configurations

- **`home/nixvim/`** - Neovim configuration using nixvim
- **`home/wezterm/`** - WezTerm terminal emulator configuration
- **`home/i3/`** - i3 window manager configuration (Linux only)
- **`machines/vm/aarch64.nix`** - VM-specific hardware configuration

## Architecture

The configuration is split into three main layers:

1. **Platform-agnostic** (`home/common.nix`) - Contains packages and configurations that work identically across platforms
2. **Platform-specific** (`home/linux.nix`, `home/darwin.nix`) - Contains OS-specific packages and configurations
3. **System-level** (`configuration.nix`, `graphical.nix`) - NixOS system configuration

### Package Organization

- **Cross-platform packages** are defined in `common.nix` (git, nodejs, kubectl, etc.)
- **Linux-specific packages** are in `linux.nix` (system monitoring tools, hardware utilities)
- **macOS-specific packages** are in `darwin.nix` (pinentry_mac, etc.)

## Usage

### For NixOS (Linux)

```bash
# Build and switch to the configuration
sudo nixos-rebuild switch --flake .

# Or build without switching
sudo nixos-rebuild build --flake .
```

### For macOS (standalone Home Manager)

```bash
# First time setup
nix run home-manager/master -- init --switch

# Apply configuration
home-manager switch --flake .

# Or build without switching
home-manager build --flake .
```

### Development

To modify the configuration:

1. **Adding cross-platform packages**: Edit `home/common.nix`
2. **Adding Linux-specific packages**: Edit `home/linux.nix`
3. **Adding macOS-specific packages**: Edit `home/darwin.nix`
4. **Modifying Neovim**: Edit files in `home/nixvim/`
5. **System-level changes**: Edit `configuration.nix` or `graphical.nix`

### Testing Changes

```bash
# Check flake syntax
nix flake check

# Build without applying
nix build .#nixosConfigurations.nixos.config.system.build.toplevel  # Linux
nix build .#homeConfigurations.pmyjavec.activationPackage            # macOS
```

## Key Features

- **Cross-platform compatibility** - Works on both Linux and macOS
- **Modular structure** - Easy to modify and extend
- **Consistent tooling** - Same development environment across platforms
- **GPG/Yubikey support** - Hardware security key integration
- **Modern development tools** - Includes modern CLI tools, editors, and development utilities

## Notes

- Currently configured for aarch64 architecture (Apple Silicon and ARM64 Linux)
- Uses nixos-unstable channel for latest packages
- GPG configuration includes smart card daemon support for Yubikey
- Git configuration automatically uses work email for LF-Certification repositories