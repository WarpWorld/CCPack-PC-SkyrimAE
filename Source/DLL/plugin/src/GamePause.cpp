#include "GamePause.h"

#include "skse64/GameAPI.h"
#include "skse64/GameMenus.h"
#include "skse64/GameReferences.h"

#include <mutex>
#include <set>
#include <string>

namespace
{
	std::mutex g_menuMutex;
	std::set<std::string> g_openBlockingMenus;

	UInt32 ReadMenuPauseCount(const MenuManager* menuManager)
	{
		return *reinterpret_cast<const UInt32*>(reinterpret_cast<const UInt8*>(menuManager) + 0x160);
	}

	UInt8 ReadMenuModalCount(const MenuManager* menuManager)
	{
		return *reinterpret_cast<const UInt8*>(reinterpret_cast<const UInt8*>(menuManager) + 0x17C);
	}

	bool IsBlockingMenuName(const char* menuName)
	{
		if (!menuName || !menuName[0])
		{
			return false;
		}

		static const char* kBlockingMenus[] = {
			"Main Menu",
			"Start Menu",
			"Loading Menu",
			"Credits Menu",
			"PlayMenu",
			nullptr
		};

		for (size_t i = 0; kBlockingMenus[i]; ++i)
		{
			if (_stricmp(menuName, kBlockingMenus[i]) == 0)
			{
				return true;
			}
		}

		return false;
	}

	bool QueryBlockingMenuOpen()
	{
		std::lock_guard lock(g_menuMutex);
		return !g_openBlockingMenus.empty();
	}

	bool QueryPlayerDeadOrAbsent()
	{
		PlayerCharacter* player = *g_thePlayer;
		if (!player)
		{
			return true;
		}

		return player->IsDead(1);
	}
}

void OnMenuOpenClose(const char* menuName, bool opening)
{
	if (!IsBlockingMenuName(menuName))
	{
		return;
	}

	std::lock_guard lock(g_menuMutex);
	if (opening)
	{
		g_openBlockingMenus.insert(menuName);
	}
	else
	{
		g_openBlockingMenus.erase(menuName);
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

	const UInt32 pauseCount = ReadMenuPauseCount(menuManager);
	const UInt8 modalCount = ReadMenuModalCount(menuManager);
	return pauseCount > 0 || modalCount > 0;
}

bool QueryEffectsBlocked()
{
	if (QueryNativeGamePaused())
	{
		return true;
	}

	if (QueryBlockingMenuOpen())
	{
		return true;
	}

	if (QueryPlayerDeadOrAbsent())
	{
		return true;
	}

	return false;
}
