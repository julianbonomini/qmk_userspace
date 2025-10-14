# Lily58 Halcyon - Personal Config

Custom firmware for my Lily58 Halcyon keyboard with TFT display modules.

## Setup Overview

- **Keyboard:** Lily58 Halcyon (splitkb)
- **Modules:** TFT LCD displays on both halves
- **Keymap:** `buenomini` (custom)
- **Base repo:** Fork of [splitkb/qmk_userspace](https://github.com/splitkb/qmk_userspace)

## Keymap Workflow

### Quick Changes (VIAL - Not Versioned)
For day-to-day keymap tweaks without flashing:

1. Go to [vial.rocks](https://vial.rocks)
2. Connect keyboard
3. Modify keymaps live
4. **Note:** Changes are stored in keyboard EEPROM, not versioned in git

### Versioning Keymaps
To save your VIAL layout to this repo:

1. In vial.rocks, click **File → Save Layout**
2. Download the JSON file
3. Replace `keyboards/splitkb/halcyon/lily58/keymaps/buenomini/keymap.json`
4. Commit to git

This gives you a backup and version history of your preferred layout.

## Customizing Module Behavior

To modify LCD display behavior or other module features:

### 1. Edit Module Code
Display customization files:
- `users/halcyon_modules/splitkb/hlc_tft_display/hlc_tft_display.c` - Main display logic
- `users/halcyon_modules/splitkb/hlc_tft_display/hlc_tft_display.h` - Colors and definitions

Key functions:
- `update_display()` - Primary display (layers, lock indicators)
- `display_module_housekeeping_task_kb()` - Main loop for both displays
- Secondary display shows Game of Life animation

### 2. Commit & Push (Automated Build)
```bash
git add .
git commit -m "Update display behavior"
git push
```

**GitHub Actions will automatically:**
- Build all firmware targets from `qmk.json`
- Create compiled `.uf2` files
- Publish to **Releases** tab

### 3. Download Firmware
1. Go to your repo's **Actions** tab
2. Wait for build to complete (green checkmark)
3. Go to **Releases** tab
4. Download the latest firmware (e.g., `splitkb_halcyon_lily58_rev2_buenomini_display.uf2`)

### 4. Flash Keyboard
1. Put keyboard in bootloader mode (double-tap reset button)
2. Keyboard appears as USB drive
3. Drag & drop the `.uf2` file onto the drive
4. Keyboard auto-reboots with new firmware

### 5. Restore Keymaps (Optional)
If your VIAL keymaps were reset:
1. Go to [vial.rocks](https://vial.rocks)
2. Import your saved JSON layout
3. Or reconfigure from scratch

---

### Local Compilation (Alternative)
If you prefer to build locally instead of using GitHub Actions:

```bash
# Compile specific target
qmk compile -kb splitkb/halcyon/lily58/rev2 -km buenomini -e HLC_TFT_DISPLAY=1

# Or compile all userspace targets
qmk userspace-compile

# Flash directly
qmk flash -kb splitkb/halcyon/lily58/rev2 -km buenomini -e HLC_TFT_DISPLAY=1
```

## Build Targets

Current build configurations in `qmk.json`:
- `splitkb_halcyon_lily58_rev2_vial_hlc_display` - TFT display version
- `splitkb_halcyon_lily58_rev2_vial_hlc_encoder` - Encoder version
- etc.

List all targets: `qmk userspace-list`

## Display Features

**Primary display (master half):**
- Large layer number indicator (0-7)
- Lock status: Caps, Num, Scroll Lock

**Secondary display:**
- Conway's Game of Life animation
- Color changes based on active layer
- Adds cell clusters on keypresses

## Setup (First Time)

If setting up on a new machine:

```bash
# 1. Setup QMK
qmk setup

# 2. Clone this repo
git clone <your-fork-url> qmk_userspace
cd qmk_userspace

# 3. Configure QMK to use this userspace
qmk config user.overlay_dir="$(realpath .)"

# 4. Compile
qmk userspace-compile
```

## Resources

- [Original splitkb README](./SPLITKB_README.md)
- [QMK Documentation](https://docs.qmk.fm/)
- [VIAL Documentation](https://get.vial.today/docs/)
- [Halcyon Modules Documentation](https://docs.splitkb.com/hc/en-us/articles/25415910333084)
