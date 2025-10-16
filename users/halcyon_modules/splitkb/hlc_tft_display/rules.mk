SRC += $(USER_PATH)/splitkb/hlc_tft_display/hlc_tft_display.c
POST_CONFIG_H += $(USER_PATH)/splitkb/hlc_tft_display/config.h

# Fonts
SRC += $(USER_PATH)/splitkb/hlc_tft_display/graphics/fonts/Retron2000-27.qff.c \
       $(USER_PATH)/splitkb/hlc_tft_display/graphics/fonts/Retron2000-underline-27.qff.c

# Numbers in image format
SRC += $(USER_PATH)/splitkb/hlc_tft_display/graphics/numbers/0.qgf.c \
	   $(USER_PATH)/splitkb/hlc_tft_display/graphics/numbers/1.qgf.c \
	   $(USER_PATH)/splitkb/hlc_tft_display/graphics/numbers/2.qgf.c \
	   $(USER_PATH)/splitkb/hlc_tft_display/graphics/numbers/3.qgf.c \
	   $(USER_PATH)/splitkb/hlc_tft_display/graphics/numbers/4.qgf.c \
	   $(USER_PATH)/splitkb/hlc_tft_display/graphics/numbers/5.qgf.c \
	   $(USER_PATH)/splitkb/hlc_tft_display/graphics/numbers/6.qgf.c \
	   $(USER_PATH)/splitkb/hlc_tft_display/graphics/numbers/7.qgf.c \
	   $(USER_PATH)/splitkb/hlc_tft_display/graphics/numbers/8.qgf.c \
	   $(USER_PATH)/splitkb/hlc_tft_display/graphics/numbers/9.qgf.c \
	   $(USER_PATH)/splitkb/hlc_tft_display/graphics/numbers/undef.qgf.c

# Emoticons
SRC += $(USER_PATH)/splitkb/hlc_tft_display/graphics/scene_test.qgf.c
SRC += $(USER_PATH)/splitkb/hlc_tft_display/graphics/emotion_backspace.qgf.c
SRC += $(USER_PATH)/splitkb/hlc_tft_display/graphics/emotion_base.qgf.c
SRC += $(USER_PATH)/splitkb/hlc_tft_display/graphics/emotion_many_backspaces.qgf.c
SRC += $(USER_PATH)/splitkb/hlc_tft_display/graphics/emotion_sleep.qgf.c
SRC += $(USER_PATH)/splitkb/hlc_tft_display/graphics/emotion_typing.qgf.c
SRC += $(USER_PATH)/splitkb/hlc_tft_display/graphics/emotion_typing_fast.qgf.c
SRC += $(USER_PATH)/splitkb/hlc_tft_display/graphics/emotion_volume_change.qgf.c
