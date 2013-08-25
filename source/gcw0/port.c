/* Per-platform code - gpSP on GCW Zero
 *
 * Copyright (C) 2013 GBATemp user Nebuleon
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public Licens e as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#include "common.h"
#include <stdarg.h>

char DEFAULT_SAVE_DIR[MAX_PATH];

void ReGBA_Trace(const char* Format, ...)
{
	char* line = malloc(82);
	va_list args;
	int linelen;

	va_start(args, Format);
	if ((linelen = vsnprintf(line, 82, Format, args)) >= 82)
	{
		va_end(args);
		va_start(args, Format);
		free(line);
		line = malloc(linelen + 1);
		vsnprintf(line, linelen + 1, Format, args);
	}
	printf(line);
	va_end(args);
	free(line);
	printf('\r');
	printf('\n');
}

void ReGBA_BadJump(u32 SourcePC, u32 TargetPC)
{
	printf("GBA segmentation fault");
	printf("The game tried to jump from %08X to %08X", SourcePC, TargetPC);
	exit(1);
}

void ReGBA_MaxBlockExitsReached(u32 BlockStartPC, u32 BlockEndPC, u32 Exits)
{
	ReGBA_Trace("Native code exit limit reached");
	ReGBA_Trace("%u exits in the block of GBA code from %08X to %08X", Exits, BlockStartPC, BlockEndPC);
}

void ReGBA_MaxBlockSizeReached(u32 BlockStartPC, u32 BlockEndPC, u32 BlockSize)
{
	ReGBA_Trace("Native code block size reached");
	ReGBA_Trace("%u instructions in the block of GBA code from %08X to %08X", BlockSize, BlockStartPC, BlockEndPC);
}

void ReGBA_DisplayFPS(void)
{
#if 0
	u32 Visible = gpsp_persistent_config.DisplayFPS;
	if (Visible)
	{
		unsigned int Now = getSysTime(), Duration = Now - Stats.LastFPSCalculationTime;
		if (Duration >= 23437 /* 1 second */)
		{
			Stats.RenderedFPS = Stats.RenderedFrames * 23437 / Duration;
			Stats.RenderedFrames = 0;
			Stats.EmulatedFPS = Stats.EmulatedFrames * 23437 / Duration;
			Stats.EmulatedFrames = 0;
			Stats.LastFPSCalculationTime = Now;
		}
		else
			Visible = Stats.RenderedFPS != -1 && Stats.EmulatedFPS != -1;
	}

	// Blacken the bottom bar
	memset((u16*) *gba_screen_addr_ptr + 177 * 256, 0, 15 * 256 * sizeof(u16));
	if (Visible)
	{
		char line[512];
		sprintf(line, msg[FMT_STATUS_FRAMES_PER_SECOND], Stats.RenderedFPS, Stats.EmulatedFPS);
		PRINT_STRING_BG_UTF8(*gba_screen_addr_ptr, line, 0x7FFF, 0x0000, 1, 177);
	}
#endif
}

void ReGBA_LoadRTCTime(struct ReGBA_RTC* RTCData)
{
#if 0
	struct rtc Time;
	ds2_getTime(&Time);

	RTCData->year = Time.year;
	RTCData->month = Time.month;
	RTCData->day = Time.day;
	// Weekday conforms to the expectations (0 = Sunday, 6 = Saturday).
	RTCData->weekday = Time.weekday;
	RTCData->hours = Time.hours;
	RTCData->minutes = Time.minutes;
	RTCData->seconds = Time.seconds;
#endif
}

u32 ReGBA_Menu(enum ReGBA_MenuEntryReason EntryReason)
{
	// TODO Fill this function in
	return 0;
}

signed int ReGBA_AudioUpdate()
{
	// TODO Fill this function in
	return 0;
}

enum ReGBA_Buttons ReGBA_GetPressedButtons()
{
	// TODO Fill this function in
	return 0;
}
