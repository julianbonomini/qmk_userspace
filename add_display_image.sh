#!/bin/bash

# Script to add images to keyboard display
# Usage: ./add_display_image.sh path/to/image.png [name]

set -e

if [ -z "$1" ]; then
    echo "Usage: ./add_display_image.sh path/to/image.png [name]"
    echo "Example: ./add_display_image.sh ~/Downloads/logo.png my_logo"
    exit 1
fi

INPUT_IMAGE="$1"
IMAGE_NAME="${2:-$(basename "$INPUT_IMAGE" .png)}"
IMAGE_NAME=$(echo "$IMAGE_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

DISPLAY_WIDTH=135
DISPLAY_HEIGHT=240

echo "🎨 Adding image to keyboard display..."
echo "Input: $INPUT_IMAGE"
echo "Name: $IMAGE_NAME"

# Check if input exists
if [ ! -f "$INPUT_IMAGE" ]; then
    echo "❌ Error: File not found: $INPUT_IMAGE"
    exit 1
fi

# 1. Resize image to 135x240 (maintain aspect ratio, pad with black)
echo "📐 Resizing to ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}..."
python3 << EOF
from PIL import Image

# Open and convert to RGB
img = Image.open('$INPUT_IMAGE').convert('RGB')

# Calculate resize to fit within 135x240 maintaining aspect ratio
img.thumbnail(($DISPLAY_WIDTH, $DISPLAY_HEIGHT), Image.Resampling.LANCZOS)

# Create black background
final = Image.new('RGB', ($DISPLAY_WIDTH, $DISPLAY_HEIGHT), (0, 0, 0))

# Center the image
x = ($DISPLAY_WIDTH - img.width) // 2
y = ($DISPLAY_HEIGHT - img.height) // 2
final.paste(img, (x, y))

# Save
final.save('${IMAGE_NAME}_resized.png')
print(f"✓ Resized to {final.size}")
EOF

# 2. Convert to QMK format
echo "🔄 Converting to QMK format (rgb565)..."
qmk painter-convert-graphics -f rgb565 -i "${IMAGE_NAME}_resized.png"

# 3. Move to graphics folder
echo "📁 Moving to graphics folder..."
mv "${IMAGE_NAME}_resized.qgf.c" "users/halcyon_modules/splitkb/hlc_tft_display/graphics/${IMAGE_NAME}.qgf.c"
mv "${IMAGE_NAME}_resized.qgf.h" "users/halcyon_modules/splitkb/hlc_tft_display/graphics/${IMAGE_NAME}.qgf.h"

# Clean up temp file
rm "${IMAGE_NAME}_resized.png"

# 4. Update rules.mk
echo "⚙️  Updating build system..."
RULES_FILE="users/halcyon_modules/splitkb/hlc_tft_display/rules.mk"
if ! grep -q "${IMAGE_NAME}.qgf.c" "$RULES_FILE"; then
    echo "SRC += \$(USER_PATH)/splitkb/hlc_tft_display/graphics/${IMAGE_NAME}.qgf.c" >> "$RULES_FILE"
    echo "✓ Added to rules.mk"
else
    echo "⚠️  Already in rules.mk"
fi

echo ""
echo "✅ Done! Image added successfully."
echo ""
echo "📝 Next steps:"
echo "1. Add to hlc_tft_display.c:"
echo "   #include \"graphics/${IMAGE_NAME}.qgf.h\""
echo ""
echo "2. Display it:"
echo "   painter_image_handle_t img = qp_load_image_mem(gfx_${IMAGE_NAME});"
echo "   qp_drawimage(lcd_surface, 0, 0, img);  // Full color!"
echo "   qp_close_image(img);"
echo ""
echo "3. Build: git add . && git commit -m \"Add ${IMAGE_NAME}\" && git push"
