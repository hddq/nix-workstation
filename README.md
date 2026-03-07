# ❄️ NixOS Workstation

My personal NixOS workstation configuration — fully declarative, reproducible, and used daily.

---

## Hosts

**`nix-client`** — main desktop, daily driver. Dual-monitor Hyprland setup, DDC brightness control over I2C, LUKS encryption.

**`nix-remote`** — secondary machine acting as a remote/streaming box. Runs [Sunshine](https://github.com/LizardByte/Sunshine) for desktop streaming, custom EDID firmware for 240Hz passthrough, initrd SSH for remote LUKS unlock over the network (port 2222), and auto-login into Hyprland via greetd.

Both share a common base config, diverging only where needed.

---

## Structure

```
.
├── flake.nix                  # Entry point — inputs, outputs, hosts
├── hosts/
│   ├── common.nix             # Shared system config (users, networking, HM)
│   ├── nix-client/            # Client-specific (monitors, boot)
│   └── nix-remote/            # Remote-specific (Sunshine, EDID firmware, initrd SSH)
├── modules/
│   └── system/
│       ├── core.nix           # Nix settings, locale, SSH, fonts, keyd
│       ├── network-shares.nix # SMB/CIFS automount
│       └── desktop/           # DE module — gnome.nix and hyprland.nix load
│                              # conditionally via mkIf based on modules.desktop.env
└── home/hddq/
    ├── default.nix            # Home-Manager root
    └── features/
        ├── browser.nix        # Zen + Helium (via flake inputs)
        ├── cli.nix            # Fish, git, direnv, keychain, aliases
        ├── media.nix          # mpv, imv, MIME types
        ├── immich.nix         # Auto-uploader systemd service
        └── desktop/
            ├── gnome.nix      # dconf settings, GTK theme, keybinds
            └── hyprland/      # Full Hyprland stack (waybar, hyprlock, hypridle, rofi...)
```

---

## Desktop Environments

Switching is a one-liner in the host config: `env = "hyprland"` or `env = "gnome"`.

### Hyprland (active)

- **greetd + tuigreet** — login manager
- **Waybar** — custom bar with MPRIS, dual-monitor DDC brightness control, clock, volume, bluetooth
- **Rofi** — app launcher + clipboard history picker (via `cliphist`)
- **Hyprlock** — lock screen with blurred screenshot background
- **Hypridle** — idle management, media-aware (won't sleep if something's playing)
- **Hyprpaper** — wallpaper daemon
- **SwayOSD** — volume and Caps Lock OSD
- **Kitty** — terminal with transparent background
- **Gammastep** — night light
- 10 workspaces on main monitor + workspace 11 pinned to secondary

### GNOME (backup)

Configured declaratively via `dconf` — dark mode, flat mouse acceleration, 10 workspaces, debloated. Not actively used, but kept as a reliable fallback to switch to at any time.

---

## Other Notable Bits

- **Keyboard**: Colemak-DH layout + `keyd` for nav layer (`Alt+hjkl` → arrows, `CapsLock` → Backspace)
- **Fonts**: 0xProto Nerd Font system-wide
- **Browsers**: Zen Browser + Helium — both pulled in as flake inputs (not nixpkgs)
- **Immich**: Systemd user service auto-uploading Screenshots, Pictures, Movies on file change
- **SMB**: NAS automount via credentials from `.env` file, set up at boot

---

## Linting & CI

```bash
direnv allow   # or: nix develop
```

GitHub Actions runs on every push: `statix check`, `deadnix`, `alejandra --check`, `nix flake check`, and Gitleaks secret scanning. Pre-commit hooks enforce the same locally.

---

## Flake Inputs

- `nixpkgs` (25.11) + `nixpkgs-unstable` — stable base with unstable overlay for select packages
- `home-manager` — user environment management
- `zen-browser-flake` + `helium2nix` — browsers not available in nixpkgs
