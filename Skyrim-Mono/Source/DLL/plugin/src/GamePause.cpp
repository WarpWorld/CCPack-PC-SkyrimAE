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
	std::set<std::string> g_openTitleMenus;
	std::set<std::string> g_openLoadingMenus;
	std::set<std::string> g_openCutsceneMenus;

	UInt32 ReadMenuPauseCount(const MenuManager* menuManager)
	{
		return *reinterpret_cast<const UInt32*>(reinterpret_cast<const UInt8*>(menuManager) + 0x160);
	}

	UInt8 ReadMenuModalCount(const MenuManager* menuManager)
	{
		return *reinterpret_cast<const UInt8*>(reinterpret_cast<const UInt8*>(menuManager) + 0x17C);
	}

	bool IsTitleMenuName(const char* menuName)
	{
		static const char* kTitleMenus[] = {
			"Main Menu",
			"Start Menu",
			"PlayMenu",
			"Credits Menu",
			nullptr
		};

		for (size_t i = 0; kTitleMenus[i]; ++i)
		{
			if (_stricmp(menuName, kTitleMenus[i]) == 0)
			{
				return true;
			}
		}

		return false;
	}

	bool IsLoadingMenuName(const char* menuName)
	{
		return _stricmp(menuName, "Loading Menu") == 0
			|| _stricmp(menuName, "LoadWaitSpinner") == 0;
	}

	bool IsCutsceneMenuName(const char* menuName)
	{
		static const char* kCutsceneMenus[] = {
			"Movie Picker",
			"Favor Menu",
			"Intro Menu",
			nullptr
		};

		for (size_t i = 0; kCutsceneMenus[i]; ++i)
		{
			if (_stricmp(menuName, kCutsceneMenus[i]) == 0)
			{
				return true;
			}
		}

		return false;
	}

	bool IsMenuSetOpen(const std::set<std::string>& menus)
	{
		std::lock_guard lock(g_menuMutex);
		return !menus.empty();
	}
}

void OnMenuOpenClose(const char* menuName, bool opening)
{
	if (!menuName || !menuName[0])
	{
		return;
	}

	std::lock_guard lock(g_menuMutex);
	const std::string name(menuName);

	auto update = [&](std::set<std::string>& menus, bool tracked)
	{
		if (!tracked)
		{
			return;
		}

		if (opening)
		{
			menus.insert(name);
		}
		else
		{
			menus.erase(name);
		}
	};

	update(g_openTitleMenus, IsTitleMenuName(menuName));
	update(g_openLoadingMenus, IsLoadingMenuName(menuName));
	update(g_openCutsceneMenus, IsCutsceneMenuName(menuName));
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

bool QueryTitleScreenActive()
{
	return IsMenuSetOpen(g_openTitleMenus);
}

bool QueryLoadingScreenActive()
{
	if (IsMenuSetOpen(g_openLoadingMenus))
	{
		return true;
	}

	return QueryPlayerAbsent() && !QueryTitleScreenActive();
}

bool QueryCutsceneScreenActive()
{
	return IsMenuSetOpen(g_openCutsceneMenus);
}

bool QueryPlayerAbsent()
{
	return *g_thePlayer == nullptr;
}

bool QueryPlayerDead()
{
	PlayerCharacter* player = *g_thePlayer;
	if (!player)
	{
		return false;
	}

	return player->IsDead(1);
}
