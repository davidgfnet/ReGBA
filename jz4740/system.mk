# 
# 
# Author: Seeger Chin
# e-mail: seeger.chin@gmail.com
# 
# Copyright (C) 2006 Ingenic Semiconductor Inc.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
# 
# 

CROSS = #/home/yliu/mipseltools-nopic/bin/
# select which module to compile, set value to 1 for the module to compile, remain blank for the module not to compile
# -----------------------------
JZ4740_PAV = 1
#
#TOUCHTYPE :
#           0. No Touch driver
#           1. AK4182
#           2. JZ4740SADC
#
TOUCHTYPE  = 0

#LCDTYPE :
#           0. No LCD Driver
#           1. Samsung tft 480 * 272
#           2. FOXCONN 8-bit serial
#           3. slcd
#           4. AUO_A030FL01_V1
#LCDTYPE    = 1
LCDTYPE    = 1
#RTCTYPE :
#           0. No RTC Driver
#           1. jz4740RTC
RTCTYPE    = 1

#CODECTYPE :
#           0. No Codec Driver
#           1. jz4740 Codec
CODECTYPE = 1
WAVDECODE = 0
#KeyCTYPE :
#           0. No Key Driver
#           1. jz4740 Key
KEYTYPE = 1

#TouchPanelTYPE :
#           0. No Tpanel Driver
#           1. jz4740 Tpanel
TPANELTYPE = 0

MMC    = 1
#MMCTYPE :
#           1. SD card
#           2. Micro -SD card
MMCTYPE    = 1

# VBA
# VBA    = 1

#NDS layer
NDS  = 1

CAMERA = 0
LWIP   = 0
UCGUI  = 0
UCFS   = 1
JPEG   = 0

UDC    = 0
MP3    = 0
NAND   = 0
UDCCPU = 0
GUIDEMO = 0
DM = 1
I2C = 1
FM = 0
USE_MIDWARE = 0

GBA_EMU_DEBUG = 0

# ------------------------------

CC	:= $(CROSS)mipsel-linux-gcc
AR	:= $(CROSS)mipsel-linux-ar rcsv
LD	:= $(CROSS)mipsel-linux-ld
OBJCOPY	:= $(CROSS)mipsel-linux-objcopy
NM	:= $(CROSS)mipsel-linux-nm
OBJDUMP	:= $(CROSS)mipsel-linux-objdump

CFLAGS	:= -Wall -mips32 -O3 -mno-abicalls -fno-pic -fno-builtin \
	   -fno-exceptions -ffunction-sections -mlong-calls\
	   -fomit-frame-pointer -msoft-float -G 0

#CFLAGS += -finit-priority

#LIBS	:= -lstdc++ -lc -lm -lgcc
LIBS	:= -lc -lm -lgcc

TOP	:= ..
COREDIR	 := $(TOP)/jz4740/core
OSDIR	 := $(TOP)/src
ARCHDIR	 := $(TOP)/mips
SOCDIR	 := $(TOP)/jz4740
MMCDIR	 := $(TOP)/mmc
UCFSDIR  := $(TOP)/ucfs
LWIPDIR  := $(TOP)/lwip/src
UCGUIDIR := $(TOP)/ucgui
CORE     := $(TOP)/ucgui/Core
TOUCHDIR := $(TOP)/jz4740/drv/touch
UDCDIR   := $(TOP)/jz4740/udc_new
LCDDIR   := $(TOP)/jz4740/drv/lcd
RTCDIR   := $(TOP)/jz4740/drv/rtc
CODECDIR := $(TOP)/jz4740/drv/codec
WAVDIR   := $(TOP)/audio/wave
KEYDIR   := $(TOP)/jz4740/drv/key
TPANELDIR	:= $(TOP)/jz4740/drv/tpanel
I2CDIR	 := $(TOP)/jz4740/drv/i2c
MP3DIR   := $(TOP)/madplay/libmad-0.15.1b
ID3DIR   := $(TOP)/madplay/libid3tag-0.15.1b
MADDIR   := $(TOP)/madplay/madplay-0.15.2b
FMDIR	 := $(TOP)/jz4740/drv/fm

NANDDIR  := $(TOP)/jz4740/nand
UDCCPUDIR := $(TOP)/jz4740/udc_new
MIDWAREDIR := $(TOP)/midware

# VBADIR  := $(TOP)/jz4740/gba
NDSDIR  := $(TOP)/jz4740/nds_layer
ZLIBDIR := $(TOP)/zlib_files

LIBDIR	:= $(TOP)/LIBS
ifeq ($(GUIDEMO),1)
LIBS += $(wildcard $(LIBDIR)/*.a)
endif
CFLAGS  += -DJZ4740_PAV=$(JZ4740_PAV)

CFLAGS += -DCAMERA=$(CAMERA) \
          -DUCGUI=$(UCGUI)   \
          -DUCFS=$(UCFS)     \
          -DMMC=$(MMC)       \
          -DJPEG=$(JPEG)     \
          -DTOUCH=$(TOUCHTYPE)\
	  -DMMCTYPE=$(MMCTYPE)

include  $(COREDIR)/core.mk

ifeq ($(UDCCPU),1)
include  $(UDCCPUDIR)/udc.mk
endif

ifeq ($(NAND),1)
include  $(NANDDIR)/nand.mk
endif


ifneq ($(KEYTYPE),0)
include $(KEYDIR)/key.mk
endif

ifneq ($(TPANELTYPE),0)
include $(TPANELDIR)/tpanel.mk
endif

ifeq ($(WAVDECODE),1)
include $(WAVDIR)/wave.mk
endif

ifneq ($(CODECTYPE),0)
include $(CODECDIR)/codec.mk
endif

ifneq ($(RTCTYPE),0)
include  $(RTCDIR)/rtc.mk
endif

ifneq ($(LCDTYPE),0)
include $(LCDDIR)/lcd.mk
endif

ifneq ($(TOUCHTYPE),0)
include $(TOUCHDIR)/touch.mk
endif

ifeq ($(MMC),1)
include $(MMCDIR)/mmc.mk
endif

ifeq ($(UCFS),1)
include $(UCFSDIR)/ucfs.mk
endif

ifeq ($(LWIP),1)
include $(LWIPDIR)/lwip.mk
endif

ifeq ($(UCGUI),1)
include $(UCGUIDIR)/ucgui.mk
endif

ifeq ($(USE_MIDWARE),1)
include $(MIDWAREDIR)/midware.mk
CFLAGS	+= -DUSE_MIDWARE=$(USE_MIDWARE)
endif

ifeq ($(GBA_EMU_DEBUG),1)
CFLAGS	+= -DGBA_EMU_DEBUG=$(GBA_EMU_DEBUG)
endif


ifeq ($(CAMERA),1)
SOURCES	+= $(wildcard $(SOCDIR)/camera/*.c) $(SOCDIR)/drv/i2c.c 
CFLAGS += -I$(SOCDIR)/camera
VPATH  += $(SOCDIR)/camera
endif

ifeq ($(JPEG),1)
SOURCES	+= $(wildcard $(UCGUIDIR)/JPEG/*.c)
CFLAGS += -I$(UCGUIDIR)/JPEG
VPATH  += $(UCGUIDIR)/JPEG
endif

ifeq ($(UDC),1)
include $(UDCDIR)/udc.mk
endif

ifeq ($(MP3),1)
include $(wildcard $(MP3DIR)/mp3.mk)
endif

ifeq ($(I2C),1)
include $(I2CDIR)/i2c.mk
endif

ifeq ($(FM),1)
include $(FMDIR)/fm.mk
endif

# ifeq ($(VBA),1)
# include $(VBADIR)/gba.mk
# endif

ifeq ($(NDS),1)
include $(NDSDIR)/nds_layer.mk
endif

include $(ZLIBDIR)/zlib.mk

