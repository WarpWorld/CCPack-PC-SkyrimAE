#include "GamePause.h"

#include "skse64/GameAPI.h"
#include "skse64/GameMenus.h"

namespace
{
	UInt32 ReadMenuPauseCount(const MenuManager* menuManager)
	{
		return *reinterpret_cast<const UInt32*>(reinterpret_cast<const UInt8*>(menuManager) + 0x160);
	}

	UInt8 ReadMenuModalCount(const MenuManager* menuManager)
	{
		return *reinterpret_cast<const UInt8*>(reinterpret_cast<const UInt8*>(menuManager) + 0x17C);
	}

}

bool QueryNativeGamePaused()
{
	if (IsConsoleMode())
	{
		return true;
	}

	MenuManager* menuManager = MenuManager::GetSingleton();
	if (!menuManager)
	{
		return false;
	}

	// Only count menus that actually pause gameplay (inventory, journal, map, etc.).
	// Do NOT use menuStack count - HUD/Fader/Cursor menus are always on the stack.
	const UInt32 pauseCount = ReadMenuPauseCount(menuManager);
	const UInt8 modalCount = ReadMenuModalCount(menuManager);
	return pauseCount > 0 || modalCount > 0;
}
