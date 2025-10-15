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
- Modifier indicators: Ctrl, Alt, Cmd (highlights when pressed)

**Secondary display:**
- Custom graphics (emoticons, logos, icons)
- Can be changed dynamically based on keyboard events

## Adding Custom Images to Display

Add any image (logo, icon, emoticon) to your keyboard display:

### 1. Prepare Your Image
- **Format:** PNG
- **Size:** 135x240px max (display size), smaller recommended
- **Colors:** High contrast works best - black background, white foreground
- **Tools:** Any image editor (Photoshop, GIMP, Figma, etc.)

For text/emoticons with Unicode, use Python + PIL:
```bash
python3 << 'EOF'
from PIL import Image, ImageDraw, ImageFont
img = Image.new('L', (120, 20), color=0)
draw = ImageDraw.Draw(img)
font = ImageFont.truetype('/path/to/font.ttf', 16)
draw.text((5, 2), "(づ ◕‿◕ )づ", fill=255, font=font)
img.save('my_image.png')
EOF
```

### 2. Convert to QMK Format
```bash
qmk painter-convert-graphics -f mono2 -i my_image.png
# Creates: my_image.qgf.c and my_image.qgf.h
```

### 3. Move Files to Graphics Folder
```bash
mv my_image.qgf.* users/halcyon_modules/splitkb/hlc_tft_display/graphics/
```

### 4. Add to Build System
Edit `users/halcyon_modules/splitkb/hlc_tft_display/rules.mk`, add to the end:
```make
SRC += $(USER_PATH)/splitkb/hlc_tft_display/graphics/my_image.qgf.c
```

### 5. Use in Code
Edit `users/halcyon_modules/splitkb/hlc_tft_display/hlc_tft_display.c`:

**Add include at top (~line 14):**
```c
#include "graphics/my_image.qgf.h"
```

**Display the image (~line 307):**
```c
painter_image_handle_t img = qp_load_image_mem(gfx_my_image);
qp_drawimage_recolor(lcd_surface, x, y, img, HSV_WHITE, HSV_BLACK);
qp_close_image(img);
```

### 6. Build & Flash
```bash
git add .
git commit -m "Add custom image"
git push
```
Download from **Releases** tab and flash to keyboard.

**Tip:** See `graphics/numbers/` for examples - one `.qgf.c` + `.qgf.h` per image.

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
